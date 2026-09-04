Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C75415F06;
	Fri,  4 Sep 2026 06:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502466; cv=none; b=fxpSRPrsYRS/qThnElIxDlH81iOXS+3YQY1dU/5GzhHkzmAGypme2l87GucL2Lis7oPlIA8n5ii98RTg7gV8X0G+UjWy6/tw88qCbdHmjB9VODwN4graf9cx9ceohhCJe1mSJQddXPTSSGaw2nlvIh9yS+Jy0knla8xOMPwI47Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502466; c=relaxed/simple;
	bh=R9Y/IgJDe40WNx4N7MoA83U29Jo1dsUvhegnOr5z0sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXY5ibe0kOSDDq3Tm/JxJ71JPXBxpjN5YRELIZ1QQNVucp7/f8szEAXhrBJN+tMjorYNi4J9fCq5EiG/XunfimbG9iu4SGt+ST5/v2DG5dtuobBeXCFMKY6bZurJTPFxYrc1P61jN1QXyX1y+FsVubEbQ/1yqd8X/IWoOZvftwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvlA/SND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvlA/SND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD4A1F00A3D;
	Fri,  4 Sep 2026 06:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502465;
	bh=3O/MwhcgKDtgdJ6IbKJtxxn+wEMTonRE2cJuoeT0XeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvlA/SNDGkjA+QN1xiVfIMpMrXqzx+UqeHf+TpAMwpkZJYi/1uAiS/Ibut+0EBMSI
	 rnpOcJuxjPNJvAvfuhvqz1pg6QNZreir4z53GOaMeXtScte8HH2uGH1x4+WiZ+P4TJ
	 tnIbISOMgkVFwaTk4EMfET6wiuIeG5Nr+FswJvI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 216/403] svcrdma: Fix unmatched rn_unregister on failed accept
Date: Fri,  4 Sep 2026 07:00:19 +0200
Message-ID: <20260904045739.775675904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 26190394c64c9429481fc88a4738f70bb92fb352 upstream.

When svc_rdma_accept() takes the errout path before
rpcrdma_rn_register() has succeeded, the existing cleanup block
calls rpcrdma_rn_unregister(dev, &newxprt->sc_rn) unconditionally.
svcxprt_rdma is kzalloc'd, so on that path sc_rn.rn_index is 0 and
sc_rn.rn_done is NULL; the unregister therefore xa_erase()s another
caller's slot 0 and performs an unmatched kref_put() on the
rpcrdma_device's rd_kref.

The same errout also brackets the cleanup with svc_xprt_get()/
svc_xprt_put() around the kref_init() birth reference. The kref
goes 1 -> 2 -> 1 and never reaches 0, so the svcxprt_rdma (and the
net/ns_tracker it pinned) is leaked on every failed accept.

rpcrdma_rn_register() writes rn->rn_done last, only after xa_alloc()
and kref_get() have both succeeded, so rn_done == NULL is a natural
"never registered" sentinel. Guard rpcrdma_rn_unregister() with an
early return when rn_done is NULL, and clear rn_done before the
matching xa_erase() so a repeated unregister is also a no-op.

With that guard in place, the accept errout drops the kref_init()
birth reference via svc_xprt_put(), which dispatches svc_rdma_free().
Teardown of sc_qp, sc_sq_cq, sc_rq_cq, and sc_pd runs under existing
IS_ERR/NULL guards in svc_rdma_free(); sc_rn is covered by the new
rn_done sentinel; sc_cm_id is non-NULL on every errout path because
svc_rdma_accept() dereferences it above the first goto errout.

svc_xprt_free() drops the module reference associated with the freed
transport, and svc_handle_xprt() drops its pre-acquired reference
when ->xpo_accept() returns NULL. Take a replacement module reference
before svc_xprt_put() so the two module_put()s remain balanced.

The rn_done guard also covers svc_rdma_free()'s non-listener call
to rpcrdma_rn_unregister() for transports whose register attempt
failed or never ran.

Fixes: 8ac6fcae5dc0 ("svcrdma: Unregister the device if svc_rdma_accept() fails")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-1-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/ib_client.c          |   24 +++++++++++++++++++++++-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   28 +++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 8 deletions(-)

--- a/net/sunrpc/xprtrdma/ib_client.c
+++ b/net/sunrpc/xprtrdma/ib_client.c
@@ -51,7 +51,11 @@ static struct rpcrdma_device *rpcrdma_ge
  * to be invoked when the device is removed, unless this notification
  * is unregistered first.
  *
- * On failure, a negative errno is returned.
+ * On failure, a negative errno is returned. rn->rn_done is left
+ * NULL on every failure path (it is assigned only after xa_alloc
+ * and kref_get have both succeeded), so the @rn may safely be
+ * passed to rpcrdma_rn_unregister() without a separate
+ * registered/unregistered flag in the caller.
  */
 int rpcrdma_rn_register(struct ib_device *device,
 			struct rpcrdma_notification *rn,
@@ -83,6 +87,10 @@ static void rpcrdma_rn_release(struct kr
  * rpcrdma_rn_unregister - stop device removal notifications
  * @device: monitored device
  * @rn: notification object that no longer wishes to be notified
+ *
+ * It is safe to call this on an @rn whose registration never
+ * completed or failed; rn_done == NULL is treated as
+ * never-registered and the call is a no-op.
  */
 void rpcrdma_rn_unregister(struct ib_device *device,
 			   struct rpcrdma_notification *rn)
@@ -92,6 +100,20 @@ void rpcrdma_rn_unregister(struct ib_dev
 	if (!rd)
 		return;
 
+	/*
+	 * rn_done is the registration sentinel: rpcrdma_rn_register
+	 * assigns it last, after xa_alloc and kref_get have both
+	 * succeeded. A NULL rn_done means this notification was
+	 * never registered (or its registration failed) or has
+	 * already been unregistered, and the call is a no-op.
+	 * Without this guard, rn_index == 0 from a kzalloc'd
+	 * parent would erase another caller's slot 0 and underflow
+	 * rd_kref.
+	 */
+	if (!rn->rn_done)
+		return;
+	rn->rn_done = NULL;
+
 	trace_rpcrdma_client_unregister(device, rn);
 	xa_erase(&rd->rd_xa, rn->rn_index);
 	kref_put(&rd->rd_kref, rpcrdma_rn_release);
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -43,6 +43,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -576,13 +577,26 @@ static struct svc_xprt *svc_rdma_accept(
 	return &newxprt->sc_xprt;
 
  errout:
-	/* Take a reference in case the DTO handler runs */
-	svc_xprt_get(&newxprt->sc_xprt);
-	if (newxprt->sc_qp && !IS_ERR(newxprt->sc_qp))
-		ib_destroy_qp(newxprt->sc_qp);
-	rdma_destroy_id(newxprt->sc_cm_id);
-	rpcrdma_rn_unregister(dev, &newxprt->sc_rn);
-	/* This call to put will destroy the transport */
+	/*
+	 * Drop the kref_init birth reference. svc_xprt_free will
+	 * dispatch xpo_free = svc_rdma_free, which tears down sc_qp,
+	 * sc_sq_cq, sc_rq_cq, and sc_pd under existing IS_ERR/NULL
+	 * guards, and sc_rn under the rn_done sentinel guard inside
+	 * rpcrdma_rn_unregister.
+	 *
+	 * sc_cm_id is destroyed unconditionally by svc_rdma_free; that
+	 * is safe here because sc_cm_id is non-NULL by caller invariant
+	 * on every path that reaches this errout: handle_connect_req
+	 * installs newxprt->sc_cm_id before queueing the new xprt for
+	 * accept, and svc_rdma_accept has already dereferenced it above
+	 * the first goto errout.
+	 *
+	 * svc_handle_xprt() drops its pre-acquired module reference when
+	 * ->xpo_accept() returns NULL. Take a replacement reference before
+	 * freeing @newxprt, because svc_xprt_free() drops the module
+	 * reference associated with @newxprt.
+	 */
+	__module_get(newxprt->sc_xprt.xpt_class->xcl_owner);
 	svc_xprt_put(&newxprt->sc_xprt);
 	return NULL;
 }


