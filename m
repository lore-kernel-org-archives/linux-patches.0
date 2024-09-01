Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C419F44C97;
	Sun,  1 Sep 2024 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208104; cv=none; b=DxhOrngz1XctUXN0T3ayIn31hzmRBQAJAyGAzZOFjHakN5afDCH4kgca7x4YmoM2HOjoxET6aEQLsk6on3iIj2z9fbI9X2jIQzvWyfCV88uX7Rxzy6LvaNxPGoHG+ARWMWaE6vOa0U+gEv5Ppuvt4wK9J7zvhzxt7duz9OUJOZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208104; c=relaxed/simple;
	bh=EDZ3krE2XCzQlxEBs7piYdVJX9YJZZ42ux2KsDa0hfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nd8LOjOCU/MLTBaFsdLrSLjzwBmizy8gfZ2VHVP3jJDyGNoj2+dK+th65BREKbOmW1Gukg9hVjGJAN7Z5J5YuFS5k8zRt6JddKbSQ9DJuWhEtsR69iEI9bQXqyybnsH6YdoyUO0HrUF3qz7bdQBK2AaYsyfI8Am5KEGLyZz1jZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlSpMORJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlSpMORJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF42C4CEC3;
	Sun,  1 Sep 2024 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208104;
	bh=EDZ3krE2XCzQlxEBs7piYdVJX9YJZZ42ux2KsDa0hfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DlSpMORJOqeU07ABGHUZablYNBw9QdJmgSJx47f4cRksInlssiuxSZPyrprHMbr5A
	 iyzTFt57BLWI5XpfMEYJlYHLa9iJWBrYjwvpYGqrF0yToHyhL3qNfaTdCXoG8n5D0h
	 QwJGefdQohtSoy/MbxvDIpT7KHJMx9rccRW7slBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 75/93] scsi: sd: Ignore command SYNCHRONIZE CACHE error if format in progress
Date: Sun,  1 Sep 2024 18:17:02 +0200
Message-ID: <20240901160810.560626716@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

commit 4f9eedfa27ae5806ed10906bcceee7bae49c8941 upstream.

If formatting a suspended disk (such as formatting with different DIF
type), the disk will be resuming first, and then the format command will
submit to the disk through SG_IO ioctl.

When the disk is processing the format command, the system does not
submit other commands to the disk. Therefore, the system attempts to
suspend the disk again and sends the SYNCHRONIZE CACHE command. However,
the SYNCHRONIZE CACHE command will fail because the disk is in the
formatting process. This will cause the runtime_status of the disk to
error and it is difficult for user to recover it. Error info like:

[  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
[  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
[  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
[  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4

To solve the issue, ignore the error and return success/0 when format is
in progress.

Cc: stable@vger.kernel.org
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Link: https://lore.kernel.org/r/20240819090934.2130592-1-liyihang9@huawei.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1690,13 +1690,15 @@ static int sd_sync_cache(struct scsi_dis
 			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+
 			/*
-			 * This drive doesn't support sync and there's not much
-			 * we can do because this is called during shutdown
-			 * or suspend so just return success so those operations
-			 * can proceed.
+			 * If a format is in progress or if the drive does not
+			 * support sync, there is not much we can do because
+			 * this is called during shutdown or suspend so just
+			 * return success so those operations can proceed.
 			 */
-			if (sshdr.sense_key == ILLEGAL_REQUEST)
+			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
+			    sshdr.sense_key == ILLEGAL_REQUEST)
 				return 0;
 		}
 


