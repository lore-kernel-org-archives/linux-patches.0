Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4FC15AADE;
	Tue, 18 Jun 2024 12:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714643; cv=none; b=dvDAywwePDqQxaZxhMd9QIbIxeK60FFOst0Fp7jNjEE6CrYgJAAikuapq71SGPMjBOiKE4QnZs9JOENKliLZyRr4jbAA7IDxs9IkXpRlfZvFzZHat7JOqZIdMsiJvo+2kWSnsyI9lhWRZwLrvBatVfJiPljAfPX5fuWv8AdNj/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714643; c=relaxed/simple;
	bh=sLV4VwdEiDWAd82RGRz+zCkNDYiQfZf7o6ywhJI41cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRqrC6lv051NM46NAw+PwCq3jhuI2kcUFSEGX0VfTLiGMVFaHeVt3Fa5vcrGfcjhIU18g71XtgVk8NmGqolcCw+HdtIbjXPOephKEtAXZFm/2CuQMJwv0H6UndFdF2coSNjcAfNceVCps9PeDDamj2yz+J5EITAlLn2JQBm3YAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVTMa7OD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVTMa7OD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62225C4AF1D;
	Tue, 18 Jun 2024 12:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714642;
	bh=sLV4VwdEiDWAd82RGRz+zCkNDYiQfZf7o6ywhJI41cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVTMa7OD3wGfJUfQZXktkhDeJxBjgrJB2NWTpw101+ssfIJT1cXxKyA4YTujXQgzZ
	 AIOMnz1Ha4h8lnctjTo3rT53Yru/kRkJoQeewgPSJ4TuvCgP2/NdOKio4q1ILCWnTs
	 vkm6UVynTU6G4DisHzaH3utnZwR5iy22fbjbi1tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/770] SUNRPC: Prepare for xdr_stream-style decoding on the server-side
Date: Tue, 18 Jun 2024 14:27:43 +0200
Message-ID: <20240618123407.689560196@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5191955d6fc65e6d4efe8f4f10a6028298f57281 ]

A "permanent" struct xdr_stream is allocated in struct svc_rqst so
that it is usable by all server-side decoders. A per-rqst scratch
buffer is also allocated to handle decoding XDR data items that
cross page boundaries.

To demonstrate how it will be used, add the first call site for the
new svcxdr_init_decode() API.

As an additional part of the overall conversion, add symbolic
constants for successful and failed XDR operations. Returning "0" is
overloaded. Sometimes it means something failed, but sometimes it
means success. To make it more clear when XDR decoding functions
succeed or fail, introduce symbolic constants.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c           |  2 ++
 include/linux/sunrpc/svc.h | 16 ++++++++++++++++
 net/sunrpc/svc.c           |  5 +++++
 3 files changed, 23 insertions(+)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 2e61a565cdbd8..311b287c5024f 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -1052,6 +1052,8 @@ int nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
 	 * (necessary in the NFSv4.0 compound case)
 	 */
 	rqstp->rq_cachetype = proc->pc_cachetype;
+
+	svcxdr_init_decode(rqstp);
 	if (!proc->pc_decode(rqstp, argv->iov_base))
 		goto out_decode_err;
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index c220b734fa69e..34c2a69820e93 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -247,6 +247,8 @@ struct svc_rqst {
 
 	size_t			rq_xprt_hlen;	/* xprt header len */
 	struct xdr_buf		rq_arg;
+	struct xdr_stream	rq_arg_stream;
+	struct page		*rq_scratch_page;
 	struct xdr_buf		rq_res;
 	struct page		*rq_pages[RPCSVC_MAXPAGES + 1];
 	struct page *		*rq_respages;	/* points into rq_pages */
@@ -557,4 +559,18 @@ static inline void svc_reserve_auth(struct svc_rqst *rqstp, int space)
 	svc_reserve(rqstp, space + rqstp->rq_auth_slack);
 }
 
+/**
+ * svcxdr_init_decode - Prepare an xdr_stream for svc Call decoding
+ * @rqstp: controlling server RPC transaction context
+ *
+ */
+static inline void svcxdr_init_decode(struct svc_rqst *rqstp)
+{
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct kvec *argv = rqstp->rq_arg.head;
+
+	xdr_init_decode(xdr, &rqstp->rq_arg, argv->iov_base, NULL);
+	xdr_set_scratch_page(xdr, rqstp->rq_scratch_page);
+}
+
 #endif /* SUNRPC_SVC_H */
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index e4e4e203ecdad..73e02ba4ed53a 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -614,6 +614,10 @@ svc_rqst_alloc(struct svc_serv *serv, struct svc_pool *pool, int node)
 	rqstp->rq_server = serv;
 	rqstp->rq_pool = pool;
 
+	rqstp->rq_scratch_page = alloc_pages_node(node, GFP_KERNEL, 0);
+	if (!rqstp->rq_scratch_page)
+		goto out_enomem;
+
 	rqstp->rq_argp = kmalloc_node(serv->sv_xdrsize, GFP_KERNEL, node);
 	if (!rqstp->rq_argp)
 		goto out_enomem;
@@ -846,6 +850,7 @@ void
 svc_rqst_free(struct svc_rqst *rqstp)
 {
 	svc_release_buffer(rqstp);
+	put_page(rqstp->rq_scratch_page);
 	kfree(rqstp->rq_resp);
 	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
-- 
2.43.0



