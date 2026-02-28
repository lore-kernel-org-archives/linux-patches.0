Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C56238F63E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302203; cv=none; b=c6i0M0zA3sP1rSaIQzAGi5Ijnlrb2udB7yZgCte8rAPF+4uBhJWZrMK7/FjfLrHl3q6UGXGwjApGtNgiAdmuLcfmM4onuq44R5waUH1g65C9HZNVhWt/EJXYJnkIDt48XgddZWnLMQKorTuu09vS2uJ9v/e0FVZHQ7ZgMVEPCL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302203; c=relaxed/simple;
	bh=bH3DJyzUf2xPIF9uul01P7TnkcV7k3AFEywNe/0EcFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c053C0lC1We7NXVawkSt3dHWSRFPOSXoz92RL4PlILSqFGeKDKlU4iQYLGcMe5GbQJG71nMxiRGtP+b3cexZBACt3QjTbfGls8mp5aZGgItKRTGt532ORgucZklIlzb9R6pkUUdGxI2biheaH8ialrRbFsKFamDQmfKbMb0MMfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCay3Wg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCay3Wg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D162CC2BCAF;
	Sat, 28 Feb 2026 18:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302203;
	bh=bH3DJyzUf2xPIF9uul01P7TnkcV7k3AFEywNe/0EcFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCay3Wg3m2jqNqNN/XWdImtF39FakOLqo41Iy3wp8PlD54FQ0JFqwNT77RNIgD/9o
	 4J26hnHQYnxjlL1GZ8I/6wgkw54EO9870Li06PXFhRMqrpV4WB8udPbrpCDTZoWRFv
	 O/jPo6GVmldCvYRWC9PTg3OmJwcM9drfY60zKcx8CLB+e+ONIFUVoixMB8FFaexYpV
	 0cQrEW/c90xVKlSqPbJvwpRTcAlA4soYSAzU80+FnJZ5BFKTlEwC2fXeaaylMUsbFm
	 15IUD1BsettcQpdF34qDUNEL3DAEJLrFdeg6nP+7cxkYKWWYebDKeIPQ1LKZ/zKIzQ
	 QRwgHlQxHtDrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/283] fs/nfs: Fix readdir slow-start regression
Date: Sat, 28 Feb 2026 13:05:50 -0500
Message-ID: <20260228180709.1583486-208-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 32e922a20d0d4..46f53f40b741a 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -70,7 +70,7 @@ const struct address_space_operations nfs_dir_aops = {
 	.free_folio = nfs_readdir_clear_array,
 };
 
-#define NFS_INIT_DTSIZE PAGE_SIZE
+#define NFS_INIT_DTSIZE SZ_64K
 
 static struct nfs_open_dir_context *
 alloc_nfs_open_dir_context(struct inode *dir)
@@ -81,7 +81,7 @@ alloc_nfs_open_dir_context(struct inode *dir)
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

