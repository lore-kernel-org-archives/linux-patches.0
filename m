Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207162;
	b=rXIRA1/0+hm9LYFD27G2A9lGU3XgnmT66z+mjVWnk72S+oztpa/M1BwHXwW+gzRZ0c+1
	 z69Ycyv90D5ZaIxMsnwzwJXe7+8qAux4o8hErpnXFdZFdmp9q7Hu/fQo5s7Yu6nSHwVCp
	 EpuvrED6r0p6wPGiDfB9TzRyhUUmd+nJyduRoev4qw8omJEpArNQr6IGd2SREw5MYSX/Q
	 XM/7CgB1COV6ptxXNC2+UkAdqmxoz6lPYzMAsfkX28X+NawBhiOTHapjft4wqo5NaPpv4
	 Pc/9X20+AV1gzkFU7mwZZK2wSta2bR975xZd71g6lcD/q2o8ELwOvbE7ZIWWeHq+O+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5DSzloH2Yqil2PllG4BcS7fWixJtF9LGJWq9RePWD8U=;
	b=Q8e/aUGNdQZnVSczpInzJ/9SgGujFjIbx/9zqDSpNGO+jtZsFXtfAkcPxx9kOjabiWYH
	 ztlpodQ2ncwfBYPmUuzo+AuNfk2MCFtiLnoL1tJlcCmNHNM8dcKzW0sHrPB9MeMEzpzZn
	 9zl7iDcgzhk7udMvP9vu0PbjKYQnmnGIr36doSYeHlBRc0QEVybeOGe9UpHOqVQMeiIPz
	 UQvGf9wZ4NQTWOmzRY6HavOuwVPqKaxRH/DbN9bA9/3ala0p2SZ8wZhxgndGhEIkKqu4z
	 ewACSYBd4xjsw5dHWtcAgucKtkYXLlwp/es2uttywepRs2LkL9aizzp0kXbIgtddAMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGXO0eEG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C74606A31F;
	Wed, 28 Oct 2026 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGXO0eEG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443471F01828;
	Wed, 28 Oct 2026 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207161;
	bh=5DSzloH2Yqil2PllG4BcS7fWixJtF9LGJWq9RePWD8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGXO0eEGxzpHHtaoIbb3d3F5AJJqX9qrwb5iyh4sVWI2tl7Tk4PZxcyvHO7GQJYui
	 3tuBlePtf4PeqghOfpl9dSoUDzoAVMy5OfGs0CA/eRq6w0w7JL4MZJGzaLFLPBbXpp
	 PciHB8HJEjvxW0Kq9sZq/SlnHrw8/5uyIimBj17g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Kuba Piecuch <jpiecuch@google.com>,
	Tejun Heo <tj@kernel.org>,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 01/88] sched_ext: Wait for SCX_OPSS_DISPATCHING before moving tasks off DSQs
Date: Wed, 28 Oct 2026 17:59:09 +0100
Message-ID: <20261028165942.145347695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuba Piecuch <jpiecuch@google.com>

[ Upstream commit 2935062be77113c1c4565ca9d0c72180449aafee ]

A task can be found on a non-local DSQ while the CPU which dispatched it
is still running ops.dequeue() and hasn't cleared SCX_OPSS_DISPATCHING.
The DSQ consume and move paths don't wait for the dispatch to finish and
can operate on the task concurrently with the dispatcher.

Call scx_wait_dispatching() in scx_move_local_task_to_local_dsq(),
unlink_dsq_and_switch_rq_lock() and move_task_between_dsqs() before they
operate on the task. In scx_move_local_task_to_local_dsq(), wait before
scx_resolve_local_dsq() as it may update p->scx.flags.

Fixes: ebf1ccff79c4 ("sched_ext: Fix ops.dequeue() semantics")
Fixes: cb86607ada73 ("sched_ext: Don't run ops.dequeue() with a DSQ lock held")
Cc: stable@vger.kernel.org # v7.1+
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Assisted-by: Claude:claude-opus-5.5
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ Inlined scx_wait_dispatching(), which 7.2.y doesn't have, into
  move_local_task_to_local_dsq(), unlink_dsq_and_lock_src_rq() and
  move_task_between_dsqs(), as was done for the reenqueue paths in
  7.2.y. 7.2.y has no scx_resolve_local_dsq(), so
  move_local_task_to_local_dsq() waits before linking the task. ]
Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 3ee16f7f22cde..c117cf172dfca 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -2292,6 +2292,8 @@ static void move_local_task_to_local_dsq(struct scx_sched *sch,
 	lockdep_assert_rq_held(dst_rq);
 
 	WARN_ON_ONCE(p->scx.holding_cpu >= 0);
+	if (unlikely(atomic_long_read_acquire(&p->scx.ops_state) == SCX_OPSS_DISPATCHING))
+		wait_ops_state(p, SCX_OPSS_DISPATCHING);
 
 	if (enq_flags & (SCX_ENQ_HEAD | SCX_ENQ_PREEMPT))
 		list_add(&p->scx.dsq_list.node, &dst_dsq->list);
@@ -2462,8 +2464,13 @@ static bool unlink_dsq_and_lock_src_rq(struct task_struct *p,
 	raw_spin_rq_lock(src_rq);
 
 	/* task_rq couldn't have changed if we're still the holding cpu */
-	return likely(p->scx.holding_cpu == cpu) &&
-		!WARN_ON_ONCE(src_rq != task_rq(p));
+	if (likely(p->scx.holding_cpu == cpu) && !WARN_ON_ONCE(src_rq != task_rq(p))) {
+		if (unlikely(atomic_long_read_acquire(&p->scx.ops_state) == SCX_OPSS_DISPATCHING))
+			wait_ops_state(p, SCX_OPSS_DISPATCHING);
+		return true;
+	}
+
+	return false;
 }
 
 static bool consume_remote_task(struct rq *this_rq,
@@ -2511,6 +2518,9 @@ static struct rq *move_task_between_dsqs(struct scx_sched *sch,
 	lockdep_assert_held(&src_dsq->lock);
 	lockdep_assert_rq_held(src_rq);
 
+	if (unlikely(atomic_long_read_acquire(&p->scx.ops_state) == SCX_OPSS_DISPATCHING))
+		wait_ops_state(p, SCX_OPSS_DISPATCHING);
+
 	if (dst_dsq->id == SCX_DSQ_LOCAL) {
 		dst_rq = container_of(dst_dsq, struct rq, scx.local_dsq);
 		if (src_rq != dst_rq &&
-- 
2.53.0



