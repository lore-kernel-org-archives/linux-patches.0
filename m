Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBAC1D0E25;
	Wed,  2 Oct 2024 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879873; cv=none; b=AUPj99hM2he9I8EXl57OZ41aTbXbIBkUQ4QaaBcQevaQDVtF+fcS3zLHDYtJT0iO7gpXaqPc8M/EnKN+CZ+OkRfIxsf+j3d+g8m9Y/n+age1Fm2KRJpCJfFnxNZ8BYlSA6MTEX98LaL8bffQl9898Yf9dNuZxAwXiKejfpNi9LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879873; c=relaxed/simple;
	bh=QRCGzpKBW4bqJcf9N5iBCWJHfFTSEMhJiep/KGUyCVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuaAQwutFwYfHYROEczt0CJCCBphtfyYAxi1nI/IOpNslymU8LIyVuYnfwr3JxOGtoK8XFG3PcWjoKPpTZ2SP8U85LBRlJmzjdChzt5ZyrkyeaVLQSSNDiDjQSebAq+Pm1LhxxrqrckDEm02I194HciyZDrS4rKwlMMJA99kYws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RO0pPdJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RO0pPdJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD27C4CEC5;
	Wed,  2 Oct 2024 14:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879872;
	bh=QRCGzpKBW4bqJcf9N5iBCWJHfFTSEMhJiep/KGUyCVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RO0pPdJn5jpnVsoMASUfc+jHGOuTmVja/s84BxKCW4+QN9Yjeyj1sR2MVYYxRlWsO
	 y5igQ1lz2Ic/znVJmlG7nnME5BpO1f1D+Bqwese5ybOyqNaY8rxWH+dklqQALgfPQp
	 tHr4+6pByw7bGFbS2qkfnZrMOPZ84ObTHz5/vx7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mel Gorman <mgorman@techsingularity.net>,
	Ingo Molnar <mingo@kernel.org>,
	Raghavendra K T <raghavendra.kt@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/538] sched/numa: Complete scanning of partial VMAs regardless of PID activity
Date: Wed,  2 Oct 2024 14:57:55 +0200
Message-ID: <20241002125801.567313337@linuxfoundation.org>
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

From: Mel Gorman <mgorman@techsingularity.net>

[ Upstream commit b7a5b537c55c088d891ae554103d1b281abef781 ]

NUMA Balancing skips VMAs when the current task has not trapped a NUMA
fault within the VMA. If the VMA is skipped then mm->numa_scan_offset
advances and a task that is trapping faults within the VMA may never
fully update PTEs within the VMA.

Force tasks to update PTEs for partially scanned PTEs. The VMA will
be tagged for NUMA hints by some task but this removes some of the
benefit of tracking PID activity within a VMA. A follow-on patch
will mitigate this problem.

The test cases and machines evaluated did not trigger the corner case so
the performance results are neutral with only small changes within the
noise from normal test-to-test variance. However, the next patch makes
the corner case easier to trigger.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Link: https://lore.kernel.org/r/20231010083143.19593-6-mgorman@techsingularity.net
Stable-dep-of: f22cde4371f3 ("sched/numa: Fix the vma scan starving issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/numa_balancing.h |  1 +
 include/trace/events/sched.h         |  3 ++-
 kernel/sched/fair.c                  | 18 +++++++++++++++---
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index c127a1509e2fa..7dcc0bdfddbbf 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -21,6 +21,7 @@ enum numa_vmaskip_reason {
 	NUMAB_SKIP_INACCESSIBLE,
 	NUMAB_SKIP_SCAN_DELAY,
 	NUMAB_SKIP_PID_INACTIVE,
+	NUMAB_SKIP_IGNORE_PID,
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b0d0dbf491ea6..27b51c81b1067 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -670,7 +670,8 @@ DEFINE_EVENT(sched_numa_pair_template, sched_swap_numa,
 	EM( NUMAB_SKIP_SHARED_RO,		"shared_ro" )	\
 	EM( NUMAB_SKIP_INACCESSIBLE,		"inaccessible" )	\
 	EM( NUMAB_SKIP_SCAN_DELAY,		"scan_delay" )	\
-	EMe(NUMAB_SKIP_PID_INACTIVE,		"pid_inactive" )
+	EM( NUMAB_SKIP_PID_INACTIVE,		"pid_inactive" )	\
+	EMe(NUMAB_SKIP_IGNORE_PID,		"ignore_pid_inactive" )
 
 /* Redefine for export. */
 #undef EM
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 07363b73ccdcc..03eb1cab320d8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3188,7 +3188,7 @@ static void reset_ptenuma_scan(struct task_struct *p)
 	p->mm->numa_scan_offset = 0;
 }
 
-static bool vma_is_accessed(struct vm_area_struct *vma)
+static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long pids;
 	/*
@@ -3201,7 +3201,19 @@ static bool vma_is_accessed(struct vm_area_struct *vma)
 		return true;
 
 	pids = vma->numab_state->pids_active[0] | vma->numab_state->pids_active[1];
-	return test_bit(hash_32(current->pid, ilog2(BITS_PER_LONG)), &pids);
+	if (test_bit(hash_32(current->pid, ilog2(BITS_PER_LONG)), &pids))
+		return true;
+
+	/*
+	 * Complete a scan that has already started regardless of PID access, or
+	 * some VMAs may never be scanned in multi-threaded applications:
+	 */
+	if (mm->numa_scan_offset > vma->vm_start) {
+		trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_IGNORE_PID);
+		return true;
+	}
+
+	return false;
 }
 
 #define VMA_PID_RESET_PERIOD (4 * sysctl_numa_balancing_scan_delay)
@@ -3345,7 +3357,7 @@ static void task_numa_work(struct callback_head *work)
 		}
 
 		/* Do not scan the VMA if task has not accessed */
-		if (!vma_is_accessed(vma)) {
+		if (!vma_is_accessed(mm, vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
 			continue;
 		}
-- 
2.43.0



