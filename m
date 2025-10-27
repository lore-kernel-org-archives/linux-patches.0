Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F9A332EC9;
	Mon, 27 Oct 2025 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591590; cv=none; b=DQtq6hLhwE8arQB1IkJLHUfYJFLeOSAMTsxyFvrbBMLrgClGCAZIlSq1MKtv5puHZoUSA/Hd/u2C8p1B479qd2TlnThAdYcMXPvThoAyDFjbjzq04g2PQlFoWBtkR+04phd4/JaP88jwiurODheW4wyq9IyzyD+EnKATNOfinO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591590; c=relaxed/simple;
	bh=diMazE92oibnmaor/2N/ue4x2ZtcwHhpTcnPwF2sQ7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCvUE4yHHWRJaAPFgDxf3FRlLsR4qYNAI1D8ibznZRjSyiG1sEEy9yHz6IjKzSinimZEB+vFtpKJ0YW0bCt3Nsn4e3veh+un0EJDLJlzyGY7+Bozni+YiZVvvnZeZA5PfKtPOoK2+D1rzann52WAl5BGlZRLBcmJbTp2gvK1vug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPiwSO6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPiwSO6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA0CC113D0;
	Mon, 27 Oct 2025 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591590;
	bh=diMazE92oibnmaor/2N/ue4x2ZtcwHhpTcnPwF2sQ7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPiwSO6VjZ2BmnK5QpiYDdhwSyNxg6aU2h2/Icu+yr1zzCoCiEYj+VNXLXuRhTQg3
	 kQAKaD5ajExlM2pmT6WNNRarParWqxhTd7WmJT4W6JRmMfe1vyOV3fKyt7jPzQqsAk
	 3bct04mFTM3CQoZJ+Pr7FgKpXLCwoHqeBcP6b/rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/332] sched/fair: Fix pelt lost idle time detection
Date: Mon, 27 Oct 2025 19:35:08 +0100
Message-ID: <20251027183531.576467529@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 952a3fd41a6fe..c11d59bea0ea8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7353,21 +7353,21 @@ done: __maybe_unused;
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



