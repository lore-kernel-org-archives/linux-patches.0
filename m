Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBEA35AC18;
	Wed, 20 May 2026 17:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297376; cv=none; b=etLp+ZugfcLEEnACXsIhWDosasNmCGrEgMg2WpO8Dxc/VCLMXGsHzrpt5jFnRY11TSfh0azzUm6Zg6epOkzwHFbhsm2GCapJjAyKLvOn+FTWMGCYzZiuvEdwNZRrl0LwEkPIK9f7xK0ER01UyFUJBnlGSC1a+hDaYYkbbeTJXQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297376; c=relaxed/simple;
	bh=JwafoCGgUrookpHrn7hnkAP2UvBEaHf/gDCL2G438+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDnA+g4HEp0K+DJQfN0onV0P028liUId9pHeOzd3Cq5VoQAAhNUDkQXR2ZG8w3VuaCUwrR5kxHzkZE30MH3WZISSciftZSEf7Wq6gmO7oCs5JgP30orddYiNWR33cjK36/l0rftRvZx8+ogzHDA+jngg8ti8W7UDxi9DqyjNOV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNqG9cka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNqG9cka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E191F000E9;
	Wed, 20 May 2026 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297375;
	bh=Pp0thGLozKi11Zp5SS4TjVFGEwnLHSqIo4NNaXFdd90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNqG9ckaQLhAWMWb4cg2jdkZFLHRIecOfXuScAZU+B0/93arueW6Dbq2uFvcjjHQk
	 jVULIk//iyVpqIFpYE3aKTVlUhTRsENy1on8BjOy7dYM53Zl/48XeQApSZvhNhdS3h
	 FNgPsOPakLSHC3FBkYKJHh9+mjJ6BWSAcpi6onEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/957] blk-cgroup: wait for blkcg cleanup before initializing new disk
Date: Wed, 20 May 2026 18:08:04 +0200
Message-ID: <20260520162134.591780023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3cffb68ba5d87..890c161bee25e 100644
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
@@ -611,6 +612,8 @@ static void blkg_destroy_all(struct gendisk *disk)
 
 	q->root_blkg = NULL;
 	spin_unlock_irq(&q->queue_lock);
+
+	wake_up_var(&q->root_blkg);
 }
 
 static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
@@ -1498,6 +1501,18 @@ int blkcg_init_disk(struct gendisk *disk)
 	struct blkcg_gq *new_blkg, *blkg;
 	bool preloaded;
 
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



