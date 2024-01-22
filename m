Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0956F54BD2;
	Tue, 23 Jan 2024 00:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970611; cv=none; b=d/7TuUFVQCc8fUbeWakVS2eJU72tGPKNpKomXURrC/JFkfYS0sLy08/44MGSsYqVt9c+o/XzovWHrBZ868B48MWSYun3PrpBzxwIk05EWRCc9h8pyaP1x8KFgoLD0snbvdPJ1vxbHxUH7GKUBZakGeIlZ9dOag565IzAtwfK6Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970611; c=relaxed/simple;
	bh=pOhraDwCzhL4PE70rWbgCxJiPLdY8JaQmuVQ6mfRd9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4c7CYIdTMke5jL4MW/gGw87D2Gp+Ytc6H1VGtlFey6KaEY4tzRlUAicN+UgC+RM2/ipWn+6GpGvLQk51xKvplayd4Z+zYBJ31vXW3WXks66O+i9kWdjKDyABiQ7B64OoDyxlXZpl+EhOWOqojUf9DU5GIRbm22hfHpSyl4F0xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSNu6vMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSNu6vMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC28C433C7;
	Tue, 23 Jan 2024 00:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970610;
	bh=pOhraDwCzhL4PE70rWbgCxJiPLdY8JaQmuVQ6mfRd9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSNu6vMerKSlgH/TMszB+2ZL0DgUDnQ6/EWEujaunPXPyyHbd0znaA/WHX3uk6UfD
	 UyvtX6TDNOUAAkDoAk8ejSVj48W7m7oXovApJoi9bbm3TNP8p4lP3tkJUHeAR4EmFQ
	 p2TJ0PUPP/2d21cFr3uPaOJHG8i8YActfTnTpEpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Christoph Hellwig <hch@lst.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/417] pNFS: Fix the pnfs block drivers calculation of layoutget size
Date: Mon, 22 Jan 2024 15:53:55 -0800
Message-ID: <20240122235754.031354977@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index 3bb530d4bb5c..8fdb65e1b14a 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -195,9 +195,10 @@ static void nfs_direct_req_release(struct nfs_direct_req *dreq)
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
index 4b07a0508f9d..35a8ae46b6c3 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -640,7 +640,7 @@ extern int nfs_sillyrename(struct inode *dir, struct dentry *dentry);
 /* direct.c */
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
 			      struct nfs_direct_req *dreq);
-extern ssize_t nfs_dreq_bytes_left(struct nfs_direct_req *dreq);
+extern ssize_t nfs_dreq_bytes_left(struct nfs_direct_req *dreq, loff_t offset);
 
 /* nfs4proc.c */
 extern struct nfs_client *nfs4_init_client(struct nfs_client *clp,
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 1ffb1068216b..4448ff829cbb 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2729,7 +2729,8 @@ pnfs_generic_pg_init_read(struct nfs_pageio_descriptor *pgio, struct nfs_page *r
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



