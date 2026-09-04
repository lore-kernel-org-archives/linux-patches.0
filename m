Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7153B7B7B;
	Fri,  4 Sep 2026 05:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499362; cv=none; b=GYEydBXD/cMvYJ69SBg4Wz1/zH/l2xvcxAAiUQG8ppjlKlRTYos1joxA+/nwBDO7zXnOI4nttlGXpjpixBg3R2ita8c8zH+2O8onHEdoxUwXdVhsBXbBZ/0i1quQTQ1o3ISW3O1ZV8iREyRiaz4KgSG+LxKznSHr2cudFaQGYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499362; c=relaxed/simple;
	bh=DTyY9TNLMSvYDMJQjNkadkyDvu5mimQ+eFqIalv+yy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEcGMNS95UtrJbbeo+QswF1dEe1/j8W3FtsDaW7GSIaPWWuQCqxvw02hznFjZSb5+U9xRDbHJm6PKnv8oovHMQS0CEP6ZN144cU7eG62ZvoC+8+kmzPYTOFKzvP13VYuy99Cg929mPIc8d6LkBl0HEtKqSQ5gHIXzWSZ2lZg1ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZKZ5MKR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZKZ5MKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686281F00A3D;
	Fri,  4 Sep 2026 05:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499360;
	bh=9MWSD+w4/Y24GXGc1roknN8z0DeBDGJa9jLkXYcvQO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZKZ5MKRb6HkmmZNkMhnMqia6i8GnaSWo6BeOEHUIpsBsHDBYESMx+W1bbMz+ApR0
	 lfF3pOBsayk9LTOU8liJpoh8eQS8aQVJCRNb9l8O6Oa2stD/x1FKtY2ULt8dOtTvt/
	 siDt3Qu4ADh3XaLjT8q+pPA6yBcL08f3PGToedy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 389/713] svcrdma: Reorder rpcrdma_rn_unregister before rdma_destroy_id
Date: Fri,  4 Sep 2026 06:55:57 +0200
Message-ID: <20260904045812.542662421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 4488e912973773d64368828acf3b8e39d93650ae upstream.

svc_rdma_free() caches rdma->sc_cm_id->device before teardown,
then calls rdma_destroy_id(sc_cm_id) which frees the cm_id.
rpcrdma_rn_unregister() follows, but between those two calls
the transport's sc_rn entry is still installed in the device's
rd_xa. A concurrent ib_unregister_device walk can dispatch
svc_rdma_xprt_done() against the now-freed sc_cm_id.

Move rpcrdma_rn_unregister() before rdma_destroy_id() so the
transport's notification entry is removed from the xarray before
the cm_id it references is destroyed.

Also guard the sc_cm_id dereference with a NULL check: the
following patches introduce paths that reach svc_rdma_free()
with sc_cm_id == NULL (listener create failure, ADDR_CHANGE
replacement failure).

Fixes: c4de97f7c454 ("svcrdma: Handle device removal outside of the CM event handler")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-2-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -634,10 +634,15 @@ static void svc_rdma_free(struct svc_xpr
 {
 	struct svcxprt_rdma *rdma =
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
-	struct ib_device *device = rdma->sc_cm_id->device;
+	struct ib_device *device;
 
 	might_sleep();
 
+	if (!rdma->sc_cm_id)
+		goto out_free;
+
+	device = rdma->sc_cm_id->device;
+
 	/* This blocks until the Completion Queues are empty */
 	if (rdma->sc_qp && !IS_ERR(rdma->sc_qp))
 		ib_drain_qp(rdma->sc_qp);
@@ -662,11 +667,13 @@ static void svc_rdma_free(struct svc_xpr
 	if (rdma->sc_pd && !IS_ERR(rdma->sc_pd))
 		ib_dealloc_pd(rdma->sc_pd);
 
+	if (!test_bit(XPT_LISTENER, &rdma->sc_xprt.xpt_flags))
+		rpcrdma_rn_unregister(device, &rdma->sc_rn);
+
 	/* Destroy the CM ID */
 	rdma_destroy_id(rdma->sc_cm_id);
 
-	if (!test_bit(XPT_LISTENER, &rdma->sc_xprt.xpt_flags))
-		rpcrdma_rn_unregister(device, &rdma->sc_rn);
+out_free:
 	kfree(rdma);
 }
 


