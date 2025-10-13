Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4882D3093C9;
	Mon, 13 Oct 2025 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368150; cv=none; b=V4NiMyg63y59mbf1wTTTNjSoAILyr/e89z+noGZGGvQK1HNwcory8aN3tTmqIQ+v23dzaSjbhUPRRTxlBn0QFD51axF8cWQA8z+Af970Y7WbUyvFkv0Ktr5uELGKKMdpGAItVCXYy7MafBIcRukSv6E3fXggCvk4NDOBJzm4sBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368150; c=relaxed/simple;
	bh=NtA3/qUiiiW3/uyIBGENbGS/UGfwire103ZVDwNF4xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gW+kPy1Sw2HMXhWPhvsFMuiT3hexg7XID3OHZ/NGRQ2iwc9PN+eJ7fmz9NCxi2WUkJt3ciOQnLQPrH96B4Gzm8460GxJejq28e8cJ+Xw2GyVyG71SQyqpDjpO3N58paTwGnRBfOaZWgRbj1DLLxngmB7OwDHV0qE66G7CPIwDtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zafesFda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zafesFda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB96C4CEE7;
	Mon, 13 Oct 2025 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368150;
	bh=NtA3/qUiiiW3/uyIBGENbGS/UGfwire103ZVDwNF4xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zafesFdaY5UDtFaS6Iogc3WE8ykTixHg9ho/V9xcO+NDAQt+DqFVCJ9wYGa3YzMO/
	 d0yjO+MTmYWkWzM1cue4tmHlEYNmsWQzGHsLfM57Xm0M4+Cp9p6q6bGgxu3WzxpmY3
	 vdAH588sVJkYqSuQ6ybWhAQJ8mbs3s+C/WSLrAXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/262] blk-mq: check kobject state_in_sysfs before deleting in blk_mq_unregister_hctx
Date: Mon, 13 Oct 2025 16:42:56 +0200
Message-ID: <20251013144327.361243078@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 156e9bb07abf1..2fb234ab467b1 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -150,9 +150,11 @@ static void blk_mq_unregister_hctx(struct blk_mq_hw_ctx *hctx)
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



