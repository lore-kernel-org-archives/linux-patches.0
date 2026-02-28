Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79642338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301732; cv=none; b=JY3x51FFe2xaWybCrQxd3ff8ZkbkKAkdlzBMm68+yE7Wet6voy0VxhHgdXwGQK735MYndTvA/u2GV9gOdmde1M+v4FjoQ3s7b/VcKUUlVxeCiECbC5qWMAk65mCEPGr2ECYjk2MPB7TTTHU7ZkbW8KH6gSv5tbHYYLeI6/sAXfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301732; c=relaxed/simple;
	bh=qd3a2+4otUx2yY591e8naNJu/78qbAyrVraKtJ3kGPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7TCbEp2ANGX/XT0PWRfQF6HGTcszTmK/S88doE9paIOw64dbkc+qu8PSibaqe1MvphJTZ/kRbLIEM0mai49OsLMAiPn1gdLr+D4SxniWnmYQ+IuoHpw/yNwlO3CUBmUKdFEVBm0lQL/gBaQkKlLbGzcIxrrQa5mesIevoXYRmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSiYZMSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSiYZMSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94C1C19425;
	Sat, 28 Feb 2026 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301732;
	bh=qd3a2+4otUx2yY591e8naNJu/78qbAyrVraKtJ3kGPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSiYZMSQvK46KyVsNJ8v0PFOuGc61QDLEWuD/OLFLqRBcxk10w53txz9NIFjiRFok
	 udzljuOi5in0dlRyCSM1cIN3LB3jx4FhReQLaHo3XdMkCoSBuLY2PshoVRsSDNhuv2
	 KWrHJMW7EnbJMYJyFhmv+W+lCaz09IbD+ZOPxMFO1yzPwEGNJHxg+iOrywVIf/VpgK
	 YftZfFMJpuFKfKRaLLLXs9qBwGkAxO4Otur49EyFPiGjrF5bHTIOu4/zYbmlsDT0oH
	 ll/bKd+gR7TIVfZkGFX8GklgKmU/YZAFR5uFPi4ArT+cioYzJ6/33SxUYvrZq+94He
	 pK5U+Fah3gCFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/385] drm/panthor: Fix immediate ticking on a disabled tick
Date: Sat, 28 Feb 2026 12:55:53 -0500
Message-ID: <20260228180011.1568201-131-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 4356d21994f4ff5c87305b874939b359f16f6677 ]

We have a few paths where we schedule the tick work immediately without
changing the resched_target. If the tick was stopped, this would lead
to a remaining_jiffies that's always > 0, and it wouldn't force a full
tick in that case. Add extra checks to cover that case properly.

v2:
- Fix typo
- Simplify the code as suggested by Steve

v3:
- Collect R-b

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Link: https://patch.msgid.link/20251128094839.3856402-6-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index d2386e54a4bc4..04236fd41518d 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2325,6 +2325,7 @@ static void tick_work(struct work_struct *work)
 						      tick_work.work);
 	struct panthor_device *ptdev = sched->ptdev;
 	struct panthor_sched_tick_ctx ctx;
+	u64 resched_target = sched->resched_target;
 	u64 remaining_jiffies = 0, resched_delay;
 	u64 now = get_jiffies_64();
 	int prio, ret, cookie;
@@ -2337,8 +2338,12 @@ static void tick_work(struct work_struct *work)
 	if (drm_WARN_ON(&ptdev->base, ret))
 		goto out_dev_exit;
 
-	if (time_before64(now, sched->resched_target))
-		remaining_jiffies = sched->resched_target - now;
+	/* If the tick is stopped, calculate when the next tick would be */
+	if (resched_target == U64_MAX)
+		resched_target = sched->last_tick + sched->tick_period;
+
+	if (time_before64(now, resched_target))
+		remaining_jiffies = resched_target - now;
 
 	full_tick = remaining_jiffies == 0;
 
-- 
2.51.0

