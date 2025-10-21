Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2962737E7;
	Tue, 21 Oct 2025 19:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076527; cv=none; b=Lxgj3gchB2+mxKMMzDUS25qgsZ30/vWgz3Ow5vzjl5EouWR0G0Ex/p7/pdCHadiUnw4bLI1I7wPxG4IWiayljn2ad1Z2BszobGrniv1J/p5ypZlL/hgK+JW7Orj2S+5hZLhRjy6HZc24TwT6lbLg8qorT8J+8KShVy9KnrxYz6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076527; c=relaxed/simple;
	bh=Qck5tU6vRhpGgfQyEP1g75413NdbiWvS9SlOzL5cqpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvAGl8JeatNDOnkiLL9GaB9SZAsgi5DLWMhdZw8rlLX7oDmixvVNP6G6hFcLOGH4evkrAaISVxLAZ5p4Ae+2P7ptqmjwaN7IrUgzw/TfNMWSHghbeZyG7FOR+7RZBHnIfz35FDwXU/LIdmpDcfs8fP4qTZQit99aheZjvO2m0Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbByn0LZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbByn0LZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F101C4CEF1;
	Tue, 21 Oct 2025 19:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076527;
	bh=Qck5tU6vRhpGgfQyEP1g75413NdbiWvS9SlOzL5cqpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbByn0LZ6DNqapT2mwPIM+B72eIkIu5IR49ulbPzdsaunW0czPeMP4/SvxL8JCjLb
	 HCQpvUwz7AvzSWaCW2PnMWtt5JgN2H/GXYEFUxJEjWzlmJ/EQ5N/6Eh1PlYeSHrys1
	 hy8wRkvl/WoUNM/utNz0LE9RBr4G3nkIMErNmDxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/105] sched/fair: Fix pelt lost idle time detection
Date: Tue, 21 Oct 2025 21:51:12 +0200
Message-ID: <20251021195023.166709232@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 84d5caf6230f6..58231999d929e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8528,21 +8528,21 @@ done: __maybe_unused;
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



