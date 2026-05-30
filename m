Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B92D32D42B;
	Sat, 30 May 2026 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160784; cv=none; b=HwBphC+m0fK6lX+X8cNgZ9HSWvh8QDKnQhifY/Ac6mzkSTNSn8Px8gwDV0ehE+oSmqwiN2ELYMvEIYkEWZfD9U5N+lTjjnpNiWRjMBtjARK3eMcWPfHm+AEoiHKausf7jZnEZM12CKjK8RvNYA/+NCrqW8unKrCNDsZ3OT5s0vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160784; c=relaxed/simple;
	bh=sHn//o/Af7yyXB7632soR4LUoT7iSOidJpy3DSd9t44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odTVsXSyEfdxWkJKNMK1opPgr1HZNGZ0zoomB0Zi9977Yme+7lsZQbqz5weo8hs70796rAtvHQztoQ/re+RlWsbExyoK0C7PB6Tl/Q+4L9qswRlu5GNq3npAGhvF5aO1HlDT/pv/vhEWbpVLuT+fUKZ5rLy2L1QmerI/ji1egBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRJbRmG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRJbRmG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509911F00893;
	Sat, 30 May 2026 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160782;
	bh=I0MYLkPFwMetaMaiCO6D0ggkdsiwxauFmbFw8fBfHyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vRJbRmG7h/5U4XvPt0ECIDNmwZHjaNuIXR6aAKBsLMrvHBfc9Q0rnskPvj5VoAqML
	 Y+g2P5xsHHZYZFoUTk2+jGiv2NFcMw2QPBLPAzfhN/E3jqRpJ1zf/lO8RQe7wmwgAn
	 ovRcnm4hC6yAlyXGW/jWA++FyVGn2U8Np98iVHnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 432/969] blk-cgroup: wait for blkcg cleanup before initializing new disk
Date: Sat, 30 May 2026 17:59:16 +0200
Message-ID: <20260530160312.189504414@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 3dbaacf6ab68f81e3375fe769a2ecdbd3ce386fd ]

When a queue is shared across disk rebind (e.g., SCSI unbind/bind), the
previous disk's blkcg state is cleaned up asynchronously via
disk_release() -> blkcg_exit_disk(). If the new disk's blkcg_init_disk()
runs before that cleanup finishes, we may overwrite q->root_blkg while
the old one is still alive, and radix_tree_insert() in blkg_create()
fails with -EEXIST because the old blkg entries still occupy the same
queue id slot in blkcg->blkg_tree. This causes the sd probe to fail
with -ENOMEM.

Fix it by waiting in blkcg_init_disk() for root_blkg to become NULL,
which indicates the previous disk's blkcg cleanup has completed.

Fixes: 1059699f87eb ("block: move blkcg initialization/destroy into disk allocation/release handler")
Cc: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260311032837.2368714-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f314192b6de84..9b081dfba9007 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -24,6 +24,7 @@
 #include <linux/backing-dev.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/wait_bit.h>
 #include <linux/atomic.h>
 #include <linux/ctype.h>
 #include <linux/resume_user_mode.h>
@@ -509,6 +510,8 @@ static void blkg_destroy_all(struct gendisk *disk)
 
 	q->root_blkg = NULL;
 	spin_unlock_irq(&q->queue_lock);
+
+	wake_up_var(&q->root_blkg);
 }
 
 static int blkcg_reset_stats(struct cgroup_subsys_state *css,
@@ -1259,6 +1262,18 @@ int blkcg_init_disk(struct gendisk *disk)
 
 	INIT_LIST_HEAD(&q->blkg_list);
 
+	/*
+	 * If the queue is shared across disk rebind (e.g., SCSI), the
+	 * previous disk's blkcg state is cleaned up asynchronously via
+	 * disk_release() -> blkcg_exit_disk(). Wait for that cleanup to
+	 * finish (indicated by root_blkg becoming NULL) before setting up
+	 * new blkcg state. Otherwise, we may overwrite q->root_blkg while
+	 * the old one is still alive, and radix_tree_insert() in
+	 * blkg_create() will fail with -EEXIST because the old entries
+	 * still occupy the same queue id slot in blkcg->blkg_tree.
+	 */
+	wait_var_event(&q->root_blkg, !READ_ONCE(q->root_blkg));
+
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
-- 
2.53.0



