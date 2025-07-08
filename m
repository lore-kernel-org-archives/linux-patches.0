Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316462E49AF;
	Tue,  8 Jul 2025 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993590; cv=none; b=CrqRhoJyCMLv9UY4P9E3WLGBEpw0hxSj7+wL2Jltl/JyH85vshUIk3ZDxBfd7G//gy4BHOuTOhNF1ZnIYkZL7nUBXvgU/uZfbbBb2wla5Xg3wlCo8ZmzU2gZkruy99L5ev96Lx9SQnRnB3k81ob0Z9gt6+YQz1lONf+lHRNP11M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993590; c=relaxed/simple;
	bh=0x5WOATSNiVVlI0fsA9qCGjJqPcmSf3jxf9EMRmia9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a55f8MiXS5Qsps3oBDIWf7wOKtrQi82PlJ8geZt//3d4DP4dz8gyRsUbP2XmJHS8L9LXtJD/3w5i6PcU4Efc1SPk98N0wGSdFLvzHU/Dur6xHXdwVHZ9g5h2Qr7h8LFE/qKyJ5SFG5ugETvMJL+TLgpVfUBkA7EvYuRNw9+SEFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ij1lOOJT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ij1lOOJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61169C4CEED;
	Tue,  8 Jul 2025 16:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993589;
	bh=0x5WOATSNiVVlI0fsA9qCGjJqPcmSf3jxf9EMRmia9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ij1lOOJTrbfvXujOui1Lhw6/iCxmsSdqkvclY7tzixC0MBZWUOYO+CYnuz67GHTa7
	 GO/aq/BIFtPPxxilHVx+N9MCzmmDbjAxSH8t3DemPkznW36g0mCs0S6q8mCVSC6hXC
	 ghvOb87JPtFg3OGX+YzZbHxFLm91SEWfKVq9nv5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 126/178] ata: libata-acpi: Do not assume 40 wire cable if no devices are enabled
Date: Tue,  8 Jul 2025 18:22:43 +0200
Message-ID: <20250708162239.874636515@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tasos Sahanidis <tasos@tasossah.com>

[ Upstream commit 33877220b8641b4cde474a4229ea92c0e3637883 ]

On at least an ASRock 990FX Extreme 4 with a VIA VT6330, the devices
have not yet been enabled by the first time ata_acpi_cbl_80wire() is
called. This means that the ata_for_each_dev loop is never entered,
and a 40 wire cable is assumed.

The VIA controller on this board does not report the cable in the PCI
config space, thus having to fall back to ACPI even though no SATA
bridge is present.

The _GTM values are correctly reported by the firmware through ACPI,
which has already set up faster transfer modes, but due to the above
the controller is forced down to a maximum of UDMA/33.

Resolve this by modifying ata_acpi_cbl_80wire() to directly return the
cable type. First, an unknown cable is assumed which preserves the mode
set by the firmware, and then on subsequent calls when the devices have
been enabled, an 80 wire cable is correctly detected.

Since the function now directly returns the cable type, it is renamed
to ata_acpi_cbl_pata_type().

Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20250519085945.1399466-1-tasos@tasossah.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-acpi.c | 24 ++++++++++++++++--------
 drivers/ata/pata_via.c    |  6 ++----
 include/linux/libata.h    |  7 +++----
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index b7f0bf7955213..f2140fc06ba0f 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -514,15 +514,19 @@ unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 EXPORT_SYMBOL_GPL(ata_acpi_gtm_xfermask);
 
 /**
- * ata_acpi_cbl_80wire		-	Check for 80 wire cable
+ * ata_acpi_cbl_pata_type - Return PATA cable type
  * @ap: Port to check
- * @gtm: GTM data to use
  *
- * Return 1 if the @gtm indicates the BIOS selected an 80wire mode.
+ * Return ATA_CBL_PATA* according to the transfer mode selected by BIOS
  */
-int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm)
+int ata_acpi_cbl_pata_type(struct ata_port *ap)
 {
 	struct ata_device *dev;
+	int ret = ATA_CBL_PATA_UNK;
+	const struct ata_acpi_gtm *gtm = ata_acpi_init_gtm(ap);
+
+	if (!gtm)
+		return ATA_CBL_PATA40;
 
 	ata_for_each_dev(dev, &ap->link, ENABLED) {
 		unsigned int xfer_mask, udma_mask;
@@ -530,13 +534,17 @@ int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm)
 		xfer_mask = ata_acpi_gtm_xfermask(dev, gtm);
 		ata_unpack_xfermask(xfer_mask, NULL, NULL, &udma_mask);
 
-		if (udma_mask & ~ATA_UDMA_MASK_40C)
-			return 1;
+		ret = ATA_CBL_PATA40;
+
+		if (udma_mask & ~ATA_UDMA_MASK_40C) {
+			ret = ATA_CBL_PATA80;
+			break;
+		}
 	}
 
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
+EXPORT_SYMBOL_GPL(ata_acpi_cbl_pata_type);
 
 static void ata_acpi_gtf_to_tf(struct ata_device *dev,
 			       const struct ata_acpi_gtf *gtf,
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index d82728a01832b..bb80e7800dcbe 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -201,11 +201,9 @@ static int via_cable_detect(struct ata_port *ap) {
 	   two drives */
 	if (ata66 & (0x10100000 >> (16 * ap->port_no)))
 		return ATA_CBL_PATA80;
+
 	/* Check with ACPI so we can spot BIOS reported SATA bridges */
-	if (ata_acpi_init_gtm(ap) &&
-	    ata_acpi_cbl_80wire(ap, ata_acpi_init_gtm(ap)))
-		return ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
+	return ata_acpi_cbl_pata_type(ap);
 }
 
 static int via_pre_reset(struct ata_link *link, unsigned long deadline)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e5695998acb02..ec3b0c9c2a8cf 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1363,7 +1363,7 @@ int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *stm);
 unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 				   const struct ata_acpi_gtm *gtm);
-int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm);
+int ata_acpi_cbl_pata_type(struct ata_port *ap);
 #else
 static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
 {
@@ -1388,10 +1388,9 @@ static inline unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 	return 0;
 }
 
-static inline int ata_acpi_cbl_80wire(struct ata_port *ap,
-				      const struct ata_acpi_gtm *gtm)
+static inline int ata_acpi_cbl_pata_type(struct ata_port *ap)
 {
-	return 0;
+	return ATA_CBL_PATA40;
 }
 #endif
 
-- 
2.39.5



