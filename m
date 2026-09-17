Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806344DDB5A;
	Thu, 17 Sep 2026 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671804; cv=none; b=iIrx9BruioQW2412HsixTdTjcFRpddyJ1Z1hVRBcF6rQ7gOUXwxw5CMOWbSO6yG/YvezBt7oArAtiRti1js8Ql5BqI8ft04OIXdrE6QU4i+FrYTPPIQgicMoyAJ0mQKBSKWJaaPXg34YqGDfQJ2uqz29zmUphYoEsxSWkLbGCMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671804; c=relaxed/simple;
	bh=rgwm8gAK+bWlzaxNRzsoWDe15S0HXR5P3KVtXoDb8EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYEf8c2QIzrn/HKIjfNykHuokIjFRmhmlSdflOocSTba7xQNxxWwrQrdRbz1emrjPEVOfZXkDzsFSC8oKGuyCihZ6qGChAUD5oMjQn1hvAQp7bpgiDuwB07yU+YsPg+ATT35ldhid+z2Vgow2fnwXgJyTJ2QDmH8VeNUd7D84eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TArw/qTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TArw/qTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22E21F00893;
	Thu, 17 Sep 2026 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671803;
	bh=PSBfGOHRBk3+bIRtrKqVE9IGcl0qtRZA8CihbyYTzL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TArw/qTccGlxWMVegbClmgyqPr63/Vc50w5+QvV7OInR/oz8nM85iG84k/cPIkvAT
	 TFHa6pauPz86Sp6Vn+YZjvLGPOay5amA7UX9c5nxHCjNblxUiTA7mKTPZjYw/M7Xwo
	 SNSzubl1pziBxtFTqyBJ0Xzcc5ylOBNncBlqV9CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1095/1102] sched_ext: Fix inverted ops.core_sched_before() invocation
Date: Thu, 17 Sep 2026 16:17:18 +0100
Message-ID: <20260917151608.358147182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit f7b6d128dd49a6eec09066ecfd29095f12588786 ]

scx_prio_less() implements prio_less() semantics - %true means that @a is
the lower priority and should run after @b. ops.core_sched_before() is
documented to return %true when @a should run before @b. scx_prio_less()
returns the op's value as-is, inverting the documented semantics at runtime.

Call the op with the arguments swapped.

scx_qmap followed the wiring instead of the documentation and returned %true
for the younger task, so the two inversions canceled out and it behaved as
intended. Flip its comparison to match. scx_qmap is likely the only current
user in or out of the kernel tree. Any scheduler written the same way needs
the same flip, while schedulers following the documentation are fixed by
this change.

Fixes: 7b0888b7cc19 ("sched_ext: Implement core-sched support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Tejun Heo <tj@kernel.org>
[ adapted the change to kernel/sched/ext.c with the older SCX_CALL_OP_2TASKS_RET() macro signature. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c             |   10 ++++++++--
 tools/sched_ext/scx_qmap.bpf.c |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3173,19 +3173,25 @@ static struct task_struct *pick_task_scx
  *
  * When ops.core_sched_before() is enabled, @p->scx.core_sched_at is used to
  * implement FIFO ordering within each local DSQ. See pick_task_scx().
+ *
+ * Return: %true if @a should run after @b.
  */
 bool scx_prio_less(const struct task_struct *a, const struct task_struct *b,
 		   bool in_fi)
 {
 	/*
+	 * scx_prio_less() returns whether @a should run after @b while
+	 * ops.core_sched_before() returns whether its first argument should run
+	 * before the second. Swap the arguments.
+	 *
 	 * The const qualifiers are dropped from task_struct pointers when
 	 * calling ops.core_sched_before(). Accesses are controlled by the
 	 * verifier.
 	 */
 	if (SCX_HAS_OP(core_sched_before) && !scx_rq_bypassing(task_rq(a)))
 		return SCX_CALL_OP_2TASKS_RET(SCX_KF_REST, core_sched_before,
-					      (struct task_struct *)a,
-					      (struct task_struct *)b);
+					      (struct task_struct *)b,
+					      (struct task_struct *)a);
 	else
 		return time_after64(a->scx.core_sched_at, b->scx.core_sched_at);
 }
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -529,7 +529,7 @@ static s64 task_qdist(struct task_struct
 bool BPF_STRUCT_OPS(qmap_core_sched_before,
 		    struct task_struct *a, struct task_struct *b)
 {
-	return task_qdist(a) > task_qdist(b);
+	return task_qdist(a) < task_qdist(b);
 }
 
 void BPF_STRUCT_OPS(qmap_cpu_release, s32 cpu, struct scx_cpu_release_args *args)


