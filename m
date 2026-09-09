Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91262566C53;
	Wed,  9 Sep 2026 14:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964661; cv=none; b=c5I+h/5MknjNON/rnxI6vf/wJTThNLCyhwEEEiqD62b1EqKEnBGAX2m/eeMGAaZ7+zS7rrMXIudDcHrIlCYypRMNgczAc4gGr0/nOjKzdPuSSdtLsiAwgv7g/gBbM+RR+WmrywJCQ6ST/BCWfw4Hffh8w8WdJmvU/oGrCVQ8+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964661; c=relaxed/simple;
	bh=6ZRPKYkCHtbRY4oFxhXn1B57FJERDZAMnhA2CDX+OMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Futr/Hh+BxX+udfh0RXcLsABoZXlQetU0FPxZf+gAWHWCFYPBTVtbBNid77U8xrQu6gsCUEZV/RV83g+oqEnWyg1GHLp/ZX6lFE0BhZd0h25g2dVhMIsYnGyHrYzmML3J7VtICh36JO8OTNcszz3aYFyjxpHqK26FismRe//zX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yw83985L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yw83985L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA041F00A3A;
	Wed,  9 Sep 2026 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964660;
	bh=FhINEQj3gnV7EY4gZgl4p1cAe1REuBCVO6mn3SlPbSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yw83985Lvmo2QCkqW+r0EvOiEH0C6lfCw7AwmNQisqngUQtpDNFkqDjoOE4Dppj31
	 1Y6Ko5OjsuBlqYI2Mo7cMPWzQuikxJvlDQmlnnhUYtHek7jD6QlYDtM86yV6qIT1bM
	 yA5PZXzDFug17RptM3G1wfQI+KxrvAOlt0PISTNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/583] sched_ext: Fix inverted ops.core_sched_before() invocation
Date: Wed,  9 Sep 2026 15:43:05 +0200
Message-ID: <20260909134255.093725100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted kernel/sched/ext/ext.c changes to the older kernel/sched/ext.c layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c             |   10 ++++++++--
 tools/sched_ext/scx_qmap.bpf.c |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2513,6 +2513,8 @@ static struct task_struct *pick_task_scx
  *
  * When ops.core_sched_before() is enabled, @p->scx.core_sched_at is used to
  * implement FIFO ordering within each local DSQ. See pick_task_scx().
+ *
+ * Return: %true if @a should run after @b.
  */
 bool scx_prio_less(const struct task_struct *a, const struct task_struct *b,
 		   bool in_fi)
@@ -2520,6 +2522,10 @@ bool scx_prio_less(const struct task_str
 	struct scx_sched *sch = scx_root;
 
 	/*
+	 * scx_prio_less() returns whether @a should run after @b while
+	 * ops.core_sched_before() returns whether its first argument should run
+	 * before the second. Swap the arguments.
+	 *
 	 * The const qualifiers are dropped from task_struct pointers when
 	 * calling ops.core_sched_before(). Accesses are controlled by the
 	 * verifier.
@@ -2528,8 +2534,8 @@ bool scx_prio_less(const struct task_str
 	    !scx_rq_bypassing(task_rq(a)))
 		return SCX_CALL_OP_2TASKS_RET(sch, SCX_KF_REST, core_sched_before,
 					      task_rq(a),
-					      (struct task_struct *)a,
-					      (struct task_struct *)b);
+					      (struct task_struct *)b,
+					      (struct task_struct *)a);
 	else
 		return time_after64(a->scx.core_sched_at, b->scx.core_sched_at);
 }
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -530,7 +530,7 @@ static s64 task_qdist(struct task_struct
 bool BPF_STRUCT_OPS(qmap_core_sched_before,
 		    struct task_struct *a, struct task_struct *b)
 {
-	return task_qdist(a) > task_qdist(b);
+	return task_qdist(a) < task_qdist(b);
 }
 
 void BPF_STRUCT_OPS(qmap_cpu_release, s32 cpu, struct scx_cpu_release_args *args)


