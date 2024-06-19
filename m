Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CCB143873;
	Wed, 19 Jun 2024 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802142; cv=none; b=QETcf6HFLfpkE9xX/kJ9d+uoBikAydNGp9hc8dbGlV3IGVRpgF/jlViPYL7NcGEvzgvoTJYDCfJ2VzohGUqqTj7hVzDO2iCnOOvmfdRkr0vy9IDpy/Wt0PEEoPY1EAp/MVsqJDHOqSDEQWU+8xNc5HvwCTNpzLw85NJj2i9cZQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802142; c=relaxed/simple;
	bh=A7PWdoKrpohA8cHq8USxfnGzF8GhEVWcB9hxEV+Y6ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TonED2WXHEb1byN3q2NsirAUoSLtjTqHlqhYuErxf30i4/TQUUcA/PeiglIUiz38lm7am9WIVhvSH1VA7PVuMbWwxD/cIBXGsi/7XbMV/qrtc4Su2pFq0XpAKlMzrXdhP2n8aA8CtT22fZ9nAw4It0UqFfDedcOeVumfroytAj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sw39yyI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sw39yyI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60627C32786;
	Wed, 19 Jun 2024 13:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802142;
	bh=A7PWdoKrpohA8cHq8USxfnGzF8GhEVWcB9hxEV+Y6ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sw39yyI/E8LmAcHAOMLGJox4LT0IXoED37yyBtMC5Hk8GYQ6bg4lzCQ7Gd0rsmpY3
	 He3WRK3Y/afACDjKPtGnqxu6wN2Yskgx81UPhAK4bFoEjBjpYPVbOFywdOl1bbmkAO
	 BOQHGK8CkwB8Mif2nHe6w7frp4DwroSpfcl5B3M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Tomon <pierretom+12@ik.me>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 097/267] scsi: sd: Use READ(16) when reading block zero on large capacity disks
Date: Wed, 19 Jun 2024 14:54:08 +0200
Message-ID: <20240619125610.074661013@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
@@ -3406,16 +3406,23 @@ static bool sd_validate_opt_xfer_size(st
 
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


