Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD063242D7;
	Sat, 30 May 2026 17:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161843; cv=none; b=TIYeXr9I1eCdYo0Si9yABUYtEzzvuL+MzHPAb/aQYyQCeoCUGFfcJo9P+bLz21qCHuh1TOZixCzogwREuD23HOJfNVmUQTAYEUAKiNPo+T3tXHs7VGIKOj4qwU/Ifh1lAgiGMLDXxB9va5gD553U+Lv+zankSJKdEfdOIq8ew5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161843; c=relaxed/simple;
	bh=Nbovf/oxOm2oThEYjVlOSoeGlpjVvSmxWrnfN+yyTFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cuy/psIETWAYI/PvXlMbeOVpAoCu9j/aT94NHdwX3JAIX5JFvlurL2+CmY9N8wYYoN5BfnubSMc28nD3v0Eh0DghpJjBfwv5ec9K/WYAgcVnXX9MP9jRT75j4WTo9+PXHxFHkelLZpaPu424LDdqe/f8knKzEH0Kk4Jw5LSpTI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ByBGZNOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByBGZNOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFEB1F00893;
	Sat, 30 May 2026 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161842;
	bh=ru/j6JRmuLqAJMp8K2MwYNRZvOosVrbh2LZeRLdKxis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByBGZNOWAdDrvlwD1VADAlwAYVQwTppwQbNRHyrVzaBV7Dy4S0DKalUaMp+sJcooj
	 nLbBQ05yA8z5flGoXn7blxsjL+Eik/EIUjVWaiud+Q35vc+xIHNEZV5fvqBNThG6Cp
	 JVlDyNWXCVJZ+hHwcB5YyE7YKQOXte1u73N/SJtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan@amutable.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 744/969] cdrom, scsi: sr: propagate read-only status to block layer via set_disk_ro()
Date: Sat, 30 May 2026 18:04:28 +0200
Message-ID: <20260530160321.103271649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daan De Meyer <daan@amutable.com>

[ Upstream commit 0898a817621a2f0cddca8122d9b974003fe5036d ]

The cdrom core never calls set_disk_ro() for a registered device, so
BLKROGET on a CD-ROM device always returns 0 (writable), even when the
drive has no write capabilities and writes will inevitably fail. This
causes problems for userspace that relies on BLKROGET to determine
whether a block device is read-only. For example, systemd's loop device
setup uses BLKROGET to decide whether to create a loop device with
LO_FLAGS_READ_ONLY. Without the read-only flag, writes pass through the
loop device to the CD-ROM and fail with I/O errors. systemd-fsck
similarly checks BLKROGET to decide whether to run fsck in no-repair
mode (-n).

The write-capability bits in cdi->mask come from two different sources:
CDC_DVD_RAM and CDC_CD_RW are populated by the driver from the MODE
SENSE capabilities page (page 0x2A) before register_cdrom() is called,
while CDC_MRW_W and CDC_RAM require the MMC GET CONFIGURATION command
and were only probed by cdrom_open_write() at device open time. This
meant that any attempt to compute the writable state from the full
mask at probe time was incorrect, because the GET CONFIGURATION bits
were still unset (and cdi->mask is initialized such that capabilities
are assumed present).

Fix this by factoring the GET CONFIGURATION probing out of
cdrom_open_write() into a new exported helper,
cdrom_probe_write_features(), and having sr call it from sr_probe()
right after get_capabilities() has populated the MODE SENSE bits.
register_cdrom() then calls set_disk_ro() based on the full
write-capability mask (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)
so the block layer reflects the drive's actual write support. The
feature queries used (CDF_MRW and CDF_RWRT via GET CONFIGURATION with
RT=00) report drive-level capabilities that are persistent across
media, so a single probe before register_cdrom() is sufficient and the
redundant probe at open time is dropped.

With set_disk_ro() now accurate, the long-vestigial cd->writeable flag
in sr can go: get_capabilities() used to set cd->writeable based on
the same four mask bits, but because CDC_MRW_W and CDC_RAM default to
"capability present" in cdi->mask and aren't touched by MODE SENSE,
the condition that gated cd->writeable was always true, making it
unconditionally 1. Replace the corresponding gate in sr_init_command()
with get_disk_ro(cd->disk), which turns a previously no-op check into
a real one and also catches kernel-internal bio writers that bypass
blkdev_write_iter()'s bdev_read_only() check.

The sd driver (SCSI disks) does not have this problem because it
checks the MODE SENSE Write Protect bit and calls set_disk_ro()
accordingly. The sr driver cannot use the same approach because the
MMC specification does not define the WP bit in the MODE SENSE
device-specific parameter byte for CD-ROM devices.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daan De Meyer <daan@amutable.com>
Reviewed-by: Phillip Potter <phil@philpotter.co.uk>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://patch.msgid.link/20260427210139.1400-2-phil@philpotter.co.uk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/cdrom.c | 73 ++++++++++++++++++++++++++++---------------
 drivers/scsi/sr.c     | 11 ++-----
 drivers/scsi/sr.h     |  1 -
 include/linux/cdrom.h |  1 +
 4 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8e3eeb96db63e..bba9eb8e2ca90 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -633,6 +633,16 @@ int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi)
 
 	WARN_ON(!cdo->generic_packet);
 
+	/*
+	 * Propagate the drive's write support to the block layer so BLKROGET
+	 * reflects actual write capability. Drivers that use GET CONFIGURATION
+	 * features (CDC_MRW_W, CDC_RAM) must have called
+	 * cdrom_probe_write_features() before register_cdrom() so the mask is
+	 * complete here.
+	 */
+	set_disk_ro(disk, !CDROM_CAN(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM |
+				     CDC_CD_RW));
+
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	mutex_lock(&cdrom_mutex);
 	list_add(&cdi->list, &cdrom_list);
@@ -747,6 +757,44 @@ static int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
 	return 0;
 }
 
+/*
+ * Probe write-related MMC features via GET CONFIGURATION and update
+ * cdi->mask accordingly. Drivers that populate cdi->mask from the MODE SENSE
+ * capabilities page (e.g. sr) should call this after those MODE SENSE bits
+ * have been set but before register_cdrom(), so that the full set of
+ * write-capability bits is known by the time register_cdrom() decides on the
+ * initial read-only state of the disk.
+ */
+void cdrom_probe_write_features(struct cdrom_device_info *cdi)
+{
+	int mrw, mrw_write, ram_write;
+
+	mrw = 0;
+	if (!cdrom_is_mrw(cdi, &mrw_write))
+		mrw = 1;
+
+	if (CDROM_CAN(CDC_MO_DRIVE))
+		ram_write = 1;
+	else
+		(void) cdrom_is_random_writable(cdi, &ram_write);
+
+	if (mrw)
+		cdi->mask &= ~CDC_MRW;
+	else
+		cdi->mask |= CDC_MRW;
+
+	if (mrw_write)
+		cdi->mask &= ~CDC_MRW_W;
+	else
+		cdi->mask |= CDC_MRW_W;
+
+	if (ram_write)
+		cdi->mask &= ~CDC_RAM;
+	else
+		cdi->mask |= CDC_RAM;
+}
+EXPORT_SYMBOL(cdrom_probe_write_features);
+
 static int cdrom_media_erasable(struct cdrom_device_info *cdi)
 {
 	disc_information di;
@@ -899,33 +947,8 @@ static int cdrom_is_dvd_rw(struct cdrom_device_info *cdi)
  */
 static int cdrom_open_write(struct cdrom_device_info *cdi)
 {
-	int mrw, mrw_write, ram_write;
 	int ret = 1;
 
-	mrw = 0;
-	if (!cdrom_is_mrw(cdi, &mrw_write))
-		mrw = 1;
-
-	if (CDROM_CAN(CDC_MO_DRIVE))
-		ram_write = 1;
-	else
-		(void) cdrom_is_random_writable(cdi, &ram_write);
-	
-	if (mrw)
-		cdi->mask &= ~CDC_MRW;
-	else
-		cdi->mask |= CDC_MRW;
-
-	if (mrw_write)
-		cdi->mask &= ~CDC_MRW_W;
-	else
-		cdi->mask |= CDC_MRW_W;
-
-	if (ram_write)
-		cdi->mask &= ~CDC_RAM;
-	else
-		cdi->mask |= CDC_RAM;
-
 	if (CDROM_CAN(CDC_MRW_W))
 		ret = cdrom_mrw_open_write(cdi);
 	else if (CDROM_CAN(CDC_DVD_RAM))
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5f..dc9c49dd1d0fd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -392,7 +392,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 
 	switch (req_op(rq)) {
 	case REQ_OP_WRITE:
-		if (!cd->writeable)
+		if (get_disk_ro(cd->disk))
 			goto out;
 		SCpnt->cmnd[0] = WRITE_10;
 		cd->cdi.media_written = 1;
@@ -672,6 +672,7 @@ static int sr_probe(struct device *dev)
 	error = -ENOMEM;
 	if (get_capabilities(cd))
 		goto fail_minor;
+	cdrom_probe_write_features(&cd->cdi);
 	sr_vendor_init(cd);
 
 	set_capacity(disk, cd->capacity);
@@ -890,14 +891,6 @@ static int get_capabilities(struct scsi_cd *cd)
 	/*else    I don't think it can close its tray
 		cd->cdi.mask |= CDC_CLOSE_TRAY; */
 
-	/*
-	 * if DVD-RAM, MRW-W or CD-RW, we are randomly writable
-	 */
-	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
-			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
-		cd->writeable = 1;
-	}
-
 	kfree(buffer);
 	return 0;
 }
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 1175f2e213b56..9809dac8b57d5 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -35,7 +35,6 @@ typedef struct scsi_cd {
 	struct scsi_device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
 	unsigned long ms_offset;	/* for reading multisession-CD's        */
-	unsigned writeable : 1;
 	unsigned use:1;		/* is this device still supportable     */
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 67caa909e3e61..24a344b15bed1 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -109,6 +109,7 @@ extern int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
 				       unsigned int clearing);
 
+extern void cdrom_probe_write_features(struct cdrom_device_info *cdi);
 extern int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi);
 extern void unregister_cdrom(struct cdrom_device_info *cdi);
 
-- 
2.53.0



