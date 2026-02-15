Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB13F2F25EB;
	Sun, 15 Feb 2026 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771167826; cv=none; b=hdGKu3gJrEr0yABIqm6TD3VibQ0tSJ3UxorOPPsscHSgHUOCiJIn+wW6RPlBa6QmtN1xk07XuFOs/dK5GzzAb27CV2XG3jEANj2KE4mkytVqhIKcO3bHgAwASnMGAWRzQ2nJMkfwc/1SA+KaGhItIaeNUKtDQthYHmmNiOT6v80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771167826; c=relaxed/simple;
	bh=GcwjBYfzTNbGqTmHst872MyOSPUCc8yXkObKcwFadws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz+TeQUv0cpTnXmRs3WNZGiqRfOt59+q+9GLA7D1lLm9aVY2kINzP+fiAwAxV2ogva8YdAIWEoDNMjMqeuRilX2PO+MCOG1PHCA643rolmcatPZZDYXR3/efbFMV01pslmoypz3OEgjrZahq2+VcI5zvA+90+e+Y5BMPmUL4fHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrA5FkfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrA5FkfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF802C19425;
	Sun, 15 Feb 2026 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771167826;
	bh=GcwjBYfzTNbGqTmHst872MyOSPUCc8yXkObKcwFadws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrA5FkfRxH/R1B1PFLrVRPawfBsGI9868CwuU8gvA+GWf1JtKhlpk87WYVzWRZTth
	 YhvvA6dlzHp7k1boKEEDtscua0+Bq1n5Eraq0RuI0SX87QPQVDMVY5ny9WE6xI+pq8
	 lkPi5V91nv9x0rM3T2bt78u9AYPQAKQMN9lLZR3A2sSFUhri3QnjuRGYix2XKbr5Mq
	 NGIGw8qpoY6PWgavsqrMpUS9wRSjeI7wlkNC2Y6+OQnDbvswxYNcG7nPSQ1h2eto1n
	 166kSSOszegELku22AoRnOjIRcE/v+aQxhHXHGibLWXj0bN1uW3gatYWHdkMSain69
	 VU8uQ0c5Diu4w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Henry Tseng <henrytseng@qnap.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cassel@kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] ata: libata: avoid long timeouts on hot-unplugged SATA DAS
Date: Sun, 15 Feb 2026 10:03:26 -0500
Message-ID: <20260215150333.2150455-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215150333.2150455-1-sashal@kernel.org>
References: <20260215150333.2150455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
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

LLM Generated explanations, may be completely bogus:

### Dependency Check Results

All dependencies are confirmed to exist in the current tree:
1. **`pci_channel_offline()`** - inline function in
   `include/linux/pci.h` (long-established API)
2. **`sys_err` label in `ata_qc_issue()`** - exists at the expected
   location
3. **`AC_ERR_HOST_BUS`** - defined in `include/linux/libata.h`
4. **`ATA_PFLAG_UNLOADING | ATA_PFLAG_SUSPENDED` pattern** - exists in
   `ata_scsi_port_error_handler()`
5. **`ata_scsi_find_dev()` structure** - matches expected layout

The commit is **self-contained** with no dependencies on other recent
commits. All APIs it uses are long-established kernel infrastructure.

### 8. SUMMARY

**Problem:** Hot-unplugging SATA DAS via Thunderbolt causes minutes-long
timeout cascades because libata keeps trying to issue commands and run
error handling against a dead PCI device.

**Fix:** Check `pci_channel_offline()` at three strategic points to fail
fast when the PCI device is already gone.

**Meets stable criteria:**
- **Obviously correct:** Uses established `pci_channel_offline()` API;
  conservative (only triggers when PCI channel is definitely offline)
- **Fixes a real bug:** Minutes-long hangs during hot-unplug
- **Important issue:** System hangs/unresponsiveness, scales with number
  of disks
- **Small and contained:** ~30 lines across 4 files, all within libata
- **No new features:** Just error detection and fast-fail for an
  already-broken state
- **No new APIs:** The new helper is internal to libata (`libata.h`, not
  `libata-scsi.h` or public headers)

**Risk vs Benefit:**
- **Benefit:** HIGH - eliminates minutes-long hangs for Thunderbolt dock
  users with SATA storage
- **Risk:** LOW - only changes behavior when PCI channel is already
  offline (device is dead anyway), uses existing error paths

**YES** - This is a well-crafted, maintainer-approved fix for a real
user-facing issue (extended timeouts/hangs on hot-unplug). It's small,
self-contained, uses established APIs, follows existing patterns in the
codebase, and has no dependencies on other commits. The fix is
conservative (only triggers when PCI is already offline) and the risk of
regression is minimal.

**YES**

 drivers/ata/libata-core.c | 24 ++++++++++++++++++++++++
 drivers/ata/libata-eh.c   |  3 ++-
 drivers/ata/libata-scsi.c |  3 +++
 drivers/ata/libata.h      |  1 +
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ddf9a7b28a594..2d55d1398f8d4 100644
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
@@ -5082,6 +5100,12 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
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
index 2586e77ebf45d..f4c9541d1910e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -736,7 +736,8 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* invoke EH, skip if unloading or suspended */
-	if (!(ap->pflags & (ATA_PFLAG_UNLOADING | ATA_PFLAG_SUSPENDED)))
+	if (!(ap->pflags & (ATA_PFLAG_UNLOADING | ATA_PFLAG_SUSPENDED)) &&
+	    ata_adapter_is_online(ap))
 		ap->ops->error_handler(ap);
 	else {
 		/* if unloading, commence suicide */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 721d3f270c8ec..8d92bb39e2434 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2982,6 +2982,9 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
 
+	if (!ata_adapter_is_online(ap))
+		return NULL;
+
 	if (unlikely(!dev || !ata_dev_enabled(dev)))
 		return NULL;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0e7ecac736809..89dd0ae2b9918 100644
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

