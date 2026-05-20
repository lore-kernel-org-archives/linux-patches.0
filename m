Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC6D3C4576;
	Wed, 20 May 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299428; cv=none; b=KUTI96S5J8gnJhQi+rmxm34RfkBX+SDg+eHdr1bvuT4jigiYRxW+HaMaNCchlY+1Jb3hoLIRDsjcx1i/P9D9Suqa+arRoYtSRSTkVggHoBNQ666QGuaBR7KivUVri8pmoChnlXqt6gBo9jXf7DrcoCV1JmZWbBKQaqcBqWd7Ozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299428; c=relaxed/simple;
	bh=+i5D3SW1vmxQgFcLs6334tuP00/FX8ehWK7eC1xz3AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZGK/5ehZVx+O04/rl/kc2cMqFL2c0Et6QsQaAu/g4V46nuBGtXwaJy7DmPFQyC98LXrSRNt1Fq+QVEIvnuWtgHS6YdYfmT1Mk4oFnHU1RjJZcK/CIr9mvlaekstoaukd4PHGMqDvGul68Xw2avpsGe1HYGx2YlvY6+11rbC1qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnfYLPCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnfYLPCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2AA1F00897;
	Wed, 20 May 2026 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299426;
	bh=Qkgd/aZx360ltAeWYO2AjybTI980aHIxe+MiIH3JvP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnfYLPCBWUJ8wbkaP7C3CI+LaLX7eemUL75dhNi67WWSYfyK6iCgH4wRJk/e2bVCA
	 FlJ9k+TaPD3SIbeeodd0drXLzWYcG4UAOExjjIpGVK9aEaO7FgYKON4RBsvkwoDBA9
	 FqF0X/r0S6B5z5T2Xar3lBvO36r5zckd8l7x5d+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 769/957] net/sched: netem: fix slot delay calculation overflow
Date: Wed, 20 May 2026 18:20:52 +0200
Message-ID: <20260520162151.239623516@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 51e94e1e2fef351c74d69eb53666df808d26af95 ]

get_slot_next() computes a random delay between min_delay and
max_delay using:

  get_random_u32() * (max_delay - min_delay) >> 32

This overflows signed 64-bit arithmetic when the delay range exceeds
approximately 2.1 seconds (2^31 nanoseconds), producing a negative
result that effectively disables slot-based pacing. This is a
realistic configuration for WAN emulation (e.g., slot 1s 5s).

Use mul_u64_u32_shr() which handles the widening multiply without
overflow.

Fixes: 0a9fe5c375b5 ("netem: slotting with non-uniform distribution")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260418032027.900913-6-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 41d60e904090d..6e221bdfb3871 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -658,9 +658,8 @@ static void get_slot_next(struct netem_sched_data *q, u64 now)
 
 	if (!q->slot_dist)
 		next_delay = q->slot_config.min_delay +
-				(get_random_u32() *
-				 (q->slot_config.max_delay -
-				  q->slot_config.min_delay) >> 32);
+			mul_u64_u32_shr(q->slot_config.max_delay - q->slot_config.min_delay,
+					get_random_u32(), 32);
 	else
 		next_delay = tabledist(q->slot_config.dist_delay,
 				       (s32)(q->slot_config.dist_jitter),
-- 
2.53.0



