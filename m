Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51410280CD5;
	Tue, 13 Oct 2026 12:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895389; cv=none; b=ZtwxHFKGNJxazsRTnS6upmQEQd9yz3ytMSfNCiya2lPiwoVD0wWsn8h3wbcZ4T32bZGYe2+V4uOdb2SCG5mxeVHhSxGfIgi9HtqEbp6r+zIX11d27txieu9vHQ76ahFXsyQdCSu2v5abDP9r0F+fmr6AzBd/JQxoNJ/FwcFdlWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895389; c=relaxed/simple;
	bh=2mr6D9tLhifUd2VAftIa2R+27ttWtZJrxtEX0gFrNIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTaFLhlcU+mFvKKtqMo7DL93f9NiwWvPIk4kpFf7YNteXeTJ8/+Z6HX1pgUNfpsjFm/l5UQxX9bXhmZRQiSQYBHg99or6RVBUH1VWw7Mvd31PDfpnhTkSnr9GH8zVCI/ztY7li5b1pnnsrF9SCUVLIz4GtrPgKaXX2K8AtLRJHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkpdFGqR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkpdFGqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36121F000FF;
	Tue, 13 Oct 2026 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895388;
	bh=nzJ2YrNVxKmFSJIUHbcjDn7s6DvoRq6cspnkcO9rkTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkpdFGqRaD+tc54mIAGNDQXXdd/WaW2ai3SVtwCNQgEvRnMzDi72JHkMIyp7K1IMq
	 mqRm9hmDiEE5M7ENuLmphGXBlGcbwPSQA+qfZIcbBZFiyQcZrAb0CzID9tios6schK
	 8GQqgtAcKL6BHXZp6Y7SV0u1mS4sBzRUG4S2Wero=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/497] svcrdma: Use svc_xprt_put to free listener on create failure
Date: Tue, 13 Oct 2026 13:37:04 +0200
Message-ID: <20261013112913.991829936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

[ Upstream commit e346ef7bcb137f50c49f969330ab7dcf64ea1654 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 55f810a22c6aa..1f9d14e46c9df 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -373,7 +373,13 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 
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
-- 
2.53.0



