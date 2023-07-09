Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1665F46B8
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8641BC433C8;
	Sun,  9 Jul 2023 11:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901489;
	bh=wFVCP8xLdTVwR7tZEWX5SG3VupPhy39YBsBy+xjiscs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4oFR6yIwMB//ro887sBcvRyF1OsMeQ508YjlJpAK0jEo0bwR8YOspuakbDKknKSH
	 drIkxnnn4lJlN6lCs7oqQGIlOwse4tBAWCPGmVqZYmI+LQatlCCy8X3BL1qd2/s6b0
	 NmKd/OA0Dhh1QG1X1UKUgDfRp+6PivgkQqhYoi48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 031/431] svcrdma: Prevent page release when nothing was received
Date: Sun,  9 Jul 2023 13:09:39 +0200
Message-ID: <20230709111451.827225621@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit baf6d18b116b7dc84ed5e212c3a89f17cdc3f28c ]

I noticed that svc_rqst_release_pages() was still unnecessarily
releasing a page when svc_rdma_recvfrom() returns zero.

Fixes: a53d5cb0646a ("svcrdma: Avoid releasing a page in svc_xprt_release()")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index a22fe7587fa6f..70207d8a318a4 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -796,6 +796,12 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 	struct svc_rdma_recv_ctxt *ctxt;
 	int ret;
 
+	/* Prevent svc_xprt_release() from releasing pages in rq_pages
+	 * when returning 0 or an error.
+	 */
+	rqstp->rq_respages = rqstp->rq_pages;
+	rqstp->rq_next_page = rqstp->rq_respages;
+
 	rqstp->rq_xprt_ctxt = NULL;
 
 	ctxt = NULL;
@@ -819,12 +825,6 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 				   DMA_FROM_DEVICE);
 	svc_rdma_build_arg_xdr(rqstp, ctxt);
 
-	/* Prevent svc_xprt_release from releasing pages in rq_pages
-	 * if we return 0 or an error.
-	 */
-	rqstp->rq_respages = rqstp->rq_pages;
-	rqstp->rq_next_page = rqstp->rq_respages;
-
 	ret = svc_rdma_xdr_decode_req(&rqstp->rq_arg, ctxt);
 	if (ret < 0)
 		goto out_err;
-- 
2.39.2



