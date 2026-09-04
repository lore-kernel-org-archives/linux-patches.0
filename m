Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18B6418A44;
	Fri,  4 Sep 2026 05:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499438; cv=none; b=dOP3vFqtSuYCvBdF10hi/lhtp8eDe/Y+0UtFTaIEeQ070LIcNTIEC1IsHDz5FCcablWEAbV6DiyS6lsvhfNpGz8LtTryy5TNeJLjeIIlr5S8kkUkfEqnqdbQnROKSkatj3f5RHFIMUN+ujAPytqdQPFgf2mWyRMpWqYbN/nncng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499438; c=relaxed/simple;
	bh=wCwbfy6/IbMrrQtxewTST6+rUQCUK2Ooyu9YS77OUq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgMmUHAxwNZsqT1FCCUmu9jUg83ULbXxg8gTPLkAuic46aXerw0XeSo3GB/z8++AIiB/l2Pt2Eff5RU8dfpoiXaBVEHGhs43oBikZrAhNHxmBV5Hs0jVXC0243hdzIEsLGQXdhAhdtiJNNvV3GBtJMQRkYTcnZ0TcTeATN8KMJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5T5vTlP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5T5vTlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82D11F00ACA;
	Fri,  4 Sep 2026 05:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499437;
	bh=LHmmgJMa4WnPyRpj/qetCZwXMCdSmLCoSqaV6XFkKbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5T5vTlPFuJsg26QYlKOO9KtfIe2X5+LIPRhPQbiOn2OR+J+pNHt3j/k7OJ8qkIrL
	 ZDOVM+slj+9Eu8fcw+/imMm1L4PmYcvuL2fxMuCXled52GRKQlDgUJR7MJlUWU2QRf
	 OjB/uiMQsqtws7JlqRhQRuSOiqSwtgRfVLWNzDcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.2 418/713] sched_ext: Keep kick_sync waiting on the rqs own CPU
Date: Fri,  4 Sep 2026 06:56:26 +0200
Message-ID: <20260904045813.201622079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e0253dd04beb03e79477c5ef4768b11135687206 upstream.

kick_sync_wait_bal_cb() assumes it runs on the rq's CPU from the
__schedule() tail: the snapshots it compares against live in that CPU's
percpu area and the busy-wait runs with the rq lock dropped and IRQs
enabled.

However, dispatch can now drop the rq lock while the callback sits queued,
and rq lock takers in that window (the sched class change paths, the scx
task iterator) flush pending balance callbacks on release, running the
callback on a foreign CPU. Such a run compares against unrelated snapshots
and can deadlock when the executing CPU is itself a wait target.

Bail on a foreign CPU and leave the wait state alone. The wait only observes
progress that the resched kicks already guarantee and the rq's next wait
picks up the stale cpus_to_sync bits.

Fixes: 4c95380701f5 ("sched/ext: Fold balance_scx() into pick_task_scx()")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3163,12 +3163,27 @@ switch_class:
 
 static void kick_sync_wait_bal_cb(struct rq *rq)
 {
-	struct scx_kick_syncs __rcu *ks = __this_cpu_read(scx_kick_syncs);
-	unsigned long *ksyncs = rcu_dereference_sched(ks)->syncs;
+	struct scx_kick_syncs __rcu *ks;
+	unsigned long *ksyncs;
 	bool waited;
 	s32 cpu;
 
 	/*
+	 * This callback is queued and normally flushed within @rq's own
+	 * scheduling pass. However, dispatch can drop the rq lock while it sits
+	 * queued, and lock takers in that window (the sched class change paths,
+	 * the scx task iterator) flush pending balance callbacks on release,
+	 * running this one on a foreign CPU whose snapshots are unrelated. The
+	 * kicked CPUs are already on their way to advance the kick_syncs being
+	 * waited on. Don't get in the way.
+	 */
+	if (unlikely(cpu_of(rq) != smp_processor_id()))
+		return;
+
+	ks = __this_cpu_read(scx_kick_syncs);
+	ksyncs = rcu_dereference_sched(ks)->syncs;
+
+	/*
 	 * Drop rq lock and enable IRQs while waiting. IRQs must be enabled
 	 * — a target CPU may be waiting for us to process an IPI (e.g. TLB
 	 * flush) while we wait for its kick_sync to advance.


