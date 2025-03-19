Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2E6215F78;
	Wed, 19 Mar 2025 14:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395082; cv=none; b=o52foWmmx7B/aihlrm9Do274YW43IiqSwdDpznpkLUi6umiF4QTZxPu8tQcOdIRfzZLhVJ3efw4t5fYFEGxHx1S+pj9KLJh5j7mvgOF9SEbpYnAJaZhTA3QPU3OeCcQolwHzS9z1CSe+FmtVOoX+t0yBtNzwE+dhTP2XwTy7eNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395082; c=relaxed/simple;
	bh=SAP1bF47rpw1G++TYoWut0K2Hfk9VKNDW+YjsabTyPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5ST04lYuScBKSke5JrBMevBwsTpfsQUkOVUKJfyd24EBJaZuZbRj+UTW7VK+sbRU0eqLWOMRNXmFC3YOsOJX9bw04hqPQzh3WFvpWypc2gf6BU6DQSbD3DdmF75cr/rfcJv74Q6unMINqF8VVe5CTgT9m2reDO3/pCi+NLl2Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1pC9Fg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1pC9Fg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A701AC4CEE8;
	Wed, 19 Mar 2025 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395081;
	bh=SAP1bF47rpw1G++TYoWut0K2Hfk9VKNDW+YjsabTyPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1pC9Fg5whuOp257ssf/+ADYZ0Xp8IFpwVc1nXthQE42hYzM366oXyFJUCUsNQbdn
	 h3O3UY5LjPJw1L8Je6zO98RBo5aOlFZXyHvDxm7z0ZC3v/H0/DjDLrvyFxqsBAIwyC
	 pgmq3QfGXqJyytx7KyIrzbZc2l05rkhUktgqa1Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/231] sched: Clarify wake_up_q()s write to task->wake_q.next
Date: Wed, 19 Mar 2025 07:29:40 -0700
Message-ID: <20250319143028.990754799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jann Horn <jannh@google.com>

[ Upstream commit bcc6244e13b4d4903511a1ea84368abf925031c0 ]

Clarify that wake_up_q() does an atomic write to task->wake_q.next, after
which a concurrent __wake_q_add() can immediately overwrite
task->wake_q.next again.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250129-sched-wakeup-prettier-v1-1-2f51f5f663fa@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9803f10a082a7..1f817d0c5d2d0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1058,9 +1058,10 @@ void wake_up_q(struct wake_q_head *head)
 		struct task_struct *task;
 
 		task = container_of(node, struct task_struct, wake_q);
-		/* Task can safely be re-inserted now: */
 		node = node->next;
-		task->wake_q.next = NULL;
+		/* pairs with cmpxchg_relaxed() in __wake_q_add() */
+		WRITE_ONCE(task->wake_q.next, NULL);
+		/* Task can safely be re-inserted now. */
 
 		/*
 		 * wake_up_process() executes a full barrier, which pairs with
-- 
2.39.5



