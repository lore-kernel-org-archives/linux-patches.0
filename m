Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA277E111;
	Mon,  8 Apr 2024 13:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583451; cv=none; b=h2zKwiL25Sm9ES+LRKh6OmIyf+Q4j8/gGtpniHh9GErOt6sXQHyiG4ir3WeOI1anH0vOoPd4VDIuV2JaAWrvcm/J35li9LqpxLQLgHefhNS5Xzt4LYmLgVX3y4x+CPsSnNsnMqAalvSdkhoCUfymnEvAl320wUGUl/8JXJ8Z5go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583451; c=relaxed/simple;
	bh=PKB67+WkpO7oKhj3biD2iELSbLn4Wordgb7EXrFVCi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQaalLaJFrdVFuaPevFQOgNTwp21leawbT1u6lHNl2UcmtpaxT0UhiVx3KprFoDbZRpZR9c/8npuVPxAvGYU/LLrg7xsE9QH/JekGfzbskp1vWls0BagIhpXBIlJEOFHWOGJVKjN0gjSPn0JITvj9SAIat4BqtKqanjWZ0OOhGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWIc6Hoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWIc6Hoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEFCC433F1;
	Mon,  8 Apr 2024 13:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583451;
	bh=PKB67+WkpO7oKhj3biD2iELSbLn4Wordgb7EXrFVCi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWIc6HohEr1DKGW1ydIzIDd1d4nBsalIaHdWcDsy7ublnP0Ye0ytlwJmzdDTZ+sDS
	 dPSpFfT+sWHwAj/h9mGoYrb4BHlQnReK8VZO6iSaPrDam4fJrsXD1K8/sXzgaQINsA
	 t/6KSQMPO+EfnDO77IwlsqQUk8zfut+2rkKPMrg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Schunk <scpcom@gmx.de>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Jakub Kacinski <kuba@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/252] SUNRPC: Fix a slow server-side memory leak with RPC-over-TCP
Date: Mon,  8 Apr 2024 14:58:16 +0200
Message-ID: <20240408125312.767899107@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 05258a0a69b3c5d2c003f818702c0a52b6fea861 ]

Jan Schunk reports that his small NFS servers suffer from memory
exhaustion after just a few days. A bisect shows that commit
e18e157bb5c8 ("SUNRPC: Send RPC message on TCP with a single
sock_sendmsg() call") is the first bad commit.

That commit assumed that sock_sendmsg() releases all the pages in
the underlying bio_vec array, but the reality is that it doesn't.
svc_xprt_release() releases the rqst's response pages, but the
record marker page fragment isn't one of those, so it is never
released.

This is a narrow fix that can be applied to stable kernels. A
more extensive fix is in the works.

Reported-by: Jan Schunk <scpcom@gmx.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218671
Fixes: e18e157bb5c8 ("SUNRPC: Send RPC message on TCP with a single sock_sendmsg() call")
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index e0ce4276274be..933e12e3a55c7 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1216,15 +1216,6 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
  * MSG_SPLICE_PAGES is used exclusively to reduce the number of
  * copy operations in this path. Therefore the caller must ensure
  * that the pages backing @xdr are unchanging.
- *
- * Note that the send is non-blocking. The caller has incremented
- * the reference count on each page backing the RPC message, and
- * the network layer will "put" these pages when transmission is
- * complete.
- *
- * This is safe for our RPC services because the memory backing
- * the head and tail components is never kmalloc'd. These always
- * come from pages in the svc_rqst::rq_pages array.
  */
 static int svc_tcp_sendmsg(struct svc_sock *svsk, struct svc_rqst *rqstp,
 			   rpc_fraghdr marker, unsigned int *sentp)
@@ -1254,6 +1245,7 @@ static int svc_tcp_sendmsg(struct svc_sock *svsk, struct svc_rqst *rqstp,
 	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, rqstp->rq_bvec,
 		      1 + count, sizeof(marker) + rqstp->rq_res.len);
 	ret = sock_sendmsg(svsk->sk_sock, &msg);
+	page_frag_free(buf);
 	if (ret < 0)
 		return ret;
 	*sentp += ret;
-- 
2.43.0



