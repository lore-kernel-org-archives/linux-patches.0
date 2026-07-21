Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECA43161BF;
	Tue, 21 Jul 2026 17:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653569; cv=none; b=upyLQV4y1Lrcsdsm4egkT2mNhB/+K8EvRyCsDnMtkEvyA5AvZ6wPU4Zuffe+tNQf9pkc75kp3n+vlrHumBu4b6rN6DZ6GqwbZKsZANPv5lID9DG3t53clVmBT5RvxbBHVb9hUj8HiWypv47QT/nK2tgNrR3IKLiYJQhz9w3kvF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653569; c=relaxed/simple;
	bh=uCTmhvDy+om4JeJV/OrUW5U0Bvbnh2t34FRP7ZwUkXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZxJzIEQUmWagsm5BrpmH3gwWOp88p+iwO5jDr6xNJ9X8hNiQ8rUu4O+cvhyFNjZrRqyU4U1flKr9fl/2L3NVJC9Fz/M3UNDvbjklpfc3WrBpF2+asM+sXeKAAz2emhMF5XysmBjnWYzQ8xJlcG9l22YT2SXU2sNVZLzriLKdTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HImgQIIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HImgQIIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CAB1F00A3D;
	Tue, 21 Jul 2026 17:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653568;
	bh=t6wvXkYjZosWxkhzIyvbV4PVwlmOSJ1lE0Voswn/mwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HImgQIITZ6iXwO56QwhomkvMGA6yYCmcGbaDdzrsVacYuUt1wb2N/gDk7UGhccTGW
	 ylrp4LzhNK6a1Ww3kt2G37AhGv2o0caWiXGB6Wrk6JS48RkL9m9G/8hlJ8HKqEamVD
	 rOAzjhf7DvJo6lq+E7WigDrZj+rA2YF122HuK3rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1339/2077] drm/panthor: Fix potential invalid pointer deref in group_process_tiler_oom()
Date: Tue, 21 Jul 2026 17:16:52 +0200
Message-ID: <20260721152624.400086716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit b39436d0ba1571dbcda69d20ec567344b3eecfc7 ]

If heaps is an ERR_PTR(), panthor_heap_pool_put() will deref an invalid
pointer. Make sure we set it to NULL in that case.

Fixes: de8548813824 ("drm/panthor: Add the scheduler logical block")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260625-panthor-signal-from-irq-v5-0-8836a74e0ef9@collabora.com?part=2
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-4-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index d3e7f70fdd3283..f249eaa0907a48 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -1600,7 +1600,10 @@ static int group_process_tiler_oom(struct panthor_group *group, u32 cs_id)
 	if (unlikely(csg_id < 0))
 		return 0;
 
-	if (IS_ERR(heaps) || frag_end > vt_end || vt_end >= vt_start) {
+	if (IS_ERR(heaps)) {
+		ret = -EINVAL;
+		heaps = NULL;
+	} else if (frag_end > vt_end || vt_end >= vt_start) {
 		ret = -EINVAL;
 	} else {
 		/* We do the allocation without holding the scheduler lock to avoid
-- 
2.53.0



