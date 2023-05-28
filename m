Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1AF569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C394C433EF;
	Sun, 28 May 2023 19:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302151;
	bh=8H42x7HyObZag/RERfcL1OkB9QV13o7fuQhC2I+vH7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YivQ4/bPQujPXvJU6ScMJo9BcU5CFWLw0CRMX1vhc7+dX3GlKO9ouI0pprgpEv4kM
	 Daqr6eUCGU6EH0ztyeIyq742x8iNWgcVFCMDn135zuOujT29DFgPVTSKe3pGm//X1S
	 YMu66P4tH8AbzssfynYdmtT/nRcZrbU+GfToW+pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.3 020/127] SUNRPC: Dont change task->tk_status after the call to rpc_exit_task
Date: Sun, 28 May 2023 20:09:56 +0100
Message-Id: <20230528190836.896621733@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit d180891fba995bd54e25b089b1ec98d134873586 upstream.

Some calls to rpc_exit_task() may deliberately change the value of
task->tk_status, for instance because it gets checked by the RPC call's
rpc_release() callback. That makes it wrong to reset the value to
task->tk_rpc_status.
In particular this causes a bug where the rpc_call_done() callback tries
to fail over a set of pNFS/flexfiles writes to a different IP address,
but the reset of task->tk_status causes nfs_commit_release_pages() to
immediately mark the file as having a fatal error.

Fixes: 39494194f93b ("SUNRPC: Fix races with rpc_killall_tasks()")
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/sched.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -927,11 +927,10 @@ static void __rpc_execute(struct rpc_tas
 		 */
 		do_action = task->tk_action;
 		/* Tasks with an RPC error status should exit */
-		if (do_action != rpc_exit_task &&
+		if (do_action && do_action != rpc_exit_task &&
 		    (status = READ_ONCE(task->tk_rpc_status)) != 0) {
 			task->tk_status = status;
-			if (do_action != NULL)
-				do_action = rpc_exit_task;
+			do_action = rpc_exit_task;
 		}
 		/* Callbacks override all actions */
 		if (task->tk_callback) {


