Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730AA44683A;
	Mon, 17 Aug 2026 13:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974970; cv=none; b=qm2nA2Zy4VfM4GGxSzPUK1y7xUIPf7I1ENcmPwDINkUi040jkYRHmQCfm4ckIufUwTKmmxx6BeMnpDCIuOL73kzslyUuFLeLSZZULBThZlpbJx8CJIIOqlH/R1gOzR5HrmddrLk5/X1HInxHOQqr+4kV0XdxtjaDAaiUD79qJCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974970; c=relaxed/simple;
	bh=XC2kpMUgUs/bqqyNnJgMX8xPKiDS3AadnMZfqD8y8+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK1vOctB6NA6ft1OGobjsx4sDnON9fIApRlF3I3w7o+OvHDIGLOHEyWAAVJzrRedqaU8FckPhuiycqJEob4B2AqFYpXXz6pUAcMLjZs6AJOf1aPrU9IZ83UoQPkRnbBG6b3FszNCkhuHYacjFMGK5K3k3gZ8HDK49b0QVh4gGi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2X2M5mI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2X2M5mI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38C91F00A3D;
	Mon, 17 Aug 2026 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974964;
	bh=GXqFyDgK2p8tckM6CjTJZ5b9Z42JyDE/tv0FtykZRdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2X2M5mI3DJhIYH4cCPAh3cU+FBCOQzg+g4C+YQBuGag7gSwb85K7/HtnO1il+6ua
	 DggzVbV8k5KxDCxDSeXP6q0+bkG3XQA4jHgU0FVrR/LiG4/WS3a9b7J3hpQT+LLoBq
	 HzaeV+UgOm/tlpN8vuQvwrXfvJH5K8ndBBOjZK28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xue <feng.xue@outlook.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/250] net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers
Date: Mon, 17 Aug 2026 15:30:37 +0200
Message-ID: <20260817132539.549388703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit a347304b2ca1a5377d5bd2d8a72e4b4f12afe648 ]

Another challenge with unlocked filters.
There is a short window in tc_new_tfilter where a tcf_proto can be found
and briefly referenced by a totally unrelated, unlocked classifier's request
and cause a race.

Feng created a poc which created this race with two threads, one creating a
u32 filter and other a flower filter in the same chain/prio:

1. Both threads enter tc_new_tfilter, both find the chain empty, both
   drop filter_chain_lock
2. u32 finishes tcf_proto_create("u32") first, calls
   tcf_chain_tp_insert_unique() -> inserts u32_tp into the chain
3. flower finishes tcf_proto_create("flower") later, calls
   tcf_chain_tp_insert_unique() -> tcf_chain_tp_find() now sees u32_tp
   already there, takes a reference on it, destroys flower's own tp_new
   and returns u32_tp to the caller.

Flower then hits the kind mismatch check (because it requested for kind
"flower" but tp->ops->kind is "u32") and goes through the errout path
which calls tcf_proto_put() on u32_tp. If the u32 thread has already
gone through its own errout (its change() call failed on the PoC's empty
options) and dropped its create and insert refs, flower's put is the
last one and drops u32_tp's refcnt to zero.

At this point tp->ops->destroy() runs in a context that never took
rtnl_lock. When that happens, it might cause a UAF like the following
(illustrated by the PoC):

[  +0.000710] BUG: KASAN: slab-use-after-free in u32_init (net/sched/cls_u32.c:393)
[  +0.000281] Read of size 8 at addr ffff888120022f00 by task poc_feng_xue/524

  Call Trace:
   u32_init (net/sched/cls_u32.c:393)
   tc_new_tfilter (net/sched/cls_api.c:2378)

  Allocated by task 526:
   u32_init (net/sched/cls_u32.c:378)
   tc_new_tfilter (net/sched/cls_api.c:2378)

  Freed by task 522:
   kfree
   u32_destroy (net/sched/cls_u32.c:662)
   tcf_proto_destroy (net/sched/cls_api.c:446)
   tcf_proto_put (net/sched/cls_api.c:459)
   tc_new_tfilter (net/sched/cls_api.c:2459)

Fix this by having tcf_proto_destroy() take rtnl_lock around
tp->ops->destroy() for locked classifiers whenever rtnl is not held.

To explain why I used a temp variable "not_lockless" I'd like to point to a
semi-related note on rtnl_held vs TCF_PROTO_OPS_DOIT_UNLOCKED (adding here
for future cleanup if deemed necessary):
The rtnl_held parameter and the TCF_PROTO_OPS_DOIT_UNLOCKED flag are
redundant sources of truth for whether rtnl_lock is held. Among the nine
classifier destroy(..rtnl_held..) callbacks, only flower consults the
rtnl_held parameter which it propagates to tc_setup_cb_destroy()
and tc_setup_cb_call(). The other eight (u32, flow, bpf, cgroup, route, basic,
fw, mall) ignore it entirely;-> those that call tc_setup_cb_destroy()
(u32, bpf, mall) hardcode true always instead of forwarding the parameter.

A future cleanup should remove the rtnl_held parameter from the destroy callback
signature entirely and have callers rely solely on their knowledge whether
they are running in an unlocked context.

Fixes: 12db03b65c2b ("net: sched: extend proto ops to support unlocked classifiers")
Reported-by: Feng Xue <feng.xue@outlook.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260801125632.360365-1-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3b0a438977cd5..21a70cc9940ce 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -443,7 +443,22 @@ static void tcf_chain_put(struct tcf_chain *chain);
 static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
 			      bool sig_destroy, struct netlink_ext_ack *extack)
 {
-	tp->ops->destroy(tp, rtnl_held, extack);
+	/* A locked classifier's destroy callback (e.g. u32_destroy) uses
+	 * rtnl_dereference() and mutates shared structures (e.g. the
+	 * tc_u_common hash list) that are only safe under rtnl_lock. When an
+	 * unlocked classifier's request (e.g. flower on ingress) loses the
+	 * tcf_chain_tp_insert_unique() race and ends up dropping the last
+	 * reference on a locked classifier's proto, destroy() would run
+	 * without rtnl held. Take it here in that case.
+	 */
+	bool not_lockless = !rtnl_held &&
+		!(tp->ops->flags & TCF_PROTO_OPS_DOIT_UNLOCKED);
+
+	if (not_lockless)
+		rtnl_lock();
+	tp->ops->destroy(tp, rtnl_held || not_lockless, extack);
+	if (not_lockless)
+		rtnl_unlock();
 	tcf_proto_count_usesw(tp, false);
 	if (sig_destroy)
 		tcf_proto_signal_destroyed(tp->chain, tp);
-- 
2.53.0



