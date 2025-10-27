Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0A82D8DB9;
	Mon, 27 Oct 2025 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590383; cv=none; b=Q7ftfPMr2NChAYQeHz0M0m7WzCejbPa/W5hb1wJpPVM0y2+CeECX8j8+KV3J4JdGYWPwqXFfOUKGcTRV0grE15aS/1PJRTfGkkLIyM/QZRYCY2AS7dhPAP1cxYHRXFI+kxIzr4rzeVSldg45CdBnhrxYzlGU9n+nUkwOj7vodLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590383; c=relaxed/simple;
	bh=k66d5R+gFWoJgSgs831IRG1RlLXegHOiaRf4RxezKh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYsQiMWTgiurQ0YcnQFiw/D/RgMzMAc2pvf1Pz8rO0kN/xcFG/7qbrIlvL4mzoMnGlpWHesjeBnX4lC36gmv3Lu3Yo0iv/sFDLkHArjT+dH7+wwC1pM8zq4ezUMwwDl029QqVTfSW+MsdWKgstMN/4HJo60cxIxtMzFyVFwRMqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFuA58nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFuA58nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC25C4CEF1;
	Mon, 27 Oct 2025 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590383;
	bh=k66d5R+gFWoJgSgs831IRG1RlLXegHOiaRf4RxezKh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFuA58nBKKtmOPAiiSHJuJN0NHzS/6kwfKZ/fQzvaYKrs34MJ1lwWyHg1E28o2xJf
	 GwOhy9Pvr0ZLznn8i6UUH3sizzdtlxWP/7fVCJJh7cFiuTJ4UZSvrLxN8HW4nC2Ktl
	 5fNSEp0A9IlPaedtfBBI0gKNCYwHT2LFOntp9up4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/224] blk-mq: check kobject state_in_sysfs before deleting in blk_mq_unregister_hctx
Date: Mon, 27 Oct 2025 19:32:50 +0100
Message-ID: <20251027183509.651473705@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 4c7ef92f6d4d08a27d676e4c348f4e2922cab3ed ]

In __blk_mq_update_nr_hw_queues() the return value of
blk_mq_sysfs_register_hctxs() is not checked. If sysfs creation for hctx
fails, later changing the number of hw_queues or removing disk will
trigger the following warning:

  kernfs: can not remove 'nr_tags', no directory
  WARNING: CPU: 2 PID: 637 at fs/kernfs/dir.c:1707 kernfs_remove_by_name_ns+0x13f/0x160
  Call Trace:
   remove_files.isra.1+0x38/0xb0
   sysfs_remove_group+0x4d/0x100
   sysfs_remove_groups+0x31/0x60
   __kobject_del+0x23/0xf0
   kobject_del+0x17/0x40
   blk_mq_unregister_hctx+0x5d/0x80
   blk_mq_sysfs_unregister_hctxs+0x94/0xd0
   blk_mq_update_nr_hw_queues+0x124/0x760
   nullb_update_nr_hw_queues+0x71/0xf0 [null_blk]
   nullb_device_submit_queues_store+0x92/0x120 [null_blk]

kobjct_del() was called unconditionally even if sysfs creation failed.
Fix it by checkig the kobject creation statusbefore deleting it.

Fixes: 477e19dedc9d ("blk-mq: adjust debugfs and sysfs register when updating nr_hw_queues")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250826084854.1030545-1-linan666@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 7abd66d1228ad..532afcb672412 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -241,9 +241,11 @@ static void blk_mq_unregister_hctx(struct blk_mq_hw_ctx *hctx)
 		return;
 
 	hctx_for_each_ctx(hctx, ctx, i)
-		kobject_del(&ctx->kobj);
+		if (ctx->kobj.state_in_sysfs)
+			kobject_del(&ctx->kobj);
 
-	kobject_del(&hctx->kobj);
+	if (hctx->kobj.state_in_sysfs)
+		kobject_del(&hctx->kobj);
 }
 
 static int blk_mq_register_hctx(struct blk_mq_hw_ctx *hctx)
-- 
2.51.0



