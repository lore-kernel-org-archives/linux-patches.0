Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7C43B5315
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301141; cv=none; b=Iv1AJGGMHbw+rgxMqimTd9qlrQnvZAggSlIYuKvFqZv1kK2oV7cU4PaHsAa8rhf4ZPTKUqaWEPXkZ4fZJLADyfcsFO/rn70+HVf5NlVdVBYIlbLFdPsaII/30vxRe1m9+TiyTbwE1tXcbewpC5AOoc+OS/njFlf626zFYdjl1TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301141; c=relaxed/simple;
	bh=h39SX9uEgtk9WO0vxigE9eJJj6RB/n2qiVxHQ+oeXMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PycR0EfmHH8m0yPagTIvkYeiA+ZKIpOe4mC5/QjEG/OjYQdra9apgBKfL/LDrwZubc6MSOj30nCSOgI4Cac2xqLxvN2SLEEqaOSmz0I2eZPG7bJkbbDM60tw8RUmkKcYspQ3tIyiP+2YTXT2A1ZOKrLNVAtE8DchvMCcuU3xUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLq/HFjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hLq/HFjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E47CC116D0;
	Sat, 28 Feb 2026 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301141;
	bh=h39SX9uEgtk9WO0vxigE9eJJj6RB/n2qiVxHQ+oeXMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLq/HFjmsX0um4BFBZJwa0TR9XMPkXqhwrxxIp2tkDBRZGi93gsRXWzj/GmC91+ji
	 HlVaXdvVd0b+nyCrYQcZVQNwHJfZCMtF8YF1QFdPvjU3vyVNx81mlyxWjasBR7p//F
	 2cibDzRnCmfv+EWGdKifDWY+kYsS1X/awUo3FOk4a+oxU4KaVpoKw4+UmfCresZ5kw
	 Ri1vAqbVbuKYFOwN3MmjeD/to2l4n+vODsBiFWsVulNTyHllc5fhNX73fOzlT5laU+
	 fJfwbF+3rfezqE86VV3F5rv2NcqPoeSwbpZeyO6R1ujgCehuDML8f7S59+yfWxycDC
	 YJvVS9tIopIGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Henry Tseng <henrytseng@qnap.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/752] ata: libata: avoid long timeouts on hot-unplugged SATA DAS
Date: Sat, 28 Feb 2026 12:40:13 -0500
Message-ID: <20260228174750.1542406-302-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Henry Tseng <henrytseng@qnap.com>

[ Upstream commit 151cabd140322205e27dae5c4bbf261ede0056e3 ]

When a SATA DAS enclosure is connected behind a Thunderbolt PCIe
switch, hot-unplugging the whole enclosure causes pciehp to tear down
the PCI hierarchy before the SCSI layer issues SYNCHRONIZE CACHE and
START STOP UNIT for the disks.

libata still queues these commands and the AHCI driver tries to access
the HBA registers even though the PCI channel is already offline. This
results in a series of timeouts and error recovery attempts, e.g.:

  [  824.778346] pcieport 0000:00:07.0: pciehp: Slot(14): Link Down
  [  891.612720] ata8.00: qc timeout after 5000 msecs (cmd 0xec)
  [  902.876501] ata8.00: qc timeout after 10000 msecs (cmd 0xec)
  [  934.107998] ata8.00: qc timeout after 30000 msecs (cmd 0xec)
  [  936.206431] sd 7:0:0:0: [sda] Synchronize Cache(10) failed:
      Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
  ...
  [ 1006.298356] ata1.00: qc timeout after 5000 msecs (cmd 0xec)
  [ 1017.561926] ata1.00: qc timeout after 10000 msecs (cmd 0xec)
  [ 1048.791790] ata1.00: qc timeout after 30000 msecs (cmd 0xec)
  [ 1050.890035] sd 0:0:0:0: [sdb] Synchronize Cache(10) failed:
      Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

With this patch applied, the same hot-unplug looks like:

  [   59.965496] pcieport 0000:00:07.0: pciehp: Slot(14): Link Down
  [   60.002502] sd 7:0:0:0: [sda] Synchronize Cache(10) failed:
      Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
  ...
  [   60.103050] sd 0:0:0:0: [sdb] Synchronize Cache(10) failed:
      Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

In this test setup with two disks, the hot-unplug sequence shrinks from
about 226 seconds (~3.8 minutes) between the Link Down event and the
last SYNCHRONIZE CACHE failure to under a second. Without this patch the
total delay grows roughly with the number of disks, because each disk
gets its own SYNCHRONIZE CACHE and qc timeout series.

If the underlying PCI device is already gone, these commands cannot
succeed anyway. Avoid issuing them by introducing
ata_adapter_is_online(), which checks pci_channel_offline() for
PCI-based hosts. It is used from ata_scsi_find_dev() to return NULL,
causing the SCSI layer to fail new commands with DID_BAD_TARGET
immediately, and from ata_qc_issue() to bail out before touching the
HBA registers.

Since such failures would otherwise trigger libata error handling,
ata_adapter_is_online() is also consulted from ata_scsi_port_error_handler().
When the adapter is offline, libata skips ap->ops->error_handler(ap) and
completes error handling using the existing path, rather than running
a full EH sequence against a dead adapter.

With this change, SYNCHRONIZE CACHE and START STOP UNIT commands
issued during hot-unplug fail quickly once the PCI channel is offline,
without qc timeout spam or long libata EH delays.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Henry Tseng <henrytseng@qnap.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 24 ++++++++++++++++++++++++
 drivers/ata/libata-eh.c   |  3 ++-
 drivers/ata/libata-scsi.c |  3 +++
 drivers/ata/libata.h      |  1 +
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b29067759cc27..1a57560ecc90f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2358,6 +2358,24 @@ static bool ata_dev_check_adapter(struct ata_device *dev,
 	return false;
 }
 
+bool ata_adapter_is_online(struct ata_port *ap)
+{
+	struct device *dev;
+
+	if (!ap || !ap->host)
+		return false;
+
+	dev = ap->host->dev;
+	if (!dev)
+		return false;
+
+	if (dev_is_pci(dev) &&
+	    pci_channel_offline(to_pci_dev(dev)))
+		return false;
+
+	return true;
+}
+
 static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
@@ -5067,6 +5085,12 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	qc->flags |= ATA_QCFLAG_ACTIVE;
 	ap->qc_active |= 1ULL << qc->tag;
 
+	/* Make sure the device is still accessible. */
+	if (!ata_adapter_is_online(ap)) {
+		qc->err_mask |= AC_ERR_HOST_BUS;
+		goto sys_err;
+	}
+
 	/*
 	 * We guarantee to LLDs that they will have at least one
 	 * non-zero sg if the command is a data command.
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 258e657f3527c..b373cceb95d23 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -752,7 +752,8 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* invoke EH, skip if unloading or suspended */
-	if (!(ap->pflags & (ATA_PFLAG_UNLOADING | ATA_PFLAG_SUSPENDED)))
+	if (!(ap->pflags & (ATA_PFLAG_UNLOADING | ATA_PFLAG_SUSPENDED)) &&
+	    ata_adapter_is_online(ap))
 		ap->ops->error_handler(ap);
 	else {
 		/* if unloading, commence suicide */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 27ad145996052..5dc9586d9724e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3093,6 +3093,9 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
 
+	if (!ata_adapter_is_online(ap))
+		return NULL;
+
 	if (unlikely(!dev || !ata_dev_enabled(dev)))
 		return NULL;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 612fe59828180..0002994ddfc9b 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -94,6 +94,7 @@ extern int atapi_check_dma(struct ata_queued_cmd *qc);
 extern void swap_buf_le16(u16 *buf, unsigned int buf_words);
 extern bool ata_phys_link_online(struct ata_link *link);
 extern bool ata_phys_link_offline(struct ata_link *link);
+bool ata_adapter_is_online(struct ata_port *ap);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);
-- 
2.51.0

