Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF7C1D014D;
	Wed,  2 Oct 2024 14:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879784; cv=none; b=iuJs7g/vPjSuCBQpIT0RAx9dE7cx3FSBRT7xxVRR39VbUtSF6Y6Lsfu8o5whHtacU6l5DJgKaAnKMvcP5FcrbT0KwugccU52Tu9W7bYiqtfRQqNDGV2OF4GG54u6VlLqEcizCBUMdRsEZ6n/p5TQ0X5cmebZ+psVRzh2D2bW+GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879784; c=relaxed/simple;
	bh=oSYIbnA5+GKJzNtF2WykNZjQ0DZQQKDl+7kJf7cRoYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4Y+0UgPh7XvrfUExFWF6rmi0M0LsQmXq1jebMc7NmXg0dUyzQLrRCZ4qgIxFWIbM7EbtWO+D8mjw22kBNu5OCI3vMcMpv3lTeb1woVp3QE/jrXTp4UrtrhCLVuViB47z98Tt6KvR8x9ocUlCr2vFQgQFSiBAvKh2Y/EnXaEyws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CK5i4xAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CK5i4xAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15D7C4CEC2;
	Wed,  2 Oct 2024 14:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879784;
	bh=oSYIbnA5+GKJzNtF2WykNZjQ0DZQQKDl+7kJf7cRoYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CK5i4xAYJSDS0LfrD9KDrRvu9H/Ofd5fq+BIKF9F54yUM56Jx/9zXD3IXxwUL8WgB
	 Z8VJzWaFgUVYASEndufpWlLIq7CzsTjnZsY5b6yzvfYqVMRDI7DShK7SqRPe8Vy1iD
	 xkMpWWUyCBrXuc6A4iTIIG9mHq1sYqOEZWtoc6ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Yujie Liu <yujie.liu@intel.com>,
	Xiaoping Zhou <xiaoping.zhou@intel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	"Chen, Tim C" <tim.c.chen@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Raghavendra K T <raghavendra.kt@amd.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 238/538] sched/numa: Fix the vma scan starving issue
Date: Wed,  2 Oct 2024 14:57:57 +0200
Message-ID: <20241002125801.645629525@linuxfoundation.org>
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

From: Yujie Liu <yujie.liu@intel.com>

[ Upstream commit f22cde4371f3c624e947a35b075c06c771442a43 ]

Problem statement:
Since commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic"), the
Numa vma scan overhead has been reduced a lot.  Meanwhile, the reducing of
the vma scan might create less Numa page fault information.  The
insufficient information makes it harder for the Numa balancer to make
decision.  Later, commit b7a5b537c55c08 ("sched/numa: Complete scanning of
partial VMAs regardless of PID activity") and commit 84db47ca7146d7
("sched/numa: Fix mm numa_scan_seq based unconditional scan") are found to
bring back part of the performance.

Recently when running SPECcpu omnetpp_r on a 320 CPUs/2 Sockets system, a
long duration of remote Numa node read was observed by PMU events: A few
cores having ~500MB/s remote memory access for ~20 seconds.  It causes
high core-to-core variance and performance penalty.  After the
investigation, it is found that many vmas are skipped due to the active
PID check.  According to the trace events, in most cases,
vma_is_accessed() returns false because the history access info stored in
pids_active array has been cleared.

Proposal:
The main idea is to adjust vma_is_accessed() to let it return true easier.
Thus compare the diff between mm->numa_scan_seq and
vma->numab_state->prev_scan_seq.  If the diff has exceeded the threshold,
scan the vma.

This patch especially helps the cases where there are small number of
threads, like the process-based SPECcpu.  Without this patch, if the
SPECcpu process access the vma at the beginning, then sleeps for a long
time, the pid_active array will be cleared.  A a result, if this process
is woken up again, it never has a chance to set prot_none anymore.
Because only the first 2 times of access is granted for vma scan:
(current->mm->numa_scan_seq) - vma->numab_state->start_scan_seq) < 2 to be
worse, no other threads within the task can help set the prot_none.  This
causes information lost.

Raghavendra helped test current patch and got the positive result
on the AMD platform:

autonumabench NUMA01
                            base                  patched
Amean     syst-NUMA01      194.05 (   0.00%)      165.11 *  14.92%*
Amean     elsp-NUMA01      324.86 (   0.00%)      315.58 *   2.86%*

Duration User      380345.36   368252.04
Duration System      1358.89     1156.23
Duration Elapsed     2277.45     2213.25

autonumabench NUMA02

Amean     syst-NUMA02        1.12 (   0.00%)        1.09 *   2.93%*
Amean     elsp-NUMA02        3.50 (   0.00%)        3.56 *  -1.84%*

Duration User        1513.23     1575.48
Duration System         8.33        8.13
Duration Elapsed       28.59       29.71

kernbench

Amean     user-256    22935.42 (   0.00%)    22535.19 *   1.75%*
Amean     syst-256     7284.16 (   0.00%)     7608.72 *  -4.46%*
Amean     elsp-256      159.01 (   0.00%)      158.17 *   0.53%*

Duration User       68816.41    67615.74
Duration System     21873.94    22848.08
Duration Elapsed      506.66      504.55

Intel 256 CPUs/2 Sockets:
autonuma benchmark also shows improvements:

                                               v6.10-rc5              v6.10-rc5
                                                                         +patch
Amean     syst-NUMA01                  245.85 (   0.00%)      230.84 *   6.11%*
Amean     syst-NUMA01_THREADLOCAL      205.27 (   0.00%)      191.86 *   6.53%*
Amean     syst-NUMA02                   18.57 (   0.00%)       18.09 *   2.58%*
Amean     syst-NUMA02_SMT                2.63 (   0.00%)        2.54 *   3.47%*
Amean     elsp-NUMA01                  517.17 (   0.00%)      526.34 *  -1.77%*
Amean     elsp-NUMA01_THREADLOCAL       99.92 (   0.00%)      100.59 *  -0.67%*
Amean     elsp-NUMA02                   15.81 (   0.00%)       15.72 *   0.59%*
Amean     elsp-NUMA02_SMT               13.23 (   0.00%)       12.89 *   2.53%*

                   v6.10-rc5   v6.10-rc5
                                  +patch
Duration User     1064010.16  1075416.23
Duration System      3307.64     3104.66
Duration Elapsed     4537.54     4604.73

The SPECcpu remote node access issue disappears with the patch applied.

Link: https://lkml.kernel.org/r/20240827112958.181388-1-yu.c.chen@intel.com
Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
Reported-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
Reviewed-and-tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0af2be3ee849e..5eb4807bad209 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3213,6 +3213,15 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
 		return true;
 	}
 
+	/*
+	 * This vma has not been accessed for a while, and if the number
+	 * the threads in the same process is low, which means no other
+	 * threads can help scan this vma, force a vma scan.
+	 */
+	if (READ_ONCE(mm->numa_scan_seq) >
+	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
+		return true;
+
 	return false;
 }
 
-- 
2.43.0



