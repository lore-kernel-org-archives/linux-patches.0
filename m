Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985C735AC03;
	Fri,  4 Sep 2026 05:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501128; cv=none; b=o36RZ3gwlOPsKgZJqYVXaRo87aWB/Yb9C/0Tht1Lur7oPgcOB8WIVkh/z7P8Ys17wJeKMJljazjeJHkr5VKRCuZVGnhdq8v9FdbxCtVjUKESMDAz6wgHtlacF0JZB9uRTUbuZsDAJ0viE7Qp+2uSgmRFcNrbwGRm00hdH7gAy7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501128; c=relaxed/simple;
	bh=/MWmDGp1OREpq6XDK4naoW7OZdr9bgQRF0mPgeV+JvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q01qhH1QSGIWMEXWGw5YvgstlHbiZNHsG2ywbHWSPHQ3mPmnp2GCyfy1Vx0dLlGiSmzCFBO2KOZjO6hkZhSwokdVB/6A7njnm25mPsgBhoIiCteTbS0KnyxAOYhqeTQ+lFy41OAhTvUbxqx+RJjUokti2Z0/jkANeBUVKGUy/i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSea77/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSea77/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F327B1F00A3D;
	Fri,  4 Sep 2026 05:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501127;
	bh=UZ8NGNjkFQrmVQEssvLZRYqFxug0AJdAb1zcS8aHtHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSea77/pbZ4XNM9jOPQISm/B1VSKX7iMqE9apRXnuWY2Q87ZViqKFkgzh9snfi3k4
	 U9235d+S6qjGO47AwnehJH26WNUY+TS2FmkwCps1vFvpPPCAtyAGZxDKZMpNFJh9Bp
	 rmSquALd+Z3RJr4IL2xP40KIbWn/ndgDv/yyQNEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 298/552] svcrdma: Use svc_xprt_put to free listener on create failure
Date: Fri,  4 Sep 2026 06:57:35 +0200
Message-ID: <20260904045756.855611345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

commit e346ef7bcb137f50c49f969330ab7dcf64ea1654 upstream.

svc_rdma_create() calls kfree(cma_xprt) when
svc_rdma_create_listen_id() fails. svc_xprt_init() has already
acquired a net namespace reference via get_net_track(); kfree
bypasses svc_xprt_free() which releases it.

Replace the kfree() with svc_xprt_put() so the kref_init birth
reference drops to zero and svc_xprt_free() dispatches
svc_rdma_free() to clean up properly. sc_cm_id is still NULL
at that point; the preceding patch added the necessary NULL
guard in svc_rdma_free().

svc_xprt_free() also drops the module reference via
module_put(), but the caller _svc_xprt_create() does the same
on xpo_create failure, double-putting the single
try_module_get() it acquired. Take a compensating
__module_get() before the svc_xprt_put() to keep the count
balanced, matching the convention in svc_rdma_accept()'s error
path.

Fixes: 4fb8518bdac8 ("sunrpc: Tag svc_xprt with net")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-3-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -373,7 +373,13 @@ static struct svc_xprt *svc_rdma_create(
 
 	listen_id = svc_rdma_create_listen_id(net, sa, cma_xprt);
 	if (IS_ERR(listen_id)) {
-		kfree(cma_xprt);
+		/* _svc_xprt_create() acquired one module reference and
+		 * puts it on xpo_create failure.  svc_xprt_free() puts
+		 * a second one when the kref drops to zero.  Take a
+		 * compensating reference so both puts are balanced.
+		 */
+		__module_get(cma_xprt->sc_xprt.xpt_class->xcl_owner);
+		svc_xprt_put(&cma_xprt->sc_xprt);
 		return ERR_CAST(listen_id);
 	}
 	cma_xprt->sc_cm_id = listen_id;


