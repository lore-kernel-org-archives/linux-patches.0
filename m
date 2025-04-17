Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5411D8DF6;
	Thu, 17 Apr 2025 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912809; cv=none; b=QmNF0egZwXyL8HCNep0+HplcU/SdaLb7Hw8HxRy9IkdTjulQn9UlC7wBCjHPxWZXaTUgYaDrxw0L3zIZMW4MalFBljmnutLrir021/j7MfLKIG7V0DzHtee/3wD4U3TaEmo1FX01AicZL6UOe77tzWLdciMyrqr4PQQgEqGy4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912809; c=relaxed/simple;
	bh=moouZmtNr6tlvuhQ80UvEelgRmwOabeO/8puIS2TBOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY+6IgQjbNb52yrVjKsrBD9BL8CwmpENakOmtRz/4B5b9JLOpCN4DSRpHVvQCqLWOi6bAKUTANH6wAEBC0sECFZQH7T/yX1XVZHIM5xbLIKCZzD5R6UxSIEHwbc77ytYpznWNwsGMKybvcAwZ02pVbmoq2BMRX5UbquVy6xyfRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWoVrKLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWoVrKLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C99C4CEE7;
	Thu, 17 Apr 2025 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912809;
	bh=moouZmtNr6tlvuhQ80UvEelgRmwOabeO/8puIS2TBOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWoVrKLMeGhzJ2Byp6+TQA+81jlZ18vaxQX8KaoQr9f9YE5EcxrbBDyyJNlF+4i+2
	 P1B0yZwApAd/9AT4AU9E199r3g0Qe9oXOxy5ao5TiwzLdoK+RMDJVqVDUyEPFZPxyG
	 2W3UWI9IXQnA/xn0TinXjnDHIgHms2qamIMqiFEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 101/449] ata: libata-core: Add external to the libata.force kernel parameter
Date: Thu, 17 Apr 2025 19:46:29 +0200
Message-ID: <20250417175122.025145528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit deca423213cb33feda15e261e7b5b992077a6a08 ]

Commit ae1f3db006b7 ("ata: ahci: do not enable LPM on external ports")
changed so that LPM is not enabled on external ports (hotplug-capable or
eSATA ports).

This is because hotplug and LPM are mutually exclusive, see 7.3.1 Hot Plug
Removal Detection and Power Management Interaction in AHCI 1.3.1.

This does require that firmware has set the appropate bits (HPCP or ESP)
in PxCMD (which is a per port register in the AHCI controller).

If the firmware has failed to mark a port as hotplug-capable or eSATA in
PxCMD, then there is currently not much a user can do.

If LPM is enabled on the port, hotplug insertions and removals will not be
detected on that port.

In order to allow a user to fix up broken firmware, add 'external' to the
libata.force kernel parameter.

libata.force can be specified either on the kernel command line, or as a
kernel module parameter.

For more information, see Documentation/admin-guide/kernel-parameters.txt.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250130133544.219297-4-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  2 +
 drivers/ata/libata-core.c                     | 38 +++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index fb8752b42ec85..aa7447f8837cb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3116,6 +3116,8 @@
 			* max_sec_lba48: Set or clear transfer size limit to
 			  65535 sectors.
 
+			* external: Mark port as external (hotplug-capable).
+
 			* [no]lpm: Enable or disable link power management.
 
 			* [no]setxfer: Indicate if transfer speed mode setting
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3d730c10f7bea..05bfcb359f92c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -88,6 +88,7 @@ struct ata_force_param {
 	unsigned int	xfer_mask;
 	unsigned int	quirk_on;
 	unsigned int	quirk_off;
+	unsigned int	pflags_on;
 	u16		lflags_on;
 	u16		lflags_off;
 };
@@ -331,6 +332,35 @@ void ata_force_cbl(struct ata_port *ap)
 	}
 }
 
+/**
+ *	ata_force_pflags - force port flags according to libata.force
+ *	@ap: ATA port of interest
+ *
+ *	Force port flags according to libata.force and whine about it.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+static void ata_force_pflags(struct ata_port *ap)
+{
+	int i;
+
+	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
+		const struct ata_force_ent *fe = &ata_force_tbl[i];
+
+		if (fe->port != -1 && fe->port != ap->print_id)
+			continue;
+
+		/* let pflags stack */
+		if (fe->param.pflags_on) {
+			ap->pflags |= fe->param.pflags_on;
+			ata_port_notice(ap,
+					"FORCE: port flag 0x%x forced -> 0x%x\n",
+					fe->param.pflags_on, ap->pflags);
+		}
+	}
+}
+
 /**
  *	ata_force_link_limits - force link limits according to libata.force
  *	@link: ATA link of interest
@@ -486,6 +516,7 @@ static void ata_force_quirks(struct ata_device *dev)
 	}
 }
 #else
+static inline void ata_force_pflags(struct ata_port *ap) { }
 static inline void ata_force_link_limits(struct ata_link *link) { }
 static inline void ata_force_xfermask(struct ata_device *dev) { }
 static inline void ata_force_quirks(struct ata_device *dev) { }
@@ -5460,6 +5491,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 #endif
 	ata_sff_port_init(ap);
 
+	ata_force_pflags(ap);
+
 	return ap;
 }
 EXPORT_SYMBOL_GPL(ata_port_alloc);
@@ -6272,6 +6305,9 @@ EXPORT_SYMBOL_GPL(ata_platform_remove_one);
 	{ "no" #name,	.lflags_on	= (flags) },	\
 	{ #name,	.lflags_off	= (flags) }
 
+#define force_pflag_on(name, flags)			\
+	{ #name,	.pflags_on	= (flags) }
+
 #define force_quirk_on(name, flag)			\
 	{ #name,	.quirk_on	= (flag) }
 
@@ -6331,6 +6367,8 @@ static const struct ata_force_param force_tbl[] __initconst = {
 	force_lflag_on(rstonce,		ATA_LFLAG_RST_ONCE),
 	force_lflag_onoff(dbdelay,	ATA_LFLAG_NO_DEBOUNCE_DELAY),
 
+	force_pflag_on(external,	ATA_PFLAG_EXTERNAL),
+
 	force_quirk_onoff(ncq,		ATA_QUIRK_NONCQ),
 	force_quirk_onoff(ncqtrim,	ATA_QUIRK_NO_NCQ_TRIM),
 	force_quirk_onoff(ncqati,	ATA_QUIRK_NO_NCQ_ON_ATI),
-- 
2.39.5



