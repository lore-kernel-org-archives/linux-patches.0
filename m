Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5417E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39325C433C1;
	Wed,  2 Nov 2022 03:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358649;
	bh=xA4mQAal6pHW63JAX1mvRsr/9zyhRBSvZ1pHZWWLQtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4DuSDxKDX38GaFXR3PKBRQz/ywMWI0kUE6mtr8sgjdPzZEDLM24WtsBuN/HOUdjn
	 pZTCFZgo1A6viaYwEMg6TouwvWD9hdqDQRlTBBsPDR2pQBV08R9+r7Ox47I/Ps382d
	 kEUa5vMPvkrCq5lTc6jC5mXRcGb/xM+7L1wzaWAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.15 127/132] scsi: sd: Revert "scsi: sd: Remove a local variable"
Date: Wed,  2 Nov 2022 03:33:53 +0100
Message-Id: <20221102022103.008409308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

This reverts commit 84f7a9de0602704bbec774a6c7f7c8c4994bee9c.

Because it introduces a problem that rq->__data_len is set to the wrong
value.

before the patch:
1) nr_bytes = rq->__data_len
2) rq->__data_len = sdp->sector_size
3) scsi_init_io()
4) rq->__data_len = nr_bytes

after the patch:
1) rq->__data_len = sdp->sector_size
2) scsi_init_io()
3) rq->__data_len = rq->__data_len -> __data_len is wrong

It will cause that io can only complete one segment each time, and the io
will requeue in scsi_io_completion_action(), which will cause severe
performance degradation.

Scsi write same is removed in commit e383e16e84e9 ("scsi: sd: Remove
WRITE_SAME support") from mainline, hence this patch is only needed for
stable kernels.

Fixes: 84f7a9de0602 ("scsi: sd: Remove a local variable")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1072,6 +1072,7 @@ static blk_status_t sd_setup_write_same_
 	struct bio *bio = rq->bio;
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	blk_status_t ret;
 
 	if (sdkp->device->no_write_same)
@@ -1108,7 +1109,7 @@ static blk_status_t sd_setup_write_same_
 	 */
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_alloc_sgtables(cmd);
-	rq->__data_len = blk_rq_bytes(rq);
+	rq->__data_len = nr_bytes;
 
 	return ret;
 }


