Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EFA5D8E1;
	Tue, 23 Jan 2024 01:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974387; cv=none; b=Jl233tEx0pzOkBdmp0FhuZh2PS/IrRaph583rjq2cDwr2VsO2QvAtOtdzWSlLII76CcgY3LR4HmyhSLM96Nep4XVWhkogY8F1cgDryXDy2awajtO/jooHFK3lw6M2oKNhZqipOsqaltpYpiwuBdgnJH+PfMlZOIys3aS98HFsas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974387; c=relaxed/simple;
	bh=0brcSGPxs2IeSjSL6ezBrIot1BiY2E9GZzAg5AUNw7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEFRfyeKrMdp/GQviZ3AGyhmI/ti1YbKkX3iJ30TE02rc6oOLNnOP+LxvfOE5ye4wEj2w2zp/qJV5L0YtR+ebTo0rFb/+W5ahwNDirRFtozEmvHs5kaiU6K7RbXlRDYk6RIeJtegbVgv6AWQUI+ZW4+N4M/An+gmVlNvN5DVmpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROg3yAEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROg3yAEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D97C433A6;
	Tue, 23 Jan 2024 01:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974387;
	bh=0brcSGPxs2IeSjSL6ezBrIot1BiY2E9GZzAg5AUNw7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROg3yAEBlQ+jNf5b/pJaVWaGb6NWvFJuhr465MXkwWSBf5bQriNBdhDACo1mYXSh6
	 s8Pk983WkxbOaeT9CMebWWlVZVojYYNyjSIvAaWW944YO7dP9N3JZGWvyjwR/NXvrF
	 0G5V3vl8mZL2tzTgtNuaxydVzTSa4T8clsEA56s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Christoph Hellwig <hch@lst.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/583] pNFS: Fix the pnfs block drivers calculation of layoutget size
Date: Mon, 22 Jan 2024 15:52:11 -0800
Message-ID: <20240122235814.603024613@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 84343aefbbd6..9084f156d67b 100644
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



