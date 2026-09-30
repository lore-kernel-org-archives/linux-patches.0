Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEC053163E;
	Wed, 30 Sep 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790171; cv=none; b=uCjqUBMHCwN+mLVsphUJRR3NxSUUlEDImzGLnos2XGURLZm5e/s03cgoTmCvBeBJmzR4uSXKY00cajiNAH8nklmNJIrnmfQR5x7e8Z4Kso71N4WLpoJZVkxgW9zLvKki8wV8d76DockLQEknuO1MR/vHBsAksex5YipAYagdFnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790171; c=relaxed/simple;
	bh=MqF4LTVnxzxS4mTSNCBm1At7LAD0sYhetiATxYwxahA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN59hfjLnxKS9lpIfVozzqRcy8yKTLXOetNBQkIAAZag1lQMMYVpS5VR40sLZwQgbdC7nxkqZoaWWw4WXoprAERQVatjz7R77OraO2xjjaQx9XhHzvNKgo6YEoiM+2oTpaoZ5GjuN82wiPFLwok7GtIZEIgFOwBRberadZo+Ibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c25dlvLB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c25dlvLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E261B1F000FF;
	Wed, 30 Sep 2026 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790170;
	bh=0qBlYsIKvuSF6Q7Rjy4X8gmQ+ueAE7GWQk8BWat10ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c25dlvLBCAHyw6pBEM4TIbVMz8PSaPNz1Jc23re2Tehy3b1gKTUBUYVXgKpKXSGoK
	 NlkzbqORUutb6TMYEuByHqaS4jLSyMGeKYx0XngO3yFyV9b/JSgSmhVCq7LJij9DxW
	 rCw0d+g94lfLPwb9Ll5TrzK8Z2tuNcYXHoyl7t9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 691/877] f2fs: limit recovery filename logging to stored length
Date: Wed, 30 Sep 2026 17:26:42 +0200
Message-ID: <20260930152429.588392383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 01027b2fcb74dade59fb833b51023f6593b6a9a2 ]

F2FS stores recovery filenames as a length plus a fixed-size i_name
buffer.  The buffer is not NUL-terminated, but recover_inode() and
recover_dentry() print it with %s.

For a 255-byte filename, recovery logging can read past i_name into the
following raw inode fields.

Print the name with a precision bounded by i_namelen and F2FS_NAME_LEN.

Fixes: f356fe0cba0e ("f2fs: add debug msgs in the recovery routine")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ adapted folio references to pages and retained %lx formatting for unsigned long inode numbers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/recovery.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -157,6 +157,22 @@ static int init_recovered_filename(const
 	return 0;
 }
 
+static const char *recover_printable_name(struct inode *inode,
+					  struct f2fs_inode *raw,
+					  int *name_len)
+{
+	static const char encrypted_name[] = "<encrypted>";
+
+	if (file_enc_name(inode)) {
+		*name_len = sizeof(encrypted_name) - 1;
+		return encrypted_name;
+	}
+
+	*name_len = min_t(unsigned int, le32_to_cpu(raw->i_namelen),
+			  F2FS_NAME_LEN);
+	return raw->i_name;
+}
+
 static int recover_dentry(struct inode *inode, struct page *ipage,
 						struct list_head *dir_list)
 {
@@ -169,7 +185,8 @@ static int recover_dentry(struct inode *
 	struct inode *dir, *einode;
 	struct fsync_inode_entry *entry;
 	int err = 0;
-	char *name;
+	const char *name;
+	int name_len;
 
 	entry = get_fsync_inode(dir_list, pino);
 	if (!entry) {
@@ -228,12 +245,9 @@ retry:
 out_put:
 	f2fs_put_page(page, 0);
 out:
-	if (file_enc_name(inode))
-		name = "<encrypted>";
-	else
-		name = raw_inode->i_name;
-	f2fs_notice(F2FS_I_SB(inode), "%s: ino = %x, name = %s, dir = %lx, err = %d",
-		    __func__, ino_of_node(ipage), name,
+	name = recover_printable_name(inode, raw_inode, &name_len);
+	f2fs_notice(F2FS_I_SB(inode), "%s: ino = %x, name = %.*s, dir = %lx, err = %d",
+		    __func__, ino_of_node(ipage), name_len, name,
 		    IS_ERR(dir) ? 0 : dir->i_ino, err);
 	return err;
 }
@@ -281,7 +295,8 @@ static int recover_inode(struct inode *i
 {
 	struct f2fs_inode *raw = F2FS_INODE(page);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
-	char *name;
+	const char *name;
+	int name_len;
 	int err;
 
 	inode->i_mode = le16_to_cpu(raw->i_mode);
@@ -330,13 +345,11 @@ static int recover_inode(struct inode *i
 
 	f2fs_mark_inode_dirty_sync(inode, true);
 
-	if (file_enc_name(inode))
-		name = "<encrypted>";
-	else
-		name = F2FS_INODE(page)->i_name;
+	name = recover_printable_name(inode, raw, &name_len);
 
-	f2fs_notice(F2FS_I_SB(inode), "recover_inode: ino = %x, name = %s, inline = %x",
-		    ino_of_node(page), name, raw->i_inline);
+	f2fs_notice(F2FS_I_SB(inode), "%s: ino = %x, name = %.*s, inline = %x",
+		    __func__, ino_of_node(page), name_len, name,
+		    raw->i_inline);
 	return 0;
 }
 


