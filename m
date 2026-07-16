Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB97332604;
	Thu, 16 Jul 2026 14:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211597; cv=none; b=pI9s0YnOwb3PvuELmoJqPtpxcvaB6CuZHFzT25zrSkbduco0HdHIuF0iteqFEd8O9qy6SHXxS4mx/zGj65dJC6qIVuF2PBiZyoFBbsm9LgVsb9h8RYt6dgVw6HwQgkxRZ6qvVR/GsMQPg3nlXTCIuQ30QU4xZkaA3caK2r1pfGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211597; c=relaxed/simple;
	bh=23z/xQH4zyebIqIq/bBrz6Ec4jU94vjyE1uaYACM7Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKnkP5KufRduqG/Oz/6U3J82fAfDVEnfizDH0dkAQIz/Q7RamF+YtgayUPs+ztkDk6KDz5pKKiMDN2oea6raMPzsDyE0SLxyHqspqq59CKP/lMEQoS7eP8pxLVq4d+FxCWhW1MFCFDed09cbGMdd2NZEsjnhuHqqTxZXJgjbn20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt1uS0Lt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt1uS0Lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF4F1F000E9;
	Thu, 16 Jul 2026 14:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211595;
	bh=/IEnvs/nmtuzzep22sPDhDbNdikfYnrcaZut9FoS2mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dt1uS0LtvAW8OZ0hTLZquxeHDeMZyzQ4QvhirqY+RnPwn2oNpmJ5mSCxEIQJR+RDN
	 pYD4gCYKc9pZ5OxafinDTcwDxDEnKS9iksaXgjboBJrwDYMAPZGXe9ulqHyPEQwRne
	 lKluNVcbTqnu1ptKvJUu5QCUZ6VT7959gVBxsZ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew R. Ochs" <mochs@nvidia.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 462/480] fuse: back uncached readdir buffers with pages
Date: Thu, 16 Jul 2026 15:33:29 +0200
Message-ID: <20260716133054.818535751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Matthew R. Ochs <mochs@nvidia.com>

commit 4dd6f6d3085a84e74b0a1efec3a05ed0b5125dce upstream.

Commit dabb90391028 ("fuse: increase readdir buffer size") changed
fuse_readdir_uncached() to size its temporary buffer from ctx->count.
This is useful for overlayfs and other in-kernel callers that use
INT_MAX to indicate an unlimited directory read.

The larger buffer is currently supplied as a kvec output argument. For
virtiofs, kvec arguments are copied through req->argbuf, which is
allocated with kmalloc(..., GFP_ATOMIC). A large uncached readdir buffer
can therefore require a multi-megabyte contiguous atomic allocation
before the request is queued.

Avoid the large bounce-buffer allocation by backing uncached readdir
output with pages and setting out_pages. Transports such as virtiofs can
then pass the pages as scatter-gather entries instead of copying the
output through argbuf.

Map the pages with vm_map_ram() only while parsing the returned dirents.
The existing parser can then continue to use a linear kernel mapping.

[SzM: separate allocation of pages into a helper function]

Fixes: dabb90391028 ("fuse: increase readdir buffer size")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew R. Ochs <mochs@nvidia.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/readdir.c |   85 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 18 deletions(-)

--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -12,6 +12,7 @@
 #include <linux/posix_acl.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
+#include <linux/vmalloc.h>
 
 static bool fuse_use_readdirplus(struct inode *dir, struct dir_context *ctx)
 {
@@ -335,6 +336,43 @@ static int parse_dirplusfile(char *buf,
 	return 0;
 }
 
+static struct page **fuse_readdir_alloc_buf(struct fuse_args_pages *ap, size_t *bufsize)
+{
+	unsigned int i, nr_alloc, nr_pages = DIV_ROUND_UP(*bufsize, PAGE_SIZE);
+	struct page **pages = kcalloc(nr_pages, sizeof(*pages), GFP_KERNEL);
+
+	if (!pages)
+		return NULL;
+
+	nr_alloc = alloc_pages_bulk(GFP_KERNEL, nr_pages, pages);
+	if (!nr_alloc)
+		goto free_array;
+
+	if (nr_alloc < nr_pages) {
+		nr_pages = nr_alloc;
+		*bufsize = (size_t) nr_pages << PAGE_SHIFT;
+	}
+
+	ap->folios = fuse_folios_alloc(nr_pages, GFP_KERNEL, &ap->descs);
+	if (!ap->folios)
+		goto release_pages;
+
+	for (i = 0; i < nr_pages; i++) {
+		ap->folios[i] = page_folio(pages[i]);
+		ap->descs[i].length = min_t(size_t, *bufsize - (size_t)i * PAGE_SIZE, PAGE_SIZE);
+	}
+	ap->num_folios = nr_pages;
+	ap->args.out_pages = true;
+
+	return pages;
+
+release_pages:
+	release_pages(pages, nr_pages);
+free_array:
+	kfree(pages);
+	return NULL;
+}
+
 static int fuse_readdir_uncached(struct file *file, struct dir_context *ctx)
 {
 	int plus;
@@ -343,18 +381,16 @@ static int fuse_readdir_uncached(struct
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_conn *fc = fm->fc;
 	struct fuse_io_args ia = {};
-	struct fuse_args *args = &ia.ap.args;
+	struct fuse_args_pages *ap = &ia.ap;
 	void *buf;
 	size_t bufsize = clamp((unsigned int) ctx->count, PAGE_SIZE, fc->max_pages << PAGE_SHIFT);
 	u64 attr_version = 0, evict_ctr = 0;
 	bool locked;
+	struct page **pages = fuse_readdir_alloc_buf(ap, &bufsize);
 
-	buf = kvmalloc(bufsize, GFP_KERNEL);
-	if (!buf)
+	if (!pages)
 		return -ENOMEM;
 
-	args->out_args[0].value = buf;
-
 	plus = fuse_use_readdirplus(inode, ctx);
 	if (plus) {
 		attr_version = fuse_get_attr_version(fm->fc);
@@ -364,24 +400,37 @@ static int fuse_readdir_uncached(struct
 		fuse_read_args_fill(&ia, file, ctx->pos, bufsize, FUSE_READDIR);
 	}
 	locked = fuse_lock_inode(inode);
-	res = fuse_simple_request(fm, args);
+	res = fuse_simple_request(fm, &ap->args);
 	fuse_unlock_inode(inode, locked);
-	if (res >= 0) {
-		if (!res) {
-			struct fuse_file *ff = file->private_data;
-
-			if (ff->open_flags & FOPEN_CACHE_DIR)
-				fuse_readdir_cache_end(file, ctx->pos);
-		} else if (plus) {
-			res = parse_dirplusfile(buf, res, file, ctx, attr_version,
-						evict_ctr);
-		} else {
+	if (res < 0)
+		goto out;
+
+	if (!res) {
+		struct fuse_file *ff = file->private_data;
+
+		if (ff->open_flags & FOPEN_CACHE_DIR)
+			fuse_readdir_cache_end(file, ctx->pos);
+		goto out;
+	}
+
+	buf = vm_map_ram(pages, ap->num_folios, -1);
+	if (!buf) {
+		res = -ENOMEM;
+	} else {
+		if (plus)
+			res = parse_dirplusfile(buf, res, file, ctx, attr_version, evict_ctr);
+		else
 			res = parse_dirfile(buf, res, file, ctx);
-		}
+
+		vm_unmap_ram(buf, ap->num_folios);
 	}
+out:
+	kfree(ap->folios);
+	release_pages(pages, ap->num_folios);
+	kfree(pages);
 
-	kvfree(buf);
 	fuse_invalidate_atime(inode);
+
 	return res;
 }
 


