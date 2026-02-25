Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49D12D8396;
	Wed, 25 Feb 2026 06:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002632; cv=none; b=S8mP6OIXAUlJo6fsE7AxRbuBnou4InHFAPmkrtjlVUlJ9DfmhVKa+BaJfNIuSCtdOzzvkHhkLNTsIBsN+Lpr3EKe6vks2ZjY3eemYhr8symjNMDdUP6xh8a/3bvJZegBZ+kBq8DPl2JgdLNALG/nn58xr5rpbzv3cb7RRCEaDhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002632; c=relaxed/simple;
	bh=vLkxfcfHlh4d861hYX8AA7sEOW+BylNM5mQdJeu8Zxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVR6v5D7ZTv0/zdCay464Ld96hWTYo8A64sjjUWegxKRNRSbLSjgxlhCXllVpRTrvfsdz8wFugsbwgOFdmiV36ZFOf2yqcM6XoHMZ95hNEngj153lNMzUsthuee8EZL3nu5lj1aRnejV98XyIAbrKVwGlDNiWKbjQQjQ7zd+fDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEvpdLEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEvpdLEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44784C116D0;
	Wed, 25 Feb 2026 06:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002632;
	bh=vLkxfcfHlh4d861hYX8AA7sEOW+BylNM5mQdJeu8Zxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEvpdLEZe85lwcWRkSQD2PBw/wllmCD0in0HNjKw7i9P7t2CHh2eIcbwnb76Ri9mS
	 2lhmmq68+2qKOLTUUICg/PIH0/cT/MzAoB1UCaRLJBX5aagsfJRhN8CA8P7dIh8uhI
	 uiEIROb6ngQagbrroWVkweuV94dnMk9Ms7Ek4D1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 395/641] fs/nfs: Fix readdir slow-start regression
Date: Tue, 24 Feb 2026 17:22:01 -0800
Message-ID: <20260225012358.146049561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3b8250ee01412..a653a401b7970 100644
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



