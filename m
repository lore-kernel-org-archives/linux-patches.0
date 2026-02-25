Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8369020C012;
	Wed, 25 Feb 2026 01:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983378; cv=none; b=nxvL87ZLAI1tdW54K8UH4UL9qSzlo1p+YjADdqUnELSm+AA7CkAbSqopmoSz5RarzR6Q91sJoisD15hGtBV+HiyRyUKaDzvQXSf3UIDdEP6lZKqFKaJbNE9en/lzBgYlWBT2wYz3FgrUplEbfO8B7ZarrWCQcBFOVrm/VqbnjXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983378; c=relaxed/simple;
	bh=XRZFchPwgJEKVJXlc1j1OD4DsyUpcw4bi3RNJhClyeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXoHXeLPtmdNokecioJuubiSm4xweEJtBudiN5YmDVofy4eU8LPxsGUlEakzAiXDd0L2QLfuJ70jelMwhqNzjYeeSy8Wt10JwxRg4qhCjuC9uk2Ofq17Z2RcYhIg+FIYB3ZjWkSF/ZArmxFH5TwIkGCPwfDh+LpKI4sLpp8zILc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlRtIuIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlRtIuIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B43C116D0;
	Wed, 25 Feb 2026 01:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983378;
	bh=XRZFchPwgJEKVJXlc1j1OD4DsyUpcw4bi3RNJhClyeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlRtIuIVylT61F8Z/Z4WeOsN8+C3WAohglh0QwXZW4LHQ0fXoXHsu+yuRQh15/ouR
	 CIKx1NxaAgAhHFNOENuN+RUZOmxbZlLwglef0Oby997L+7nNJeDGYXqD/7JJ1TxUC5
	 zpgKj897WkbtTprGhQ/4GR/vOtBWNtoWKxkv5ZmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 502/781] fs/nfs: Fix readdir slow-start regression
Date: Tue, 24 Feb 2026 17:20:11 -0800
Message-ID: <20260225012412.116889896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index e3654f4a1b9aa..571bb40880b2d 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -73,7 +73,7 @@ const struct address_space_operations nfs_dir_aops = {
 	.free_folio = nfs_readdir_clear_array,
 };
 
-#define NFS_INIT_DTSIZE PAGE_SIZE
+#define NFS_INIT_DTSIZE SZ_64K
 
 static struct nfs_open_dir_context *
 alloc_nfs_open_dir_context(struct inode *dir)
@@ -84,7 +84,7 @@ alloc_nfs_open_dir_context(struct inode *dir)
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



