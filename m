Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C98713D24D;
	Thu, 11 Apr 2024 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832425; cv=none; b=pqJmnNdgBHVNktn7oJcLGzegWXrEauJTvkSeYEhKCsJqk+0wAYCBfL/CIfQoYBlnpsPIlxNtlSfoeFUH7ukY7KBVCrT5jO0XuYS1USq/jhqZQavPGE2adaCN4mHGfikAXqzg/k5XXFwFHqwB3a037MdsRAkzz6g5ANNX0Lmmyyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832425; c=relaxed/simple;
	bh=QEpTGOJRAeOts1P6yJxqDcNdd65QWzNyuhMinm8JlvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjspjWGyhqpOVHOz5Pljp6Vx7XY345D60NqalKSRkz7Zn4Z8El5Etg3UrOSVsuAKBZuI3dF/Uug5kN2+1TZx2G0cUmH0+pZTcmFz08S8gX9GpAVm/gUrmyNlpg+7xhBvZw2EILBJZTsxKRAU4ZUPOViogmaTXyI9Nxy/ndJxNss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOZpjEo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOZpjEo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD95AC43390;
	Thu, 11 Apr 2024 10:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832425;
	bh=QEpTGOJRAeOts1P6yJxqDcNdd65QWzNyuhMinm8JlvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOZpjEo+4C8UhbdSggAYfJYBDoRrvKen9EDLF17g6rCLqleUnuo/m2mx8TnFk0XMY
	 oV1ti82ln5FToeKFOjrCWoUapr/23beWPoXPKfz5yV3UV5nehDA3qdkV3AQLzGg99C
	 lhD7rQYdY1Th2TBEj7vs9lBnweLUgRhekQtyY6mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 45/83] SUNRPC: increase size of rpc_wait_queue.qlen from unsigned short to unsigned int
Date: Thu, 11 Apr 2024 11:57:17 +0200
Message-ID: <20240411095414.040467427@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 2c35f43b5a4b9cdfaa6fdd946f5a212615dac8eb ]

When the NFS client is under extreme load the rpc_wait_queue.qlen counter
can be overflowed. Here is an instant of the backlog queue overflow in a
real world environment shown by drgn helper:

rpc_task_stats(rpc_clnt):
-------------------------
rpc_clnt: 0xffff92b65d2bae00
rpc_xprt: 0xffff9275db64f000
  Queue:  sending[64887] pending[524] backlog[30441] binding[0]
XMIT task: 0xffff925c6b1d8e98
     WRITE: 750654
        __dta_call_status_580: 65463
        __dta_call_transmit_status_579: 1
        call_reserveresult: 685189
        nfs_client_init_is_complete: 1
    COMMIT: 584
        call_reserveresult: 573
        __dta_call_status_580: 11
    ACCESS: 1
        __dta_call_status_580: 1
   GETATTR: 10
        __dta_call_status_580: 4
        call_reserveresult: 6
751249 tasks for server 111.222.333.444
Total tasks: 751249

count_rpc_wait_queues(xprt):
----------------------------
**** rpc_xprt: 0xffff9275db64f000 num_reqs: 65511
wait_queue: xprt_binding[0] cnt: 0
wait_queue: xprt_binding[1] cnt: 0
wait_queue: xprt_binding[2] cnt: 0
wait_queue: xprt_binding[3] cnt: 0
rpc_wait_queue[xprt_binding].qlen: 0 maxpriority: 0
wait_queue: xprt_sending[0] cnt: 0
wait_queue: xprt_sending[1] cnt: 64887
wait_queue: xprt_sending[2] cnt: 0
wait_queue: xprt_sending[3] cnt: 0
rpc_wait_queue[xprt_sending].qlen: 64887 maxpriority: 3
wait_queue: xprt_pending[0] cnt: 524
wait_queue: xprt_pending[1] cnt: 0
wait_queue: xprt_pending[2] cnt: 0
wait_queue: xprt_pending[3] cnt: 0
rpc_wait_queue[xprt_pending].qlen: 524 maxpriority: 0
wait_queue: xprt_backlog[0] cnt: 0
wait_queue: xprt_backlog[1] cnt: 685801
wait_queue: xprt_backlog[2] cnt: 0
wait_queue: xprt_backlog[3] cnt: 0
rpc_wait_queue[xprt_backlog].qlen: 30441 maxpriority: 3 [task cnt mismatch]

There is no effect on operations when this overflow occurs. However
it causes confusion when trying to diagnose the performance problem.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 8ada7dc802d30..8f9bee0e21c3b 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -186,7 +186,7 @@ struct rpc_wait_queue {
 	unsigned char		maxpriority;		/* maximum priority (0 if queue is not a priority queue) */
 	unsigned char		priority;		/* current priority */
 	unsigned char		nr;			/* # tasks remaining for cookie */
-	unsigned short		qlen;			/* total # tasks waiting in queue */
+	unsigned int		qlen;			/* total # tasks waiting in queue */
 	struct rpc_timer	timer_list;
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG) || IS_ENABLED(CONFIG_TRACEPOINTS)
 	const char *		name;
-- 
2.43.0



