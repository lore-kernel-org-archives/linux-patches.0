Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDC863B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB868C433D2;
	Mon, 20 Feb 2023 13:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900744;
	bh=4BJYpIQX2lfL8CSqrlELwr0VtstnX92bf437lvX5Qhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9GV80ZLknyLGBSK/bp4A4cbmfAu6JhJhHXgzgskCM3/FY+Zpqp8bhT5gJNmIVoFC
	 gZovZ9B/VK2leCEnn/70dKdToAIgghd/9tyZKqzh+fWxlPDyKu9iM0KLgvpitAdsdK
	 vKeX2CmU+axWY8iCBoESCyOZ6OhFq8fBd3Ts4iGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 052/156] xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
Date: Mon, 20 Feb 2023 14:34:56 +0100
Message-Id: <20230220133604.535504919@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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

commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 upstream.

If rdma receive buffer allocate failed, should call rpcrdma_regbuf_free()
to free the send buffer, otherwise, the buffer data will be leaked.

Fixes: bb93a1ae2bf4 ("xprtrdma: Allocate req's regbufs at xprt create time")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[Harshit: Backport to 5.4.y]
Also make the same change for 'req->rl_rdmabuf' at the same time as
this will also have the same memory leak problem as 'req->rl_sendbuf'
(This is because commit b78de1dca00376aaba7a58bb5fe21c1606524abe is not
in 5.4.y)
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/verbs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1034,9 +1034,9 @@ struct rpcrdma_req *rpcrdma_req_create(s
 	return req;
 
 out4:
-	kfree(req->rl_sendbuf);
+	rpcrdma_regbuf_free(req->rl_sendbuf);
 out3:
-	kfree(req->rl_rdmabuf);
+	rpcrdma_regbuf_free(req->rl_rdmabuf);
 out2:
 	kfree(req);
 out1:


