Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D13118C025;
	Tue, 10 Sep 2024 10:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963163; cv=none; b=Fh4BnTcL7SwZBKMQktAj5+1qXELOD7igw2McRD1GqYLlNQ0HDUlrc15iyKIKvZJ5B0jA/4wQ81zMBtPEEbMKnLzMmQb/tUh2UF87gaHbbzU+KVkjg/JRpLUoBTqbYXGeKZDcBglnUw3n+lvkNdh3OTfKYuaBj+BRdl86pxxKPh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963163; c=relaxed/simple;
	bh=euAKZzKfvuQ8D3H9xGBguPOGfA6jd1pva+hXmgPmsVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=te7nX71CVswrJgH+qDthLP9U629d/yi+zXycFvVqYlp1slH+TBy8Tth4+sil6daALiq0myEdRRq+9JWAomw9/7ESPgm/ajPTypwMLGoM7rg3rKf/ZVc7mTUALY77MdSUFt/Ua1QU0ngOwpFFxO/aGWHkjo3MWBh0R32dlRPaAHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A19sFQBt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A19sFQBt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57516C4CEC3;
	Tue, 10 Sep 2024 10:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963162;
	bh=euAKZzKfvuQ8D3H9xGBguPOGfA6jd1pva+hXmgPmsVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A19sFQBtD/qm0N25vNUQmGtXX6fRX9eD+gHhXgsocJ8W0rbu6jokFvBKKVw59af5w
	 GdAxprupNvzxR/Y+elNtX+yunr8xGVCsBcOC1mnaDB8S6J+6pBAd7tDhR6jwVT8moE
	 e+j0fOCbMYsTbmFAbF0BtOwQkZklcrtEDhh5z5hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/192] fuse: add request extension
Date: Tue, 10 Sep 2024 11:33:00 +0200
Message-ID: <20240910092604.385822569@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 15d937d7ca8c55d2b0ce9116e20c780fdd0b67cc ]

Will need to add supplementary groups to create messages, so add the
general concept of a request extension.  A request extension is appended to
the end of the main request.  It has a header indicating the size and type
of the extension.

The create security context (fuse_secctx_*) is similar to the generic
request extension, so include that as well in a backward compatible manner.

Add the total extension length to the request header.  The offset of the
extension block within the request can be calculated by:

  inh->len - inh->total_extlen * 8

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 3002240d1649 ("fuse: fix memory leak in fuse_create_open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c             |  2 ++
 fs/fuse/dir.c             | 66 ++++++++++++++++++++++-----------------
 fs/fuse/fuse_i.h          |  6 ++--
 include/uapi/linux/fuse.h | 28 ++++++++++++++++-
 4 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 61bef919c042..7e0d4f08a0cf 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -476,6 +476,8 @@ static void fuse_args_to_req(struct fuse_req *req, struct fuse_args *args)
 	req->in.h.opcode = args->opcode;
 	req->in.h.nodeid = args->nodeid;
 	req->args = args;
+	if (args->is_ext)
+		req->in.h.total_extlen = args->in_args[args->ext_idx].size / 8;
 	if (args->end)
 		__set_bit(FR_ASYNC, &req->flags);
 }
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8474003aa54d..3b7887312ac0 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -470,7 +470,7 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 }
 
 static int get_security_context(struct dentry *entry, umode_t mode,
-				void **security_ctx, u32 *security_ctxlen)
+				struct fuse_in_arg *ext)
 {
 	struct fuse_secctx *fctx;
 	struct fuse_secctx_header *header;
@@ -517,14 +517,42 @@ static int get_security_context(struct dentry *entry, umode_t mode,
 
 		memcpy(ptr, ctx, ctxlen);
 	}
-	*security_ctxlen = total_len;
-	*security_ctx = header;
+	ext->size = total_len;
+	ext->value = header;
 	err = 0;
 out_err:
 	kfree(ctx);
 	return err;
 }
 
+static int get_create_ext(struct fuse_args *args, struct dentry *dentry,
+			  umode_t mode)
+{
+	struct fuse_conn *fc = get_fuse_conn_super(dentry->d_sb);
+	struct fuse_in_arg ext = { .size = 0, .value = NULL };
+	int err = 0;
+
+	if (fc->init_security)
+		err = get_security_context(dentry, mode, &ext);
+
+	if (!err && ext.size) {
+		WARN_ON(args->in_numargs >= ARRAY_SIZE(args->in_args));
+		args->is_ext = true;
+		args->ext_idx = args->in_numargs++;
+		args->in_args[args->ext_idx] = ext;
+	} else {
+		kfree(ext.value);
+	}
+
+	return err;
+}
+
+static void free_ext_value(struct fuse_args *args)
+{
+	if (args->is_ext)
+		kfree(args->in_args[args->ext_idx].value);
+}
+
 /*
  * Atomic create+open operation
  *
@@ -545,8 +573,6 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_inode *fi;
 	struct fuse_file *ff;
-	void *security_ctx = NULL;
-	u32 security_ctxlen;
 	bool trunc = flags & O_TRUNC;
 
 	/* Userspace expects S_IFREG in create mode */
@@ -590,19 +616,12 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	args.out_args[1].size = sizeof(outopen);
 	args.out_args[1].value = &outopen;
 
-	if (fm->fc->init_security) {
-		err = get_security_context(entry, mode, &security_ctx,
-					   &security_ctxlen);
-		if (err)
-			goto out_put_forget_req;
-
-		args.in_numargs = 3;
-		args.in_args[2].size = security_ctxlen;
-		args.in_args[2].value = security_ctx;
-	}
+	err = get_create_ext(&args, entry, mode);
+	if (err)
+		goto out_put_forget_req;
 
 	err = fuse_simple_request(fm, &args);
-	kfree(security_ctx);
+	free_ext_value(&args);
 	if (err)
 		goto out_free_ff;
 
@@ -709,8 +728,6 @@ static int create_new_entry(struct fuse_mount *fm, struct fuse_args *args,
 	struct dentry *d;
 	int err;
 	struct fuse_forget_link *forget;
-	void *security_ctx = NULL;
-	u32 security_ctxlen;
 
 	if (fuse_is_bad(dir))
 		return -EIO;
@@ -725,21 +742,14 @@ static int create_new_entry(struct fuse_mount *fm, struct fuse_args *args,
 	args->out_args[0].size = sizeof(outarg);
 	args->out_args[0].value = &outarg;
 
-	if (fm->fc->init_security && args->opcode != FUSE_LINK) {
-		err = get_security_context(entry, mode, &security_ctx,
-					   &security_ctxlen);
+	if (args->opcode != FUSE_LINK) {
+		err = get_create_ext(args, entry, mode);
 		if (err)
 			goto out_put_forget_req;
-
-		BUG_ON(args->in_numargs != 2);
-
-		args->in_numargs = 3;
-		args->in_args[2].size = security_ctxlen;
-		args->in_args[2].value = security_ctx;
 	}
 
 	err = fuse_simple_request(fm, args);
-	kfree(security_ctx);
+	free_ext_value(args);
 	if (err)
 		goto out_put_forget_req;
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index cb464e5b171a..6c3ec70c1b70 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -264,8 +264,9 @@ struct fuse_page_desc {
 struct fuse_args {
 	uint64_t nodeid;
 	uint32_t opcode;
-	unsigned short in_numargs;
-	unsigned short out_numargs;
+	uint8_t in_numargs;
+	uint8_t out_numargs;
+	uint8_t ext_idx;
 	bool force:1;
 	bool noreply:1;
 	bool nocreds:1;
@@ -276,6 +277,7 @@ struct fuse_args {
 	bool page_zeroing:1;
 	bool page_replace:1;
 	bool may_block:1;
+	bool is_ext:1;
 	struct fuse_in_arg in_args[3];
 	struct fuse_arg out_args[2];
 	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index e3c54109bae9..c71f12429e3d 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -201,6 +201,9 @@
  *  7.38
  *  - add FUSE_EXPIRE_ONLY flag to fuse_notify_inval_entry
  *  - add FOPEN_PARALLEL_DIRECT_WRITES
+ *  - add total_extlen to fuse_in_header
+ *  - add FUSE_MAX_NR_SECCTX
+ *  - add extension header
  */
 
 #ifndef _LINUX_FUSE_H
@@ -503,6 +506,15 @@ struct fuse_file_lock {
  */
 #define FUSE_EXPIRE_ONLY		(1 << 0)
 
+/**
+ * extension type
+ * FUSE_MAX_NR_SECCTX: maximum value of &fuse_secctx_header.nr_secctx
+ */
+enum fuse_ext_type {
+	/* Types 0..31 are reserved for fuse_secctx_header */
+	FUSE_MAX_NR_SECCTX	= 31,
+};
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
@@ -886,7 +898,8 @@ struct fuse_in_header {
 	uint32_t	uid;
 	uint32_t	gid;
 	uint32_t	pid;
-	uint32_t	padding;
+	uint16_t	total_extlen; /* length of extensions in 8byte units */
+	uint16_t	padding;
 };
 
 struct fuse_out_header {
@@ -1047,4 +1060,17 @@ struct fuse_secctx_header {
 	uint32_t	nr_secctx;
 };
 
+/**
+ * struct fuse_ext_header - extension header
+ * @size: total size of this extension including this header
+ * @type: type of extension
+ *
+ * This is made compatible with fuse_secctx_header by using type values >
+ * FUSE_MAX_NR_SECCTX
+ */
+struct fuse_ext_header {
+	uint32_t	size;
+	uint32_t	type;
+};
+
 #endif /* _LINUX_FUSE_H */
-- 
2.43.0



