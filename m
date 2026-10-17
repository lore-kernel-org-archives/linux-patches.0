Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4114374E60;
	Sat, 17 Oct 2026 17:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257808; cv=none; b=bk8+GsiY7pPCt2mAUk76B94QgNMRe29430aRMvTXSmiPdS0zGZ+SbvoqgZmQOQRkqSwS8B4NQjEb2zUeAEc7D9o5AlgAH1IJo64OWl49GzHQww2wTTOZVhxa9emJ7p7fxo5TQoDXAkrmHW4T7J4g92tzO9+ZOFAO6Ho1gnCWDLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257808; c=relaxed/simple;
	bh=NYGy1qYGvRVCykRR77blfE5AjVGiMkjjp0T55EvRwmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/neDqzRcOpMvY5frXOna2N1eDAHtdqnN5nJN2RQLe6ERPpZZk2IA/kwEZi2yTAXYeen6CN/UwoLsQBPdCCAE5j8Y181BZHcZv6MhLmqnbvB/6QcUfqclcsjbYS3OvvM2EGBFWs46UJBgbqyJ1Xx/zlFzznQYF7ElhuiP7lYW7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3CXNvFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3CXNvFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356FB1F000C4;
	Sat, 17 Oct 2026 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257807;
	bh=oOnKB5INrBkpDbBhOIiToZ00tAVp1fPoI3I8AzRaOc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3CXNvFJ6p2D7TfWt5decLnNIN7YdFMYJseTml3dkQrPINQ1bbEIGuwqi36KLGdQ3
	 eJGjXJ856vSsueDENQJiYCJhZwSK3qx8Q482oRphR+cPhIXCNhB5IWIobM7+Gu3Ekw
	 LuY2evIC/ujqDYtTSJi4iibvwAo5AqIhQ/yQdKb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0677/1674] scsi: mpi3mr: Fix possible crash when setting up bsg fails
Date: Sat, 17 Oct 2026 17:49:09 +0200
Message-ID: <20261017160448.486302678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/scsi/mpi3mr/mpi3mr_app.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 8e9e278d04495..27fcffa94713b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1534,6 +1534,7 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 {
 	struct device *bsg_dev = &mrioc->bsg_dev;
 	struct device *parent = &mrioc->shost->shost_gendev;
+	struct request_queue *q;
 
 	device_initialize(bsg_dev);
 
@@ -1549,9 +1550,9 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
-	mrioc->bsg_queue = bsg_setup_queue(bsg_dev, dev_name(bsg_dev),
+	q = bsg_setup_queue(bsg_dev, dev_name(bsg_dev),
 			mpi3mr_bsg_request, NULL, 0);
-	if (IS_ERR(mrioc->bsg_queue)) {
+	if (IS_ERR(q)) {
 		ioc_err(mrioc, "%s: bsg registration failed\n",
 		    dev_name(bsg_dev));
 		device_del(bsg_dev);
@@ -1559,6 +1560,8 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
+	mrioc->bsg_queue = q;
+
 	blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
 	blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
 
-- 
2.53.0



