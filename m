Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9D52210CD;
	Thu, 12 Dec 2024 15:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018522; cv=none; b=JbZyNRfSHGUecTaTFeMvVYjh8JUwBExlyhooq36E3sayzYXfA7O6JBJ+6CybPT9wswbUUVldD4sAKhKQ5jDseyHczgEK3h1Cau6fb5cDrEgOl4u/3zWDgJ5pl2Nt4IlqVLxq6b4E8VXcW5iyPI4eqBmWMsHV0JjSWEXUuDf7J64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018522; c=relaxed/simple;
	bh=N/jctqUJnHTBYPzWrm6x/E1zsd0FRgvAGHVqXlBLAp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikUwz/9F/fOpDNEHNHp2tdzlbmMaGuIKgJAa3rDR7NN8cJwS5KrASVRDVGrbd0o8DhCROmh47bbrUXg6V2VWMjgi0XDddxHGkH8Us9ELnBGWyjn+qNQrEewYsHN68+ODcJZQ69lcZEQyl7hVJ6ie9CfIf0y6tZeoS4hiZEhZMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l84EOuVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l84EOuVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBB9C4CED0;
	Thu, 12 Dec 2024 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018520;
	bh=N/jctqUJnHTBYPzWrm6x/E1zsd0FRgvAGHVqXlBLAp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l84EOuVDSvuWKcPc7PYZjrlAtnhsW8hXeohZ2fajbSEUOTTpoAbOD5JaYGTJBbsSm
	 DVJ/opUa2RLlR18/jCy4n7sK/IfDEE3uPM2nxHfgb2DzI9GNubkc4bmiV7dB4EcRfL
	 R20oJ+hNwVoGPivK0MrMvkQc0bkf6F+nQuYOBhuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raghavendra K T <raghavendra.kt@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mel Gorman <mgorman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/356] sched/numa: Fix mm numa_scan_seq based unconditional scan
Date: Thu, 12 Dec 2024 16:00:35 +0100
Message-ID: <20241212144257.039158416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

[ Upstream commit 84db47ca7146d7bd00eb5cf2b93989a971c84650 ]

Since commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic")

NUMA Balancing allows updating PTEs to trap NUMA hinting faults if the
task had previously accessed VMA. However unconditional scan of VMAs are
allowed during initial phase of VMA creation until process's
mm numa_scan_seq reaches 2 even though current task had not accessed VMA.

Rationale:
 - Without initial scan subsequent PTE update may never happen.
 - Give fair opportunity to all the VMAs to be scanned and subsequently
understand the access pattern of all the VMAs.

But it has a corner case where, if a VMA is created after some time,
process's mm numa_scan_seq could be already greater than 2.

For e.g., values of mm numa_scan_seq when VMAs are created by running
mmtest autonuma benchmark briefly looks like:
start_seq=0 : 459
start_seq=2 : 138
start_seq=3 : 144
start_seq=4 : 8
start_seq=8 : 1
start_seq=9 : 1
This results in no unconditional PTE updates for those VMAs created after
some time.

Fix:
 - Note down the initial value of mm numa_scan_seq in per VMA start_seq.
 - Allow unconditional scan till start_seq + 2.

Result:
SUT: AMD EPYC Milan with 2 NUMA nodes 256 cpus.
base kernel: upstream 6.6-rc6 with Mels patches [1] applied.

kernbench
==========		base                  patched %gain
Amean    elsp-128      165.09 ( 0.00%)      164.78 *   0.19%*

Duration User       41404.28    41375.08
Duration System      9862.22     9768.48
Duration Elapsed      519.87      518.72

Ops NUMA PTE updates           1041416.00      831536.00
Ops NUMA hint faults            263296.00      220966.00
Ops NUMA pages migrated         258021.00      212769.00
Ops AutoNUMA cost                 1328.67        1114.69

autonumabench

NUMA01_THREADLOCAL
==================
Amean  elsp-NUMA01_THREADLOCAL   81.79 (0.00%)  67.74 *  17.18%*

Duration User       54832.73    47379.67
Duration System        75.00      185.75
Duration Elapsed      576.72      476.09

Ops NUMA PTE updates                  394429.00    11121044.00
Ops NUMA hint faults                    1001.00     8906404.00
Ops NUMA pages migrated                  288.00     2998694.00
Ops AutoNUMA cost                          7.77       44666.84

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Link: https://lore.kernel.org/r/2ea7cbce80ac7c62e90cbfb9653a7972f902439f.1697816692.git.raghavendra.kt@amd.com
Stable-dep-of: 5f1b64e9a9b7 ("sched/numa: fix memory leak due to the overwritten vma->numab_state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_types.h | 3 +++
 kernel/sched/fair.c      | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 43c19d85dfe7f..20c96ce98751a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -576,6 +576,9 @@ struct vma_numab_state {
 	 */
 	unsigned long pids_active[2];
 
+	/* MM scan sequence ID when scan first started after VMA creation */
+	int start_scan_seq;
+
 	/*
 	 * MM scan sequence ID when the VMA was last completely scanned.
 	 * A VMA is not eligible for scanning if prev_scan_seq == numa_scan_seq
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index db59bf549c644..934d6f198b073 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3197,7 +3197,7 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
 	 * This is also done to avoid any side effect of task scanning
 	 * amplifying the unfairness of disjoint set of VMAs' access.
 	 */
-	if (READ_ONCE(current->mm->numa_scan_seq) < 2)
+	if ((READ_ONCE(current->mm->numa_scan_seq) - vma->numab_state->start_scan_seq) < 2)
 		return true;
 
 	pids = vma->numab_state->pids_active[0] | vma->numab_state->pids_active[1];
@@ -3349,6 +3349,8 @@ static void task_numa_work(struct callback_head *work)
 			if (!vma->numab_state)
 				continue;
 
+			vma->numab_state->start_scan_seq = mm->numa_scan_seq;
+
 			vma->numab_state->next_scan = now +
 				msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
 
-- 
2.43.0



