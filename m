Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FBA33033A;
	Mon, 27 Oct 2025 19:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591883; cv=none; b=CDqVgqg6zXtOABXVF4de+ji5RmL8IadORF/tVFwgsxbyFoxvs8QboUqAooKpO+ZRi3OQ5ZCm5aWRDycnh/hajl9KuoCh/+5K/Kpdr0Z4FrWc5g4+NyoIz92A0CwKB46Q+j3GwDQGp01SKV1A0sN1UDUIRHLFSKTeNCUWMVTbAD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591883; c=relaxed/simple;
	bh=qz0WgPcZ3MdXDHK+cXMbTRbmz9c+x30wT+Q1HoziQfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB0b2Pt81HXLKE5fCV9cfhClccKqGU8GBzjs1URk3JsKo/yxPw0XbxWt5+I+vTelURAYN89wNvMjhYe3+sHbe4yPaFPO1mycazKLUwSbBPmYxB3rxzFp4cDzHV1AW3jPKhLFo7s1xYn8AXzltzRQ1Qj0l9jYJJvfnQu4vBLAm84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUtZjN1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUtZjN1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FE1C4CEF1;
	Mon, 27 Oct 2025 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591883;
	bh=qz0WgPcZ3MdXDHK+cXMbTRbmz9c+x30wT+Q1HoziQfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUtZjN1ecZplttXJTNhM5eK+CyIuMCtjYc67PuWzHMVpo9b5OBvqLdiJQzTktodOt
	 uIhqR6/HrxSm4YjMincJ3pHL5ctkuWaInatoyEVQBBKGlQzW4VbtW4Lp2hvzGh4MZ1
	 z51lgKfXszcs84gcHic7ngiH70fdO6TS8wjFtkS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/123] sched/fair: Fix pelt lost idle time detection
Date: Mon, 27 Oct 2025 19:35:15 +0100
Message-ID: <20251027183447.339978156@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 03b809308712e..87f32cf8aa029 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7613,21 +7613,21 @@ done: __maybe_unused;
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



