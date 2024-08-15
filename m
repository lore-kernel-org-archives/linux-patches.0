Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996341AC893;
	Thu, 15 Aug 2024 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732766; cv=none; b=pq7rIsfPstDILCV9NZ2fDG5WnpCk0thNSydX9dz6CHD2LVdmn35xC2O5nd7LCm2Hqk1L21KBsA5QrB0NWzH1X8w9u0iUjt+NBZUYmk9YlVQks+qCQIb1oGXUyrSUrRGjVJeHaHyc6iHJkOEsux61w7A6Ez/LC3TJTLVhWnKESd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732766; c=relaxed/simple;
	bh=oYJN5em6vu9jvfj85TIiOiAPN5AyXOPJUgM8m9wX9ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQKd73ieeQ11gQ8+fyYMtp2Mer4RoJE0Pk2YrvJQ78UkO8TD6/b24phs57Z+G/Tg6fGehw4rLsEfS2KzINb/PVKb7wRXLU/8XSrLkW6/3OLIO1fBqo3JXbEjvEkEr18whnDPeeVBMF3H2CVu0seSOeUy0z2UOwGPg4BWaW5HsXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zfh7QRCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zfh7QRCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBB4C32786;
	Thu, 15 Aug 2024 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732766;
	bh=oYJN5em6vu9jvfj85TIiOiAPN5AyXOPJUgM8m9wX9ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zfh7QRCeELyC11RZpdoFLuNYaz0/8M1s3ubOM2O59ppzd+2Km008FRwnps7je8BA3
	 AZcNT4hhD2nB2HLqlmFZz8KQtPQtUCqfUbYjRDrVFao6Y2+0BcQQiHFfYZTTA56Gy+
	 pXwnThp3sVzF5DYjyT/fsfKVyr4pPcj1mFenvQKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/352] SUNRPC: Fix a race to wake a sync task
Date: Thu, 15 Aug 2024 15:25:44 +0200
Message-ID: <20240815131930.197385839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a4c9d410eb8d5..f4b1b7fee2c05 100644
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



