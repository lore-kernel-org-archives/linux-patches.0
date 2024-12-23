Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D771180C02;
	Mon, 23 Dec 2024 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969647; cv=none; b=aE+HAUKEon5n+PJpobJZkizHJQSgrhDTsa2+6UcRnvbJaT1c6yTg/BcTLxzTwGFGDNmYTV/9Y+kVF5D07XkIjxG5a6BuJ6vSe5HmJFpNfmhJV3aZt5pJUMExxOfoxCPBD3zYrbwDQz/DEqx4yuV4CSNAvLKTOQe42GNeM9DAgOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969647; c=relaxed/simple;
	bh=n5bvR1/a0RkF4iJR1Hg1P0s3h+BpEDtyFolr9EavDfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2RwoYpucPyvFFs+sN/EU8zVebg6lRtB4MHQjISC4LtuscsUReKQpa2+Z+Ndfrm4sV9W6REDK54S6RgVogYOSAhz4BQWcPhn2qECm4gurtlFyjhINhbYlE6aNSLbrs41yaiDW61C6WmKaFXHiZcrsWHsjdaS7dA3l71j1lNJGsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzwDAxM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzwDAxM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01234C4CED4;
	Mon, 23 Dec 2024 16:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969647;
	bh=n5bvR1/a0RkF4iJR1Hg1P0s3h+BpEDtyFolr9EavDfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzwDAxM7We4SQK7mFFh7hOcLLHNuGevVcQ7z4J6ZepC1xfL3JgKinWqjZFmobnpnZ
	 IB+l7LYiPoenxbFTIy7RDqJcsOTM0J7TLC7sxuDlhyTRT3JOrlK02L8ALUrOmiLXIV
	 oSEWrnw9g6Kndu19UqmSFrTengFSAkwMKOfAXg8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/160] sched/fair: Fix sched_can_stop_tick() for fair tasks
Date: Mon, 23 Dec 2024 16:56:58 +0100
Message-ID: <20241223155408.920415010@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit c1f43c342e1f2e32f0620bf2e972e2a9ea0a1e60 ]

We can't stop the tick of a rq if there are at least 2 tasks enqueued in
the whole hierarchy and not only at the root cfs rq.

rq->cfs.nr_running tracks the number of sched_entity at one level
whereas rq->cfs.h_nr_running tracks all queued tasks in the
hierarchy.

Fixes: 11cc374f4643b ("sched_ext: Simplify scx_can_stop_tick() invocation in sched_can_stop_tick()")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20241202174606.4074512-2-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6cc12777bb11..d07dc87787df 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1300,7 +1300,7 @@ bool sched_can_stop_tick(struct rq *rq)
 	if (scx_enabled() && !scx_can_stop_tick(rq))
 		return false;
 
-	if (rq->cfs.nr_running > 1)
+	if (rq->cfs.h_nr_running > 1)
 		return false;
 
 	/*
-- 
2.39.5



