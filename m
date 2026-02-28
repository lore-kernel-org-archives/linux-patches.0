Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B12533A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301870; cv=none; b=odMLfxj31j1tKhuOXtPtDHyJE/TUKfnBbv3/5T+7+TydVbWl9h2PM6TrMJI3NJV/kXWgGh7C5FkT//RMPFsu5137cfRqVxtO1iQjXtqaQlIWz75fC2W/gLwRcliG3fWdunXBSNJmwdehGdpFkThJnECmTfmCVqO0aGLCgPyPONM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301870; c=relaxed/simple;
	bh=6Iw05c8N0YOmWYXwFkmvcDTZobgEsNAsLAyC5tA6dOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIdAzafex7vJWuTXWNQAZKYDQkY5ivewwPu0lm0HF3XK5B2dlMlJiTNO6TMgIMYCazCSrr4bhHjSGszNvqk6EJ+8Gdq/V+nhpqo36rfArhVcpVim4ioVbMCS1goehET3Onkz2MOTQ8QOmuqL3dthOK8h0XS1fD4wlCHSDFr3XUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxMOY38l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxMOY38l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A94C19423;
	Sat, 28 Feb 2026 18:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301870;
	bh=6Iw05c8N0YOmWYXwFkmvcDTZobgEsNAsLAyC5tA6dOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxMOY38lFkRywNSQ9QGwAj/yGhBLe1xeQAh+dGfWQjw/xIeaWndHFgNfRzPcOHaBp
	 ZClssBBvM+3RcaETLoGagSGhnUXvcP2NrLYIo+SZvqZ1HGOB9chGczCgl7g4cP4f0n
	 JvihEO0YxD6FgwIIinAEhi8EyhgB5Rp/EVcdTdJbj2f/yMtXRZ2SuF26OcRvKaiLxk
	 qTcCTioRQFhCPkEkLi84go6HqjN2Jplzbj4evnpk5vSBl8oFOtLtqOHC5uIJFm7D2E
	 DA0iuMvrT0AEHo7dqB4oBJ3rGNnZ+zJ4PrabxD6JReVs6FVUyScZ1NsN+fp5wpyk57
	 4/BCOZoDQQDOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/385] fs/nfs: Fix readdir slow-start regression
Date: Sat, 28 Feb 2026 12:58:36 -0500
Message-ID: <20260228180011.1568201-294-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 42e7c876b182da65723700f6bc507a8aecb10d3b ]

Commit 580f236737d1 ("NFS: Adjust the amount of readahead
performed by NFS readdir") reduces the amount of readahead names
caching done by the client.

The downside of this approach is READDIR now may suffer from
a slow-start issue, where initially it will fetch names that fit
in a single page, then in 2, 4, 8 until the maximum supported
transfer size (usually 1M).

This patch tries to take a balanced approach between mitigating
the slow-start issue still maintaining some efficiency gains.

Fixes: 580f236737d1 ("NFS: Adjust the amount of readahead performed by NFS readdir")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 1cf1b2ddbf549..5b90f8727e683 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -72,7 +72,7 @@ const struct address_space_operations nfs_dir_aops = {
 	.free_folio = nfs_readdir_clear_array,
 };
 
-#define NFS_INIT_DTSIZE PAGE_SIZE
+#define NFS_INIT_DTSIZE SZ_64K
 
 static struct nfs_open_dir_context *
 alloc_nfs_open_dir_context(struct inode *dir)
@@ -83,7 +83,7 @@ alloc_nfs_open_dir_context(struct inode *dir)
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
 	if (ctx != NULL) {
 		ctx->attr_gencount = nfsi->attr_gencount;
-		ctx->dtsize = NFS_INIT_DTSIZE;
+		ctx->dtsize = min(NFS_SERVER(dir)->dtsize, NFS_INIT_DTSIZE);
 		spin_lock(&dir->i_lock);
 		if (list_empty(&nfsi->open_files) &&
 		    (nfsi->cache_validity & NFS_INO_DATA_INVAL_DEFER))
-- 
2.51.0

