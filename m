Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033094;
	b=pRRAm2G3+hKwej0QQa3uW/ar6VZfBHYa7RYUIWn+wffGM4bLlLJNvyzD7Xe4ud9Gat+8
	 kMDuDzhAigu+K17CB6tK3GBkN7W4BJBYjWi7cuxojnPiRuUy1CUMWZtYz3UWfqk3F1loU
	 0X/AzmDzqJvNEIJ7RHJxJMiYJs5hQxIVLLR7mp6fRwqHUOXqz1GxvXMzyN/z92mz+Lg27
	 rKt8Q01rWgHAeg00/4dd3gPgpWOGsVsNO/hxtU97wpnhP5/sPw3Qlsyh4l0OdDI8T7b47
	 H/MMGYRuE0GcqTXAUbNWtnmvJt6oJzlD5cXb/pIdYfoS8muqLKFp/xfriGi664/HJLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gMkZSs224ryr/18/mSjPH/V68uO5cZXRalzyqCMghgM=;
	b=mLMcsLREVpRhdLa0tk1VUfCjxG/Rl52dsZy8K7uUHHBSr/Vja4PQinAvdqZdmCEMWAF/
	 aP+qoX0HIyd/IU8L5U2AJJTtZWP8JXPdGWk6CoCLnCg5+MMrEILJPrh9woCqs9JXwLeO8
	 RU2u90aytEPfLf3RfqonzXqzf/VjLeU3PwYQ23V8H0w4hBXKM36ux8KrIkFG8WfLmdSeF
	 uFxWdqf1I7OrAPNSaPvt5WI9RG3LMinvYL75BvBzgaeo6k/ba7LyN8bz0LYmEKiNW+AiT
	 nAdPObkwDHdfd4OvyO7xSSJwroPG+9XTEx6UsxBb5zbyvGiEfgdmjXooMSPh1lCzzIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gphNu5fq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7A1606A31C;
	Wed, 18 Nov 2026 20:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gphNu5fq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9F41F000C7;
	Wed, 18 Nov 2026 20:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033094;
	bh=gMkZSs224ryr/18/mSjPH/V68uO5cZXRalzyqCMghgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gphNu5fqflzeaJLdabD1QDeMNBdn9JFsjWsEvFcydTJtU4NxICgXgqo4hpx/GFdtp
	 4n7OeBL2U+DSYKqFQH9WIFAERXrqEgn5OXWI6YnvfwkquJaC842Snpvl5KrLo+XRWq
	 eC8CoS8UPJ2g8As6bETfzeS62ld/dDpGifQGUWQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1643/1756] block: flush all throttled bios when deleting the cgroup
Date: Wed, 18 Nov 2026 16:02:50 +0100
Message-ID: <20261118150115.169681756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 919b5139bd1d557a4d4cd4b2466e2440dda65484 ]

When a process migrates to another cgroup and the original cgroup is deleted,
the restrictions of throttled bios cannot be removed. If the restrictions
are set too low, it will take a long time to complete these bios.

Refer to the process of deleting a disk to remove the restrictions and
issue bios when deleting the cgroup.

This makes difference on the behavior of throttled bios:
Before: the limit of the throttled bios can't be changed and the bios will
complete under this limit;
Now: the limit will be canceled and the throttled bios will be flushed
immediately.

References:
[1] https://lore.kernel.org/r/20220318130144.1066064-4-ming.lei@redhat.com
[2] https://lore.kernel.org/all/da861d63-58c6-3ca0-2535-9089993e9e28@huaweicloud.com/

Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20240817071108.1919729-1-lilingfeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 587edb931fdd ("blk-throttle: pass the I/O counts of a dead group on")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-throttle.c | 68 ++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c15dfb3100ee9..83b5390be11d6 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1527,6 +1527,42 @@ static void throtl_shutdown_wq(struct request_queue *q)
 	cancel_work_sync(&td->dispatch_work);
 }
 
+static void tg_flush_bios(struct throtl_grp *tg)
+{
+	struct throtl_service_queue *sq = &tg->service_queue;
+
+	if (tg->flags & THROTL_TG_CANCELING)
+		return;
+	/*
+	 * Set the flag to make sure throtl_pending_timer_fn() won't
+	 * stop until all throttled bios are dispatched.
+	 */
+	tg->flags |= THROTL_TG_CANCELING;
+
+	/*
+	 * Do not dispatch cgroup without THROTL_TG_PENDING or cgroup
+	 * will be inserted to service queue without THROTL_TG_PENDING
+	 * set in tg_update_disptime below. Then IO dispatched from
+	 * child in tg_dispatch_one_bio will trigger double insertion
+	 * and corrupt the tree.
+	 */
+	if (!(tg->flags & THROTL_TG_PENDING))
+		return;
+
+	/*
+	 * Update disptime after setting the above flag to make sure
+	 * throtl_select_dispatch() won't exit without dispatching.
+	 */
+	tg_update_disptime(tg);
+
+	throtl_schedule_pending_timer(sq, jiffies + 1);
+}
+
+static void throtl_pd_offline(struct blkg_policy_data *pd)
+{
+	tg_flush_bios(pd_to_tg(pd));
+}
+
 struct blkcg_policy blkcg_policy_throtl = {
 	.dfl_cftypes		= throtl_files,
 	.legacy_cftypes		= throtl_legacy_files,
@@ -1534,6 +1570,7 @@ struct blkcg_policy blkcg_policy_throtl = {
 	.pd_alloc_fn		= throtl_pd_alloc,
 	.pd_init_fn		= throtl_pd_init,
 	.pd_online_fn		= throtl_pd_online,
+	.pd_offline_fn		= throtl_pd_offline,
 	.pd_free_fn		= throtl_pd_free,
 };
 
@@ -1554,32 +1591,15 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
 	 */
 	rcu_read_lock();
 	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg) {
-		struct throtl_grp *tg = blkg_to_tg(blkg);
-		struct throtl_service_queue *sq = &tg->service_queue;
-
-		/*
-		 * Set the flag to make sure throtl_pending_timer_fn() won't
-		 * stop until all throttled bios are dispatched.
-		 */
-		tg->flags |= THROTL_TG_CANCELING;
-
 		/*
-		 * Do not dispatch cgroup without THROTL_TG_PENDING or cgroup
-		 * will be inserted to service queue without THROTL_TG_PENDING
-		 * set in tg_update_disptime below. Then IO dispatched from
-		 * child in tg_dispatch_one_bio will trigger double insertion
-		 * and corrupt the tree.
+		 * disk_release will call pd_offline_fn to cancel bios.
+		 * However, disk_release can't be called if someone get
+		 * the refcount of device and issued bios which are
+		 * inflight after del_gendisk.
+		 * Cancel bios here to ensure no bios are inflight after
+		 * del_gendisk.
 		 */
-		if (!(tg->flags & THROTL_TG_PENDING))
-			continue;
-
-		/*
-		 * Update disptime after setting the above flag to make sure
-		 * throtl_select_dispatch() won't exit without dispatching.
-		 */
-		tg_update_disptime(tg);
-
-		throtl_schedule_pending_timer(sq, jiffies + 1);
+		tg_flush_bios(blkg_to_tg(blkg));
 	}
 	rcu_read_unlock();
 	spin_unlock_irq(&q->queue_lock);
-- 
2.53.0



