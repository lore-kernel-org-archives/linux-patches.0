Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086A28640C;
	Wed, 25 Feb 2026 01:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983902; cv=none; b=TosOOdwpNMb93J/1HFoZYwJTfzEXJHzk9bhZ2uaMrrHd8YeqBTDOwBuM7xi2TUXbxd4Z5OgxWRh/uRY2fYoJrQ4M6w5f+7OcruP0q7y/Qf1EKZCIjKV68y6dYe2P7l1VHYMFLd+00fiYrjxvEU2WTnazUKQRO65uh11HzfxUH9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983902; c=relaxed/simple;
	bh=XLwgo6jg8kcgQuOktrWm0o1l2YPMxHQRoBA6h2hS5yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NStdTKeiMDpVBiAEwnr59wAvQAjjj1oNJvst/FKJMHpTSPDo7ue4RCGIIHgu/XwiTvmMIwEAWSu7Y4VdT4wgTspqREcnM/I3gc1dvjqzM0skiUGp8m1Tu5a7S1iXXawioGIlZSAM9GIimN4uywYKtRAAL9scIcSKHsNs2KHYkhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxNufQtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxNufQtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F646C116D0;
	Wed, 25 Feb 2026 01:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983902;
	bh=XLwgo6jg8kcgQuOktrWm0o1l2YPMxHQRoBA6h2hS5yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxNufQtkXpaNJ0oC5ek8CuuMiOCJzDbWhSKdi7C/eIRb2bqnpcxBBInI4hmzHInWp
	 IJUrI/SrXFS8x3nYYKQq3dvYy7na9iia/omrr/6CrdI1CpppyvpqSBlyIpjDNBg1hH
	 woqdR4BTy4M+BA+EvPhQ+zIJ5GptHJSwXPqQdNRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/641] drm/panthor: Fix immediate ticking on a disabled tick
Date: Tue, 24 Feb 2026 17:18:17 -0800
Message-ID: <20260225012353.189508734@linuxfoundation.org>
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
index 03062169b8d33..3d4ac73999825 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2374,6 +2374,7 @@ static void tick_work(struct work_struct *work)
 						      tick_work.work);
 	struct panthor_device *ptdev = sched->ptdev;
 	struct panthor_sched_tick_ctx ctx;
+	u64 resched_target = sched->resched_target;
 	u64 remaining_jiffies = 0, resched_delay;
 	u64 now = get_jiffies_64();
 	int prio, ret, cookie;
@@ -2386,8 +2387,12 @@ static void tick_work(struct work_struct *work)
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



