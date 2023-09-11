Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736D512B6D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CEDC433C8;
	Mon, 11 Sep 2023 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446141;
	bh=QKW5moZwJ55K18Sw3B15gqWCQY7GiAeC1bZxRr0WxOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfkMpv5CsDVv+H+MLHfqA3oGJck6nv6g06sYI+tvRpQ1FV6gjw624kFkH4p2TjHei
	 78xjv0HBO8UA6DPstq/4vAIjqa1sOMQqBID3sbCTzl8GFZzVZVt1mqsIQz5bYMmMsO
	 gKfbJuJqk+iB+pDnh5rSa8e4akRUMCXPCWPW9TmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.1 596/600] NFSv4.2: Rework scratch handling for READ_PLUS (again)
Date: Mon, 11 Sep 2023 15:50:29 +0200
Message-ID: <20230911134651.250569572@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

commit 303a78052091c81e9003915c521fdca1c7e117af upstream.

I found that the read code might send multiple requests using the same
nfs_pgio_header, but nfs4_proc_read_setup() is only called once. This is
how we ended up occasionally double-freeing the scratch buffer, but also
means we set a NULL pointer but non-zero length to the xdr scratch
buffer. This results in an oops the first time decoding needs to copy
something to scratch, which frequently happens when decoding READ_PLUS
hole segments.

I fix this by moving scratch handling into the pageio read code. I
provide a function to allocate scratch space for decoding read replies,
and free the scratch buffer when the nfs_pgio_header is freed.

Fixes: fbd2a05f29a9 (NFSv4.2: Rework scratch handling for READ_PLUS)
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |    1 +
 fs/nfs/nfs42.h    |    1 +
 fs/nfs/nfs42xdr.c |    2 +-
 fs/nfs/nfs4proc.c |   13 +------------
 fs/nfs/read.c     |   10 ++++++++++
 5 files changed, 14 insertions(+), 13 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -484,6 +484,7 @@ struct nfs_pgio_completion_ops;
 extern void nfs_pageio_init_read(struct nfs_pageio_descriptor *pgio,
 			struct inode *inode, bool force_mds,
 			const struct nfs_pgio_completion_ops *compl_ops);
+extern bool nfs_read_alloc_scratch(struct nfs_pgio_header *hdr, size_t size);
 extern void nfs_read_prepare(struct rpc_task *task, void *calldata);
 extern void nfs_pageio_reset_read_mds(struct nfs_pageio_descriptor *pgio);
 
--- a/fs/nfs/nfs42.h
+++ b/fs/nfs/nfs42.h
@@ -13,6 +13,7 @@
  * more? Need to consider not to pre-alloc too much for a compound.
  */
 #define PNFS_LAYOUTSTATS_MAXDEV (4)
+#define READ_PLUS_SCRATCH_SIZE (16)
 
 /* nfs4.2proc.c */
 #ifdef CONFIG_NFS_V4_2
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -1351,7 +1351,7 @@ static int nfs4_xdr_dec_read_plus(struct
 	struct compound_hdr hdr;
 	int status;
 
-	xdr_set_scratch_buffer(xdr, res->scratch, sizeof(res->scratch));
+	xdr_set_scratch_buffer(xdr, res->scratch, READ_PLUS_SCRATCH_SIZE);
 
 	status = decode_compound_hdr(xdr, &hdr);
 	if (status)
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5444,18 +5444,8 @@ static bool nfs4_read_plus_not_supported
 	return false;
 }
 
-static inline void nfs4_read_plus_scratch_free(struct nfs_pgio_header *hdr)
-{
-	if (hdr->res.scratch) {
-		kfree(hdr->res.scratch);
-		hdr->res.scratch = NULL;
-	}
-}
-
 static int nfs4_read_done(struct rpc_task *task, struct nfs_pgio_header *hdr)
 {
-	nfs4_read_plus_scratch_free(hdr);
-
 	if (!nfs4_sequence_done(task, &hdr->res.seq_res))
 		return -EAGAIN;
 	if (nfs4_read_stateid_changed(task, &hdr->args))
@@ -5475,8 +5465,7 @@ static bool nfs42_read_plus_support(stru
 	/* Note: We don't use READ_PLUS with pNFS yet */
 	if (nfs_server_capable(hdr->inode, NFS_CAP_READ_PLUS) && !hdr->ds_clp) {
 		msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_READ_PLUS];
-		hdr->res.scratch = kmalloc(32, GFP_KERNEL);
-		return hdr->res.scratch != NULL;
+		return nfs_read_alloc_scratch(hdr, READ_PLUS_SCRATCH_SIZE);
 	}
 	return false;
 }
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -47,6 +47,8 @@ static struct nfs_pgio_header *nfs_readh
 
 static void nfs_readhdr_free(struct nfs_pgio_header *rhdr)
 {
+	if (rhdr->res.scratch != NULL)
+		kfree(rhdr->res.scratch);
 	kmem_cache_free(nfs_rdata_cachep, rhdr);
 }
 
@@ -109,6 +111,14 @@ void nfs_pageio_reset_read_mds(struct nf
 }
 EXPORT_SYMBOL_GPL(nfs_pageio_reset_read_mds);
 
+bool nfs_read_alloc_scratch(struct nfs_pgio_header *hdr, size_t size)
+{
+	WARN_ON(hdr->res.scratch != NULL);
+	hdr->res.scratch = kmalloc(size, GFP_KERNEL);
+	return hdr->res.scratch != NULL;
+}
+EXPORT_SYMBOL_GPL(nfs_read_alloc_scratch);
+
 static void nfs_readpage_release(struct nfs_page *req, int error)
 {
 	struct inode *inode = d_inode(nfs_req_openctx(req)->dentry);


