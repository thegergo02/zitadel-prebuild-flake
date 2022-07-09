self: {
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.services.zitadel;
in {
  options.services.zitadel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables Zitadel";
    };
    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.default;
      description = "Zitadel package to use";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.zitadel = {
      description = "Starts Zitadel.";
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = "${cfg.package}/bin/zitadel start-from-init";
    };
  };
}
