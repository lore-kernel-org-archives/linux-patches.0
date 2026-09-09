Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FA2582BBA;
	Wed,  9 Sep 2026 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964641; cv=none; b=o7gq8DIc4+N6hXZqXF2YhRS1XuqqAlWOhkigRCNGfFn3fS4IJv9mU0692pX/2xH0ql+VoYrFHUFDY7zEk7fcX7D9pSWK0Zw7qEvMZHNWUYSNU6LoaiYurAKsrPYlVUUkMz5+nQ6gKEgniihFMB28IFmDNnpVInPq3ExjEgmiW/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964641; c=relaxed/simple;
	bh=217UzdTi2V95+K7QVmVIB/DeMoSyarKmh75uU4bSpIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPu1pjoCHD5nQcdsA+uAsh+Iz41F5crp3X9Ymw02TTWBKdhtdmab31xwLOAiDfaWrKm8Iyf3deG28MKjiNSjTk0Lh8YH/slr9erHpAZTKsDGBIWrCPyUTU7XTbytu7Jz7Flo4bii2l1qkjsk3lTO3g1eS9fYdRtpup1fX2MADww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuY9+ClF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuY9+ClF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E373C1F00A3A;
	Wed,  9 Sep 2026 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964640;
	bh=rLmpix081IJIXrlYrphXk6w+m/iVituiKyslAUGgWl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuY9+ClFP7I/Fy2SWgzS0dnmOEbONn2i0KCNjqJByVU/s7VWrvy+9sTAG0hquIXKt
	 CnJhFdQVKj7Beh4efRHsBNvJ9rge8qe3OXMBDKcj/lDw4RKngS5Unswni5FtM3Fyup
	 bc/hnEvy+OT5HsVop0j7IavZn+9UZCHcb4nM5w9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 493/583] svcrdma: Reorder rpcrdma_rn_unregister before rdma_destroy_id
Date: Wed,  9 Sep 2026 15:42:58 +0200
Message-ID: <20260909134254.874219108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4488e912973773d64368828acf3b8e39d93650ae ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -621,10 +621,15 @@ static void svc_rdma_free(struct svc_xpr
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
@@ -649,11 +654,13 @@ static void svc_rdma_free(struct svc_xpr
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
 


