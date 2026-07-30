Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09954503EA;
	Thu, 30 Jul 2026 16:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428281; cv=none; b=r4Ab9n0/9Hadu3mMTUzH5RLySDIbxYk417+XZ3aFDA5T7iP1pHYKxSu4leNzi28puRbqU+7hD7IWjVd0ut+SnZaoDcqKJBAV7Y1E+XdNVmWImaJBkPF9Cf4bO3W0tbkA4vZGpDM9A6TeWlCASvU1TJzSGanq0zUXQMq5wbn9pc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428281; c=relaxed/simple;
	bh=EZ9QIQYCpCfwSM8p6lARpEqZU6YhNKWt1nzlvF9mINk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtsxS7WGNSAzit2B7c0X9AQdw5zwddokHeIZDMCwDz+KyxwEyjtfw+timk9EE9snpupsQNWDJwXtpNuvgmqmeGw+lCZbEY/qSaqNpmfAwMZc/g9OCTECGrmZNx9zy5Pc9/TI0nOAAoAoFu/9o48KoyCUT5htvzeHOYqpjxdUY1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lABUp7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lABUp7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62A91F000E9;
	Thu, 30 Jul 2026 16:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428279;
	bh=6Uhc4oMYkWzOlVRtXy35nth5fbfqimce6rQIOSlfQFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lABUp7uYht1QbiKCXDdCeBlpn228HDmeTCtZY08a0w8vzdjgmNdLfq3irm0CzS0J
	 iLx+wHIC/6tZ8YZPnu+YhfJWVGDqfquO7R6pcmAKcy0mA2XyDmyvi0pBUlbQ2+tGEf
	 Ojqb6rKP3RQGOHocDInb8ay2/ZRg03inissgHPGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 421/484] sunrpc: allocate a separate bvec array for socket sends
Date: Thu, 30 Jul 2026 16:15:18 +0200
Message-ID: <20260730141432.624492986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/sunrpc/svcsock.h |    3 +++
 net/sunrpc/svcsock.c           |   37 ++++++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 9 deletions(-)

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
@@ -750,15 +761,14 @@ static int svc_udp_sendto(struct svc_rqs
 	if (svc_xprt_is_dead(xprt))
 		goto out_notconn;
 
-	count = xdr_buf_to_bvec(rqstp->rq_bvec,
-				ARRAY_SIZE(rqstp->rq_bvec), xdr);
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
@@ -1257,19 +1267,19 @@ static int svc_tcp_sendmsg(struct svc_so
 	*sentp = 0;
 
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
 
-	count = xdr_buf_to_bvec(rqstp->rq_bvec + 1,
-				ARRAY_SIZE(rqstp->rq_bvec) - 1, &rqstp->rq_res);
+	count = xdr_buf_to_bvec(svsk->sk_bvec + 1, RPCSVC_MAXPAGES,
+				&rqstp->rq_res);
 
-	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, svsk->sk_bvec,
 		      1 + count, sizeof(marker) + rqstp->rq_res.len);
 	ret = sock_sendmsg(svsk->sk_sock, &msg);
 	page_frag_free(buf);
@@ -1432,6 +1442,13 @@ static struct svc_sock *svc_setup_socket
 	if (!svsk)
 		return ERR_PTR(-ENOMEM);
 
+	svsk->sk_bvec = kcalloc(RPCSVC_MAXPAGES + 1, sizeof(*svsk->sk_bvec),
+				GFP_KERNEL);
+	if (!svsk->sk_bvec) {
+		kfree(svsk);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	inet = sock->sk;
 
 	if (pmap_register) {
@@ -1441,6 +1458,7 @@ static struct svc_sock *svc_setup_socket
 				     inet->sk_protocol,
 				     ntohs(inet_sk(inet)->inet_sport));
 		if (err < 0) {
+			kfree(svsk->sk_bvec);
 			kfree(svsk);
 			return ERR_PTR(err);
 		}
@@ -1660,5 +1678,6 @@ static void svc_sock_free(struct svc_xpr
 	if (pfc->va)
 		__page_frag_cache_drain(virt_to_head_page(pfc->va),
 					pfc->pagecnt_bias);
+	kfree(svsk->sk_bvec);
 	kfree(svsk);
 }


