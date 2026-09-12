Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5414341A503;
	Sat, 12 Sep 2026 13:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218953; cv=none; b=kII2em5Y0YpNWjmibk/JJD/vmbzA2n+9XNGToCq6djEFyzOg3jS+yn16vmPouC41vrnXfY0fcqUMYb5muN4TiqIqb5ELXwPFiXHIWfBe7TBeFqwJW+Z6AcsU+HRO48sRto2JfZv8TPeO9gcsfqGYSICH/tnmoZ0+R5pN1VsHHfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218953; c=relaxed/simple;
	bh=68bZaXcQwUgIF3CiYjUr/ikabmAKtfU0Qpc7PvM9MCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMLSnT23gTBk0/3rMhnb0wbSqVvd1PBf+6u/TdA8mo9RoRXV5FUmAeqgoiFzSNtt7yJ8Owl8v7sGmoAupw5l9I8XYtMMp4yoSxmRCW0OHwHhHKzRH1DaRnQQyUq8XgHJB+vvsKshsn2BXFRzoNOClw3+8uZvCDk2fpplcyLeSJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze+rPwFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze+rPwFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272791F000FF;
	Sat, 12 Sep 2026 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218952;
	bh=FWEp91EScgFQy8tcYrmxO+JC3Rm9Bly/6n9ZiC/2sC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ze+rPwFxFRpkRZ1+7P9TaN6CEbg8MRQ+I/9yhBj22XTzpzs7CX8QX7GZrLsRvzay1
	 qX+FhY+m9/97SK9jTT4AYAbWoeLa/V5Gdq8J75D7VZMfFbUa8/99QRmVgmfyQrSjcE
	 2XBcNlvt3Bp7XcyfPSOxC4pg9ajOSKhgF9I+XSSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1208/1376] fuse: support folios in struct fuse_args_pages and fuse_copy_pages()
Date: Sat, 12 Sep 2026 09:00:34 +0200
Message-ID: <20260912065634.473698132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c3e7267517a88..865c857c72aeb 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1023,17 +1023,41 @@ static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
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
index 28cf319c1c25c..a413a44ecff19 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -291,6 +291,12 @@ struct fuse_page_desc {
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
@@ -319,9 +325,19 @@ struct fuse_args {
 
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
 
 struct fuse_release_args {
-- 
2.53.0



