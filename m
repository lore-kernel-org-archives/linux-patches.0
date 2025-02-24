Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8896819F489;
	Mon, 24 Feb 2025 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409066; cv=none; b=DLzECwbu1C3/XECa952lTU99aw3oc/qBaSQl6tXz7ygEg70XuqnGI99OXagg9LIFyFFm2qUq3tHECE74e9gXhNfzxt2z3ldIzTq9zspQifMxfjKqjHJRn8GCn6gORQUCZeqWRHDLHkZDuUWarPdVi23CVfCqMKyxbmnzCtXdH+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409066; c=relaxed/simple;
	bh=ys0IBXsj6dRXtudSkeWEDV32pAWH+Sr/GqGYK3kvdX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXNmvol7XbMH5Ifs5LBUgMPFMjtV5rUDynnAE2myA0oB8lqfQ8Tf+Wf0YdaLYJ/xqlvUNa+RAcHtW4PyyYLbw5g/8UvWj18Kjh5N+kYBL6kEKK1eN5JFkTzsTkzQ/OmeENw5QsSdiNNM558jbLGH0ngp/BOa7U0K7kNUiUegJe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUvztvh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUvztvh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94729C4CED6;
	Mon, 24 Feb 2025 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409065;
	bh=ys0IBXsj6dRXtudSkeWEDV32pAWH+Sr/GqGYK3kvdX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUvztvh8zXPek3D/zQd9tAKWHy8/Fb0CivisldBMgpnWO0ctmjMIxcY1kvlaYdna0
	 YGZ63QhzbYUq8t3lh7edrPnnB7wqxOy6KgmE4JePyMFB427RSOTRIXd4F2m1IlewFE
	 y/sHtlhGnPvNwJS5/vGgnljkwzQ8u1Dkl3oUXhSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 086/138] sched: Compact RSEQ concurrency IDs with reduced threads and affinity
Date: Mon, 24 Feb 2025 15:35:16 +0100
Message-ID: <20250224142607.857548314@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 02d954c0fdf91845169cdacc7405b120f90afe01 ]

When a process reduces its number of threads or clears bits in its CPU
affinity mask, the mm_cid allocation should eventually converge towards
smaller values.

However, the change introduced by:

commit 7e019dcc470f ("sched: Improve cache locality of RSEQ concurrency
IDs for intermittent workloads")

adds a per-mm/CPU recent_cid which is never unset unless a thread
migrates.

This is a tradeoff between:

A) Preserving cache locality after a transition from many threads to few
   threads, or after reducing the hamming weight of the allowed CPU mask.

B) Making the mm_cid upper bounds wrt nr threads and allowed CPU mask
   easy to document and understand.

C) Allowing applications to eventually react to mm_cid compaction after
   reduction of the nr threads or allowed CPU mask, making the tracking
   of mm_cid compaction easier by shrinking it back towards 0 or not.

D) Making sure applications that periodically reduce and then increase
   again the nr threads or allowed CPU mask still benefit from good
   cache locality with mm_cid.

Introduce the following changes:

* After shrinking the number of threads or reducing the number of
  allowed CPUs, reduce the value of max_nr_cid so expansion of CID
  allocation will preserve cache locality if the number of threads or
  allowed CPUs increase again.

* Only re-use a recent_cid if it is within the max_nr_cid upper bound,
  else find the first available CID.

Fixes: 7e019dcc470f ("sched: Improve cache locality of RSEQ concurrency IDs for intermittent workloads")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lkml.kernel.org/r/20250210153253.460471-2-gmonaco@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm_types.h |  7 ++++---
 kernel/sched/sched.h     | 25 ++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 332cee2856620..14fc1b39c0cf3 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -873,10 +873,11 @@ struct mm_struct {
 		 */
 		unsigned int nr_cpus_allowed;
 		/**
-		 * @max_nr_cid: Maximum number of concurrency IDs allocated.
+		 * @max_nr_cid: Maximum number of allowed concurrency
+		 *              IDs allocated.
 		 *
-		 * Track the highest number of concurrency IDs allocated for the
-		 * mm.
+		 * Track the highest number of allowed concurrency IDs
+		 * allocated for the mm.
 		 */
 		atomic_t max_nr_cid;
 		/**
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 66744d60904d5..f3e121888d050 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3666,10 +3666,28 @@ static inline int __mm_cid_try_get(struct task_struct *t, struct mm_struct *mm)
 {
 	struct cpumask *cidmask = mm_cidmask(mm);
 	struct mm_cid __percpu *pcpu_cid = mm->pcpu_cid;
-	int cid = __this_cpu_read(pcpu_cid->recent_cid);
+	int cid, max_nr_cid, allowed_max_nr_cid;
 
+	/*
+	 * After shrinking the number of threads or reducing the number
+	 * of allowed cpus, reduce the value of max_nr_cid so expansion
+	 * of cid allocation will preserve cache locality if the number
+	 * of threads or allowed cpus increase again.
+	 */
+	max_nr_cid = atomic_read(&mm->max_nr_cid);
+	while ((allowed_max_nr_cid = min_t(int, READ_ONCE(mm->nr_cpus_allowed),
+					   atomic_read(&mm->mm_users))),
+	       max_nr_cid > allowed_max_nr_cid) {
+		/* atomic_try_cmpxchg loads previous mm->max_nr_cid into max_nr_cid. */
+		if (atomic_try_cmpxchg(&mm->max_nr_cid, &max_nr_cid, allowed_max_nr_cid)) {
+			max_nr_cid = allowed_max_nr_cid;
+			break;
+		}
+	}
 	/* Try to re-use recent cid. This improves cache locality. */
-	if (!mm_cid_is_unset(cid) && !cpumask_test_and_set_cpu(cid, cidmask))
+	cid = __this_cpu_read(pcpu_cid->recent_cid);
+	if (!mm_cid_is_unset(cid) && cid < max_nr_cid &&
+	    !cpumask_test_and_set_cpu(cid, cidmask))
 		return cid;
 	/*
 	 * Expand cid allocation if the maximum number of concurrency
@@ -3677,8 +3695,9 @@ static inline int __mm_cid_try_get(struct task_struct *t, struct mm_struct *mm)
 	 * and number of threads. Expanding cid allocation as much as
 	 * possible improves cache locality.
 	 */
-	cid = atomic_read(&mm->max_nr_cid);
+	cid = max_nr_cid;
 	while (cid < READ_ONCE(mm->nr_cpus_allowed) && cid < atomic_read(&mm->mm_users)) {
+		/* atomic_try_cmpxchg loads previous mm->max_nr_cid into cid. */
 		if (!atomic_try_cmpxchg(&mm->max_nr_cid, &cid, cid + 1))
 			continue;
 		if (!cpumask_test_and_set_cpu(cid, cidmask))
-- 
2.39.5



