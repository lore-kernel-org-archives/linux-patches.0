Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4549346E57;
	Tue, 16 Dec 2025 11:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885094; cv=none; b=tMRWrUxxR8xf17OZeQtZyEyEQ365mT8IR4aTynwG39LfMNhO1Mcl7iJfog8pC3dxhBAUZZXylHAvivcr7r19KnWCsHu/2HqRd0y+PMbNhEJG2so7o2rskYXHAS9v2tbbG0zdfVG3ZblxfLca47IEEcjBUTtiH5igOKBG3iKkmAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885094; c=relaxed/simple;
	bh=5LhOi+uPSXQPqQeqAoG6Shqw5MyV8NO1NI6a6IAJIiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNs6sMgpBuwf9JOojI5ajbE5QG+HfavajTB4MD9Im++hWuMNdkdD1pQUHvgfk6bX6m7oVjk7HSeI9o+86CVx8LLUIEi1gR//Qiqm7gsmtEhkS1xispMx/jpvJHIzFCCrtr6zwFdvJvWsLoJpqurHkTxqzSI6jLz9YhQIKoTnnjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ia+/p5Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ia+/p5Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F64BC4CEF1;
	Tue, 16 Dec 2025 11:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885094;
	bh=5LhOi+uPSXQPqQeqAoG6Shqw5MyV8NO1NI6a6IAJIiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ia+/p5RmlkdZlkqJQ3cHf4Y7ekHMQ88luBcLVGkfyRvSKW76K+Sjnq62PJkchvGHB
	 xpOY2jbVnvx/wQ3nByF6j0OFDiqHA7CfWXnQFY2cxhFMIjMeNPizcuFMbPXRabTUYe
	 vsX+ap0+4PSz3vL4vsLHC0ll1zDqlkKnFiuV+Lis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernand Sieber <sieberf@amazon.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 037/507] sched/fair: Forfeit vruntime on yield
Date: Tue, 16 Dec 2025 12:07:58 +0100
Message-ID: <20251216111346.884468436@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Fernand Sieber <sieberf@amazon.com>

[ Upstream commit 79104becf42baeeb4a3f2b106f954b9fc7c10a3c ]

If a task yields, the scheduler may decide to pick it again. The task in
turn may decide to yield immediately or shortly after, leading to a tight
loop of yields.

If there's another runnable task as this point, the deadline will be
increased by the slice at each loop. This can cause the deadline to runaway
pretty quickly, and subsequent elevated run delays later on as the task
doesn't get picked again. The reason the scheduler can pick the same task
again and again despite its deadline increasing is because it may be the
only eligible task at that point.

Fix this by making the task forfeiting its remaining vruntime and pushing
the deadline one slice ahead. This implements yield behavior more
authentically.

We limit the forfeiting to eligible tasks. This is because core scheduling
prefers running ineligible tasks rather than force idling. As such, without
the condition, we can end up on a yield loop which makes the vruntime
increase rapidly, leading to anomalous run delays later down the line.

Fixes: 147f3efaa24182 ("sched/fair: Implement an EEVDF-like scheduling  policy")
Signed-off-by: Fernand Sieber <sieberf@amazon.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250401123622.584018-1-sieberf@amazon.com
Link: https://lore.kernel.org/r/20250911095113.203439-1-sieberf@amazon.com
Link: https://lore.kernel.org/r/20250916140228.452231-1-sieberf@amazon.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4770d25ae2406..35b98cad06515 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8919,7 +8919,19 @@ static void yield_task_fair(struct rq *rq)
 	 */
 	rq_clock_skip_update(rq);
 
-	se->deadline += calc_delta_fair(se->slice, se);
+	/*
+	 * Forfeit the remaining vruntime, only if the entity is eligible. This
+	 * condition is necessary because in core scheduling we prefer to run
+	 * ineligible tasks rather than force idling. If this happens we may
+	 * end up in a loop where the core scheduler picks the yielding task,
+	 * which yields immediately again; without the condition the vruntime
+	 * ends up quickly running away.
+	 */
+	if (entity_eligible(cfs_rq, se)) {
+		se->vruntime = se->deadline;
+		se->deadline += calc_delta_fair(se->slice, se);
+		update_min_vruntime(cfs_rq);
+	}
 }
 
 static bool yield_to_task_fair(struct rq *rq, struct task_struct *p)
-- 
2.51.0



