Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BD2359A60
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302429; cv=none; b=FerNXFA0H/0gwy6gaWfyTioP5zzyPwnPFIV8DTvKcfBQ+/bHIfLk1F9dEhrmcTW+xp8T8LK5obxDOjOxVZJstODJI1/Ee6zW0CysjHs8LLuzmGVXRf2xBmVDbZjjZsG/pUF7cv8rdFtZZWy6lD+dGXhnz6+w8U3JJWPJizUKS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302429; c=relaxed/simple;
	bh=NgglbA29/qaiTq20t29CwKlozplJKkFP5QsciWZVSj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAqQN01wR3GfHcwYQyZGwo/zfKNQMh+08hVQtltSZccgfqcYRbVwFU6wY9atQ9F3A0Cf40k8fo11nrw4tWRJmOH8N1gs1F9nVGKKg/g2Scrz/c3HneXXXIi7mprn3NtnSJ9+1/Xc1uRoLbaIoo0OtwXSgbqUcC/lZezMfAY0Ssk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dCOOt5UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dCOOt5UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871A7C19423;
	Sat, 28 Feb 2026 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302429;
	bh=NgglbA29/qaiTq20t29CwKlozplJKkFP5QsciWZVSj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCOOt5UCwlmOAW+/GeGF1R7xQLY6TMZDRSZe/gsdk3RQ08v+U97AeG2yUAWFDHYGK
	 iDPJNWiSw5PK02Yd9BWD07M1CISMwVcXPQVAas3s+CBaD9PZjxhpd184JC13FgktfT
	 UpjSIYmTxVP7Ji+gSRTfkIQoVRw+7GrdLac70rjLCkQYybY+IbJssfxsE5AQxUlqeA
	 9YpGi5KwaRfXtvcEBaQB0RpSzBEZpyYKpXmEJbzD6AysrlqzFLImq4/jKRL/i/g/s0
	 aGeZvDzxiyvLQKFK/Pz8Nw5y8e7QEi5bs7Qw1BKywsUUtn4JOuo1/pXjxplu9GZfxW
	 6K/wEb9/o+5fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/232] fs/nfs: Fix readdir slow-start regression
Date: Sat, 28 Feb 2026 13:10:19 -0500
Message-ID: <20260228181127.1592657-166-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index a89c0528c858e..024b1848c7971 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -70,7 +70,7 @@ const struct address_space_operations nfs_dir_aops = {
 	.free_folio = nfs_readdir_free_folio,
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

