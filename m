Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCC4CA6F;
	Sat, 12 Sep 2026 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226052; cv=none; b=QSu3K8TPM4S7To75f0OiVWNxoJVWoOTQIpnZzY7sGLvwyfB9WG9PXAt9xAHZkpCNiDwOqISXTryZumpRqP34MEoaUQv/dXwPu/HjUjXKL2gMxGCmEOhNTh5r5IALsxYL3+NVmjYvaOL+EE/keO9Fc2kMKvC/jwK8k0PYd3AOua4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226052; c=relaxed/simple;
	bh=a9bab2yODPiKMs2nTgSS87kBulXTFfgvFl2+OLLG08g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5xajp9IRrB3TIPEZU7/1bUBAI6R0wavQt4OC/Y99jgMFYo0ljNlE9FMkJe1AADBBTBXrg/qohO2QLSFM8w3solNj1wxTyssIMWNP5/D3bxfFjFHL2f1Sak9rpuECa08i3z84/u1dEAZWND1mEHRzEWnLg2oNiuPoSi0HwvZFhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5kC48eY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5kC48eY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3501F000FF;
	Sat, 12 Sep 2026 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226051;
	bh=HG7d8i+eLHC6X97I34LOxrsSBgassoL59uzpjMESJ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5kC48eY3QIXEajRzXyqWW66iOZrrUgWdvmkTJmZ08aIX6z4c8lYxoxOt52Y4Stdb
	 2s+KXGI+coT1Xu+QBxM+mfKL6p54HsWDJUIPS58mYaMRc1K99+9zclludWlBIGMNzo
	 GnFoFtV8UM+YB1xWPLoTtmt3n6msI02KaI8Nzw7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1280/1424] fuse: support folios in struct fuse_args_pages and fuse_copy_pages()
Date: Sat, 12 Sep 2026 09:01:52 +0200
Message-ID: <20260912065635.939880214@linuxfoundation.org>
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

[ Upstream commit a669c2df36db5fa7a2674ec5ae10548760702f99 ]

This adds support in struct fuse_args_pages and fuse_copy_pages() for
using folios instead of pages for transferring data. Both folios and
pages must be supported right now in struct fuse_args_pages and
fuse_copy_pages() until all request types have been converted to use
folios. Once all have been converted, then
struct fuse_args_pages and fuse_copy_pages() will only support folios.

Right now in fuse, all folios are one page (large folios are not yet
supported). As such, copying folio->page is sufficient for copying
the entire folio in fuse_copy_pages().

No functional changes.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 928f659a3e36 ("fuse: check for NULL root inode in fuse_fill_super_submount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c    | 40 ++++++++++++++++++++++++++++++++--------
 fs/fuse/fuse_i.h | 22 +++++++++++++++++++---
 2 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 252b6697960f2..bfc07ffc6eb75 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -974,17 +974,41 @@ static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
 	struct fuse_req *req = cs->req;
 	struct fuse_args_pages *ap = container_of(req->args, typeof(*ap), args);
 
+	if (ap->uses_folios) {
+		for (i = 0; i < ap->num_folios && (nbytes || zeroing); i++) {
+			int err;
+			unsigned int offset = ap->folio_descs[i].offset;
+			unsigned int count = min(nbytes, ap->folio_descs[i].length);
+			struct page *orig, *pagep;
 
-	for (i = 0; i < ap->num_pages && (nbytes || zeroing); i++) {
-		int err;
-		unsigned int offset = ap->descs[i].offset;
-		unsigned int count = min(nbytes, ap->descs[i].length);
+			orig = pagep = &ap->folios[i]->page;
 
-		err = fuse_copy_page(cs, &ap->pages[i], offset, count, zeroing);
-		if (err)
-			return err;
+			err = fuse_copy_page(cs, &pagep, offset, count, zeroing);
+			if (err)
+				return err;
+
+			nbytes -= count;
+
+			/*
+			 *  fuse_copy_page may have moved a page from a pipe
+			 *  instead of copying into our given page, so update
+			 *  the folios if it was replaced.
+			 */
+			if (pagep != orig)
+				ap->folios[i] = page_folio(pagep);
+		}
+	} else {
+		for (i = 0; i < ap->num_pages && (nbytes || zeroing); i++) {
+			int err;
+			unsigned int offset = ap->descs[i].offset;
+			unsigned int count = min(nbytes, ap->descs[i].length);
 
-		nbytes -= count;
+			err = fuse_copy_page(cs, &ap->pages[i], offset, count, zeroing);
+			if (err)
+				return err;
+
+			nbytes -= count;
+		}
 	}
 	return 0;
 }
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index aa12ff6de7068..7b9a4e10212b0 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -266,6 +266,12 @@ struct fuse_page_desc {
 	unsigned int offset;
 };
 
+/** FUSE folio descriptor */
+struct fuse_folio_desc {
+	unsigned int length;
+	unsigned int offset;
+};
+
 struct fuse_args {
 	uint64_t nodeid;
 	uint32_t opcode;
@@ -290,9 +296,19 @@ struct fuse_args {
 
 struct fuse_args_pages {
 	struct fuse_args args;
-	struct page **pages;
-	struct fuse_page_desc *descs;
-	unsigned int num_pages;
+	union {
+		struct {
+			struct page **pages;
+			struct fuse_page_desc *descs;
+			unsigned int num_pages;
+		};
+		struct {
+			struct folio **folios;
+			struct fuse_folio_desc *folio_descs;
+			unsigned int num_folios;
+		};
+	};
+	bool uses_folios;
 };
 
 #define FUSE_ARGS(args) struct fuse_args args = {}
-- 
2.53.0



