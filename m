Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EC71D2238;
	Wed,  2 Oct 2024 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879869; cv=none; b=igudDvWxXp6Ghm1P2EXmOrg5WRdrD6Sx6INB59L2HwoL9lY+nFAx0/CWGm3HVojQ+C7nFPc5426hxRfX/jHEWGLxfMdaZX/Wdfli0fy9OD7YYJolDu47UQJvc/rTAvfZkXJYCKehS6HrPm6CBEvly3yPEKq6A5R0hxzqcQEz37o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879869; c=relaxed/simple;
	bh=mYtExGgUHzkESnQFbhBRqATKiTUXZHtvVjVaLKUKD7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AG1o2WpUce4PJZ1burRwB0dfZTv7cwkzRu+ZJbsHjsnRx5CxG8kgSidDJi/JB+0fK9FBdjNcozH74GOYJdyeusNNs95Zie+1/3/BKHzjD16B8yF6uLtulkCG/tdkveLB0vGUinauzLnRGoeBdDE43Ve41y8agt05V9dj1gv6jzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZFE6E6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZFE6E6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDE5C4CECD;
	Wed,  2 Oct 2024 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879869;
	bh=mYtExGgUHzkESnQFbhBRqATKiTUXZHtvVjVaLKUKD7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZFE6E6IalfWvEbdRPA3AtA9R/7KgYbOtK1TUI5uqTwJilGWjkMmtyq5YLqUPG6a8
	 aPuet9TEqW2/o5a9hYS0II5td62mCj+kBUN4Ggt+DTsVsP6czcYl0RohMqWtNYdjmq
	 7Xmh3bIp28KUywD4ig+j8OH+ZuKTkrY+upeczDdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Raghavendra K T <raghavendra.kt@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 235/538] sched/numa: Move up the access pid reset logic
Date: Wed,  2 Oct 2024 14:57:54 +0200
Message-ID: <20241002125801.527879720@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Raghavendra K T <raghavendra.kt@amd.com>

[ Upstream commit 2e2675db1906ac04809f5399bf1f5e30d56a6f3e ]

Recent NUMA hinting faulting activity is reset approximately every
VMA_PID_RESET_PERIOD milliseconds. However, if the current task has not
accessed a VMA then the reset check is missed and the reset is potentially
deferred forever. Check if the PID activity information should be reset
before checking if the current task recently trapped a NUMA hinting fault.

[ mgorman@techsingularity.net: Rewrite changelog ]

Suggested-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20231010083143.19593-5-mgorman@techsingularity.net
Stable-dep-of: f22cde4371f3 ("sched/numa: Fix the vma scan starving issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c5f6e94b3cdc..07363b73ccdcc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3335,16 +3335,7 @@ static void task_numa_work(struct callback_head *work)
 			continue;
 		}
 
-		/* Do not scan the VMA if task has not accessed */
-		if (!vma_is_accessed(vma)) {
-			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
-			continue;
-		}
-
-		/*
-		 * RESET access PIDs regularly for old VMAs. Resetting after checking
-		 * vma for recent access to avoid clearing PID info before access..
-		 */
+		/* RESET access PIDs regularly for old VMAs. */
 		if (mm->numa_scan_seq &&
 				time_after(jiffies, vma->numab_state->pids_active_reset)) {
 			vma->numab_state->pids_active_reset = vma->numab_state->pids_active_reset +
@@ -3353,6 +3344,12 @@ static void task_numa_work(struct callback_head *work)
 			vma->numab_state->pids_active[1] = 0;
 		}
 
+		/* Do not scan the VMA if task has not accessed */
+		if (!vma_is_accessed(vma)) {
+			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
+			continue;
+		}
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
-- 
2.43.0



