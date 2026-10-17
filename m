Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9A43ACA49;
	Sat, 17 Oct 2026 16:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255092; cv=none; b=Ec+PvTnQ1Mo3yzUJHPOSjGvhXnhFCcptcN1moTBEoYfcmkMkmvlCuxi3Xzg9XFPWn1HTEmU/xJEi3OKT1jAGjE3dRK5lZ/IhGrkGZvHkqDDHU/DdWcfAEi5BmkZLe4JdStW494oAq/tSFLJ92kdGvYs1lm+vfkjpj/qEnJyYUsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255092; c=relaxed/simple;
	bh=Bjf0eafEN7mFxb+itBr5gGvGDQqWUPrPa/roIr7KiDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud/jCq6RPyp5ftubW50GERvwvBQULGjy++clZRFZgjcAjGhf+W6yGzF4fCVYZc/+oED0Hy0451rvQJ63+XYUcDG7iOp53Fb9olIl4E1hGt2RwJkfIpwua7njUgJvxxh1rB8uM1ycfMLHMCLTVA+TYbM+y7VCUJYOo0ZB0oNzGvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfM6m359; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfM6m359"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5681F000C4;
	Sat, 17 Oct 2026 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255090;
	bh=H3lcYsMMhn2cwp8Xf903ahulbvuzZvk07OghAMuMNiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfM6m3596IBHkf6PkCGqq3mdBTeRafIKiqj/9kcVmQe+812ODXrndmTUt7wJyGGEm
	 rOm5kDguBqlkPxHSeSlFTSfpdzEfwGort1gH5wQEP3tjwN+lk+u4nQRd32X/9IUAUu
	 9MYc70J3z9BJYTYuLedLgGQw/K5O5LpeuqmhATWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Yu Kuai <yukuai@fygo.io>,
	Tao Cui <cuitao@kylinos.cn>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 663/869] blk-cgroup: fix race between policy activation and blkg destruction
Date: Sat, 17 Oct 2026 17:58:24 +0200
Message-ID: <20261017160053.994259036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 5313d4d41739b0cb63000747c97bb1217ac45f3e ]

When switching an IO scheduler on a block device, blkcg_activate_policy()
allocates blkg_policy_data (pd) for all blkgs attached to the queue.
However, blkcg_activate_policy() may race with concurrent blkcg deletion,
leading to use-after-free and memory leak issues.

The use-after-free occurs in the following race:

T1 (blkcg_activate_policy):
  - Successfully allocates pd for blkg1 (loop0->queue, blkcgA)
  - Fails to allocate pd for blkg2 (loop0->queue, blkcgB)
  - Enters the enomem rollback path to release blkg1 resources

T2 (blkcg deletion):
  - blkcgA is deleted concurrently
  - blkg1 is freed via blkg_free_workfn()
  - blkg1->pd is freed

T1 (continued):
  - Rollback path accesses blkg1->pd->online after pd is freed
  - Triggers use-after-free

In addition, blkg_free_workfn() frees pd before removing the blkg from
q->blkg_list. This allows blkcg_activate_policy() to allocate a new pd
for a blkg that is being destroyed, leaving the newly allocated pd
unreachable when the blkg is finally freed.

Fix these races by extending blkcg_mutex coverage to serialize
blkcg_activate_policy() rollback and blkg destruction, ensuring pd
lifecycle is synchronized with blkg list visibility.

Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260802112525.3933753-3-yukuai@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cc882dc2db7f6..06de4024a9a25 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1561,6 +1561,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 	if (queue_is_mq(q))
 		blk_mq_freeze_queue(q);
+
+	mutex_lock(&q->blkcg_mutex);
 retry:
 	spin_lock_irq(&q->queue_lock);
 
@@ -1625,6 +1627,7 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 	spin_unlock_irq(&q->queue_lock);
 out:
+	mutex_unlock(&q->blkcg_mutex);
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q);
 	if (pinned_blkg)
-- 
2.53.0



