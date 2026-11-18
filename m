Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021930;
	b=xYBO+AhILNITiI7QfCKvQdN1E8RpZhC+aYukSV15XeylZ515UBykJeF4Ya8fbgopZ6MC
	 TYmt6mjseG3jW2zTh2xIfWo2jwPCeER5KO6+XCjGJmCGXXNRW694a0xfaVoKYGailnQgY
	 fPOyAn8LHUiM+XgJF9/R8hLWsRZCwsiWj85XSqwKIzAZ2nZZCfi/0Q7Pofk4OwTvkWt3W
	 nGXRT8HB0o0SG1FKQM9LZbZ7TakxB/a8qLnornjWrt96m0rFd1PWoOMsC4w+a9uwHxjl6
	 s2d1Kf1usEixBMiTyeO3DQQ29TDI2NUVrbn4V7fOCwUlguPPK1sgZOdprUcGajOso0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dSpWa+RkIUfwbqyxTa01ITElHaTz/7QQ3ikUljjdJvM=;
	b=2yjy/wnMr3jVtXZYNZAweIzmaH1vN3mt5ZOA2o33MPhKaI4z4+XSp0SVJr5el56Zaq+m
	 CyIVhe+HDQuNIrtK2hvb2d5kJghyb6xZSsJYB0xDuJAiTjH45Ws8xH3iUFFiIRgILtwLg
	 kHhjPGxTdpPf1/OnNjGwgFcltMWYxrS+mDPUpRz1Ay1K3wGWyHs+dETcWczd/uKgizGyT
	 GNTMdaHcXkD0Nm9mc+DHzqNScKOwbXif0VhXnkFKwj5YPLtr97QNLWs55g+Bl+GXcYksQ
	 qUOnp2h7gHQTagw/6NVfBTmy4NHmkUA34HUDeKK7Ysx8LE/dg8BICo0Wmrye2M5h0Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtlUdXWd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FBE606A320;
	Wed, 18 Nov 2026 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FtlUdXWd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5611F000C4;
	Wed, 18 Nov 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021930;
	bh=dSpWa+RkIUfwbqyxTa01ITElHaTz/7QQ3ikUljjdJvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtlUdXWdYFXL5CZcwhRqFDJSagxWerNKqxwpDDxCzQ3KkkWdPFSe0zFaGvo9uwIbk
	 zpm/RsYciDDHlTtnDSOMAxw88hXcRZE7hkTmk0jbI6CB8zyZH7XA1YLNgiPT1OFcBH
	 j0Q7dHNJOom0RPBkGh/QFnPfZ9znCuqCHXzanqBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2481/2651] sched_ext: Fix bypassed tasks looping on a host without SCX_CAP_ENQ
Date: Wed, 18 Nov 2026 16:02:01 +0100
Message-ID: <20261118150414.239982764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit a676ada0d6544928c0ceb032fb991a9abe0977db ]

Bypass exists so that runnable tasks make progress without trusting the BPF
scheduler. A host with SCX_CAP_ENQ_IMMED (BASE) but not SCX_CAP_ENQ on a cpu
cannot run a single bypassed task there. The task loops instead:

 1. a bypassed task lands on the host's bypass DSQ for the cpu
 2. the cpu's dispatch descends into the host, which holds BASE there
 3. the host consumes the task into the local DSQ as a plain insert
 4. the insert needs ENQ and the host lacks it, so the task is rejected
 5. the reject drain reenqueues the task and it is back at step 1

A bypass consume puts a task on the cpu being dispatched for, to run right
away. That is the IMMED contract, and BASE is the cap it needs. Consume with
SCX_ENQ_IMMED. BASE is then the one cap a bypassed task ever needs. Dispatch
descends into a host only on a cpu where the host holds BASE, so a consume
never lacks it.

A consumed task is first on the local DSQ when dispatch enters the host with
the DSQ empty. That is always the case for the root and normally for a
parent dispatching into a child.

A consumed task that cannot run right away is reenqueued like any IMMED task
and goes back to the bypass DSQ. Waiting on the local DSQ would need ENQ.
The task cannot run right away when a higher class or a HEAD insert took the
cpu meanwhile, or when the parent queued its own task before dispatching
into the host.

Each such task waits on the bypass DSQ for the next dispatch. The reenqueue
is not counted against the reenqueue limit, as the task's scheduler is
bypassing.

v2: The description says that the reenqueue of a consumed task is not
counted against the reenqueue limit (sashiko).

Fixes: 701b7bcad868 ("sched_ext: Add the SCX_CAP_ENQ cap")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/inlines.h | 15 ++++++++++++---
 kernel/sched/ext/sub.c     |  6 ++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/ext/inlines.h b/kernel/sched/ext/inlines.h
index 8de9d8fb4b25f..1e39d12678c4d 100644
--- a/kernel/sched/ext/inlines.h
+++ b/kernel/sched/ext/inlines.h
@@ -39,10 +39,18 @@ scx_dispatch_sched(struct scx_sched *sch, struct rq *rq,
 	if (scx_consume_global_dsq(sch, rq))
 		return SCX_DSP_LOCAL;
 
+	/*
+	 * A bypass consume puts a task on the cpu being dispatched for, to run
+	 * right away. That is an IMMED insert and needs only
+	 * %SCX_CAP_ENQ_IMMED, the base cap. Dispatch descends into @sch only on
+	 * a cpu where @sch holds the base cap, so @sch holds it here. The same
+	 * holds for the consume at the end of this function.
+	 */
 	if (scx_bypass_dsp_enabled(sch)) {
 		/* if @sch is bypassing, only the bypass DSQs are active */
 		if (scx_bypassing(sch, cpu)) {
-			if (scx_consume_dispatch_q(sch, rq, scx_bypass_dsq(sch, cpu), 0))
+			if (scx_consume_dispatch_q(sch, rq, scx_bypass_dsq(sch, cpu),
+						   SCX_ENQ_IMMED))
 				return SCX_DSP_LOCAL;
 			return SCX_DSP_NONE;
 		}
@@ -63,7 +71,8 @@ scx_dispatch_sched(struct scx_sched *sch, struct rq *rq,
 		struct scx_sched_pcpu *pcpu = per_cpu_ptr(sch->pcpu, cpu);
 
 		if (!(pcpu->bypass_host_seq++ % SCX_BYPASS_HOST_NTH) &&
-		    scx_consume_dispatch_q(sch, rq, scx_bypass_dsq(sch, cpu), 0)) {
+		    scx_consume_dispatch_q(sch, rq, scx_bypass_dsq(sch, cpu),
+					   SCX_ENQ_IMMED)) {
 			__scx_add_event(sch, SCX_EV_SUB_BYPASS_DISPATCH, 1);
 			return SCX_DSP_LOCAL;
 		}
@@ -135,7 +144,7 @@ scx_dispatch_sched(struct scx_sched *sch, struct rq *rq,
 	 * scheduler's ops.dispatch() doesn't yield any tasks.
 	 */
 	if (scx_bypass_dsp_enabled(sch) &&
-	    scx_consume_dispatch_q(sch, rq, scx_bypass_dsq(sch, cpu), 0)) {
+	    scx_consume_dispatch_q(sch, rq, scx_bypass_dsq(sch, cpu), SCX_ENQ_IMMED)) {
 		__scx_add_event(sch, SCX_EV_SUB_BYPASS_DISPATCH, 1);
 		return SCX_DSP_LOCAL;
 	}
diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index eb345df340f59..f1707d93bc004 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -2257,6 +2257,12 @@ __bpf_kfunc_start_defs();
  * child schedulers. The child scheduler runs its dispatch operation to
  * move tasks from dispatch queues to the local runqueue.
  *
+ * Dispatch into a child while the local DSQ is empty, when the cpu needs a
+ * task. A child holding only %SCX_CAP_ENQ_IMMED can insert only IMMED tasks,
+ * and the consume of its bypassing descendants' bypass DSQs is one such insert.
+ * With a task already queued on the local DSQ, such an insert fails and the
+ * task is reenqueued.
+ *
  * Returns: true on success, false if cgroup_id is invalid, not a direct
  * child, or caller lacks dispatch permission.
  */
-- 
2.53.0



