Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07102396566;
	Mon, 23 Mar 2026 16:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282448; cv=none; b=fxM9c94uBqa/gOmONY8pVkHvie0PTLdArjCGCQFosEl2u8+a+idmuyS+Bi7YALQD8rGb8+ffa6c+/SjMVMO+ZJbpYz28AwcMaokvhnv4u01FkAYA7SLuY66Ptprk6FdSeNueowNX8ob8FE5wDu8K2bWT1EWtB6yeLoLlAtpL/lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282448; c=relaxed/simple;
	bh=D0/9f/0EXNcUzHSaFOzKMzIwMbQBHSf3XmLn40M7hOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbHIcI3l2Lri8AJWg1oBq+8VoRcqMs7EK9oekpRLLRYmWm6LjqEcmB2evFh1x8Bjdz5sbaAlVK8JzAxJPp/zDl1lkmZxCmiso1TLpWJcIstgTcDPot+i0acET5YeNs8zYExsyK4Vue9oFpHptpJe5BbaJo9u+vaCDUDwITSo10Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWrV/orw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWrV/orw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661FEC4CEF7;
	Mon, 23 Mar 2026 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282447;
	bh=D0/9f/0EXNcUzHSaFOzKMzIwMbQBHSf3XmLn40M7hOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWrV/orwUKpdqstGtEXY9dYW7iy65uSq8+CjUHfIS+saFB6uGgOJi2+vyntpCsPFi
	 xG1T1r0Rw854ifUVPfsfR3jIKbO6U9u4gsfko9z6m+5MoIFMHGbtBtti59MCzAoy0i
	 TkYlULYTlVSode1dVDsU24/Xp5eLr0/L99btiXXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Badger <ebadger@purestorage.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/481] xprtrdma: Decrement re_receiving on the early exit paths
Date: Mon, 23 Mar 2026 14:42:22 +0100
Message-ID: <20260323134529.134501943@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Badger <ebadger@purestorage.com>

[ Upstream commit 7b6275c80a0c81c5f8943272292dfe67730ce849 ]

In the event that rpcrdma_post_recvs() fails to create a work request
(due to memory allocation failure, say) or otherwise exits early, we
should decrement ep->re_receiving before returning. Otherwise we will
hang in rpcrdma_xprt_drain() as re_receiving will never reach zero and
the completion will never be triggered.

On a system with high memory pressure, this can appear as the following
hung task:

    INFO: task kworker/u385:17:8393 blocked for more than 122 seconds.
          Tainted: G S          E       6.19.0 #3
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    task:kworker/u385:17 state:D stack:0     pid:8393  tgid:8393  ppid:2      task_flags:0x4248060 flags:0x00080000
    Workqueue: xprtiod xprt_autoclose [sunrpc]
    Call Trace:
     <TASK>
     __schedule+0x48b/0x18b0
     ? ib_post_send_mad+0x247/0xae0 [ib_core]
     schedule+0x27/0xf0
     schedule_timeout+0x104/0x110
     __wait_for_common+0x98/0x180
     ? __pfx_schedule_timeout+0x10/0x10
     wait_for_completion+0x24/0x40
     rpcrdma_xprt_disconnect+0x444/0x460 [rpcrdma]
     xprt_rdma_close+0x12/0x40 [rpcrdma]
     xprt_autoclose+0x5f/0x120 [sunrpc]
     process_one_work+0x191/0x3e0
     worker_thread+0x2e3/0x420
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x10d/0x230
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x273/0x2b0
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30

Fixes: 15788d1d1077 ("xprtrdma: Do not refresh Receive Queue while it is draining")
Signed-off-by: Eric Badger <ebadger@purestorage.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index cb909329a5039..4132a505d742a 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1362,7 +1362,7 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 		needed += RPCRDMA_MAX_RECV_BATCH;
 
 	if (atomic_inc_return(&ep->re_receiving) > 1)
-		goto out;
+		goto out_dec;
 
 	/* fast path: all needed reps can be found on the free list */
 	wr = NULL;
@@ -1389,7 +1389,7 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 		++count;
 	}
 	if (!wr)
-		goto out;
+		goto out_dec;
 
 	rc = ib_post_recv(ep->re_id->qp, wr,
 			  (const struct ib_recv_wr **)&bad_wr);
@@ -1404,9 +1404,10 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 			--count;
 		}
 	}
+
+out_dec:
 	if (atomic_dec_return(&ep->re_receiving) > 0)
 		complete(&ep->re_done);
-
 out:
 	trace_xprtrdma_post_recvs(r_xprt, count);
 	ep->re_receive_count += count;
-- 
2.51.0



