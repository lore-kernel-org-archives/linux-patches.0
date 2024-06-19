Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3CCAD58;
	Wed, 19 Jun 2024 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802954; cv=none; b=GcSe5TZV1LP4M68zVpvRDEbUWHRdMA2uhOaME/uDmqxeiUY3BZGMQuOJY3VtT+9JW5mpMkRiidcGkSoLOBhe6Iy9jsjkIIJfPbmHbVb44ApYZZ1IXB+FS0QxLewaR4OvHzBwBOSEHq+a+iqhlttTKfa+YGqjPiTt+gUdTPoow1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802954; c=relaxed/simple;
	bh=Fo6WaBN8y3PBGRersXQS4POEqQpQ4r0UCvHxOyahM5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbZGqIrkHUM1So1BH7lHX5BpF41Ltybhfk/aVbrCNBIJyk8+8TuMU12EvZli5VzhQdbcnqZXq9uj7rxJVLIcHJJ/n76mYq0ZYcqAJ8SNIcQkCV79TxRi9ZBy6Cwvjdta+i3IO6Zkl6xTjS75pkntWgnmCIFM7sohnqOBb32xJOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvKLw8XD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvKLw8XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D686C2BBFC;
	Wed, 19 Jun 2024 13:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802954;
	bh=Fo6WaBN8y3PBGRersXQS4POEqQpQ4r0UCvHxOyahM5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvKLw8XDFA/28QqRlO2sqPqW7qEv5gGCDtduYoGxV0KC3/WHhX1cpWBwWi+BnUTni
	 ZwkivyEysA1dcTOWnhV5ejZUg5sruwzeViWXHzDGr9j1dnkHAuht5UwBVaBWGvI1Hu
	 g96gHNL7shcAFweWEbfTqZMDxbBtf/uelh31K0dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Tomon <pierretom+12@ik.me>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.9 103/281] scsi: sd: Use READ(16) when reading block zero on large capacity disks
Date: Wed, 19 Jun 2024 14:54:22 +0200
Message-ID: <20240619125613.811050344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin K. Petersen <martin.petersen@oracle.com>

commit 7926d51f73e0434a6250c2fd1a0555f98d9a62da upstream.

Commit 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior
to querying device properties") triggered a read to LBA 0 before
attempting to inquire about device characteristics. This was done
because some protocol bridge devices will return generic values until
an attached storage device's media has been accessed.

Pierre Tomon reported that this change caused problems on a large
capacity external drive connected via a bridge device. The bridge in
question does not appear to implement the READ(10) command.

Issue a READ(16) instead of READ(10) when a device has been identified
as preferring 16-byte commands (use_16_for_rw heuristic).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218890
Link: https://lore.kernel.org/r/70dd7ae0-b6b1-48e1-bb59-53b7c7f18274@rowland.harvard.edu
Link: https://lore.kernel.org/r/20240605022521.3960956-1-martin.petersen@oracle.com
Fixes: 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior to querying device properties")
Cc: stable@vger.kernel.org
Reported-by: Pierre Tomon <pierretom+12@ik.me>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Pierre Tomon <pierretom+12@ik.me>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3572,16 +3572,23 @@ static bool sd_validate_opt_xfer_size(st
 
 static void sd_read_block_zero(struct scsi_disk *sdkp)
 {
-	unsigned int buf_len = sdkp->device->sector_size;
-	char *buffer, cmd[10] = { };
+	struct scsi_device *sdev = sdkp->device;
+	unsigned int buf_len = sdev->sector_size;
+	u8 *buffer, cmd[16] = { };
 
 	buffer = kmalloc(buf_len, GFP_KERNEL);
 	if (!buffer)
 		return;
 
-	cmd[0] = READ_10;
-	put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
-	put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	if (sdev->use_16_for_rw) {
+		cmd[0] = READ_16;
+		put_unaligned_be64(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be32(1, &cmd[10]);/* Transfer 1 logical block */
+	} else {
+		cmd[0] = READ_10;
+		put_unaligned_be32(0, &cmd[2]); /* Logical block address 0 */
+		put_unaligned_be16(1, &cmd[7]);	/* Transfer 1 logical block */
+	}
 
 	scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, buffer, buf_len,
 			 SD_TIMEOUT, sdkp->max_retries, NULL);


