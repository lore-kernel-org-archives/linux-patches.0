Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0651C2DC8;
	Wed, 19 Mar 2025 14:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394887; cv=none; b=S3JUNsjJDpPLSUn3w7ofRcauP1hqFHBkowmqJlKVJucXk4Hak+rvYjgSedv4SCvDky30nl48aXg9aP8Obqt54ZtSSVEb0cbIVrNggtIYoD4te7LLa3P90l7DUijLEHL6X2T9SsM7fwBAQycfETXzZnu8znzccbgKaRsrm5OUd0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394887; c=relaxed/simple;
	bh=g5GulIV+Q6O28Gvz5uu8Si1jG8IhaJWu9sKO84D1RcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqkEvUpNRmPtoYX8lLNEAuRS5a2/9uCS1Ul1GS3Q92ZxkHmtBbWd8xAkBIzIiwP9zQTBjgaOuEbbBt9FdPaOTFQrgbHp3mDpiVf5XP3SbAdzRecKcwiKdGhJ5kkxSbb36kCjZDg6E8b5xnaSjwW1qs8kpwfiWvBNmLXhxt8rAok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcIwPz8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcIwPz8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBE0C4CEE4;
	Wed, 19 Mar 2025 14:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394887;
	bh=g5GulIV+Q6O28Gvz5uu8Si1jG8IhaJWu9sKO84D1RcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcIwPz8Br0ENQ+G4iVS96MGBItYs4Ss/LyIg7j8sA+yzQkRXBQycl4LVCPeleYB8o
	 uVGq8mT1/1NR7Tiv/Dq+tDCOJSkjEkJ2wnW4byWl2wiSnd8RsIanSUipL5krvL1CFd
	 TY9NHztn2Zc1NqXqTKmYq/G2uCYUPAijUxveMr7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 089/241] sched: Clarify wake_up_q()s write to task->wake_q.next
Date: Wed, 19 Mar 2025 07:29:19 -0700
Message-ID: <20250319143029.926728932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 86cb6db081680..4b5878b2fdd02 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1057,9 +1057,10 @@ void wake_up_q(struct wake_q_head *head)
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



