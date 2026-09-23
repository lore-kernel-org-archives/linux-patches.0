Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE98648EC6C;
	Wed, 23 Sep 2026 14:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173693; cv=none; b=rtfDJSklZpIAB+CuBZea9Ku8ClHwvHUIoFmIQGMD7jIQWcqGWiJJSYPywGGD4fjiW9uOZ+ZmQ8wiQzTAgoJAleWJZA1Mar/gz+ZuwOnLBkrP6ioWtzFb24H3qSqQejyOXVt3yraBvpeckeFCxEaNUh53oFxFqyWq4O/0/ElsJao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173693; c=relaxed/simple;
	bh=MZhCtdo1nm7YppKZqAcL/YyO8LAjCfupat96pwISxls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7oaDbK6RmSm9HjAXSl9Hlo5pEJEDYOa16vg9Ti6I3iWW8PrVbJpF5bLluxFO/aZPPmpLH4JdKSGjQA+bdIAnpJue4WaylvVc3qNHw4NscJ30QVD0QMdgWxD4GsSUFr0nzrOT22z7yYDBYvS6ejjsvFpoO7W/D+WNdPQ52wiLQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRcClVL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRcClVL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1332A1F000FF;
	Wed, 23 Sep 2026 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173692;
	bh=xpimMPvAceIHYUjHkotMUczGjFP7G1uZsG45k/oTKjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRcClVL4szkfdMpSkGZMfbfyAa8q2IxEh0iItsGlfaBWJw15NLilmFFx8OFa7SkCe
	 VU4eI0/ZOQG9GfRAhEQbAiu5WQ/7t9/dIi869TlyeHkMKzVToAgHQ3EopAAM2Tiolb
	 I0j8K+t3XjRcuyoq1vY58HRw5z4lQwsxEg0C3APA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fangqiurong <fangqiurong@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 324/438] sched_ext: Close the pre-enable ops error claim window
Date: Wed, 23 Sep 2026 16:05:45 +0200
Message-ID: <20260923140653.197112810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: fangqiurong <fangqiurong@kylinos.cn>

commit c7a1c6e8004ab12a9c9bfdcb603f60f9bf4a3cee upstream.

scx_alloc_and_add_sched() publishes ops->priv before
scx_root_enable_workfn() switches the state to SCX_ENABLING. An error
claimed via scx_bpf_error_bstr() from an associated BPF program in that
window is consumed by scx_disable_workfn(), which takes the pre-enable
shortcut in scx_root_disable(). The shortcut returns without any teardown
and restores SCX_DISABLED with an unconditional scx_set_enable_state() xchg
racing the enable workfn's own transition. The enable then completes with
the claim consumed: the scheduler stays up but can never be disabled again,
and bpf_scx_unreg() frees it while still in use, resulting in a
use-after-free. Both WARN_ON_ONCE()s fire back to back:

  WARNING: kernel/sched/ext/ext.c:7522 at
  scx_root_enable_workfn+0xeec/0x1be0, CPU#3: scx_enable_help/276

  WARNING: kernel/sched/ext/ext.c:6398 at scx_root_disable+0xb50/0xdb8,
  CPU#0: sched_ext_helpe/664

scx_root_enable_workfn() switches to SCX_ENABLING before the scheduler
allocation, so ops->priv is never visible while SCX_DISABLED. The allocation
failure path restores SCX_DISABLED.

Fixes: 105dcd005be2 ("sched_ext: Introduce scx_prog_sched()")
Cc: stable@vger.kernel.org
Signed-off-by: fangqiurong <fangqiurong@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -7282,22 +7282,24 @@ static void scx_root_enable_workfn(struc
 #ifdef CONFIG_EXT_SUB_SCHED
 	cgroup_get(cgrp);
 #endif
+	/*
+	 * Transition to ENABLING to arm the disable path. Allocation failure
+	 * still unwinds locally. Full disabling on failure applies only after
+	 * scx_alloc_and_add_sched() succeeds.
+	 */
+	WARN_ON_ONCE(scx_set_enable_state(SCX_ENABLING) != SCX_DISABLED);
+	WARN_ON_ONCE(scx_root);
+
 	sch = scx_alloc_and_add_sched(cmd, cgrp, NULL);
 	if (IS_ERR(sch)) {
 		ret = PTR_ERR(sch);
+		WARN_ON_ONCE(scx_set_enable_state(SCX_DISABLED) != SCX_ENABLING);
 		goto err_free_tid_hash;
 	}
 
 	if (sch->is_cid_type)
 		static_branch_enable(&__scx_is_cid_type);
 
-	/*
-	 * Transition to ENABLING and clear exit info to arm the disable path.
-	 * Failure triggers full disabling from here on.
-	 */
-	WARN_ON_ONCE(scx_set_enable_state(SCX_ENABLING) != SCX_DISABLED);
-	WARN_ON_ONCE(scx_root);
-
 	atomic_long_set(&scx_nr_rejected, 0);
 
 	for_each_possible_cpu(cpu) {


