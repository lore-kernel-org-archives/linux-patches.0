Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78A3334368;
	Mon, 29 Dec 2025 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025987; cv=none; b=Tc4UuABrnQIaw9dabgZYdEsc1iy77mwUJO3HtxwqkXay+uOH7R1HATCbgNj3kupWV5FNRwCLVfZjxo+87pln1fgUqJ73OnqGpL6Xss6nFmew2P3qbv8KRLiyI+hOGYEbQgIunW7s6EYBc9n3LlADiSues68vFE1ucM1xCFRtgUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025987; c=relaxed/simple;
	bh=PfDGb6kxfCE8toBzATbZaLRLqUdUiHvfFqK01GfIObk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSNx3x87Ht73d6PG1fxtoTeYKVu3P9rV46WSCYpVTUBzsWR8GmGCwsB60v2mQWBhm0h0g7lq/5sKODNzwMHmxnmEhVRzDfiaYs//XCiptt8d3k3zwW131WfzLFnakT23FrBXaWRUXfpz3EMaKZX++J8L1KplautRd3oqw2tEtUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJy+7e+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJy+7e+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61781C116C6;
	Mon, 29 Dec 2025 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025987;
	bh=PfDGb6kxfCE8toBzATbZaLRLqUdUiHvfFqK01GfIObk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJy+7e+qejHxupTUmznTE67giaGuQ5L1/KR+qnMB4wB9l3kUnO5/UR/0ORgX/Obw0
	 B27V3ftgGUM24jrbcbTidAf5yC8WJTvUeg4TRkz1cKwmC1jA9LVm8rQCrryxLTI+UL
	 C8+Wx4iimtTO0n2pttcOe4+sFTim3GQOxnIlUMpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 380/430] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Date: Mon, 29 Dec 2025 17:13:02 +0100
Message-ID: <20251229160738.306179870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

commit 3309b63a2281efb72df7621d60cc1246b6286ad3 upstream.

On x86-64, this_cpu_cmpxchg() uses CMPXCHG without LOCK prefix which
means it is only safe for the local CPU and not for multiple CPUs.
Recently the commit 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi
safe") make css_rstat_updated lockless and uses lockless list to allow
reentrancy. Since css_rstat_updated can invoked from process context,
IRQ and NMI, it uses this_cpu_cmpxchg() to select the winner which will
inset the lockless lnode into the global per-cpu lockless list.

However the commit missed one case where lockless node of a cgroup can
be accessed and modified by another CPU doing the flushing. Basically
llist_del_first_init() in css_process_update_tree().

On a cursory look, it can be questioned how css_process_update_tree()
can see a lockless node in global lockless list where the updater is at
this_cpu_cmpxchg() and before llist_add() call in css_rstat_updated().
This can indeed happen in the presence of IRQs/NMI.

Consider this scenario: Updater for cgroup stat C on CPU A in process
context is after llist_on_list() check and before this_cpu_cmpxchg() in
css_rstat_updated() where it get interrupted by IRQ/NMI. In the IRQ/NMI
context, a new updater calls css_rstat_updated() for same cgroup C and
successfully inserts rstatc_pcpu->lnode.

Now concurrently CPU B is running the flusher and it calls
llist_del_first_init() for CPU A and got rstatc_pcpu->lnode of cgroup C
which was added by the IRQ/NMI updater.

Now imagine CPU B calling init_llist_node() on cgroup C's
rstatc_pcpu->lnode of CPU A and on CPU A, the process context updater
calling this_cpu_cmpxchg(rstatc_pcpu->lnode) concurrently.

The CMPXCNG without LOCK on CPU A is not safe and thus we need LOCK
prefix.

In Meta's fleet running the kernel with the commit 36df6e3dbd7e, we are
observing on some machines the memcg stats are getting skewed by more
than the actual memory on the system. On close inspection, we noticed
that lockless node for a workload for specific CPU was in the bad state
and thus all the updates on that CPU for that cgroup was being lost.

To confirm if this skew was indeed due to this CMPXCHG without LOCK in
css_rstat_updated(), we created a repro (using AI) at [1] which shows
that CMPXCHG without LOCK creates almost the same lnode corruption as
seem in Meta's fleet and with LOCK CMPXCHG the issue does not
reproduces.

Link: http://lore.kernel.org/efiagdwmzfwpdzps74fvcwq3n4cs36q33ij7eebcpssactv3zu@se4hqiwxcfxq [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: stable@vger.kernel.org # v6.17+
Fixes: 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe")
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/rstat.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -71,7 +71,6 @@ __bpf_kfunc void css_rstat_updated(struc
 {
 	struct llist_head *lhead;
 	struct css_rstat_cpu *rstatc;
-	struct css_rstat_cpu __percpu *rstatc_pcpu;
 	struct llist_node *self;
 
 	/*
@@ -104,18 +103,22 @@ __bpf_kfunc void css_rstat_updated(struc
 	/*
 	 * This function can be renentered by irqs and nmis for the same cgroup
 	 * and may try to insert the same per-cpu lnode into the llist. Note
-	 * that llist_add() does not protect against such scenarios.
+	 * that llist_add() does not protect against such scenarios. In addition
+	 * this same per-cpu lnode can be modified through init_llist_node()
+	 * from css_rstat_flush() running on a different CPU.
 	 *
 	 * To protect against such stacked contexts of irqs/nmis, we use the
 	 * fact that lnode points to itself when not on a list and then use
-	 * this_cpu_cmpxchg() to atomically set to NULL to select the winner
+	 * try_cmpxchg() to atomically set to NULL to select the winner
 	 * which will call llist_add(). The losers can assume the insertion is
 	 * successful and the winner will eventually add the per-cpu lnode to
 	 * the llist.
+	 *
+	 * Please note that we can not use this_cpu_cmpxchg() here as on some
+	 * archs it is not safe against modifications from multiple CPUs.
 	 */
 	self = &rstatc->lnode;
-	rstatc_pcpu = css->rstat_cpu;
-	if (this_cpu_cmpxchg(rstatc_pcpu->lnode.next, self, NULL) != self)
+	if (!try_cmpxchg(&rstatc->lnode.next, &self, NULL))
 		return;
 
 	lhead = ss_lhead_cpu(css->ss, cpu);


