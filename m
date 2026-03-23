Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BF5194AD7;
	Mon, 23 Mar 2026 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774271088; cv=none; b=uE6oxXzrK70m+vsuXmLGZQNFJBvfMQKG2Ig3D66tAK9bvBm9iH1Z53cUWkX7ZZhwM+PZgS6p/JXnNK4NdGuAZ0p3j00VtO2+Du46xjHCxGfdYNKPdHB78RbyzjknDM7iQ7Der1W8hgZwVEvnCJGCL/2hP43bFwg/1hMv25OQ5cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774271088; c=relaxed/simple;
	bh=beMDJA3aNT3RHRUCvb+d9gBZnwCyhVvZxT6aFHZNjDs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=GgTaWPoZ/PZVK1C9tmTh9WkpkYEMACpUcrAoOJnV0PWjDGwgujKcSa6C0SJWbtDWRi4BJ/gotwdTKjUKWZb2DFcHL2tTmiVo3eAdjlnuY3b3lhWvjTxlrVjyvqOtlLgtrM9enag+ryrTU2AeO8JTC7HMnsE6v20+Ji9HYEvf0qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvHvCRAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvHvCRAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E134C4CEF7;
	Mon, 23 Mar 2026 13:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774271088;
	bh=beMDJA3aNT3RHRUCvb+d9gBZnwCyhVvZxT6aFHZNjDs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=AvHvCRAsrhtPBY0rbZ79YCG+Q4C1kQe6+by7zg1m30/10sqa4THFx+tk7a2Apb/Th
	 M1M4FcFcLwWu/mVMtiyvWlJlNfvgE3xaUxFm2189bkipOhR0ig1GOIiTQiduuPCo9U
	 tkOXOlpUPxyjTzelOqe/tp5CBCJWRKaq975UCs2A=
Subject: Patch "rcu/nocb: Fix possible invalid rdp's->nocb_cb_kthread pointer access" has been added to the 6.1-stable tree
To: frederic@kernel.org,gregkh@linuxfoundation.org,jiangshanlai@gmail.com,jianqkang@sina.cn,joel@joelfernandes.org,josh@joshtriplett.org,mathieu.desnoyers@efficios.com,neeraj.upadhyay@kernel.org,patches@lists.linux.dev,paulmck@kernel.org,qiang.zhang1211@gmail.com,quic_neeraju@quicinc.com,rostedt@goodmis.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Mar 2026 14:03:51 +0100
In-Reply-To: <20260304024934.2364383-1-jianqkang@sina.cn>
Message-ID: <2026032351-untidy-cyclic-2027@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    rcu/nocb: Fix possible invalid rdp's->nocb_cb_kthread pointer access

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rcu-nocb-fix-possible-invalid-rdp-s-nocb_cb_kthread-pointer-access.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From jianqkang@sina.cn Wed Mar  4 03:49:40 2026
From: Jianqiang kang <jianqkang@sina.cn>
Date: Wed,  4 Mar 2026 10:49:34 +0800
Subject: rcu/nocb: Fix possible invalid rdp's->nocb_cb_kthread pointer access
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, qiang.zhang1211@gmail.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, paulmck@kernel.org, frederic@kernel.org, quic_neeraju@quicinc.com, josh@joshtriplett.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, joel@joelfernandes.org, rcu@vger.kernel.org, neeraj.upadhyay@kernel.org
Message-ID: <20260304024934.2364383-1-jianqkang@sina.cn>

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 1bba3900ca18bdae28d1b9fa10f16a8f8cb2ada1 ]

In the preparation stage of CPU online, if the corresponding
the rdp's->nocb_cb_kthread does not exist, will be created,
there is a situation where the rdp's rcuop kthreads creation fails,
and then de-offload this CPU's rdp, does not assign this CPU's
rdp->nocb_cb_kthread pointer, but this rdp's->nocb_gp_rdp and
rdp's->rdp_gp->nocb_gp_kthread is still valid.

This will cause the subsequent re-offload operation of this offline
CPU, which will pass the conditional check and the kthread_unpark()
will access invalid rdp's->nocb_cb_kthread pointer.

This commit therefore use rdp's->nocb_gp_kthread instead of
rdp_gp's->nocb_gp_kthread for safety check.

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree_nocb.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1112,7 +1112,6 @@ static long rcu_nocb_rdp_offload(void *a
 	struct rcu_segcblist *cblist = &rdp->cblist;
 	unsigned long flags;
 	int wake_gp;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
 	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
 	/*
@@ -1122,7 +1121,7 @@ static long rcu_nocb_rdp_offload(void *a
 	if (!rdp->nocb_gp_rdp)
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(!rdp_gp->nocb_gp_kthread))
+	if (WARN_ON_ONCE(!rdp->nocb_gp_kthread))
 		return -EINVAL;
 
 	pr_info("Offloading %d\n", rdp->cpu);
@@ -1151,7 +1150,7 @@ static long rcu_nocb_rdp_offload(void *a
 	 */
 	wake_gp = rdp_offload_toggle(rdp, true, flags);
 	if (wake_gp)
-		wake_up_process(rdp_gp->nocb_gp_kthread);
+		wake_up_process(rdp->nocb_gp_kthread);
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB) &&
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_GP));


Patches currently in stable-queue which might be from jianqkang@sina.cn are

queue-6.1/riscv-stacktrace-disable-kasan-checks-for-non-current-tasks.patch
queue-6.1/rcu-nocb-fix-possible-invalid-rdp-s-nocb_cb_kthread-pointer-access.patch
queue-6.1/io_uring-io-wq-check-io_wq_bit_exit-inside-work-run-loop.patch
