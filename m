Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ED63787B;
	Mon, 18 Dec 2023 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WI0cAqbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63261C433C8;
	Mon, 18 Dec 2023 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908201;
	bh=O563ZjFazYgIHLKNvwPVMVNrDskgfJm7AuF8Nsf9X7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WI0cAqbelghOtlO6Ri4qAmVrTfzR59Y/sKOeUR8pnZc8wURyW+izzZbGDQ3UIPlXc
	 mADHb++CjPMIfDh09lbXGTcGvfd4qwI4SQGLph25r06p+3mbA3sDtZk4Pgptzwrm0r
	 chODE+aG+pVIg/QglHjeK1ohcoLMPTHEqDULZ2Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tyler Fanelli <tfanelli@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 061/166] fuse: Rename DIRECT_IO_RELAX to DIRECT_IO_ALLOW_MMAP
Date: Mon, 18 Dec 2023 14:50:27 +0100
Message-ID: <20231218135107.781960134@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Tyler Fanelli <tfanelli@redhat.com>

commit c55e0a55b165202f18cbc4a20650d2e1becd5507 upstream.

Although DIRECT_IO_RELAX's initial usage is to allow shared mmap, its
description indicates a purpose of reducing memory footprint. This
may imply that it could be further used to relax other DIRECT_IO
operations in the future.

Replace it with a flag DIRECT_IO_ALLOW_MMAP which does only one thing,
allow shared mmap of DIRECT_IO files while still bypassing the cache
on regular reads and writes.

[Miklos] Also Keep DIRECT_IO_RELAX definition for backward compatibility.

Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
Fixes: e78662e818f9 ("fuse: add a new fuse init flag to relax restrictions in no cache mode")
Cc: <stable@vger.kernel.org> # v6.6
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c            |    6 +++---
 fs/fuse/fuse_i.h          |    4 ++--
 fs/fuse/inode.c           |    6 +++---
 include/uapi/linux/fuse.h |   10 ++++++----
 4 files changed, 14 insertions(+), 12 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1448,7 +1448,7 @@ ssize_t fuse_direct_io(struct fuse_io_pr
 	if (!ia)
 		return -ENOMEM;
 
-	if (fopen_direct_io && fc->direct_io_relax) {
+	if (fopen_direct_io && fc->direct_io_allow_mmap) {
 		res = filemap_write_and_wait_range(mapping, pos, pos + count - 1);
 		if (res) {
 			fuse_io_free(ia);
@@ -2466,9 +2466,9 @@ static int fuse_file_mmap(struct file *f
 
 	if (ff->open_flags & FOPEN_DIRECT_IO) {
 		/* Can't provide the coherency needed for MAP_SHARED
-		 * if FUSE_DIRECT_IO_RELAX isn't set.
+		 * if FUSE_DIRECT_IO_ALLOW_MMAP isn't set.
 		 */
-		if ((vma->vm_flags & VM_MAYSHARE) && !fc->direct_io_relax)
+		if ((vma->vm_flags & VM_MAYSHARE) && !fc->direct_io_allow_mmap)
 			return -ENODEV;
 
 		invalidate_inode_pages2(file->f_mapping);
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -797,8 +797,8 @@ struct fuse_conn {
 	/* Is tmpfile not implemented by fs? */
 	unsigned int no_tmpfile:1;
 
-	/* relax restrictions in FOPEN_DIRECT_IO mode */
-	unsigned int direct_io_relax:1;
+	/* Relax restrictions to allow shared mmap in FOPEN_DIRECT_IO mode */
+	unsigned int direct_io_allow_mmap:1;
 
 	/* Is statx not implemented by fs? */
 	unsigned int no_statx:1;
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1232,8 +1232,8 @@ static void process_init_reply(struct fu
 				fc->init_security = 1;
 			if (flags & FUSE_CREATE_SUPP_GROUP)
 				fc->create_supp_group = 1;
-			if (flags & FUSE_DIRECT_IO_RELAX)
-				fc->direct_io_relax = 1;
+			if (flags & FUSE_DIRECT_IO_ALLOW_MMAP)
+				fc->direct_io_allow_mmap = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1280,7 +1280,7 @@ void fuse_send_init(struct fuse_mount *f
 		FUSE_NO_OPENDIR_SUPPORT | FUSE_EXPLICIT_INVAL_DATA |
 		FUSE_HANDLE_KILLPRIV_V2 | FUSE_SETXATTR_EXT | FUSE_INIT_EXT |
 		FUSE_SECURITY_CTX | FUSE_CREATE_SUPP_GROUP |
-		FUSE_HAS_EXPIRE_ONLY | FUSE_DIRECT_IO_RELAX;
+		FUSE_HAS_EXPIRE_ONLY | FUSE_DIRECT_IO_ALLOW_MMAP;
 #ifdef CONFIG_FUSE_DAX
 	if (fm->fc->dax)
 		flags |= FUSE_MAP_ALIGNMENT;
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -209,7 +209,7 @@
  *  - add FUSE_HAS_EXPIRE_ONLY
  *
  *  7.39
- *  - add FUSE_DIRECT_IO_RELAX
+ *  - add FUSE_DIRECT_IO_ALLOW_MMAP
  *  - add FUSE_STATX and related structures
  */
 
@@ -409,8 +409,7 @@ struct fuse_file_lock {
  * FUSE_CREATE_SUPP_GROUP: add supplementary group info to create, mkdir,
  *			symlink and mknod (single group that matches parent)
  * FUSE_HAS_EXPIRE_ONLY: kernel supports expiry-only entry invalidation
- * FUSE_DIRECT_IO_RELAX: relax restrictions in FOPEN_DIRECT_IO mode, for now
- *                       allow shared mmap
+ * FUSE_DIRECT_IO_ALLOW_MMAP: allow shared mmap in FOPEN_DIRECT_IO mode.
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -449,7 +448,10 @@ struct fuse_file_lock {
 #define FUSE_HAS_INODE_DAX	(1ULL << 33)
 #define FUSE_CREATE_SUPP_GROUP	(1ULL << 34)
 #define FUSE_HAS_EXPIRE_ONLY	(1ULL << 35)
-#define FUSE_DIRECT_IO_RELAX	(1ULL << 36)
+#define FUSE_DIRECT_IO_ALLOW_MMAP (1ULL << 36)
+
+/* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
+#define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
 
 /**
  * CUSE INIT request/reply flags


