Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3241A611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6896C433D2;
	Sun, 28 May 2023 19:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302485;
	bh=O3fsy7ijyqO4mArYTxbyMAJSjOjw1VR2kiAxiF7zQr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaDJ6OcbsKtSqNpoxZs5/5YWriZeLNU+KDZFih5Cw6mQb6M24lYtAL2OU+FBKB+LA
	 G9lkLoIzawLCZcMZ10oslQbOmJh4DdWRC7SpFIaCQrtmOlC0peh8EWp3tsWxG7PK/4
	 yACkglnjfx/yANelMRIuIGMhlufxcRUA8cbAm2xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.1 022/119] SUNRPC: Dont change task->tk_status after the call to rpc_exit_task
Date: Sun, 28 May 2023 20:10:22 +0100
Message-Id: <20230528190836.083784080@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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
 net/sunrpc/sched.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index c8321de341ee..6debf4fd42d4 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -927,11 +927,10 @@ static void __rpc_execute(struct rpc_task *task)
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
-- 
2.40.1



