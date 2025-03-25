Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACF725A2C0;
	Tue, 25 Mar 2025 12:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905625; cv=none; b=Vj500FNawtrbcEY7d2QOXz0DVXaFWbjSFL0P1v8LyGXF7fIgVvwMy4dmoGt1DaaRZXTlkbZQAvmoQuWgV2eyNCGFs+rGekNS1NbRisgJAQRFoz5aNjMbkezvnAABK4iETAEIQgm/riFQ6kbMhkg8yfScvbB50kvFL5v6cVQjbMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905625; c=relaxed/simple;
	bh=UXSdBcKyN88grZrvEi7fevU+Fjgkp4WVo8wTcf6c9pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq/Evk4mgWf+MaaXAwQEXj4IXf4eliJObWEZXYOyDRL68Y9MwamiQYrdToFjc2f4IvNVQFANb9arLRxaQ2J1f7UMWeekgakCW7YQMI6YRvPdla2rJAgmV0Rscs8jARtMCpzLEVx2epQcM+IquS86dndW50ktfD2Xi09lcudJ7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqrwS3ku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqrwS3ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1988C4CEE9;
	Tue, 25 Mar 2025 12:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905625;
	bh=UXSdBcKyN88grZrvEi7fevU+Fjgkp4WVo8wTcf6c9pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqrwS3kuFiBHR7ekl+wN1kpeyZ5fWnyl2Z4S7eVFGdkStXLlmefdatNMLAltGvDEY
	 oGm9966IdBTysRzCr/gyzTk/EKM88UN1oKp7SiZF1H99bGeVqdKcAeivs5HkjeegOS
	 eCHrKfTpo1MvtrcjiQFgFQBOpeZUIfrOYAvIVoWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/198] sched: Clarify wake_up_q()s write to task->wake_q.next
Date: Tue, 25 Mar 2025 08:20:08 -0400
Message-ID: <20250325122157.843620662@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9be8a509b5f3f..9b01fdceb6220 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -997,9 +997,10 @@ void wake_up_q(struct wake_q_head *head)
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



