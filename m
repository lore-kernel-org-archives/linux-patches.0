Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C731875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8FFC433EF;
	Wed, 28 Dec 2022 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242933;
	bh=cLdSKwkfEU+/xCMa34CkE1yrdtXpDsiCSfRd3IkF/JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clOAjxNjcjEu7thJxhL+8UeJgKIc9HPk4gvX9YqUwK4UTtVtx2ZDDCvb70dGUjVin
	 TCGEL48MBfOtfOz+iWIzywemqhF7S3pjxkCougt0afvIGwsc2aagZdYrcqNu7VGMOD
	 UkDD7wAJ9srdXAN248551n0RHU/4kcOXRZBmMSv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0471/1073] xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
Date: Wed, 28 Dec 2022 15:34:19 +0100
Message-Id: <20221228144340.829546126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 ]

If rdma receive buffer allocate failed, should call rpcrdma_regbuf_free()
to free the send buffer, otherwise, the buffer data will be leaked.

Fixes: bb93a1ae2bf4 ("xprtrdma: Allocate req's regbufs at xprt create time")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 2fbe9aaeec34..efa7bcdf6b28 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -834,7 +834,7 @@ struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t size,
 	return req;
 
 out3:
-	kfree(req->rl_sendbuf);
+	rpcrdma_regbuf_free(req->rl_sendbuf);
 out2:
 	kfree(req);
 out1:
-- 
2.35.1



