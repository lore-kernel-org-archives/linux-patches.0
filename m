Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F88183CD3;
	Mon, 12 Aug 2024 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480231; cv=none; b=gVNFSXuBwORH0i9ObFGkniX+ZctLBzDb1v9pVDlBYb0bv90peqjCYM6AI3KuaKiPXp9bk/b9VSTh0Sdbkg0IJrQa59cLIlT0XtUhNqzXhPtshiKa+C2Pybe6ciRIK61UcrB8eAW/7cAd+pO7T9RTpF56Hy+/oUoQCCi5vfcTJYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480231; c=relaxed/simple;
	bh=riOnGXUXDyI/tIaiBHOfNlHjGCv6nXxkTxG+ZZGuaEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RR+uMT4zdTQCFXg4zGfod3SHNN1FNd+d3MhrYbvUcsi4+CPNSyyIyTdFoekSUOp4wuUNP47qp5jq4fyVF8/Y3+3ICqESyr375HGV7U7T+SMDuK9g467oC2mN4JW95iLIrou9AXxInX1YBTvc25pO8XX5K4GEz9TzgCyBPkJS7OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0w0OJ4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0w0OJ4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C81C4AF0C;
	Mon, 12 Aug 2024 16:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480231;
	bh=riOnGXUXDyI/tIaiBHOfNlHjGCv6nXxkTxG+ZZGuaEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0w0OJ4zyd2axUkkAYgDZtR6SGqqxPk0iIbtDlRPqkTc+PCeLI78/GQzQLEcjNH4d
	 9ujskVv2356iGur4W0JL3Iu1Y6C2Fum5FepTmNfeFqN6T/1fT+4xTAONWGhDzxMQgW
	 PWWKrirE88Kvev8xKHLVqcKycHnCK1TjhHZVHtnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 117/263] SUNRPC: Fix a race to wake a sync task
Date: Mon, 12 Aug 2024 18:01:58 +0200
Message-ID: <20240812160151.024562367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit ed0172af5d6fc07d1b40ca82f5ca3979300369f7 ]

We've observed NFS clients with sync tasks sleeping in __rpc_execute
waiting on RPC_TASK_QUEUED that have not responded to a wake-up from
rpc_make_runnable().  I suspect this problem usually goes unnoticed,
because on a busy client the task will eventually be re-awoken by another
task completion or xprt event.  However, if the state manager is draining
the slot table, a sync task missing a wake-up can result in a hung client.

We've been able to prove that the waker in rpc_make_runnable() successfully
calls wake_up_bit() (ie- there's no race to tk_runstate), but the
wake_up_bit() call fails to wake the waiter.  I suspect the waker is
missing the load of the bit's wait_queue_head, so waitqueue_active() is
false.  There are some very helpful comments about this problem above
wake_up_bit(), prepare_to_wait(), and waitqueue_active().

Fix this by inserting smp_mb__after_atomic() before the wake_up_bit(),
which pairs with prepare_to_wait() calling set_current_state().

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sched.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 6debf4fd42d4e..cef623ea15060 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -369,8 +369,10 @@ static void rpc_make_runnable(struct workqueue_struct *wq,
 	if (RPC_IS_ASYNC(task)) {
 		INIT_WORK(&task->u.tk_work, rpc_async_schedule);
 		queue_work(wq, &task->u.tk_work);
-	} else
+	} else {
+		smp_mb__after_atomic();
 		wake_up_bit(&task->tk_runstate, RPC_TASK_QUEUED);
+	}
 }
 
 /*
-- 
2.43.0



