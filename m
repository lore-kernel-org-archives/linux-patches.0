Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11833F5BC3;
	Wed, 20 May 2026 16:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294356; cv=none; b=MB21jN1JpAaBr0ygEuEBIPkMzAtrWSAx4wkRcH4hCqrHpFb7sQ2+yTnTRmvp8A3irOPeIfTugsZn6CcXgEcBUatR+trzLtmTp6+4dPmopHOhqldupGCgyMNeDrL8y97Cma0zd0gjeDcHVfA9BnTFrzdCemWuQi1GBiMiSus75Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294356; c=relaxed/simple;
	bh=yX192t1XB8h54aXER876UA1UR0BPzvaRQorRu5f7Cig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6LaOrpAqzE8Li7UE8sp+pKIiMCd/i52S+CE3MLQO4NM7EraoJdgWa+5dxWdzsIOhmTOmlLTsqQSXwptIUaw33N7Yl2xaa+FvDXWnF5QfPgAGSm33pLxBoTYXk0uRqNYTOh1G6ikpWg5MtXVmHPk/0TgwcgGpxZRY/BOBJka+Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUltN0Tf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUltN0Tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E842F1F000E9;
	Wed, 20 May 2026 16:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294355;
	bh=9/YzxTvrnrbYbXP9QkDeZiAQX0VxhnZ5+2t9HEUAQiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUltN0TfYlyxRL8itqnpaoK/SxW2K/o4PmJTwsxVlOCbHsYGZzRdRUKC2ad82GzrC
	 B1OfWJCo+4YfjaeWXvCrRDIsBOXfjG9CTwRQSlaHq7swhkI7BDnJoJDoodtfpD2YvY
	 IoBLzhK1zqpHPhvXUgL7YnRoRwTBPifBFYznKhzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0001/1146] blk-cgroup: wait for blkcg cleanup before initializing new disk
Date: Wed, 20 May 2026 18:04:11 +0200
Message-ID: <20260520162148.429730037@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index b70096497d389..2d7b18eb72915 100644
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



