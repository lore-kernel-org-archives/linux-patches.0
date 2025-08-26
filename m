Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEF51A256B;
	Tue, 26 Aug 2025 11:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208540; cv=none; b=UHSkf5eJH/SrzkNdCDRcbM0o6Wy7DjQ4bhU6NWjHTIN3uAnX3X/UDQnTKbixqYqh/YI9ULImM8POF4SUtWkHQEDhV3BqUvaQj3h1nglD1FnoVgES7oI9KtEEF4NIIkZBUz1hWpdlkc/DN4qTf3Bbad12Nk5pYaaRX8Eq9QMcO24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208540; c=relaxed/simple;
	bh=uVUTToQ5xXgnxVtIAuwwFo8XGZvjwT6Q2Opx4myi4H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIUGE9hsXdyLUe3WD/t26ZNAhNPkmXbkAPD/eIyJJuuXYpjr1surBF3mNv0AZ0UqunI13Ye0L5JlzjbBmFsvHuUGDjD7x4XaI6zEbMPZ03uhq5iHRmn0AqvYUdSmtID/j4+npm/Kk8cz4W+6TMnXVeASTxAIQ6JiJvvg41wELCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut8Ss2T9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut8Ss2T9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EF8C4CEF1;
	Tue, 26 Aug 2025 11:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208540;
	bh=uVUTToQ5xXgnxVtIAuwwFo8XGZvjwT6Q2Opx4myi4H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ut8Ss2T9Sii3cWBzHIpkav4eWcPBwM67jtHiVvdDlzG5P5NeBnRFfayLUarrWdN+k
	 iAZKQVKeRcrne0yDzivs7T3Mr+xYJEhLKTjX1Q0OkZsrydLA28hS1jvnNGPxz544yd
	 zzqNKPtVzUZzIrxwj8fwrU+ILqCAVTBSxUJ3sCps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/322] btrfs: send: factor out common logic when sending xattrs
Date: Tue, 26 Aug 2025 13:09:26 +0200
Message-ID: <20250826110919.541188286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 17f6a74d0b89092e38e3328b66eda1ab29a195d4 ]

We always send xattrs for the current inode only and both callers of
send_set_xattr() pass a path for the current inode. So move the path
allocation and computation to send_set_xattr(), reducing duplicated
code. This also facilitates an upcoming patch.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 005b0a0c24e1 ("btrfs: send: use fallocate for hole punching with send stream v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4878,11 +4878,19 @@ out:
 }
 
 static int send_set_xattr(struct send_ctx *sctx,
-			  struct fs_path *path,
 			  const char *name, int name_len,
 			  const char *data, int data_len)
 {
-	int ret = 0;
+	struct fs_path *path;
+	int ret;
+
+	path = fs_path_alloc();
+	if (!path)
+		return -ENOMEM;
+
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, path);
+	if (ret < 0)
+		goto out;
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_SET_XATTR);
 	if (ret < 0)
@@ -4896,6 +4904,8 @@ static int send_set_xattr(struct send_ct
 
 tlv_put_failure:
 out:
+	fs_path_free(path);
+
 	return ret;
 }
 
@@ -4923,19 +4933,13 @@ static int __process_new_xattr(int num,
 			       const char *name, int name_len, const char *data,
 			       int data_len, void *ctx)
 {
-	int ret;
 	struct send_ctx *sctx = ctx;
-	struct fs_path *p;
 	struct posix_acl_xattr_header dummy_acl;
 
 	/* Capabilities are emitted by finish_inode_if_needed */
 	if (!strncmp(name, XATTR_NAME_CAPS, name_len))
 		return 0;
 
-	p = fs_path_alloc();
-	if (!p)
-		return -ENOMEM;
-
 	/*
 	 * This hack is needed because empty acls are stored as zero byte
 	 * data in xattrs. Problem with that is, that receiving these zero byte
@@ -4952,15 +4956,7 @@ static int __process_new_xattr(int num,
 		}
 	}
 
-	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
-	if (ret < 0)
-		goto out;
-
-	ret = send_set_xattr(sctx, p, name, name_len, data, data_len);
-
-out:
-	fs_path_free(p);
-	return ret;
+	return send_set_xattr(sctx, name, name_len, data, data_len);
 }
 
 static int __process_deleted_xattr(int num, struct btrfs_key *di_key,
@@ -5836,7 +5832,6 @@ static int send_extent_data(struct send_
  */
 static int send_capabilities(struct send_ctx *sctx)
 {
-	struct fs_path *fspath = NULL;
 	struct btrfs_path *path;
 	struct btrfs_dir_item *di;
 	struct extent_buffer *leaf;
@@ -5862,25 +5857,19 @@ static int send_capabilities(struct send
 	leaf = path->nodes[0];
 	buf_len = btrfs_dir_data_len(leaf, di);
 
-	fspath = fs_path_alloc();
 	buf = kmalloc(buf_len, GFP_KERNEL);
-	if (!fspath || !buf) {
+	if (!buf) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, fspath);
-	if (ret < 0)
-		goto out;
-
 	data_ptr = (unsigned long)(di + 1) + btrfs_dir_name_len(leaf, di);
 	read_extent_buffer(leaf, buf, data_ptr, buf_len);
 
-	ret = send_set_xattr(sctx, fspath, XATTR_NAME_CAPS,
+	ret = send_set_xattr(sctx, XATTR_NAME_CAPS,
 			strlen(XATTR_NAME_CAPS), buf, buf_len);
 out:
 	kfree(buf);
-	fs_path_free(fspath);
 	btrfs_free_path(path);
 	return ret;
 }


