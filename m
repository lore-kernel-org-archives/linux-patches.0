Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D8C337B87;
	Wed, 21 Jan 2026 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020196; cv=none; b=H+sdg5oUDUFYkxQ1B4kQKIzrxApy/uIBN+wREXVH6cg01RW6n9DiBJv/NDfpDfRzvjlZAE5Ffq59a7ikegNdkrH+kcCT6Bn6ey1zhxAj6x+AYvNgZYrwRNLqvEpXGCWVX83xu2FfsuGIzAfouhoK1r1xKbiG5P86Mp/Tq78LJNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020196; c=relaxed/simple;
	bh=ajhqsTjaJQjLRqPkMCeHFlgU2o4tx8oQB/myQb0mIwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXmx0fjXGlHgoCrUBGDIp3TLk7iXiD4zQNXBfl0NqwP1tvCIhhW4zX1EYa+l1vuGA2jXWQOOZnFpS00alKtENsrBlqh01JZbfbG5sYy/oqBAttqkylFj/wzCSfHfw9O2lI4CzceXjpIZcxbtrT+yCBwY2ypNPHSd3USvJT2KKdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1Rpdksn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1Rpdksn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20670C4CEF1;
	Wed, 21 Jan 2026 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020195;
	bh=ajhqsTjaJQjLRqPkMCeHFlgU2o4tx8oQB/myQb0mIwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1RpdksnQVl642NPbyOFTw0DqxZ30gpNJkCgeTeOc8DL2ZQxs5y/jnQ4B6OmPRczW
	 odzTLy2IWPDKozL1cuqGc62BxGGpYYa6SU0jEv2AZklb2cQe2dx7K0VcfqGscH/3Fv
	 7bst0xq5diCL/CyOU4N+mto+PCPgueDBBGSbIB7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/198] sched/deadline: Avoid double update_rq_clock()
Date: Wed, 21 Jan 2026 19:15:15 +0100
Message-ID: <20260121181421.689499629@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4de9ff76067b40c3660df73efaea57389e62ea7a ]

When setup_new_dl_entity() is called from enqueue_task_dl() ->
enqueue_dl_entity(), the rq-clock should already be updated, and
calling update_rq_clock() again is not right.

Move the update_rq_clock() to the one other caller of
setup_new_dl_entity(): sched_init_dl_server().

Fixes: 9f239df55546 ("sched/deadline: Initialize dl_servers after SMP")
Reported-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Pierre Gondois <pierre.gondois@arm.com>
Link: https://patch.msgid.link/20260113115622.GA831285@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d3be71d5a9ccc..465592fa530ef 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -761,8 +761,6 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
 	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
 	struct rq *rq = rq_of_dl_rq(dl_rq);
 
-	update_rq_clock(rq);
-
 	WARN_ON(is_dl_boosted(dl_se));
 	WARN_ON(dl_time_before(rq_clock(rq), dl_se->deadline));
 
@@ -1623,6 +1621,7 @@ void sched_init_dl_servers(void)
 		rq = cpu_rq(cpu);
 
 		guard(rq_lock_irq)(rq);
+		update_rq_clock(rq);
 
 		dl_se = &rq->fair_server;
 
-- 
2.51.0



