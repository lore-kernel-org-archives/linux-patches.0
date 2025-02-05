Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C69B198845;
	Wed,  5 Feb 2025 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767306; cv=none; b=AJ9iFmtFwYHAzYJgiBfZflAMnieYfDx+9iPqwrdrHvWoS2429GXPGXCeApIKfEpQUvZd5qBPOZY72gpRQjjHosHaXXpfV1BfMI5ekoxg3HIpa1/0kH58RACJH4p/c/HbSPzxx6aqQabgS3gztZsf2j2SYNQn35q6u4SuaJVDVo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767306; c=relaxed/simple;
	bh=YLZOeYxpyOK+bIUZVcLOM5PK7zqnv2nz13cVATviMgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJZE6LHX32lGMB9aTHIapsYYf68fYOYfwOYL9D1CQZgdxkgpxvZvtThU9xSARcZmhqG07aJ7OCyLIiHW2IagnSOGt5ikhisvL3FcRuhhuaaEZ26O/kYzWQXoCpNl4lQUYwbQqNMEU4V/Q/lrzkvIFy9jpOH6adXRcYihVK0KMpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRl/dTmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRl/dTmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0F2C4CED1;
	Wed,  5 Feb 2025 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767305;
	bh=YLZOeYxpyOK+bIUZVcLOM5PK7zqnv2nz13cVATviMgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRl/dTmkMs8aFbQvbtbI5T0EOext1dw93QHpfTZgdDwHkM4komitEAyog9daYE83k
	 xk3eTlwkGLM2HgS3poHeZ97k1hISOWNMf0Op3Kk++wpazgUABh1f72OxfaGYYwLPrh
	 /+seiVXu/moqMQM9wj67MAItpO/hcSSGNpTmz15k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 437/590] scsi: mpi3mr: Fix possible crash when setting up bsg fails
Date: Wed,  5 Feb 2025 14:43:12 +0100
Message-ID: <20250205134511.986299556@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 295006f6e8c17212d3098811166e29627d19e05c ]

If bsg_setup_queue() fails, the bsg_queue is assigned a non-NULL value.
Consequently, in mpi3mr_bsg_exit(), the condition "if(!mrioc->bsg_queue)"
will not be satisfied, preventing execution from entering
bsg_remove_queue(), which could lead to the following crash:

BUG: kernel NULL pointer dereference, address: 000000000000041c
Call Trace:
  <TASK>
  mpi3mr_bsg_exit+0x1f/0x50 [mpi3mr]
  mpi3mr_remove+0x6f/0x340 [mpi3mr]
  pci_device_remove+0x3f/0xb0
  device_release_driver_internal+0x19d/0x220
  unbind_store+0xa4/0xb0
  kernfs_fop_write_iter+0x11f/0x200
  vfs_write+0x1fc/0x3e0
  ksys_write+0x67/0xe0
  do_syscall_64+0x38/0x80
  entry_SYSCALL_64_after_hwframe+0x78/0xe2

Fixes: 4268fa751365 ("scsi: mpi3mr: Add bsg device support")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250107022032.24006-1-kanie@linux.alibaba.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 10b8e4dc64f8b..7589f48aebc80 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2951,6 +2951,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		.max_hw_sectors		= MPI3MR_MAX_APP_XFER_SECTORS,
 		.max_segments		= MPI3MR_MAX_APP_XFER_SEGMENTS,
 	};
+	struct request_queue *q;
 
 	device_initialize(bsg_dev);
 
@@ -2966,14 +2967,17 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
+	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev), &lim,
 			mpi3mr_bsg_request, NULL, 0);
-	if (IS_ERR(mrioc->bsg_queue)) {
+	if (IS_ERR(q)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
 		device_del(bsg_dev);
 		put_device(bsg_dev);
+		return;
 	}
+
+	mrioc->bsg_queue = q;
 }
 
 /**
-- 
2.39.5



