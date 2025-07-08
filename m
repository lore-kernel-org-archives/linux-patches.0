Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DDB1DF74F;
	Tue,  8 Jul 2025 16:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992420; cv=none; b=M3bUTZ6u+wdLi4HeIsVIYOYqLEFswW9loTAl2vo+3obMD8q8h6iAemc7E3sA1YktlLV3gjAf2Oty4a28sQdWb7ixa5fPD/AU0dClAtyvvHWxnzJ7eE3AAWZs1KwMr7RuVTchpsLRlibTKOg1OJ4z4mstC9OAaJkioQykTC0ofJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992420; c=relaxed/simple;
	bh=LZiObVV78/OTK4h+DrJpfZGtvYtIk9zwEd3jAAqnz4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp3irtC3IXahZBHU6DEgNMGjZ7qGba68RWYsZ/N9l5HrKSx+e4Dr/Qk+Xo40azyFDpOuPf3leVaBAwwf9z4Mn5axUd2AxcRWzMyzTlRUtN0mbLiWLEWZrc5xssuoK2PbNh4MjujFCqUjgvSsRcKjSI/7Gbhxq3dZNQtnw7VeCsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXurH9Dz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXurH9Dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E642BC4CEED;
	Tue,  8 Jul 2025 16:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992420;
	bh=LZiObVV78/OTK4h+DrJpfZGtvYtIk9zwEd3jAAqnz4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXurH9Dz3dK9mh5cObzKJVIW9v79n+RlN3tPB0MMD5uchC1NT5ot7T5Ba6PgD4oQn
	 eeBwxgmlzyE3KJxTOGCTFhj1M6aIvZVpfd3K8Z6K3WWLsZxWFoEdbHq+Vj16NtUdmP
	 n6vXB7aeXhcm1a2v9HUurUktKHOwtL9dYw9wKqXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/132] ata: libata-acpi: Do not assume 40 wire cable if no devices are enabled
Date: Tue,  8 Jul 2025 18:23:17 +0200
Message-ID: <20250708162233.147689992@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d36e71f475abd..39a350755a1ba 100644
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
index 91c4e11cb6abb..285d709cbbde4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1305,7 +1305,7 @@ int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *stm);
 unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
 				   const struct ata_acpi_gtm *gtm);
-int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm);
+int ata_acpi_cbl_pata_type(struct ata_port *ap);
 #else
 static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
 {
@@ -1330,10 +1330,9 @@ static inline unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
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



