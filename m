Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DC77DA7D;
	Thu, 15 Aug 2024 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730371; cv=none; b=m+qy8S1U9OQmveJx211dmoOCNRRxvUAvTyuEh/7k1V8oddKTiwCI2wlM5t77nReiLQbSztHkJ6+A50Pgt6h0fHu0L8Pvmksj3qL3tjL2XNe0EzqyiHmYyLGk69HvtDfAI0Foc4QKNqgWqk6YEoOm41Lcu5o8f2e0r29ztBpXieo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730371; c=relaxed/simple;
	bh=4sC7fFKWGBzWXH3jj7WFuCwxWJtVCFj3vkmz9zrl0T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJPaAED83qKsvqAcPLk5/LczD4Csanwe0og4VcrjcOwSr4ocxrLRVQoPDOdV8tEN+jSPLy6NA5uTOgGVt+gOZkbaDnuiqLmlx1xlgRecDRIjhEvaE7rQPK1rNbLRwKWr9xESmR838Ux2LMjsa+dcDHlQ6rsrdpFgmAXZJFXazI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2Tx/Zou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2Tx/Zou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03383C32786;
	Thu, 15 Aug 2024 13:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730371;
	bh=4sC7fFKWGBzWXH3jj7WFuCwxWJtVCFj3vkmz9zrl0T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2Tx/Zou+bnSRvK2vFUi1OeAhgayuAzkCgNi9ZlXCOyeyAzlJhsRlqEY0+RkrdRZn
	 nC9u8A7z+qhkg8oke6v9hvnLHtjFS5SzoeNy+1mUQD00Q/vYtwFY6WC1ztFu5DoWvQ
	 ZGP/e3cSxBtRdLOGW7Cw+OVOejgn1NIbrNPppKKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 387/484] SUNRPC: Fix a race to wake a sync task
Date: Thu, 15 Aug 2024 15:24:05 +0200
Message-ID: <20240815131956.394678420@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a00890962e115..540220264b31e 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -348,8 +348,10 @@ static void rpc_make_runnable(struct workqueue_struct *wq,
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



