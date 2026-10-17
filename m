Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC333A1E92;
	Sat, 17 Oct 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259680; cv=none; b=CDxe2mhIqP138Aam29DhxgYPqfVO06dDXlgojzq1AtrG2fldF0KjNcmPAZP73vlVNly7O6fgPn7lJRXQ8+KORlxZcpGtMoYDzrycju+u7xk0jmi5ta/3gMCC9RoTg2B3PwLFHEDj3xzGJStZW4CSuAAfykr1mfhp86vkCZgSpPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259680; c=relaxed/simple;
	bh=JvyyXitISugYQj+ezTeWWHLLudatHCiePvccEqJVMuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYr/88QBKgwhTL4KRGFg9FpAJDrwDRa5F4isIQnLBGw2u82ReXov+w2U5/Q0Dqm0CxKY9jQ8q080R4hWdO5Od5IztBmmy7rJF4L92LVc4FShUHrowj3D1xhJjm2w7AHnuFsrq/ABNTvrOxLWD4cwhzIsh6tZaCsMSauI/YGjDUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQKOgisK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQKOgisK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9099F1F000C4;
	Sat, 17 Oct 2026 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259679;
	bh=RbibNxRf7v9zYfofHRKADfEvID7dg8xwnvQGTvXbui4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQKOgisKsSm4Mtyll45LlsNfXoRtp65Hjx7ZAAoE3dSKar5nMqWTh88Hu5e9f3csE
	 IKnUDp72whTuMNSAnwLgeCJ2MfokNfL7bsBDdhPAtdErAh7nSRFYuy2iLeRIqrmt6h
	 zsQKa7FRxmLGn/apjnqkwgJC1pUNP4cyBjDkSu+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1295/1674] SUNRPC: Update svcxdr_init_decode() to call xdr_set_scratch_folio()
Date: Sat, 17 Oct 2026 17:59:27 +0200
Message-ID: <20261017160504.386227283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Anna Schumaker <anna.schumaker@oracle.com>

[ Upstream commit d57e43b72bf2071caac90da323849c3983a695f0 ]

The only snag here is that __folio_alloc_node() doesn't handle
NUMA_NO_NODE, so I also need to update svc_pool_map_get_node() to return
numa_mem_id() instead. I arrived at this approach by  looking at what
other users of __folio_alloc_node() do for this case.

Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: c479bde671cb ("sunrpc: defer rq_argp and rq_resp free until after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h |  4 ++--
 net/sunrpc/svc.c           | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index e1afc35e961d1..b9fcacb3902b2 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -206,7 +206,7 @@ struct svc_rqst {
 	struct xdr_buf		rq_arg;
 	struct xdr_stream	rq_arg_stream;
 	struct xdr_stream	rq_res_stream;
-	struct page		*rq_scratch_page;
+	struct folio		*rq_scratch_folio;
 	struct xdr_buf		rq_res;
 	struct page		*rq_pages[RPCSVC_MAXPAGES + 1];
 	struct page *		*rq_respages;	/* points into rq_pages */
@@ -469,7 +469,7 @@ static inline void svcxdr_init_decode(struct svc_rqst *rqstp)
 	buf->len = buf->head->iov_len + buf->page_len + buf->tail->iov_len;
 
 	xdr_init_decode(xdr, buf, argv->iov_base, NULL);
-	xdr_set_scratch_page(xdr, rqstp->rq_scratch_page);
+	xdr_set_scratch_folio(xdr, rqstp->rq_scratch_folio);
 }
 
 /**
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index a5e73b6959373..145ba93a9c019 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -366,7 +366,7 @@ static int svc_pool_map_get_node(unsigned int pidx)
 		if (m->mode == SVC_POOL_PERNODE)
 			return m->pool_to[pidx];
 	}
-	return NUMA_NO_NODE;
+	return numa_mem_id();
 }
 /*
  * Set the given thread's cpus_allowed mask so that it
@@ -742,8 +742,8 @@ svc_rqst_free(struct svc_rqst *rqstp)
 {
 	folio_batch_release(&rqstp->rq_fbatch);
 	svc_release_buffer(rqstp);
-	if (rqstp->rq_scratch_page)
-		put_page(rqstp->rq_scratch_page);
+	if (rqstp->rq_scratch_folio)
+		folio_put(rqstp->rq_scratch_folio);
 	kfree(rqstp->rq_resp);
 	kfree(rqstp->rq_argp);
 	kfree(rqstp->rq_auth_data);
@@ -765,8 +765,8 @@ svc_rqst_alloc(struct svc_serv *serv, struct svc_pool *pool, int node)
 	rqstp->rq_server = serv;
 	rqstp->rq_pool = pool;
 
-	rqstp->rq_scratch_page = alloc_pages_node(node, GFP_KERNEL, 0);
-	if (!rqstp->rq_scratch_page)
+	rqstp->rq_scratch_folio = __folio_alloc_node(GFP_KERNEL, 0, node);
+	if (!rqstp->rq_scratch_folio)
 		goto out_enomem;
 
 	rqstp->rq_argp = kmalloc_node(serv->sv_xdrsize, GFP_KERNEL, node);
-- 
2.53.0



