Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD06256C6C;
	Wed, 25 Feb 2026 01:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983029; cv=none; b=j9m5+MqSpcKKGBX9U5zgBHSmSqwQevpQk5VWjN+SVx2zzfUkOgEcDYjOzS8FB6vQpKzWg28KPenVvfD0Cy2FmehH9DqVS+wr40eXDP0jcfNwktjdw/750iNSHM1g0WgIFcnsBjRlZLr74j4aWE/ZpFFDoJ4yi2kkIswle1ol4QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983029; c=relaxed/simple;
	bh=pprYroGdwwl2EE9IJK79bnl8UphoBd68RrpSynvh+a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAO+O+FceoBfin7V5QQy2clhdhthr+CW8Uf/MN996b84VjOQxkuM8GF9Poo/bzLIR8RQ+GAAEFM5v8SQbPKC+99t2603YMJV7ClDgue+RShk7N0/gm155yLd2bUz7pMBkPv6YOUO0BYoGMZvW3athROKMcN0dlvdVmm501YsDmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiZnf9qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiZnf9qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF756C116D0;
	Wed, 25 Feb 2026 01:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983029;
	bh=pprYroGdwwl2EE9IJK79bnl8UphoBd68RrpSynvh+a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiZnf9qvRUOjO/kPo0Ed++M31O28IZdTlhAHFluhOuPPrOUbjCMLd9TPkPZ5lxfzX
	 /4cyT6HHPCismN8hRIDFgGd68N7eYXFomdlIhZQ0qE6wbmA2L4PCQ9OB+xdS1m2nZ7
	 RLwN9tQPEWTl8zSczAIhdsFLZDCvTTEbN4PyWTlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 194/781] drm/panthor: Fix the full_tick check
Date: Tue, 24 Feb 2026 17:15:03 -0800
Message-ID: <20260225012404.409981545@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit a3c2d0b40b108bd45d44f6c1dfa33c39d577adcd ]

We have a full tick when the remaining time to the next tick is zero,
not the other way around. Declare a full_tick variable so we don't get
that test wrong in other places.

v2:
- Add R-b

v3:
- Collect R-b

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251128094839.3856402-4-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index a6b8024e1a3cd..3b52c23849339 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2483,6 +2483,7 @@ static void tick_work(struct work_struct *work)
 	u64 remaining_jiffies = 0, resched_delay;
 	u64 now = get_jiffies_64();
 	int prio, ret, cookie;
+	bool full_tick;
 
 	if (!drm_dev_enter(&ptdev->base, &cookie))
 		return;
@@ -2494,15 +2495,17 @@ static void tick_work(struct work_struct *work)
 	if (time_before64(now, sched->resched_target))
 		remaining_jiffies = sched->resched_target - now;
 
+	full_tick = remaining_jiffies == 0;
+
 	mutex_lock(&sched->lock);
 	if (panthor_device_reset_is_pending(sched->ptdev))
 		goto out_unlock;
 
-	tick_ctx_init(sched, &ctx, remaining_jiffies != 0);
+	tick_ctx_init(sched, &ctx, full_tick);
 	if (ctx.csg_upd_failed_mask)
 		goto out_cleanup_ctx;
 
-	if (remaining_jiffies) {
+	if (!full_tick) {
 		/* Scheduling forced in the middle of a tick. Only RT groups
 		 * can preempt non-RT ones. Currently running RT groups can't be
 		 * preempted.
-- 
2.51.0



