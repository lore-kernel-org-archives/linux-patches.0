Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731C3149010;
	Tue, 23 Jan 2024 00:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969192; cv=none; b=AGBvirpuVJdnxtCoiPNzIFjtIwJ8AZ9bSqdkcb8rRQUb2Pd73glV1XNcbFozA1Zy4WsbiFqibyNubjjSJUR1LlkkAEgb0x3tyX4JS2fwobd49UQOKUm0BdBO5DhZU9XvN0XSICbI9SD9BNHOBIr8jlPazddO4TWJ3dPOt2o7UsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969192; c=relaxed/simple;
	bh=ts/n9xt5/bR/lORKKeQAf8YbCh2/8K5/ok54KUXRHFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7LwnLEX51CS/yH1HCWgZMvy8+P0Nntuhe9DTpGfkOQtrCY4ZwjAGmld1ZifVcqZ015Cxmzedk4KLtGMQzLM+gwr2UpjE7wyNCor0EXA6SWGQrdnrO8rxFqfV9kEBnGXFlrb+pIMb2n/R07ve0XjADxEvW4Wlo+0W0qlyyQV7L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXE7qVgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXE7qVgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099ADC43399;
	Tue, 23 Jan 2024 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969192;
	bh=ts/n9xt5/bR/lORKKeQAf8YbCh2/8K5/ok54KUXRHFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXE7qVguPkV9n3KOKQxObixtsZPB2tU/+NL6p1ediUZ7rQQWAQDHHoQjt56shxgYR
	 VKp3uZD383xrQkhzF23EP9OhN/qC0exntbUYA2KtNtw5AG+57NBU8lWsr8qdfkJbSC
	 pLxwiTd8490RIRZGdWk/xgp4njvPhFXuWMYgMrvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Christoph Hellwig <hch@lst.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 089/641] pNFS: Fix the pnfs block drivers calculation of layoutget size
Date: Mon, 22 Jan 2024 15:49:53 -0800
Message-ID: <20240122235820.824200999@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 8a6291bf3b0eae1bf26621e6419a91682f2d6227 ]

Instead of relying on the value of the 'bytes_left' field, we should
calculate the layout size based on the offset of the request that is
being written out.

Reported-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Fixes: 954998b60caa ("NFS: Fix error handling for O_DIRECT write scheduling")
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/blocklayout.c | 5 ++---
 fs/nfs/direct.c                  | 5 +++--
 fs/nfs/internal.h                | 2 +-
 fs/nfs/pnfs.c                    | 3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 1d1d7abc3205..6be13e0ec170 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -895,10 +895,9 @@ bl_pg_init_write(struct nfs_pageio_descriptor *pgio, struct nfs_page *req)
 	}
 
 	if (pgio->pg_dreq == NULL)
-		wb_size = pnfs_num_cont_bytes(pgio->pg_inode,
-					      req->wb_index);
+		wb_size = pnfs_num_cont_bytes(pgio->pg_inode, req->wb_index);
 	else
-		wb_size = nfs_dreq_bytes_left(pgio->pg_dreq);
+		wb_size = nfs_dreq_bytes_left(pgio->pg_dreq, req_offset(req));
 
 	pnfs_generic_pg_init_write(pgio, req, wb_size);
 
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index f6c74f424691..5918c67dae0d 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -205,9 +205,10 @@ static void nfs_direct_req_release(struct nfs_direct_req *dreq)
 	kref_put(&dreq->kref, nfs_direct_req_free);
 }
 
-ssize_t nfs_dreq_bytes_left(struct nfs_direct_req *dreq)
+ssize_t nfs_dreq_bytes_left(struct nfs_direct_req *dreq, loff_t offset)
 {
-	return dreq->bytes_left;
+	loff_t start = offset - dreq->io_start;
+	return dreq->max_count - start;
 }
 EXPORT_SYMBOL_GPL(nfs_dreq_bytes_left);
 
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 9c9cf764f600..b1fa81c9dff6 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -655,7 +655,7 @@ extern int nfs_sillyrename(struct inode *dir, struct dentry *dentry);
 /* direct.c */
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
 			      struct nfs_direct_req *dreq);
-extern ssize_t nfs_dreq_bytes_left(struct nfs_direct_req *dreq);
+extern ssize_t nfs_dreq_bytes_left(struct nfs_direct_req *dreq, loff_t offset);
 
 /* nfs4proc.c */
 extern struct nfs_client *nfs4_init_client(struct nfs_client *clp,
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 21a365357629..0c0fed1ecd0b 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2733,7 +2733,8 @@ pnfs_generic_pg_init_read(struct nfs_pageio_descriptor *pgio, struct nfs_page *r
 		if (pgio->pg_dreq == NULL)
 			rd_size = i_size_read(pgio->pg_inode) - req_offset(req);
 		else
-			rd_size = nfs_dreq_bytes_left(pgio->pg_dreq);
+			rd_size = nfs_dreq_bytes_left(pgio->pg_dreq,
+						      req_offset(req));
 
 		pgio->pg_lseg =
 			pnfs_update_layout(pgio->pg_inode, nfs_req_openctx(req),
-- 
2.43.0



