Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1A6171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C2DC433EF;
	Mon, 22 May 2023 19:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784921;
	bh=wvYOVRFexBBDRA9VHdTVEVhGxWLIx++LZGxP1FpRQrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQy8dA7DMY5An+Fdv8n/qYP2xPn7qxOXUkpWi4OcPAV8u1rqI3cA1iMTQ9K6clWm7
	 WWe23CjELs5IvvZNLwRW/KXb3L714UxlOYxXLkoGo3tQR4kCXvgHwcSdzVygUIq5qU
	 7pBle1A3KsEUuTv0geTLrghNpr27WiWfZ8xiLgg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 246/364] SUNRPC: double free xprt_ctxt while still in use
Date: Mon, 22 May 2023 20:09:11 +0100
Message-Id: <20230522190418.847007571@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: NeilBrown <neilb@suse.de>

[ Upstream commit eb8d3a2c809abd73ab0a060fe971d6b9019aa3c1 ]

When an RPC request is deferred, the rq_xprt_ctxt pointer is moved out
of the svc_rqst into the svc_deferred_req.
When the deferred request is revisited, the pointer is copied into
the new svc_rqst - and also remains in the svc_deferred_req.

In the (rare?) case that the request is deferred a second time, the old
svc_deferred_req is reused - it still has all the correct content.
However in that case the rq_xprt_ctxt pointer is NOT cleared so that
when xpo_release_xprt is called, the ctxt is freed (UDP) or possible
added to a free list (RDMA).
When the deferred request is revisited for a second time, it will
reference this ctxt which may be invalid, and the free the object a
second time which is likely to oops.

So change svc_defer() to *always* clear rq_xprt_ctxt, and assert that
the value is now stored in the svc_deferred_req.

Fixes: 773f91b2cf3f ("SUNRPC: Fix NFSD's request deferral on RDMA transports")
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index ba629297da4e2..feab34db870fe 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1224,13 +1224,14 @@ static struct cache_deferred_req *svc_defer(struct cache_req *req)
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 		dr->xprt_ctxt = rqstp->rq_xprt_ctxt;
-		rqstp->rq_xprt_ctxt = NULL;
 
 		/* back up head to the start of the buffer and copy */
 		skip = rqstp->rq_arg.len - rqstp->rq_arg.head[0].iov_len;
 		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base - skip,
 		       dr->argslen << 2);
 	}
+	WARN_ON_ONCE(rqstp->rq_xprt_ctxt != dr->xprt_ctxt);
+	rqstp->rq_xprt_ctxt = NULL;
 	trace_svc_defer(rqstp);
 	svc_xprt_get(rqstp->rq_xprt);
 	dr->xprt = rqstp->rq_xprt;
-- 
2.39.2



