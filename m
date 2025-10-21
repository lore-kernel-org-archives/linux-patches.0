Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2B1350A3C;
	Tue, 21 Oct 2025 20:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076933; cv=none; b=WtMWsaABd4hdV/LlL3Nv2KjaBlhyryXAkKxYQ7wBeNIdiIliBdYX92OgGkZt86CqHQTj+qxaCMzDa0+ycuPDI5bddwP/TCtnMiSzwXOk6QYdcb78Gy0rHy9013QBjqiKCeop3x7aDqUD+ZJf/U6bgITv7KmKF9m8pcLSAnIYfe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076933; c=relaxed/simple;
	bh=evImX3301NFovwySkLTcIayrlHv06j4vI0K3Dhro75I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCMlLM+40YM76aTYa8W7ZKY2B0AabGnyQ6gA+Zs+IJkFHB0CK1UIvgr93APad1NCp0wRCQkG0ECfL43ZvFKwi5bQ2eiXfoaw54LUl/oab8BlNKwUa2hSSoIyzleTrE+Txk3fGKzu9NYVtawJzq4uPyedaDiVXNvRmXYNS7kC6K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeqblKgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeqblKgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792EBC4CEF1;
	Tue, 21 Oct 2025 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076932;
	bh=evImX3301NFovwySkLTcIayrlHv06j4vI0K3Dhro75I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yeqblKgMHxeLW/JH+3FjjmgxVxlbS7SGjlK/PLbrdyRcznxt/6jqqcKFCBQ7RkvjA
	 ouoB6SL30nwgnSJQyJXgF+RFk3hY4b492I+mqQyz71lPgdISFY08rP4ku6ty1XKNYd
	 go4hXfzEFrX3ZrBT1laytcXfGDbiTwKHANHRtFqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/136] sched/fair: Fix pelt lost idle time detection
Date: Tue, 21 Oct 2025 21:51:10 +0200
Message-ID: <20251021195037.937834626@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b3d9826e25b03..8bdcb5df0d461 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9059,21 +9059,21 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev, struct rq_flags *rf
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



