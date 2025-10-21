Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22096350A0D;
	Tue, 21 Oct 2025 20:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077485; cv=none; b=LYOx9M2x9xWy3T5JpUEOsWY/KKWMiIFmMnBkYZI1v9qIHEeSr2LRX0TD7ikXhAkyugt87XJ9BzkEC51MP6UraaSJS+Vvio8UsMO2JqaQKX0g3+5zZvRQgV6GuVSfk2oNLRO5OObw9DJ5xN3lj297C2tNk/b8TFN8EXOwT0ijIl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077485; c=relaxed/simple;
	bh=AXpjNk5PniJfOyyGlAhnkq60zohJ3aJrFwYMyC/u3p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El3NQmngW2Et7Nti6ergbigheFoAUMjXKBOyGlke83wOqpxmhVNSjyKy9M5q1hzAjWFY9NRYovHZT3ZBIbQQNIcmGNb4n7z2JgtR5fRIAXz6b0F7CIK+2WbY5fZqCxsXQYMQKfuYMEpDJntJ2bzcvNBjZpEHtT74kN0RAliBZ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqQiKPh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqQiKPh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4663DC4CEF1;
	Tue, 21 Oct 2025 20:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077484;
	bh=AXpjNk5PniJfOyyGlAhnkq60zohJ3aJrFwYMyC/u3p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqQiKPh0RRZXCywXbwdR8aYi6ZW1xnSs1H74lp6j11RX5uB49HIHeXqE7NbvC5VAF
	 Cgksb2DHuo+0alGn9KekadBMDBbOf+Z4ERjuOY8Z0wsze/H/GUPo7mIfXkKrSwhZfW
	 hADN9ZhUuo0KN17UOjCSf4h5RyCMkpBQUtdI0pOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 119/159] sched/fair: Fix pelt lost idle time detection
Date: Tue, 21 Oct 2025 21:51:36 +0200
Message-ID: <20251021195046.021757241@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 17e3e88ed0b6318fde0d1c14df1a804711cab1b5 ]

The check for some lost idle pelt time should be always done when
pick_next_task_fair() fails to pick a task and not only when we call it
from the fair fast-path.

The case happens when the last running task on rq is a RT or DL task. When
the latter goes to sleep and the /Sum of util_sum of the rq is at the max
value, we don't account the lost of idle time whereas we should.

Fixes: 67692435c411 ("sched: Rework pick_next_task() slow-path")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8ce56a8d507f9..8f0b1acace0ad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8829,21 +8829,21 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf
 	return p;
 
 idle:
-	if (!rf)
-		return NULL;
-
-	new_tasks = sched_balance_newidle(rq, rf);
+	if (rf) {
+		new_tasks = sched_balance_newidle(rq, rf);
 
-	/*
-	 * Because sched_balance_newidle() releases (and re-acquires) rq->lock, it is
-	 * possible for any higher priority task to appear. In that case we
-	 * must re-start the pick_next_entity() loop.
-	 */
-	if (new_tasks < 0)
-		return RETRY_TASK;
+		/*
+		 * Because sched_balance_newidle() releases (and re-acquires)
+		 * rq->lock, it is possible for any higher priority task to
+		 * appear. In that case we must re-start the pick_next_entity()
+		 * loop.
+		 */
+		if (new_tasks < 0)
+			return RETRY_TASK;
 
-	if (new_tasks > 0)
-		goto again;
+		if (new_tasks > 0)
+			goto again;
+	}
 
 	/*
 	 * rq is about to be idle, check if we need to update the
-- 
2.51.0



