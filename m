Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6802FFFBE;
	Mon, 13 Apr 2026 16:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097347; cv=none; b=TIW8RxbdxwU/AYhC0aqrMNCdrvxcl7jVYFY7+JeCPQVp+3YOVTyCOvKWc0d/0dh/2Yx5CUxVS6KSzQYQxcrv/h7S4r/dRqsCxP18XmOQjh5E0XZLc2MzV2dRqn7aMENt6zEIwhC2cBA11/iKJdJFdw+JVNATGLVNqDCHLqMRKaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097347; c=relaxed/simple;
	bh=uZQ/uhP+eypuZOb8soygmHY9adYG+ION3R7e2OkwtnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2VOsA4OytvHfFLomNooR7C2VH8OhUGMMe2HShq4+KoDyJ1hV03i2FQFOWkZIQuvmA+sv2/lCn6TpmpirB5MajwmkoV9sQG6hoOlmNXry4ocAay3ynZ5UUS66bX6HnGEKyXzu9kDcs6XJMXHPv22ksFQsfA3IhBz3Wt40HvSLLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuCGVMIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuCGVMIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222D6C2BCAF;
	Mon, 13 Apr 2026 16:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097347;
	bh=uZQ/uhP+eypuZOb8soygmHY9adYG+ION3R7e2OkwtnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuCGVMISNW89j7rtvPy13Ea77ENofXFsHE9k5URTMfUfj2KC4HQr8JE2IsBivoMoI
	 3qb3VfgGcOINIS0UbSZwyx0UM6LLnkKN2PScX8Mw2Utc0LtA5tea2psxIInQFur7Al
	 Iqb1zEQ2Rhe/BSld68QJwVjBdbQiVOdtBoZ5nFHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Badger <ebadger@purestorage.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/570] xprtrdma: Decrement re_receiving on the early exit paths
Date: Mon, 13 Apr 2026 17:53:53 +0200
Message-ID: <20260413155834.265302685@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b61ade10254d4..f1a6b98b8aa98 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1390,7 +1390,7 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 		needed += RPCRDMA_MAX_RECV_BATCH;
 
 	if (atomic_inc_return(&ep->re_receiving) > 1)
-		goto out;
+		goto out_dec;
 
 	/* fast path: all needed reps can be found on the free list */
 	wr = NULL;
@@ -1417,7 +1417,7 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
 		++count;
 	}
 	if (!wr)
-		goto out;
+		goto out_dec;
 
 	rc = ib_post_recv(ep->re_id->qp, wr,
 			  (const struct ib_recv_wr **)&bad_wr);
@@ -1432,9 +1432,10 @@ void rpcrdma_post_recvs(struct rpcrdma_xprt *r_xprt, int needed, bool temp)
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



