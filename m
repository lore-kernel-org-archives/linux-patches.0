Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8B21419A0;
	Tue, 27 Feb 2024 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042079; cv=none; b=Tx5jmuibUa2bulpOrafVrkIFA1VNfZ8ChQqKdIH9uCobpJ3XEwxrkN7zAXYbW9J83AVB7F3mc2LtisX1w4MeOHewaL01hw1wNaUmQRgXXNyzC4U3G2k/oYndzFHvFk/6H9v7dshih1evgWPjE+EkNJwkv1a+PJjQSuEKlZGmF74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042079; c=relaxed/simple;
	bh=goLyyIxMDOIj+28eLFicuhVieFdjW15uJPyTnTYkrNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMZB70KeXviOJCBVzuaDdtll1lSr7X8Ueg9NNNiWBQU8y82nahtozbgXFPlBdv5I89XTnShnhUXnDogcCMgcpCumchn8Tgrorkil3xQcBvRxrjxvhozmWtFnfM1038uEBXgBSA+iLQzAwC8LS1o30z1XsAW0C9tQfQTYKLlqaqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjSUQ3DE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjSUQ3DE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E76C433F1;
	Tue, 27 Feb 2024 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042079;
	bh=goLyyIxMDOIj+28eLFicuhVieFdjW15uJPyTnTYkrNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjSUQ3DE3dzEu1T9hsXJ3vKU3PcZrK9ElkkH3PKV7/hUHKJI+rfvbTAqFv76IErPU
	 k9LskSU3MP3xB0SVCioTTDMLBVa5N9rI9L8JoELpWv95Ouz5D5nCrxe2l49GiGBqk8
	 TAzXKImTzLU5sqqZyXd9V++7CMEzc3wg351U0g9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 154/299] scsi: sd: usb_storage: uas: Access media prior to querying device properties
Date: Tue, 27 Feb 2024 14:24:25 +0100
Message-ID: <20240227131630.817888479@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin K. Petersen <martin.petersen@oracle.com>

commit 321da3dc1f3c92a12e3c5da934090d2992a8814c upstream.

It has been observed that some USB/UAS devices return generic properties
hardcoded in firmware for mode pages for a period of time after a device
has been discovered. The reported properties are either garbage or they do
not accurately reflect the characteristics of the physical storage device
attached in the case of a bridge.

Prior to commit 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to
avoid calling revalidate twice") we would call revalidate several
times during device discovery. As a result, incorrect values would
eventually get replaced with ones accurately describing the attached
storage. When we did away with the redundant revalidate pass, several
cases were reported where devices reported nonsensical values or would
end up in write-protected state.

An initial attempt at addressing this issue involved introducing a
delayed second revalidate invocation. However, this approach still
left some devices reporting incorrect characteristics.

Tasos Sahanidis debugged the problem further and identified that
introducing a READ operation prior to MODE SENSE fixed the problem and that
it wasn't a timing issue. Issuing a READ appears to cause the devices to
update their state to reflect the actual properties of the storage
media. Device properties like vendor, model, and storage capacity appear to
be correctly reported from the get-go. It is unclear why these devices
defer populating the remaining characteristics.

Match the behavior of a well known commercial operating system and
trigger a READ operation prior to querying device characteristics to
force the device to populate the mode pages.

The additional READ is triggered by a flag set in the USB storage and
UAS drivers. We avoid issuing the READ for other transport classes
since some storage devices identify Linux through our particular
discovery command sequence.

Link: https://lore.kernel.org/r/20240213143306.2194237-1-martin.petersen@oracle.com
Fixes: 1e029397d12f ("scsi: sd: Reorganize DIF/DIX code to avoid calling revalidate twice")
Cc: stable@vger.kernel.org
Reported-by: Tasos Sahanidis <tasos@tasossah.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Tasos Sahanidis <tasos@tasossah.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c              |   26 +++++++++++++++++++++++++-
 drivers/usb/storage/scsiglue.c |    7 +++++++
 drivers/usb/storage/uas.c      |    7 +++++++
 include/scsi/scsi_device.h     |    1 +
 4 files changed, 40 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3404,6 +3404,24 @@ static bool sd_validate_opt_xfer_size(st
 	return true;
 }
 
+static void sd_read_block_zero(struct scsi_disk *sdkp)
+{
+	unsigned int buf_len = sdkp->device->sector_size;
+	char *buffer, cmd[10] = { };
+
+	buffer = kmalloc(buf_len, GFP_KERNEL);
+	if (!buffer)
+		return;
+
+	cmd[0] = READ_10;
+	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+
+	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
+			 SD_TIMEOUT, sdkp->max_retries, NULL);
+	kfree(buffer);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -3443,7 +3461,13 @@ static int sd_revalidate_disk(struct gen
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
-
+		/*
+		 * Some USB/UAS devices return generic values for mode pages
+		 * until the media has been accessed. Trigger a READ operation
+		 * to force the device to populate mode pages.
+		 */
+		if (sdp->read_before_ms)
+			sd_read_block_zero(sdkp);
 		/*
 		 * set the default to rotational.  All non-rotational devices
 		 * support the block characteristics VPD page, which will
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -180,6 +180,13 @@ static int slave_configure(struct scsi_d
 		sdev->use_192_bytes_for_3f = 1;
 
 		/*
+		 * Some devices report generic values until the media has been
+		 * accessed. Force a READ(10) prior to querying device
+		 * characteristics.
+		 */
+		sdev->read_before_ms = 1;
+
+		/*
 		 * Some devices don't like MODE SENSE with page=0x3f,
 		 * which is the command used for checking if a device
 		 * is write-protected.  Now that we tell the sd driver
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -879,6 +879,13 @@ static int uas_slave_configure(struct sc
 		sdev->guess_capacity = 1;
 
 	/*
+	 * Some devices report generic values until the media has been
+	 * accessed. Force a READ(10) prior to querying device
+	 * characteristics.
+	 */
+	sdev->read_before_ms = 1;
+
+	/*
 	 * Some devices don't like MODE SENSE with page=0x3f,
 	 * which is the command used for checking if a device
 	 * is write-protected.  Now that we tell the sd driver
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -208,6 +208,7 @@ struct scsi_device {
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned set_dbd_for_ms:1; /* Set "DBD" field in mode sense */
+	unsigned read_before_ms:1;	/* perform a READ before MODE SENSE */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */


