Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653B656C643;
	Wed,  9 Sep 2026 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964604; cv=none; b=O7+QXZWCgyfIAYducs60JljrWP9bdey4sPuSwW710Hc2ndzvYvLX1rUEKslWfbogTdgq5K6/L2/0b8JF5wP6wYo2GVe8XSRDaD0C7NtQbglolc0+P9WIxu8UBDy1g1rdc1u6DYdiEkLOF3zurDK5Qfqoz9bWzJGms6zs+lDvcrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964604; c=relaxed/simple;
	bh=25i1dUca0fhMdHGIcGWPUU2RNqv83Q8o2aCV4i8fCfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWJKY6GQOz6u3uLxMDg9XmuKH5zS4QOqwlaOfvXbd03zb4KgFz55yeMDSg12NSIQ9ywI0KVslfB9ONZuu5BtOkNYc/v3njolyK4Arraiz6g2Ss831/xi2tLfPY75WwCAEk4j9TnBDf/Kx9ypvFtxDuu6wHPdBigoFkmXXquwvB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpWp6+CD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpWp6+CD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8361F00A3A;
	Wed,  9 Sep 2026 14:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964603;
	bh=DEsc54FpnC46AQuJhO/P/U+5z+nHG8CC0TuJLTZn1XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpWp6+CDQb+/PqfRWUfnOrDPXi4g8SZgOwHRZIEsCyBhAmgMUIHUcyU8dLmq3GzUO
	 vC5s9i/LfiuP3bKBgA3ZHjZmJKXEuptJmTSlw+fOn3o/kwjAvATsb0VlIokQ9imrjV
	 8qnKxD3ZWU/B2hP8q+yt6UqJyTAezgTvjqomLsOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 433/583] fuse: remove fm arg of args->end callback
Date: Wed,  9 Sep 2026 15:41:58 +0200
Message-ID: <20260909134252.989323982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit a697d95fcdbb3bbe25cdc29db5542ddcebb831c1 ]

Only used by FUSE_INIT and CUSE_INIT, these can store the relevant pointer
in their structs derived from fuse_args.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: ed9c881f3b49 ("fuse: fix race between interrupt and resend")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/args.h  |    2 +-
 fs/fuse/cuse.c  |    7 ++++---
 fs/fuse/dev.c   |    7 +++----
 fs/fuse/file.c  |   22 +++++++++-------------
 fs/fuse/inode.c |   10 ++++++----
 5 files changed, 23 insertions(+), 25 deletions(-)

--- a/fs/fuse/args.h
+++ b/fs/fuse/args.h
@@ -44,7 +44,7 @@ struct fuse_args {
 	bool abort_on_kill:1;
 	struct fuse_in_arg in_args[4];
 	struct fuse_arg out_args[2];
-	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
+	void (*end)(struct fuse_args *args, int error);
 	/* Used for kvec iter backed by vmalloc address */
 	void *vmap_base;
 };
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -306,6 +306,7 @@ struct cuse_init_args {
 	struct cuse_init_out out;
 	struct folio *folio;
 	struct fuse_folio_desc desc;
+	struct fuse_conn *fc;
 };
 
 /**
@@ -319,11 +320,10 @@ struct cuse_init_args {
  * required data structures for it.  Please read the comment at the
  * top of this file for high level overview.
  */
-static void cuse_process_init_reply(struct fuse_mount *fm,
-				    struct fuse_args *args, int error)
+static void cuse_process_init_reply(struct fuse_args *args, int error)
 {
-	struct fuse_conn *fc = fm->fc;
 	struct cuse_init_args *ia = container_of(args, typeof(*ia), ap.args);
+	struct fuse_conn *fc = ia->fc;
 	struct fuse_args_pages *ap = &ia->ap;
 	struct cuse_conn *cc = fc_to_cc(fc), *pos;
 	struct cuse_init_out *arg = &ia->out;
@@ -468,6 +468,7 @@ static int cuse_send_init(struct cuse_co
 	ap->descs = &ia->desc;
 	ia->folio = folio;
 	ia->desc.length = ap->args.out_args[1].size;
+	ia->fc = &cc->fc;
 	ap->args.end = cuse_process_init_reply;
 
 	rc = fuse_simple_background(fm, &ap->args, GFP_KERNEL);
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -512,7 +512,7 @@ void fuse_request_end(struct fuse_req *r
 	}
 
 	if (test_bit(FR_ASYNC, &req->flags))
-		req->args->end(fm, req->args, req->out.h.error);
+		req->args->end(req->args, req->out.h.error);
 put_request:
 	fuse_put_request(req);
 }
@@ -1860,8 +1860,7 @@ struct fuse_retrieve_args {
 	struct fuse_notify_retrieve_in inarg;
 };
 
-static void fuse_retrieve_end(struct fuse_mount *fm, struct fuse_args *args,
-			      int error)
+static void fuse_retrieve_end(struct fuse_args *args, int error)
 {
 	struct fuse_retrieve_args *ra =
 		container_of(args, typeof(*ra), ap.args);
@@ -1956,7 +1955,7 @@ static int fuse_retrieve(struct fuse_mou
 
 	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
-		fuse_retrieve_end(fm, args, err);
+		fuse_retrieve_end(args, err);
 
 	return err;
 }
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -91,8 +91,7 @@ static struct fuse_file *fuse_file_get(s
 	return ff;
 }
 
-static void fuse_release_end(struct fuse_mount *fm, struct fuse_args *args,
-			     int error)
+static void fuse_release_end(struct fuse_args *args, int error)
 {
 	struct fuse_release_args *ra = container_of(args, typeof(*ra), args);
 
@@ -112,15 +111,15 @@ static void fuse_file_put(struct fuse_fi
 		if (!args) {
 			/* Do nothing when server does not implement 'opendir' */
 		} else if (args->opcode == FUSE_RELEASE && ff->fm->fc->no_open) {
-			fuse_release_end(ff->fm, args, 0);
+			fuse_release_end(args, 0);
 		} else if (sync) {
 			fuse_simple_request(ff->fm, args);
-			fuse_release_end(ff->fm, args, 0);
+			fuse_release_end(args, 0);
 		} else {
 			args->end = fuse_release_end;
 			if (fuse_simple_background(ff->fm, args,
 						   GFP_KERNEL | __GFP_NOFAIL))
-				fuse_release_end(ff->fm, args, -ENOTCONN);
+				fuse_release_end(args, -ENOTCONN);
 		}
 		kfree(ff);
 	}
@@ -709,8 +708,7 @@ static void fuse_io_free(struct fuse_io_
 	kfree(ia);
 }
 
-static void fuse_aio_complete_req(struct fuse_mount *fm, struct fuse_args *args,
-				  int err)
+static void fuse_aio_complete_req(struct fuse_args *args, int err)
 {
 	struct fuse_io_args *ia = container_of(args, typeof(*ia), ap.args);
 	struct fuse_io_priv *io = ia->io;
@@ -758,7 +756,7 @@ static ssize_t fuse_async_req_send(struc
 	ia->ap.args.may_block = io->should_dirty;
 	err = fuse_simple_background(fm, &ia->ap.args, GFP_KERNEL);
 	if (err)
-		fuse_aio_complete_req(fm, &ia->ap.args, err);
+		fuse_aio_complete_req(&ia->ap.args, err);
 
 	return num_bytes;
 }
@@ -881,8 +879,7 @@ static int fuse_iomap_read_folio_range(c
 	return fuse_do_readfolio(file, folio, off, len);
 }
 
-static void fuse_readpages_end(struct fuse_mount *fm, struct fuse_args *args,
-			       int err)
+static void fuse_readpages_end(struct fuse_args *args, int err)
 {
 	int i;
 	struct fuse_io_args *ia = container_of(args, typeof(*ia), ap.args);
@@ -947,7 +944,7 @@ static void fuse_send_readpages(struct f
 		res = fuse_simple_request(fm, &ap->args);
 		err = res < 0 ? res : 0;
 	}
-	fuse_readpages_end(fm, &ap->args, err);
+	fuse_readpages_end(&ap->args, err);
 }
 
 static void fuse_readahead(struct readahead_control *rac)
@@ -1950,8 +1947,7 @@ __acquires(fi->lock)
 	}
 }
 
-static void fuse_writepage_end(struct fuse_mount *fm, struct fuse_args *args,
-			       int error)
+static void fuse_writepage_end(struct fuse_args *args, int error)
 {
 	struct fuse_writepage_args *wpa =
 		container_of(args, typeof(*wpa), ia.ap.args);
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1311,13 +1311,14 @@ struct fuse_init_args {
 	struct fuse_args args;
 	struct fuse_init_in in;
 	struct fuse_init_out out;
+	struct fuse_mount *fm;
 };
 
-static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
-			       int error)
+static void process_init_reply(struct fuse_args *args, int error)
 {
-	struct fuse_conn *fc = fm->fc;
 	struct fuse_init_args *ia = container_of(args, typeof(*ia), args);
+	struct fuse_mount *fm = ia->fm;
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_init_out *arg = &ia->out;
 	bool ok = true;
 
@@ -1486,6 +1487,7 @@ static struct fuse_init_args *fuse_new_i
 
 	ia = kzalloc(sizeof(*ia), GFP_KERNEL | __GFP_NOFAIL);
 
+	ia->fm = fm;
 	ia->in.major = FUSE_KERNEL_VERSION;
 	ia->in.minor = FUSE_KERNEL_MINOR_VERSION;
 	ia->in.max_readahead = fm->sb->s_bdi->ra_pages * PAGE_SIZE;
@@ -1559,7 +1561,7 @@ int fuse_send_init(struct fuse_mount *fm
 		if (!err)
 			return 0;
 	}
-	process_init_reply(fm, &ia->args, err);
+	process_init_reply(&ia->args, err);
 	if (fm->fc->conn_error)
 		return -ENOTCONN;
 	return 0;


