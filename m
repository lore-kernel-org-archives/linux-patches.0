Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D072459C5;
	Tue, 29 Apr 2025 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949159; cv=none; b=NuV9JPUF5alz+i9sR1d43QJ0G4DkR6rksW5EdcqD9AKJBbFX2ZH+WHXeLGy7G60jFIl400gnruycznuhtC1Mlfst8dRtqNUYLMBqmYr//018JKDAUsJSHPSfRwuR4bPr4dIdfTtCHBfMSbuBaMdPd0+m1wSNQ/5ZdVbVgmekG0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949159; c=relaxed/simple;
	bh=/vQ0UzKPwuFHnnm1RLfV2racaT5LQazjGZ9vgFEz+P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBI4tvViwQ++yTZsCJsv1aSyJT5M+7TaC8COfM63kgyzr7vE2pQEl3uPL+GFESuZR2+fkehP7U6tdgYxs5i7iSkFG5uMSvKgh8lGLOR7Ls3V5akptVDkwNvxck3rnztAAFeazDYRiTBOHJsnxqs39YMuwATwejXlqKHpY10jxFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2b7BOS3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2b7BOS3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD37EC4CEE3;
	Tue, 29 Apr 2025 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949159;
	bh=/vQ0UzKPwuFHnnm1RLfV2racaT5LQazjGZ9vgFEz+P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2b7BOS3+qxfItv+WEmhj+eaS+Xb4xwex773e+wM1rqwS3IDSJTEK524uOo5xzTsW7
	 onInwkSHFx5eJxWYFCxxI5Ux8ovr0sbhgvf7c50POCkn3dSpC72EhqWx6NN47KHViQ
	 KaBCX2cJC76nW1eIZKOvQ113VnETU9llxiJM4NU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 232/373] blk-cgroup: support to track if policy is online
Date: Tue, 29 Apr 2025 18:41:49 +0200
Message-ID: <20250429161132.686642769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit dfd6200a095440b663099d8d42f1efb0175a1ce3 upstream.

A new field 'online' is added to blkg_policy_data to fix following
2 problem:

1) In blkcg_activate_policy(), if pd_alloc_fn() with 'GFP_NOWAIT'
   failed, 'queue_lock' will be dropped and pd_alloc_fn() will try again
   without 'GFP_NOWAIT'. In the meantime, remove cgroup can race with
   it, and pd_offline_fn() will be called without pd_init_fn() and
   pd_online_fn(). This way null-ptr-deference can be triggered.

2) In order to synchronize pd_free_fn() from blkg_free_workfn() and
   blkcg_deactivate_policy(), 'list_del_init(&blkg->q_node)' will be
   delayed to blkg_free_workfn(), hence pd_offline_fn() can be called
   first in blkg_destroy(), and then blkcg_deactivate_policy() will
   call it again, we must prevent it.

The new field 'online' will be set after pd_online_fn() and will be
cleared after pd_offline_fn(), in the meantime pd_offline_fn() will only
be called if 'online' is set.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230119110350.2287325-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c         |   24 +++++++++++++++++-------
 include/linux/blk-cgroup.h |    1 +
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -192,6 +192,7 @@ static struct blkcg_gq *blkg_alloc(struc
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
 		pd->plid = i;
+		pd->online = false;
 	}
 
 	return blkg;
@@ -289,8 +290,11 @@ static struct blkcg_gq *blkg_create(stru
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];
 
-			if (blkg->pd[i] && pol->pd_online_fn)
-				pol->pd_online_fn(blkg->pd[i]);
+			if (blkg->pd[i]) {
+				if (pol->pd_online_fn)
+					pol->pd_online_fn(blkg->pd[i]);
+				blkg->pd[i]->online = true;
+			}
 		}
 	}
 	blkg->online = true;
@@ -390,8 +394,11 @@ static void blkg_destroy(struct blkcg_gq
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
 
-		if (blkg->pd[i] && pol->pd_offline_fn)
-			pol->pd_offline_fn(blkg->pd[i]);
+		if (blkg->pd[i] && blkg->pd[i]->online) {
+			if (pol->pd_offline_fn)
+				pol->pd_offline_fn(blkg->pd[i]);
+			blkg->pd[i]->online = false;
+		}
 	}
 
 	blkg->online = false;
@@ -1367,6 +1374,7 @@ retry:
 		blkg->pd[pol->plid] = pd;
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
+		pd->online = false;
 	}
 
 	/* all allocated, init in the same order */
@@ -1374,9 +1382,11 @@ retry:
 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
 			pol->pd_init_fn(blkg->pd[pol->plid]);
 
-	if (pol->pd_online_fn)
-		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
+		if (pol->pd_online_fn)
 			pol->pd_online_fn(blkg->pd[pol->plid]);
+		blkg->pd[pol->plid]->online = true;
+	}
 
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
@@ -1438,7 +1448,7 @@ void blkcg_deactivate_policy(struct requ
 
 		spin_lock(&blkcg->lock);
 		if (blkg->pd[pol->plid]) {
-			if (pol->pd_offline_fn)
+			if (blkg->pd[pol->plid]->online && pol->pd_offline_fn)
 				pol->pd_offline_fn(blkg->pd[pol->plid]);
 			pol->pd_free_fn(blkg->pd[pol->plid]);
 			blkg->pd[pol->plid] = NULL;
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -92,6 +92,7 @@ struct blkg_policy_data {
 	/* the blkg and policy id this per-policy data belongs to */
 	struct blkcg_gq			*blkg;
 	int				plid;
+	bool				online;
 };
 
 /*


