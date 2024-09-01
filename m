Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652F317F389;
	Sun,  1 Sep 2024 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208570; cv=none; b=Nhkzv4ABSvSnMDqAfO9a5UA3jU/2wfCMn8hdyJ+C10rqYGUwEGXW61mJB43AcJtO4BubPmTh2TTq2Bcga+Q33F6SE11KKfPOjlu/xzA8w6TKThtUp4ZX4bjARhmh4fQdKP4N/tJXRSYbgvgTYht8O1dcOOg8X7mxIgjrJXpzMSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208570; c=relaxed/simple;
	bh=C+jrN6zvj3fny5D/r0dCtP++jlIr5TSjex3ghNVWhj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABMs80KyMP+beyol3Olkx0kCr6XGjPlS93jGZJhoJUdhAujbmrZ+8O7iXtFAqzaUSppVrvQs0YxgkPsWx9Q+i6cagVy8Q61r6Lo2XgQXF/tPiXI62hskKyMoIRSotR/ZeiRSNZ9Oy+nryFpB/i3Z4DV3VJKxxCviJ8vPMs92i8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWvdsnqg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWvdsnqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE446C4CEC3;
	Sun,  1 Sep 2024 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208570;
	bh=C+jrN6zvj3fny5D/r0dCtP++jlIr5TSjex3ghNVWhj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWvdsnqg0KnQtU1EZ76y3/ROzujQWL/2VfGZIxVt2qr47YItQSul9p31hMJuhQmtj
	 v/N+7cVwsnezWttBPsxueIky4kq1s3qdqsfGUuygWHrPWAVVCfw3/X1nm5+/es1PMN
	 O5nfyi+jnbfbam0v9UmaMu/4VXbHe8nwBovRw/8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 121/149] scsi: sd: Ignore command SYNCHRONIZE CACHE error if format in progress
Date: Sun,  1 Sep 2024 18:17:12 +0200
Message-ID: <20240901160822.004128133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1711,13 +1711,15 @@ static int sd_sync_cache(struct scsi_dis
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
 


