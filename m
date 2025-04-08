Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2C32192F2;
	Tue,  8 Apr 2025 11:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112483; cv=none; b=reNRt2+CETRb+AN44UgDotodetR8W22lQYQxmyLc2vtWtECH3F8i1MBy6QIAAnoXyTs+XJTwtGQkxjGBYrH1cEkP0++03aVGM2rTmSA1hysqL3qDbGP2XhGeIczvXHb7hemvLjJehAFQt8IYhRElqMqcB/sTeQC00+4atoBFiwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112483; c=relaxed/simple;
	bh=pMMe9b2y7/yXZu2T9WO2ACP86Vbs7Bfbos+pQOpxz+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heytFPEOsJnxDA2iF3eSAPp3fpiJLojVkul1B215gXLzHfX5nM+LQNefwN1LH3f6XvP1w9eegXXDtyo06hne8rM4XFBWoIgIUja0PoAjGZpiRCTyCkQEQuxg/ycwreLAUqXUOxKwk6UIUFuwBBlWWZH1ppkj1i8OC9kIrioxLqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUzdo8ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUzdo8ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44286C4CEE5;
	Tue,  8 Apr 2025 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112482;
	bh=pMMe9b2y7/yXZu2T9WO2ACP86Vbs7Bfbos+pQOpxz+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUzdo8MEIlfk1g0ybbl9oDXr5bXJBaXEZgvKmok7FMEmLwLJvax+c9wUrGPN6OMIW
	 ME3eIIgdiHUoHklhYf+HZXpbJSY+sKMithmewjZpVYmJexLiaM3/KKeZfwtov2wcXz
	 UxfrVLMpcSk1D1mOMUIxRDrYjhzlvUoB857dGPQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/279] sched: Clarify wake_up_q()s write to task->wake_q.next
Date: Tue,  8 Apr 2025 12:46:58 +0200
Message-ID: <20250408104827.329163293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 70a7cf563f01e..380938831b130 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -941,9 +941,10 @@ void wake_up_q(struct wake_q_head *head)
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



