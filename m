Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135DC19F462;
	Thu, 15 Aug 2024 13:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728950; cv=none; b=U/89pBRH2Ec3MTmceD3sYX9rFIxJ9QvwwSrRwBIFs8ROtziUi0zFtO5hgkPU/nJRPb7fdcgTnTNJv91yw4h6rpPw/LjAXeoPtVsr02lt0NBjcoRWcYq7KstNkoUYy6EvIE9MHlUO293JiOSyZRKDNMQwWrckpJEpndIh+r3YeIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728950; c=relaxed/simple;
	bh=a1Ho4/PFE0gK/5iXg1Wj/SebUPkcMGNyvTFntVc8OOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWF72ZseeKAQIswVMa+oa6Snra6od+/rLl/TW+IlLneWWv+8bZch/5vfpvNmlEP67X/MgpNf7t2We4oWjR/cVVX+neO7yztKtaLmVOJtuKb8H2H7cqDz5IDuiCsfvO1NeU+sJMbb5kbwBTBqbDdQNdln8JYF+VbdmdCVuSQa4M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jahEl1pa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jahEl1pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7988BC4AF0A;
	Thu, 15 Aug 2024 13:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728950;
	bh=a1Ho4/PFE0gK/5iXg1Wj/SebUPkcMGNyvTFntVc8OOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jahEl1paMVWuqXQFv7fVMO3IPONEHZMziNtlkus4m1vdXPH6YM3c4sEV3C+707tjH
	 CYG5vsAIjbSqi2/VIh6GNj0holc7CH35BiV3a4GdnLgW88HAbczWgX0hp+mbKUuKrK
	 Cnnu1kTfU/PTfYZwb0cGiWAPw3O2+qJfr0a4M1vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/196] SUNRPC: Fix a race to wake a sync task
Date: Thu, 15 Aug 2024 15:24:22 +0200
Message-ID: <20240815131857.621369970@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 9af919364a001..92d88aa62085b 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -349,8 +349,10 @@ static void rpc_make_runnable(struct workqueue_struct *wq,
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



