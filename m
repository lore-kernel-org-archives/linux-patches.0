Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C728330B00;
	Fri, 17 Oct 2025 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715991; cv=none; b=tRBwkk6p+yxwitl61IvvYGD+A8tnUiK+rnNV1Fo5Co3NDCLWNaZhw4uLtBn62tQeQyh+Umo1lVF97W/vSN6XZC5rQOJk7F0EQLmAcdIJCAjpMuN5b2ZiSuviTfkS35Ux70HqCIJcNqFhmktchBLBe1fIW5l9tr38vv2q0fqdsU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715991; c=relaxed/simple;
	bh=rqg6dxBrtjgUZEk7TatVRlSUd5+2HExAyVRrGYTmGQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyE98zC1ln5taF9G83yMAREmnjQW0b526taRNlLvjcbiv7vHbSXbBvYKuo/BppIv5bp8mHNbbCKy7bgySKoAh4ZLAf6LXOVkx3qUXg63oF5Re2+MljRwERecESH+ZnpmBLWQePriDZlT2c0B6aM27wUF+OV3+Tpe7NmvWvMUxKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtNX6Mjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtNX6Mjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B91C4CEE7;
	Fri, 17 Oct 2025 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715991;
	bh=rqg6dxBrtjgUZEk7TatVRlSUd5+2HExAyVRrGYTmGQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtNX6MjjezfDa+CY/BerbtwgP45sR05Shrdqf7SsuBNsDWvgOTjOCDIlwKASOXk+N
	 zgHbhSZvf7sHPDM2lk76v8QAALkijXj7iAcqMMKF/0NQzAlNDRAA/YXtVsZzfkvW5+
	 JE7a/DupXffiF8eHji/ymahEr/eR+TzXJOToXkCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/276] blk-mq: check kobject state_in_sysfs before deleting in blk_mq_unregister_hctx
Date: Fri, 17 Oct 2025 16:52:07 +0200
Message-ID: <20251017145143.650715577@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7074ce8d2d03f..09f4faca338a2 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -178,9 +178,11 @@ static void blk_mq_unregister_hctx(struct blk_mq_hw_ctx *hctx)
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



