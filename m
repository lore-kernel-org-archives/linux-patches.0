Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9787646B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E473C433F0;
	Mon, 16 Jan 2023 16:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885895;
	bh=0EZBU+jOBINJ0C8XPYvrDQPUPrSKxPhyN/rlJQXE8hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8MPkbZ45pMzioNCqLYsf3FE/EoLaniYa4Jz2lEp6rn6Cd9mRMRLM3PcMsS0sEYd3
	 +yVDoko3PogMQi8+JpmHCaTM1u3VRFNxEXfo5rkB2B7rLCsENhu6ErqhxDfq/C6475
	 YWCbkHifcPYsgtaiCVoQJHFo5iQodKa9GFXudfDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 185/658] xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
Date: Mon, 16 Jan 2023 16:44:33 +0100
Message-Id: <20230116154917.918263147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
 net/sunrpc/xprtrdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 0f4d39fdb48f..e13115bbe719 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1037,6 +1037,7 @@ struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t size,
 	kfree(req->rl_sendbuf);
 out3:
 	kfree(req->rl_rdmabuf);
+	rpcrdma_regbuf_free(req->rl_sendbuf);
 out2:
 	kfree(req);
 out1:
-- 
2.35.1



