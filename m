Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE62206AA;
	Tue, 29 Apr 2025 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947185; cv=none; b=SxdzpwZnRgbXJwxQrH0mZIIsM2QujWaIvUbWsX8Lz1PKgRkEMWaUvzhfcitT3cvKhOZCIyjGEUghwDtK4/7RL/FAIEc4CkdC0OB50kZQCZsXDibNx03pu6sJHt+bRcstTM31xcCjwbhHFKzTEapDhJsHU39IlLnLD2ceGn8zfpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947185; c=relaxed/simple;
	bh=60T5jdSV1Bbl+42uiECU3vUomaZ2jueyEKOnkU90HMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIHyznR2f6EMU9Z5eeU6UbdyOp3XCgkqJ8R+3liMGxT5n3Fv8l/wSY/NCmPZIGeNZ4Zl9iK1A9gRoWizrCvtMspwOLahz5TnqAFqMts8tMM3wyj2DQivrA85z7m9UIBv+PSIO/8YXFKNh0goHcgOuCzrC4OJRhWkQz888d7yZt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G++PsmSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G++PsmSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63794C4CEE3;
	Tue, 29 Apr 2025 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947184;
	bh=60T5jdSV1Bbl+42uiECU3vUomaZ2jueyEKOnkU90HMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G++PsmSSmRJWWa+30HG5Zovg8fb7i5C2yJgZ5VERNKSwwvKzrik0YgxZwUjwx4yVD
	 sSE0PrVES0Ny3vqnNh12gALpnVcKVvWQdgyG4FpH9pryRViamLYixjtFk64govCgLU
	 8W9E50TxZToO+SBVciSwUwKKw5/BTV//WXWfHrsU=
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
Subject: [PATCH 5.10 170/286] blk-cgroup: support to track if policy is online
Date: Tue, 29 Apr 2025 18:41:14 +0200
Message-ID: <20250429161114.878961854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -191,6 +191,7 @@ static struct blkcg_gq *blkg_alloc(struc
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
 		pd->plid = i;
+		pd->online = false;
 	}
 
 	return blkg;
@@ -288,8 +289,11 @@ static struct blkcg_gq *blkg_create(stru
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
@@ -389,8 +393,11 @@ static void blkg_destroy(struct blkcg_gq
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
@@ -1364,6 +1371,7 @@ retry:
 		blkg->pd[pol->plid] = pd;
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
+		pd->online = false;
 	}
 
 	/* all allocated, init in the same order */
@@ -1371,9 +1379,11 @@ retry:
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
@@ -1435,7 +1445,7 @@ void blkcg_deactivate_policy(struct requ
 
 		spin_lock(&blkcg->lock);
 		if (blkg->pd[pol->plid]) {
-			if (pol->pd_offline_fn)
+			if (blkg->pd[pol->plid]->online && pol->pd_offline_fn)
 				pol->pd_offline_fn(blkg->pd[pol->plid]);
 			pol->pd_free_fn(blkg->pd[pol->plid]);
 			blkg->pd[pol->plid] = NULL;
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -87,6 +87,7 @@ struct blkg_policy_data {
 	/* the blkg and policy id this per-policy data belongs to */
 	struct blkcg_gq			*blkg;
 	int				plid;
+	bool				online;
 };
 
 /*


