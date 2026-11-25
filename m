Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625518;
	b=BF/oi376k04TsuIg9Ct3bAwKIYSDNWCjON79wGCDmSuQ3xjmWwOHdo27bLeT6tjdCPbw
	 DbjmbuEX2vSP+32h7hP6u8omG+ZS8+42zTs7mtXxgr0rZsm+liezZDh+ImCUsJAjp4Hof
	 cuMErmrVGjdxhKVpeBIAcZ0mkBkiQ9jGW8HQYoOitzUiYdkqkU/Ea0gcVhgXtg+mm7jOu
	 cufvXIIym5AcE8BRYys1v/8ai00lKxprQkpsChSjcxs6NxUbPpK7vFk12Jju+nVYNdtEa
	 b0ylYx/2FVxC2heqyKy2VdTdunb8qhK0wRjW3h3XwAeX7S5780W/xJlYhsgcThNWavA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z9QXWUmqqjoMvZUn31XSve174VMwCoXXssptpVKCVwQ=;
	b=BpXAOsoKHK/9UMvQcvHwAvYw1dY+zwtk2OfzVV95HIDtZqq6kWs6+w+SWI4tnI/WkrQN
	 p5nDz13pfB6ILYsxzBcvHjRZhTDglY321RrRWpjPjWmAK0AtZkmX8WaMdVTQfG+Z+yIea
	 0nFjfVG8kjWelKx0ApfYNNbsXy2bWaZWK/M4zd7kL6iEeteYatnl/RkmeVosoLiBvMKxN
	 W78djvKvZuoUedFmFmXWqr4y35GH/oEDrzMIUw2yC221l+xchz2xrpeqybIQmoqPg4p3K
	 xy6TaFHJ+sgLPI1fStqtBJjHBNvbMxPLogtTYuqgxaUEavcmcODEC2pnAp1+YKyTG9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMK65akM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEEE606A31E;
	Wed, 25 Nov 2026 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMK65akM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5099C1F000C6;
	Wed, 25 Nov 2026 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625517;
	bh=Z9QXWUmqqjoMvZUn31XSve174VMwCoXXssptpVKCVwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMK65akMNk85ClSvCXH56hviJjsptMcag80U0i4qUdeixB2ks5btEY+eNwfVRr7xo
	 /ZpEWECrzIhmq8YjWgMKoQO8HdsIZaaTi4ho6hsL+SHb5axuxjMXau5GlR610k7Ari
	 3giRJ7N+2QNFxwSj+//n+UbKp4SuaxucfeGXhtMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 542/816] block: dont enter reclaim under rq_qos_mutex
Date: Wed, 25 Nov 2026 15:34:50 +0100
Message-ID: <20261125143901.732337212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 045cbfc369f5929ed473f7c200dc2e8146569ce5 ]

ioc_qos_write() and the wbt_lat_usec writers take rq_qos_mutex with the
queue frozen, blkcg_deactivate_policy() does the same with blkcg_mutex,
so nothing holding either may wait for IO. blkg_conf_prep() got
GFP_NOIO for the blkg in commit 5d726c4dbeed, but the
radix_tree_preload() right after it, the policy init functions and the
GFP_KERNEL fallback in blkcg_activate_policy() can still enter reclaim
there. lockdep reports the cycle on the first write to io.max.

Use GFP_NOIO for all of them.

Fixes: 9730763f4756 ("block: correct locking order for protecting blk-wbt parameters")
Fixes: 5d726c4dbeed ("blk-cgroup: fix possible deadlock while configuring policy")
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261028164415.1262013-35-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Replaced kzalloc_obj(*ioc, GFP_NOIO) and the kzalloc_obj(*blkiolat, GFP_NOIO) call with plain kzalloc(sizeof(...), GFP_NOIO), since kzalloc_obj doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c    | 13 +++++++++----
 block/blk-iocost.c    |  5 +++--
 block/blk-iolatency.c |  3 ++-
 block/blk-throttle.c  |  3 ++-
 4 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d1f3d3491bd36..9e8a89b439611 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -884,7 +884,11 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			parent = blkcg_parent(parent);
 		}
 
-		/* Drop locks to do new blkg allocation with GFP_KERNEL. */
+		/*
+		 * Drop the spinlock to allocate the new blkg. rq_qos_mutex and
+		 * blkcg_mutex stay held, and both are taken with the queue
+		 * frozen elsewhere: GFP_NOIO.
+		 */
 		spin_unlock_irq(&q->queue_lock);
 
 		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
@@ -893,7 +897,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail_exit;
 		}
 
-		if (radix_tree_preload(GFP_KERNEL)) {
+		if (radix_tree_preload(GFP_NOIO)) {
 			blkg_free(new_blkg);
 			ret = -ENOMEM;
 			goto fail_exit;
@@ -1598,7 +1602,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 		if (!pd) {
 			/*
 			 * GFP_NOWAIT failed.  Free the existing one and
-			 * prealloc for @blkg w/ GFP_KERNEL.
+			 * prealloc for @blkg w/ GFP_NOIO: blkcg_mutex is held,
+			 * and a bio based queue has not been frozen above.
 			 */
 			if (pinned_blkg)
 				blkg_put(pinned_blkg);
@@ -1610,7 +1615,7 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 			if (pd_prealloc)
 				pol->pd_free_fn(pd_prealloc);
 			pd_prealloc = pol->pd_alloc_fn(disk, blkg->blkcg,
-						       GFP_KERNEL);
+						       GFP_NOIO);
 			if (pd_prealloc)
 				goto retry;
 			else
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c7097b5c39c3a..29bfbfdb43750 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2982,11 +2982,12 @@ static int blk_iocost_init(struct gendisk *disk)
 	struct ioc *ioc;
 	int i, cpu, ret;
 
-	ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);
+	/* The caller holds rq_qos_mutex, which is taken with the queue frozen */
+	ioc = kzalloc(sizeof(*ioc), GFP_NOIO);
 	if (!ioc)
 		return -ENOMEM;
 
-	ioc->pcpu_stat = alloc_percpu(struct ioc_pcpu_stat);
+	ioc->pcpu_stat = alloc_percpu_gfp(struct ioc_pcpu_stat, GFP_NOIO);
 	if (!ioc->pcpu_stat) {
 		kfree(ioc);
 		return -ENOMEM;
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index a82ee8c408c2f..3e3667159624f 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -761,7 +761,8 @@ static int blk_iolatency_init(struct gendisk *disk)
 	struct blk_iolatency *blkiolat;
 	int ret;
 
-	blkiolat = kzalloc(sizeof(*blkiolat), GFP_KERNEL);
+	/* The caller holds rq_qos_mutex, which is taken with the queue frozen */
+	blkiolat = kzalloc(sizeof(*blkiolat), GFP_NOIO);
 	if (!blkiolat)
 		return -ENOMEM;
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 35b35b34cad5f..3e950426c6643 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1211,7 +1211,8 @@ static int blk_throtl_init(struct gendisk *disk)
 	struct throtl_data *td;
 	int ret;
 
-	td = kzalloc_node(sizeof(*td), GFP_KERNEL, q->node);
+	/* The caller holds rq_qos_mutex, which is taken with the queue frozen */
+	td = kzalloc_node(sizeof(*td), GFP_NOIO, q->node);
 	if (!td)
 		return -ENOMEM;
 
-- 
2.53.0



