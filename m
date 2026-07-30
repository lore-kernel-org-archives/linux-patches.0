Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4A5449B27;
	Thu, 30 Jul 2026 15:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425107; cv=none; b=dog4g1+15eD25tAu3yWPqWcpvEHWqV+FSDDTm6TqthPbBaAH0ch4IWgNGoQuq/UZXQHdrxtDWIgGdjI1VerUvevE+kcp0dtq4rEZ2CgZ94t9HnI+uvPslwAg56rD8YPeCDZV3IAkCZt4WaL3uDWUPPtUdxYnDQVTHIqdrxmJBZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425107; c=relaxed/simple;
	bh=Xvbha5TxG6JZ5hIvHE1xhFC3SENPBfyLb7v6sYvI/lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiCz4sUxaNsY64a0ce17u4zNRdncPRkd8PW8t9suFLGAu6sGWBtHsChZH6xQLZrmbrqzbyV+Tl1a/EBV0kjMno23T3DvhDcM7MXqEY7NqPLwk+zImNH0NW4v9oQTsrKi8zBKKd0vJlB8VuamVXdFMI4FH8jHNkgcmX6uUlYGIkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2l2bhgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2l2bhgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65091F000E9;
	Thu, 30 Jul 2026 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425106;
	bh=TAvKBZt8Awf4VFB/f6zoVECAsBuC9Bug/lgFWE0b4q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2l2bhgyB4bPhCKURgOq6fhZ3oggFcPeZyGw1RhyilppTBkdMdrcL1+CzGAae8DER
	 ZaSLTkvAivyC6L2qkUP6jnfkshGjuvIdesCfiaT5mf3G7KcNKgwS65PUgWOvjllJoI
	 xmk4ZKsTHH4k8WHVUwaOpvDyHzY6DlKnv9vOLbkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 626/675] sunrpc: allocate a separate bvec array for socket sends
Date: Thu, 30 Jul 2026 16:15:56 +0200
Message-ID: <20260730141458.431592676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6b3b697d65d46a0f640216a3f6c72856c159c567 ]

svc_tcp_sendmsg() calls xdr_buf_to_bvec() with the second slot of
rq_bvec as the start, but doesn't reduce the array length by one, which
could lead to an array overrun. Also, rq_bvec is always rq_maxpages in
length, which can be too short in some cases, since the TCP record
marker consumes a slot.

Fix both problems by adding a separate bvec array to the svc_sock that
is specifically for sending. For TCP, make this array one slot longer
than rq_maxpages, to account for the record marker. For UDP, only
allocate as large an array as we need since it's limited to 64k of
payload.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 18c1cc698861 ("SUNRPC: Return an error from xdr_buf_to_bvec() on overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svcsock.h |    3 ++
 net/sunrpc/svcsock.c           |   55 +++++++++++++++++++++++++++++++++++------
 2 files changed, 51 insertions(+), 7 deletions(-)

--- a/include/linux/sunrpc/svcsock.h
+++ b/include/linux/sunrpc/svcsock.h
@@ -26,6 +26,9 @@ struct svc_sock {
 	void			(*sk_odata)(struct sock *);
 	void			(*sk_owspace)(struct sock *);
 
+	/* For sends (protected by xpt_mutex) */
+	struct bio_vec		*sk_bvec;
+
 	/* private TCP part */
 	/* On-the-wire fragment header: */
 	__be32			sk_marker;
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -68,6 +68,17 @@
 
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
 
+/*
+ * For UDP:
+ * 1 for header page
+ * enough pages for RPCSVC_MAXPAYLOAD_UDP
+ * 1 in case payload is not aligned
+ * 1 for tail page
+ */
+enum {
+	SUNRPC_MAX_UDP_SENDPAGES = 1 + RPCSVC_MAXPAYLOAD_UDP / PAGE_SIZE + 1 + 1
+};
+
 /* To-do: to avoid tying up an nfsd thread while waiting for a
  * handshake request, the request could instead be deferred.
  */
@@ -750,14 +761,14 @@ static int svc_udp_sendto(struct svc_rqs
 	if (svc_xprt_is_dead(xprt))
 		goto out_notconn;
 
-	count = xdr_buf_to_bvec(rqstp->rq_bvec, rqstp->rq_maxpages, xdr);
+	count = xdr_buf_to_bvec(svsk->sk_bvec, SUNRPC_MAX_UDP_SENDPAGES, xdr);
 
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, svsk->sk_bvec,
 		      count, rqstp->rq_res.len);
 	err = sock_sendmsg(svsk->sk_sock, &msg);
 	if (err == -ECONNREFUSED) {
 		/* ICMP error on earlier request. */
-		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
+		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, svsk->sk_bvec,
 			      count, rqstp->rq_res.len);
 		err = sock_sendmsg(svsk->sk_sock, &msg);
 	}
@@ -1245,19 +1256,19 @@ static int svc_tcp_sendmsg(struct svc_so
 	int ret;
 
 	/* The stream record marker is copied into a temporary page
-	 * fragment buffer so that it can be included in rq_bvec.
+	 * fragment buffer so that it can be included in sk_bvec.
 	 */
 	buf = page_frag_alloc(&svsk->sk_frag_cache, sizeof(marker),
 			      GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	memcpy(buf, &marker, sizeof(marker));
-	bvec_set_virt(rqstp->rq_bvec, buf, sizeof(marker));
+	bvec_set_virt(svsk->sk_bvec, buf, sizeof(marker));
 
-	count = xdr_buf_to_bvec(rqstp->rq_bvec + 1, rqstp->rq_maxpages,
+	count = xdr_buf_to_bvec(svsk->sk_bvec + 1, rqstp->rq_maxpages,
 				&rqstp->rq_res);
 
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, svsk->sk_bvec,
 		      1 + count, sizeof(marker) + rqstp->rq_res.len);
 	ret = sock_sendmsg(svsk->sk_sock, &msg);
 	page_frag_free(buf);
@@ -1402,6 +1413,20 @@ void svc_sock_update_bufs(struct svc_ser
 	spin_unlock_bh(&serv->sv_lock);
 }
 
+static int svc_sock_sendpages(struct svc_serv *serv, struct socket *sock, int flags)
+{
+	switch (sock->type) {
+	case SOCK_STREAM:
+		/* +1 for TCP record marker */
+		if (flags & SVC_SOCK_TEMPORARY)
+			return svc_serv_maxpages(serv) + 1;
+		return 0;
+	case SOCK_DGRAM:
+		return SUNRPC_MAX_UDP_SENDPAGES;
+	}
+	return -EINVAL;
+}
+
 /*
  * Initialize socket for RPC use and create svc_sock struct
  */
@@ -1412,12 +1437,26 @@ static struct svc_sock *svc_setup_socket
 	struct svc_sock	*svsk;
 	struct sock	*inet;
 	int		pmap_register = !(flags & SVC_SOCK_ANONYMOUS);
+	int		sendpages;
 	unsigned long	pages;
 
+	sendpages = svc_sock_sendpages(serv, sock, flags);
+	if (sendpages < 0)
+		return ERR_PTR(sendpages);
+
 	pages = svc_serv_maxpages(serv);
 	svsk = kzalloc(struct_size(svsk, sk_pages, pages), GFP_KERNEL);
 	if (!svsk)
 		return ERR_PTR(-ENOMEM);
+
+	if (sendpages) {
+		svsk->sk_bvec = kcalloc(sendpages, sizeof(*svsk->sk_bvec), GFP_KERNEL);
+		if (!svsk->sk_bvec) {
+			kfree(svsk);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
+
 	svsk->sk_maxpages = pages;
 
 	inet = sock->sk;
@@ -1429,6 +1468,7 @@ static struct svc_sock *svc_setup_socket
 				     inet->sk_protocol,
 				     ntohs(inet_sk(inet)->inet_sport));
 		if (err < 0) {
+			kfree(svsk->sk_bvec);
 			kfree(svsk);
 			return ERR_PTR(err);
 		}
@@ -1646,5 +1686,6 @@ static void svc_sock_free(struct svc_xpr
 		sock_release(sock);
 
 	page_frag_cache_drain(&svsk->sk_frag_cache);
+	kfree(svsk->sk_bvec);
 	kfree(svsk);
 }


