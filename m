Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32CB1C8618;
	Wed, 19 Mar 2025 14:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395196; cv=none; b=OEMJ3IkMVHw2DaJ6GDlPLyLdYMP5wtSSgEltPJugrF9+adcYwZo323Dz2DnnrQt+AhDJXKsNzW/u3w6ugBX9FH+P/MDsgLC5pb0uud1wVfxlNJbl3krie5ITO2NhYn6MapiABwY0y9QCgypd5fawZgKS4xM4FbSLfCau8WIRbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395196; c=relaxed/simple;
	bh=OKnEojHfHU5kkE7EwkhT00ULSyyf1pnYruAQd1LfxUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRkYLz4i1Nd00l/g9V/DqqwLiVSSdUlziMO7y1pik+U64LCc4RuEvgQITruuMfNYRrCJN++lHwMufkpPvVDjcQ4k42mOWTWKESlFe6H1oRWGyBMNbFWBIvGrkeuJN79sW7gjEQRySqrKvvTT/3j48qX5SGTJtfXboOhh3ldQb2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1f4GTYES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1f4GTYES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A821DC4CEE4;
	Wed, 19 Mar 2025 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395196;
	bh=OKnEojHfHU5kkE7EwkhT00ULSyyf1pnYruAQd1LfxUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1f4GTYEStMOS4ubHBi2yfy2X4qAaHRyUVw7WeM9r0ks5PWsDNZ+8SdVMEWN01MFlj
	 y7vlMz2YrJaoRVxnPjD1SUmghALELtTuB5eNct9KIKbs7etIfN69t2/ahkmU1bzOUi
	 k1Gn71sJGHlTUOnQLzK727SRVUlI6oVleUYA7jA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/166] sched: Clarify wake_up_q()s write to task->wake_q.next
Date: Wed, 19 Mar 2025 07:30:29 -0700
Message-ID: <20250319143021.569035432@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d6dc03e4a7d3..942734bf7347d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1019,9 +1019,10 @@ void wake_up_q(struct wake_q_head *head)
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



