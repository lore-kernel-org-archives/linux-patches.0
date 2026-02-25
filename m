Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F33256C6C;
	Wed, 25 Feb 2026 01:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983898; cv=none; b=XkZfkhTU4oiqhk/qv+Qv5EG7zc1uODcVjNBpy5ZrmaHmdWyWTp3ES5jwMfxoOavgtXPU8NIGOPQiqwAzwZfgKKE4MxwmPxuzrJPMSDToqwbo3KAAsZuD7a7qy9EZreI9qD3e5jFY3GdS2t1WmD9C+IP83ht3d8p266fR0pnhGp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983898; c=relaxed/simple;
	bh=y97uaVZ8iyJXT4kv82mgEcS7DiCCXg7JL25TjKJwAvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2rGWVV7RiIXX2zlHv9HJ4dLgUSdD8Po6AP4gvwryGphrDWbu5U90+DfTP4IfV4Ub9RNsrb1ODKCt1B8nqYLDWjaA05y2SUE+pLsDwlZPGC5JbUxG7zQLA8bbKHkobwjE0L7PFHv0fPOg504z50dr3VwD7sqFZqjV+RiL2YYNxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sarG2uWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sarG2uWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF48C116D0;
	Wed, 25 Feb 2026 01:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983898;
	bh=y97uaVZ8iyJXT4kv82mgEcS7DiCCXg7JL25TjKJwAvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sarG2uWgw8UgDuckCOoprwnhXCiwnxuKkG++I+cVOGUjUbDQ4L7GFHzV8Q2YTGreU
	 lds31rDqE2m4lU14wyaZHx17WLWW2LZ4DKf+HU4jsymXnqxRyx5NDewqaOtagKppzm
	 y0xr+VIB8ThPuXbMo0tNWIpiV9G2sE6FbMqdLwdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/641] drm/panthor: Fix the full_tick check
Date: Tue, 24 Feb 2026 17:18:15 -0800
Message-ID: <20260225012353.146343160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 881a07ffbabc8..6e4667cbe1b82 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2387,6 +2387,7 @@ static void tick_work(struct work_struct *work)
 	u64 remaining_jiffies = 0, resched_delay;
 	u64 now = get_jiffies_64();
 	int prio, ret, cookie;
+	bool full_tick;
 
 	if (!drm_dev_enter(&ptdev->base, &cookie))
 		return;
@@ -2398,15 +2399,17 @@ static void tick_work(struct work_struct *work)
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



