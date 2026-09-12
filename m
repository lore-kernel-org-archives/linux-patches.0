Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77751CA6F;
	Sat, 12 Sep 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226057; cv=none; b=TLJLRxzv7+s47FMHOdwj6+N5WRhDbosrLd5beoLphSEhoKHnpKzFnkcm6JlRYlbrOCZ3MvV/14qivJyV0MaJacCzq6t9kDGluuLVsi5vYUYu1v+BWJRE1iTWehVRoTozxjc97sVhXN3NaXAkraZEIaUXL8FD1z2rgxDvoNE0tEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226057; c=relaxed/simple;
	bh=AJq1He3eYOoCvZO8Kr30FlCcqNGX/W0Oe2w4le1B7g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICcD41q64U6FHJ+TolUQtCWZv8m2M9yKc5bq+cct+AD/AHXPlEN0nOY6HH7bD7rVPpTlTFAKnr4FEXVY3HhhOO18siXRgsMvF7Lssrf+7QVwAG4Arz8Q6OUaMHxArk2O5sYACj9zggu74jb4+91C8IePmMJlIg0+umhp9y+YZ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5Vm3sUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5Vm3sUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172C31F000FF;
	Sat, 12 Sep 2026 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226056;
	bh=8fAw07bdVwy9o8G8ljt4ws+uW8HvUASoYSu5CZRZmmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5Vm3sUNQPm+eEGFIBoVtks8Nf2EC/aiWZpJsJpLsnOhqXo5enpODnfjQ/YK3Dj04
	 KzlGKfThVTydE6c0FDTTKRODuZ6Q/ygfZ4qy89N1JwBo+AcNmULaxNMGgnc1GyIx6b
	 oN135Mg1J/OwpScrpSQeXL44I4JG9vulsIip3tVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1281/1424] fuse: convert readdir to use folios
Date: Sat, 12 Sep 2026 09:01:53 +0200
Message-ID: <20260912065635.962253316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 02b78c7a7a0c72aee6f600a167e6adee9417ac0e ]

Convert readdir requests to use a folio instead of a page.

No functional changes.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 928f659a3e36 ("fuse: check for NULL root inode in fuse_fill_super_submount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/readdir.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index fca0671322afd..f4653df0ba01c 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -335,24 +335,25 @@ static int fuse_readdir_uncached(struct file *file, struct dir_context *ctx)
 {
 	int plus;
 	ssize_t res;
-	struct page *page;
+	struct folio *folio;
 	struct inode *inode = file_inode(file);
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_io_args ia = {};
 	struct fuse_args_pages *ap = &ia.ap;
-	struct fuse_page_desc desc = { .length = PAGE_SIZE };
+	struct fuse_folio_desc desc = { .length = PAGE_SIZE };
 	u64 attr_version = 0;
 	bool locked;
 
-	page = alloc_page(GFP_KERNEL);
-	if (!page)
+	folio = folio_alloc(GFP_KERNEL, 0);
+	if (!folio)
 		return -ENOMEM;
 
 	plus = fuse_use_readdirplus(inode, ctx);
 	ap->args.out_pages = true;
-	ap->num_pages = 1;
-	ap->pages = &page;
-	ap->descs = &desc;
+	ap->uses_folios = true;
+	ap->num_folios = 1;
+	ap->folios = &folio;
+	ap->folio_descs = &desc;
 	if (plus) {
 		attr_version = fuse_get_attr_version(fm->fc);
 		fuse_read_args_fill(&ia, file, ctx->pos, PAGE_SIZE,
@@ -371,15 +372,15 @@ static int fuse_readdir_uncached(struct file *file, struct dir_context *ctx)
 			if (ff->open_flags & FOPEN_CACHE_DIR)
 				fuse_readdir_cache_end(file, ctx->pos);
 		} else if (plus) {
-			res = parse_dirplusfile(page_address(page), res,
+			res = parse_dirplusfile(folio_address(folio), res,
 						file, ctx, attr_version);
 		} else {
-			res = parse_dirfile(page_address(page), res, file,
+			res = parse_dirfile(folio_address(folio), res, file,
 					    ctx);
 		}
 	}
 
-	__free_page(page);
+	folio_put(folio);
 	fuse_invalidate_atime(inode);
 	return res;
 }
-- 
2.53.0



