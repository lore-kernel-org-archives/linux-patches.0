Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA3F32E6BB;
	Thu, 12 Mar 2026 20:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346508; cv=none; b=JsjRjxlajPS5YHctJVs6BWVuH7hGOv+UNZ+l6RvtIKu+cYjtperO6yB+utZFxBdP906E4uaj+s1o1B8XZLKMAJ1OEI9ia4NYwbO/CiNKELGgA88AKDB/wqRFIZZTK9mqNzqNDK31hvRTEsIsx6KwzTNJ/bULHlFYC2HpyrD9HFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346508; c=relaxed/simple;
	bh=F2ILVrGxQ9Y069/Trmu46tfa5sGQkXq+D3tqElwcHqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh0N2T3z7KtIUVaTul5rZOzOjKhdbpkGhOk/Hpba1SwC7xdWYD5VDCyRUPwGaxjXqCG1tRhnK54601kz4KDxXrgMWmWC8UHx3wXVA1HZHI9WDtFIIKAnL80/XViAodCE0AV4MvvzFYtV+p+KsMiik0X+2c45zuo4B/32Lu8gLpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02PhEtWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02PhEtWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA05C4CEF7;
	Thu, 12 Mar 2026 20:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346508;
	bh=F2ILVrGxQ9Y069/Trmu46tfa5sGQkXq+D3tqElwcHqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02PhEtWw1uW9JUeitJavjEQmTiHXymANKnWXYWReLR9ztSdhWakVSUT4mtWOXgIYw
	 E0E5vNTSDq+KBkyUXaV+huuxvPzTOmDviayc1zvmy5fLbozkK2lfzwsAuSqE9h3RBH
	 tr9nqfyYmCw9GeWoPPP5OADuXFXSKlYo1EuUm888=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/265] ata: libata: Remove ATA_DFLAG_ZAC device flag
Date: Thu, 12 Mar 2026 21:07:27 +0100
Message-ID: <20260312201020.380177167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit a0f26fcc383965e0522b81269062a9278bc802fe ]

The ATA device flag ATA_DFLAG_ZAC is used to indicate if a devie is a
host managed or host aware zoned device. However, this flag is not used
in the hot path and only used during device scanning/revalidation and
for inquiry and sense SCSI command translation.

Save one bit from struct ata_device flags field by replacing this flag
with the internal helper function ata_dev_is_zac(). This function
returns true if the device class is ATA_DEV_ZAC (host managed ZAC device
case) or if its identify data reports it supports the zoned command set
(host aware ZAC device case).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 13 +------------
 drivers/ata/libata-scsi.c |  5 ++---
 drivers/ata/libata.h      |  7 +++++++
 include/linux/libata.h    |  1 -
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 39dcefb1fdd54..2b1cb2998331d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2439,18 +2439,7 @@ static void ata_dev_config_zac(struct ata_device *dev)
 	dev->zac_zones_optimal_nonseq = U32_MAX;
 	dev->zac_zones_max_open = U32_MAX;
 
-	/*
-	 * Always set the 'ZAC' flag for Host-managed devices.
-	 */
-	if (dev->class == ATA_DEV_ZAC)
-		dev->flags |= ATA_DFLAG_ZAC;
-	else if (ata_id_zoned_cap(dev->id) == 0x01)
-		/*
-		 * Check for host-aware devices.
-		 */
-		dev->flags |= ATA_DFLAG_ZAC;
-
-	if (!(dev->flags & ATA_DFLAG_ZAC))
+	if (!ata_dev_is_zac(dev))
 		return;
 
 	if (!ata_identify_page_supported(dev, ATA_LOG_ZONED_INFORMATION)) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 4281516a46e0b..58070edec7c77 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1955,8 +1955,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_device *dev,
 	};
 
 	for (i = 0; i < sizeof(pages); i++) {
-		if (pages[i] == 0xb6 &&
-		    !(dev->flags & ATA_DFLAG_ZAC))
+		if (pages[i] == 0xb6 && !ata_dev_is_zac(dev))
 			continue;
 		rbuf[num_pages + 4] = pages[i];
 		num_pages++;
@@ -2209,7 +2208,7 @@ static unsigned int ata_scsiop_inq_b2(struct ata_device *dev,
 static unsigned int ata_scsiop_inq_b6(struct ata_device *dev,
 				      struct scsi_cmnd *cmd, u8 *rbuf)
 {
-	if (!(dev->flags & ATA_DFLAG_ZAC)) {
+	if (!ata_dev_is_zac(dev)) {
 		ata_scsi_set_invalid_field(dev, cmd, 2, 0xff);
 		return 1;
 	}
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index d07693bd054eb..e78995833e7e6 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -44,6 +44,13 @@ static inline bool ata_sstatus_online(u32 sstatus)
 	return (sstatus & 0xf) == 0x3;
 }
 
+static inline bool ata_dev_is_zac(struct ata_device *dev)
+{
+	/* Host managed device or host aware device */
+	return dev->class == ATA_DEV_ZAC ||
+		ata_id_zoned_cap(dev->id) == 0x01;
+}
+
 #ifdef CONFIG_ATA_FORCE
 extern void ata_force_cbl(struct ata_port *ap);
 #else
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 1983a98e3d677..50cb59402cb17 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -155,7 +155,6 @@ enum {
 	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
 	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
 	ATA_DFLAG_D_SENSE	= (1 << 29), /* Descriptor sense requested */
-	ATA_DFLAG_ZAC		= (1 << 30), /* ZAC device */
 
 	ATA_DFLAG_FEATURES_MASK	= (ATA_DFLAG_TRUSTED | ATA_DFLAG_DA |	\
 				   ATA_DFLAG_DEVSLP | ATA_DFLAG_NCQ_SEND_RECV | \
-- 
2.51.0



