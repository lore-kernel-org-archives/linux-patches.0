Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16FD179659;
	Tue, 18 Jun 2024 12:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715539; cv=none; b=skb25y2xZXN1DBxxG1gLTKm/GsEjml6ODXQYsLI66Cyey/WYzn1a7QyG3iXLZa8DuwMjw7X65usxx4v3GJyQ8h6E4zQAXFep3e/TTbS9TBKIoBnVzsVGEvXn38tzyoUa/zgdqf9MZ2diA9h/1bsyRs/1nRnjqLcHFDZLdmQnu0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715539; c=relaxed/simple;
	bh=AQgVpMot2pt9pM68JLWMy5CkoB4gXrUFTzL7hDi7poY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXStlrY7JHHXZXFI1vPD9Q2oGaaIKx6npq0d1dkAZYSkpi8ry5YHU+3q0fIBW+GvEXo3bQ36CYIOqVFUTCqcbb4fqLhqLVMyH3GLlVDjbX/wwNZKpHpvb/JQjtXprMdd/nVDlSVfPo2DblwYYW1cSPDkhyAqU0Y68jmuQVVlkK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKiyEUYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKiyEUYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D81BC3277B;
	Tue, 18 Jun 2024 12:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715538;
	bh=AQgVpMot2pt9pM68JLWMy5CkoB4gXrUFTzL7hDi7poY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKiyEUYUe19jnYLnli0imBCtCjno+Xeza5VabsIId8GwGw2lcFDbWdRYRBJahjMKQ
	 NgNm4EY87rXilTxHGPCOmHo9Rd7vHZM0Edj10g4qUVA3j0cwFhbrA6v0wWBSCZITdr
	 5dkYbficCFIt0KeySSvVXu0sracPhdNaGXIP3aHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 341/770] SUNRPC: Add svc_rqst_replace_page() API
Date: Tue, 18 Jun 2024 14:33:14 +0200
Message-ID: <20240618123420.429094161@linuxfoundation.org>
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

[ Upstream commit 2f0f88f42f2eab0421ed37d7494de9124fdf0d34 ]

Replacing a page in rq_pages[] requires a get_page(), which is a
bus-locked operation, and a put_page(), which can be even more
costly.

To reduce the cost of replacing a page in rq_pages[], batch the
put_page() operations by collecting "freed" pages in a pagevec,
and then release those pages when the pagevec is full. This
pagevec is also emptied when each RPC completes.

[ cel: adjusted to apply without f6e70aab9dfe ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h |  4 ++++
 net/sunrpc/svc.c           | 21 +++++++++++++++++++++
 net/sunrpc/svc_xprt.c      |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index e91d51ea028bb..ab9afbf0a0d8b 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -19,6 +19,7 @@
 #include <linux/sunrpc/svcauth.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
+#include <linux/pagevec.h>
 
 /* statistics for svc_pool structures */
 struct svc_pool_stats {
@@ -256,6 +257,7 @@ struct svc_rqst {
 	struct page *		*rq_next_page; /* next reply page to use */
 	struct page *		*rq_page_end;  /* one past the last page */
 
+	struct pagevec		rq_pvec;
 	struct kvec		rq_vec[RPCSVC_MAXPAGES]; /* generally useful.. */
 	struct bio_vec		rq_bvec[RPCSVC_MAXPAGES];
 
@@ -502,6 +504,8 @@ struct svc_rqst *svc_rqst_alloc(struct svc_serv *serv,
 					struct svc_pool *pool, int node);
 struct svc_rqst *svc_prepare_thread(struct svc_serv *serv,
 					struct svc_pool *pool, int node);
+void		   svc_rqst_replace_page(struct svc_rqst *rqstp,
+					 struct page *page);
 void		   svc_rqst_free(struct svc_rqst *);
 void		   svc_exit_thread(struct svc_rqst *);
 unsigned int	   svc_pool_map_get(void);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 73e02ba4ed53a..27f98756d1751 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -842,6 +842,27 @@ svc_set_num_threads_sync(struct svc_serv *serv, struct svc_pool *pool, int nrser
 }
 EXPORT_SYMBOL_GPL(svc_set_num_threads_sync);
 
+/**
+ * svc_rqst_replace_page - Replace one page in rq_pages[]
+ * @rqstp: svc_rqst with pages to replace
+ * @page: replacement page
+ *
+ * When replacing a page in rq_pages, batch the release of the
+ * replaced pages to avoid hammering the page allocator.
+ */
+void svc_rqst_replace_page(struct svc_rqst *rqstp, struct page *page)
+{
+	if (*rqstp->rq_next_page) {
+		if (!pagevec_space(&rqstp->rq_pvec))
+			__pagevec_release(&rqstp->rq_pvec);
+		pagevec_add(&rqstp->rq_pvec, *rqstp->rq_next_page);
+	}
+
+	get_page(page);
+	*(rqstp->rq_next_page++) = page;
+}
+EXPORT_SYMBOL_GPL(svc_rqst_replace_page);
+
 /*
  * Called from a server thread as it's exiting. Caller must hold the "service
  * mutex" for the service.
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index d150e25b4d45e..570b092165d73 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -525,6 +525,7 @@ static void svc_xprt_release(struct svc_rqst *rqstp)
 	kfree(rqstp->rq_deferred);
 	rqstp->rq_deferred = NULL;
 
+	pagevec_release(&rqstp->rq_pvec);
 	svc_free_res_pages(rqstp);
 	rqstp->rq_res.page_len = 0;
 	rqstp->rq_res.page_base = 0;
@@ -651,6 +652,8 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 	int pages;
 	int i;
 
+	pagevec_init(&rqstp->rq_pvec);
+
 	/* now allocate needed pages.  If we get a failure, sleep briefly */
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
-- 
2.43.0



