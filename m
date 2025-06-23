Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FB35FDA7;
	Mon, 23 Jun 2025 21:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713322; cv=none; b=CTG+LBXNyAaVwX4KSbssB2X/rmyluSoywOYmKZeS6dVgScnogSqr9wMjZOwMPfmR8m0o2982ryXDg10CSJiPqKMqQcIAJIB2mavYGQNUt8XVZfNsPDwT+d3qbPflepvZGc0qP/2bDeieOQ4ViP1Pygj7MlTIzlXebogF6iKNqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713322; c=relaxed/simple;
	bh=uRAMvwiM/jthdPI+0n8+KJSwdy9fGB4i0ekqbklpspE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO0NW3+vFN+T7CnbGKzNFneT2EZviIf+czYvMY830wK1FvaLx4Q187+Q5RE57Rzuyb1WTPzElLVaGDdFCQUnds7eL60u3TVJNcTBnjpQDLE56I0kx/UuP919/TtUvIJZdMan5u8BoOxSjyDHlnH8WrdM48NJWVewNVFf+YkV8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d50AXR04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d50AXR04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE75C4CEED;
	Mon, 23 Jun 2025 21:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713321;
	bh=uRAMvwiM/jthdPI+0n8+KJSwdy9fGB4i0ekqbklpspE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d50AXR04TorxUk++q0sMj5eieucqLNZxNQRWOYqwiCBuUt8iKltmw8J+ZslGR667e
	 hvbkE2/cmhIujm3Wub3SxCiXYg6+NG/wFYtdQNjI43/uCkxhTHC38eeEwcLC/wL7XL
	 7FsW+WSSlOIRYd6JToxPAyHMisf7LC9AYKEzvAlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 038/414] svcrdma: Unregister the device if svc_rdma_accept() fails
Date: Mon, 23 Jun 2025 15:02:55 +0200
Message-ID: <20250623130642.988647466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 8ac6fcae5dc0e801f1c82a83f5ae2c0a4db19932 upstream.

To handle device removal, svc_rdma_accept() requests removal
notification for the underlying device when accepting a connection.
However svc_rdma_free() is not invoked if svc_rdma_accept() fails.
There needs to be a matching "unregister" in that case; otherwise
the device cannot be removed.

Fixes: c4de97f7c454 ("svcrdma: Handle device removal outside of the CM event handler")
Cc: stable@vger.kernel.org
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -577,6 +577,7 @@ static struct svc_xprt *svc_rdma_accept(
 	if (newxprt->sc_qp && !IS_ERR(newxprt->sc_qp))
 		ib_destroy_qp(newxprt->sc_qp);
 	rdma_destroy_id(newxprt->sc_cm_id);
+	rpcrdma_rn_unregister(dev, &newxprt->sc_rn);
 	/* This call to put will destroy the transport */
 	svc_xprt_put(&newxprt->sc_xprt);
 	return NULL;


