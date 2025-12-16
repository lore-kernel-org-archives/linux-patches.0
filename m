Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABD41991B6;
	Tue, 16 Dec 2025 12:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886428; cv=none; b=D1IryPxDGWIssjMNM2VpAi3lDmbQOmU0W0fX/OK/C37S+L7umKJtygV46z2L4vbGPUlSmwAQaEI54ct/Np9zr21az6MKeyH0j+vzmFCQ4/3sPq2cAmhO2/YYhlMAwbV5AjIKyy/MFkIEEQMke/qc3SBUW4MayA55ESQzZJS+uPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886428; c=relaxed/simple;
	bh=kvvWt6GuhVzw8fzTPQMJG9qYxIhrHvcKZrWjN+Alwiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNxXEod0JJXphc8Ttb9ZFe/2t6Jpe2A2ZFBIMCcGL+LsEXz/Nr/PS7F0fXsyYLpA8FTpWN4ln15qiKyfMGWEeDgg7/XwXavGJ7VfaE0eGKnxueuMIKlfuqxFI/jMbGmN0M/CAjh0wJFGkARb2luxnA/DQMH6R6ZVL1q2kliFkfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtWhnpuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtWhnpuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AD2C4CEF1;
	Tue, 16 Dec 2025 12:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886427;
	bh=kvvWt6GuhVzw8fzTPQMJG9qYxIhrHvcKZrWjN+Alwiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtWhnpuXwXZhCDLhMSWmFrpmGCrlNNT0F3ExvK1/expjbiUfhsz+tGOm2BGRObfDK
	 FqYK/M31dRP6hBThIpAFpESCqJH1+7l8mWYbonWlHJoDkyNbaUL1HFn7QTd9VSwBwm
	 5uP30nRJfYMFK8GKa1TeIagvl/m2iLCf9vfncjNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	John Stultz <jstultz@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Haiyue Wang <haiyuewa@163.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 434/507] sched/core: Fix psi_dequeue() for Proxy Execution
Date: Tue, 16 Dec 2025 12:14:35 +0100
Message-ID: <20251216111401.181915087@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit c2ae8b0df2d1bb7a063f9e356e4e9a06cd4afe11 ]

Currently, if the sleep flag is set, psi_dequeue() doesn't
change any of the psi_flags.

This is because psi_task_switch() will clear TSK_ONCPU as well
as other potential flags (TSK_RUNNING), and the assumption is
that a voluntary sleep always consists of a task being dequeued
followed shortly there after with a psi_sched_switch() call.

Proxy Execution changes this expectation, as mutex-blocked tasks
that would normally sleep stay on the runqueue. But in the case
where the mutex-owning task goes to sleep, or the owner is on a
remote cpu, we will then deactivate the blocked task shortly
after.

In that situation, the mutex-blocked task will have had its
TSK_ONCPU cleared when it was switched off the cpu, but it will
stay TSK_RUNNING. Then if we later dequeue it (as currently done
if we hit a case find_proxy_task() can't yet handle, such as the
case of the owner being on another rq or a sleeping owner)
psi_dequeue() won't change any state (leaving it TSK_RUNNING),
as it incorrectly expects a psi_task_switch() call to
immediately follow.

Later on when the task get woken/re-enqueued, and psi_flags are
set for TSK_RUNNING, we hit an error as the task is already
TSK_RUNNING:

  psi: inconsistent task state! task=188:kworker/28:0 cpu=28 psi_flags=4 clear=0 set=4

To resolve this, extend the logic in psi_dequeue() so that
if the sleep flag is set, we also check if psi_flags have
TSK_ONCPU set (meaning the psi_task_switch is imminent) before
we do the shortcut return.

If TSK_ONCPU is not set, that means we've already switched away,
and this psi_dequeue call needs to clear the flags.

Fixes: be41bde4c3a8 ("sched: Add an initial sketch of the find_proxy_task() function")
Reported-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Haiyue Wang <haiyuewa@163.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://patch.msgid.link/20251205012721.756394-1-jstultz@google.com
Closes: https://lore.kernel.org/lkml/20251117185550.365156-1-kprateek.nayak@amd.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/stats.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 26f3fd4d34cea..73bd6bca4d310 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -180,8 +180,13 @@ static inline void psi_dequeue(struct task_struct *p, int flags)
 	 * avoid walking all ancestors twice, psi_task_switch() handles
 	 * TSK_RUNNING and TSK_IOWAIT for us when it moves TSK_ONCPU.
 	 * Do nothing here.
+	 *
+	 * In the SCHED_PROXY_EXECUTION case we may do sleeping
+	 * dequeues that are not followed by a task switch, so check
+	 * TSK_ONCPU is set to ensure the task switch is imminent.
+	 * Otherwise clear the flags as usual.
 	 */
-	if (flags & DEQUEUE_SLEEP)
+	if ((flags & DEQUEUE_SLEEP) && (p->psi_flags & TSK_ONCPU))
 		return;
 
 	/*
-- 
2.51.0



