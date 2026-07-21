Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731484195C9;
	Tue, 21 Jul 2026 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660499; cv=none; b=lgt2znRovAzFF0Py0JhtPQ2FV3u9/nWgeRsKj5sfMu35mgbGCRepJC4/R9C59BG1IHS2ktPSLYqwzcBiA5MnD1Xvu6aLmB/LwRBo6J2rB0ghkRPIEn6V+y28IFOKtpv/QRgONSZt7vcOG8HA5FBA0iazlwxF1SplWqRlVAzkRqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660499; c=relaxed/simple;
	bh=x7T6GcmnUFj3fyLdouAgmy1WqdewzXzNo8zwo7qV1L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfiwwHtM2Qlsw+pAS5Nyb2pmlWn+9xCGzW891csnEGvdOoyBs5l0TUxxVjZO2cqOXHiibFAZsnX6okXu0ZdMI246vFm8IrAUhRTNhmRkDRnnEydDpgD8GVWJW6Vfgl1GgEg4VQ6pgNQGt0ADo9L+Mn69r9CdHtP2FgL5aUdNhBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqlKiTFa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqlKiTFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BC31F01560;
	Tue, 21 Jul 2026 19:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660473;
	bh=XPULf3+aLxQxsb7BYK4RsS0GwbP9HbjEgxQl9KXHFMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XqlKiTFaTs1CdHFuT+4m2k9oHZVZieghZUvbwdmzkFd8F593zXrgs6L1/SGl864lO
	 K40500+dZ/7+6WmHQ0n4DgjAzskKqaPKd7bv91f9ZQB1LpUBpH+zNoRggNjncVOfXk
	 lVr2kihj5PvOhDrJnbBcdMAlGQnYufKz7wrMPbkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0993/2077] xprtrdma: Initialize re_id before removal registration
Date: Tue, 21 Jul 2026 17:11:06 +0200
Message-ID: <20260721152616.239299493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

[ Upstream commit bb7caa63e1db22fd03e8dc591b12169e99169dff ]

rpcrdma_create_id() registers ep->re_rn with the rpcrdma ib_client
before returning the new rdma_cm_id to rpcrdma_ep_create(). However
rpcrdma_ep_create() currently stores that pointer in ep->re_id only
after rpcrdma_create_id() returns.

A local administrator can race an NFS/RDMA mount against RDMA device
removal. If rpcrdma_remove_one() observes the just-registered
notification before rpcrdma_ep_create() assigns ep->re_id,
rpcrdma_ep_removal_done() calls trace_xprtrdma_device_removal(NULL).
The tracepoint dereferences id->device->name and copies
id->route.addr.dst_addr, so the callback can crash the kernel with a
NULL pointer dereference.

Store the rdma_cm_id in ep->re_id immediately before publishing
ep->re_rn. The existing error path still destroys the id directly if
registration fails; ep is then freed by the caller without using
ep->re_id. Remove the later duplicate assignment in rpcrdma_ep_create().

Fixes: 3f4eb9ff9234 ("xprtrdma: Handle device removal outside of the CM event handler")
Assisted-by: kres:openai-gpt-5
Signed-off-by: Chris Mason <clm@meta.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 5a36f35792e0d3..9b2c186fd221b8 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -334,6 +334,7 @@ static struct rdma_cm_id *rpcrdma_create_id(struct rpcrdma_xprt *r_xprt,
 	if (rc)
 		goto out;
 
+	ep->re_id = id;
 	rc = rpcrdma_rn_register(id->device, &ep->re_rn, rpcrdma_ep_removal_done);
 	if (rc)
 		goto out;
@@ -406,7 +407,6 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 	}
 	__module_get(THIS_MODULE);
 	device = id->device;
-	ep->re_id = id;
 	reinit_completion(&ep->re_done);
 
 	ep->re_max_requests = r_xprt->rx_xprt.max_reqs;
-- 
2.53.0



