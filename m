Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B7B2571A2;
	Thu, 17 Apr 2025 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914131; cv=none; b=pxkH1+yUd1uTSrHyuV0bmRXdqqZDrBT2kicQllwFT4UDj7aGANt/dbukaVfzeXjvwKtyo4r5ez+1DLU8iOreQegrCm66gdVBmi0F9V0gmFs6+t2gYtYTpntTzBmIJCwLKeSDxk6iac7P4H87n10vaE+wctA2xXy+vStlx+rllcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914131; c=relaxed/simple;
	bh=wXWX64GXtmKy/01DQHjx9OoF3N44j0ZAbcFJlSJBV8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2sfY9dIpj+fcuTfnXjMvE4oPomMSamsnQQgFtqlNjz+wLT+fmhHDY1FIGc93cNTdDvE2SfRN+PWvQk3tZjcggoOpFK2W3qKvNU2zwlJ2zQtF0Dla8n68Zgw10pfh5FSZHyKuhQHFThvRCHrj/rAC1hY4Cy0r0Oyb+ww8tk/g/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYekXmvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYekXmvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90312C4CEE4;
	Thu, 17 Apr 2025 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914131;
	bh=wXWX64GXtmKy/01DQHjx9OoF3N44j0ZAbcFJlSJBV8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYekXmvFjHiR0FHgGuqGAE+fHhxAZWEj84sB8QBIlbMVyFaYl1KqmfY+3nBKr205j
	 MLch3R6nqx1dmheGNhEyzPfuSHTtOjmhbHEI08O9zsQZ2BRoWaGsWa2h3MBHq4HAJT
	 pdNWjjWxUqPcnOF7pEpPhozM1LrDHMoBcwb7BY5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 087/414] ata: libata-core: Add external to the libata.force kernel parameter
Date: Thu, 17 Apr 2025 19:47:25 +0200
Message-ID: <20250417175114.940463663@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3872bc6ec49d6..d9c55dcbf4a21 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3036,6 +3036,8 @@
 			* max_sec_lba48: Set or clear transfer size limit to
 			  65535 sectors.
 
+			* external: Mark port as external (hotplug-capable).
+
 			* [no]lpm: Enable or disable link power management.
 
 			* [no]setxfer: Indicate if transfer speed mode setting
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d956735e2a764..0cb97181d10a9 100644
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



