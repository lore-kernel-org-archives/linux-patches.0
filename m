Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B8B470430;
	Tue, 21 Jul 2026 19:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663370; cv=none; b=ON7WmPtY6ypuHC/CjOI1qY4UmV+xihcxqyIa4xSt5gDUW08wxDTJC3pcU+j52zwXmfuJDlEZ/fLFFLTaoHaPWJZeX+/AbhfjqsbGbHO10afoEwFkiLfeE4hefqs2urmPIayACmINQav6nVhU7ESWRKVhyNqfTH6PIqhLlAgR+cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663370; c=relaxed/simple;
	bh=HiPqBiPSQtVwUz+93K8QDqYROwZEWff1h/iEe3CIS/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG7p8CStxlPZ0AYq8cjLbYioeQbnLssQj8TeA8yApqdUeNQaZS2cGgY8fSw+r1KxyL6h6jvfa4VaCHvMn2LqSxaMTdhtmNRjeSL48BeMRBoIFc2R6hVtHN1E4GiBcq7JIEyl4NVg8TLrdQt43tq1SoBlgV7qELD9J0nFb3hWYt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfDzMjfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfDzMjfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A421F00A3A;
	Tue, 21 Jul 2026 19:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663369;
	bh=YdCI/kQeueCPJEh+Kxkqc3dtLib2CeVVNNWU+ttfEw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfDzMjfDUF8a0hYqzeBP1bHy7ZWUr5FKxRj3NiVvw0rJJSFAv+YDjwU6vB4hjlxuD
	 9nB7sOO0aslE7xz2QlhnXXkSNqToD2Mw2bAOkS6qlZ2yobtFCPhZ4M3dVPqLIs0NSN
	 0/SPNYeglEkloOU6ARfkhnfJDty3lVg170uNR8gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Nemanov <michael.nemanov@vastdata.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0798/1276] SUNRPC: pin upper rpc_clnt across the TLS connect_worker
Date: Tue, 21 Jul 2026 17:20:41 +0200
Message-ID: <20260721152503.931615062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 46bc86c833956219bbfd246c1ffd832a479c5199 ]

The TLS connect path has a use-after-free: nothing pins the
upper rpc_clnt across the delayed connect_worker. xs_connect()
stores task->tk_client in sock_xprt::clnt as a raw pointer
and queues the worker; for TLS-secured transports that worker
is xs_tcp_tls_setup_socket(), which reads several fields out
of the saved pointer (cl_timeout, cl_program, cl_prog,
cl_vers, cl_cred, cl_stats) to construct the args for the
inner handshake rpc_clnt.

The xprt does not reference the rpc_clnt; the rpc_clnt
references the xprt. xs_destroy() does cancel the
connect_worker, but it runs only when the xprt's refcount
drops to zero, which cannot happen until the rpc_clnt
releases its cl_xprt reference in rpc_free_client_work().
When a TLS handshake fails fatally (for example, an mTLS
mount whose client cert does not match the server), the
connecting task is woken with -EACCES and exits, the mount
caller invokes rpc_shutdown_client(), and the upper rpc_clnt
is freed before the queued connect_worker fires.
xs_tcp_tls_setup_socket() then dereferences the freed clnt,
producing the refcount_t underflow Michael Nemanov reported.

Take a reference on the upper rpc_clnt in xs_connect() for
TLS transports via a new rpc_hold_client() helper, and drop
it in the connect_worker's exit path with rpc_release_client().
The xprt_lock_connect() / xprt_unlock_connect() pairing
already serialises xs_connect() with xs_tcp_tls_setup_socket(),
so the take and release are balanced one-for-one.

The non-TLS connect worker (xs_tcp_setup_socket) never reads
sock_xprt::clnt, so leave that path alone and avoid the
clnt-holds-xprt-holds-clnt cycle that would otherwise prevent
xprt destruction.

Reported-by: Michael Nemanov <michael.nemanov@vastdata.com>
Closes: https://lore.kernel.org/linux-nfs/40e3d522-dfcf-4fc1-9c55-b5e81f1536d5@vastdata.com/
Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Michael Nemanov <michael.nemanov@vastdata.com>
Reviewed-by: Michael Nemanov <michael.nemanov@vastdata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/clnt.h |  1 +
 net/sunrpc/clnt.c           | 19 +++++++++++++++++--
 net/sunrpc/xprtsock.c       | 11 ++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index 5321585c778fcc..bd6ac060450cb6 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -186,6 +186,7 @@ int		rpc_switch_client_transport(struct rpc_clnt *,
 				const struct rpc_timeout *);
 
 void		rpc_shutdown_client(struct rpc_clnt *);
+void		rpc_hold_client(struct rpc_clnt *);
 void		rpc_release_client(struct rpc_clnt *);
 void		rpc_task_release_transport(struct rpc_task *);
 void		rpc_task_release_client(struct rpc_task *);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index e492655cb2212e..e88e21c2ab3299 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1026,8 +1026,23 @@ rpc_free_auth(struct rpc_clnt *clnt)
 	return NULL;
 }
 
-/*
- * Release reference to the RPC client
+/**
+ * rpc_hold_client - acquire a reference on an rpc_clnt
+ * @clnt: rpc_clnt to pin
+ *
+ * Pairs with rpc_release_client().
+ */
+void rpc_hold_client(struct rpc_clnt *clnt)
+{
+	refcount_inc(&clnt->cl_count);
+}
+
+/**
+ * rpc_release_client - release a reference on an rpc_clnt
+ * @clnt: rpc_clnt to release
+ *
+ * Pairs with rpc_hold_client(). The rpc_clnt's resources are
+ * freed once its reference count drops to zero.
  */
 void
 rpc_release_client(struct rpc_clnt *clnt)
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index f5b22267fadf46..56819b6a7bde2f 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2770,6 +2770,7 @@ static void xs_tcp_tls_setup_socket(struct work_struct *work)
 out_unlock:
 	current_restore_flags(pflags, PF_MEMALLOC);
 	upper_transport->clnt = NULL;
+	rpc_release_client(upper_clnt);
 	xprt_unlock_connect(upper_xprt, upper_transport);
 	return;
 
@@ -2817,7 +2818,15 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 	} else
 		dprintk("RPC:       xs_connect scheduled xprt %p\n", xprt);
 
-	transport->clnt = task->tk_client;
+	/*
+	 * Only the TLS connect_worker reads transport->clnt; pinning
+	 * the upper rpc_clnt unconditionally would form a cycle with
+	 * cl_xprt and prevent xprt destruction.
+	 */
+	if (xprt->xprtsec.policy != RPC_XPRTSEC_NONE) {
+		rpc_hold_client(task->tk_client);
+		transport->clnt = task->tk_client;
+	}
 	queue_delayed_work(xprtiod_workqueue,
 			&transport->connect_worker,
 			delay);
-- 
2.53.0



