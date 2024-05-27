Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69C51607A4;
	Mon, 27 May 2024 19:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837863; cv=none; b=k/vviEuinA2Tu3Nz1ZwpERvYE6KH8HsGM+n+0fkDIHT8MPNS9FVzSga1x6IKdijFo+mcNyYylp/eZ/tjRbEkdGP/dYCfzn9vp/M8lvYUbNCMiqAAiJBKI8zNaUPAoLDYogIZ0sOuhkZFoJ6zUMfkaGLr7p3lBsu33dfgxepWrIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837863; c=relaxed/simple;
	bh=nL7Clfvm5g9+qIXuZCkETP52hg3q3GwUQVAU3gElwV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbTMjzbvQ/7BodOxcP0ICekTPQX0VwCKGaOjhEPtsNQozv9D+f9hjmBHEzSwHbY8xi4UQhEVIvYdOHdMKzjEgvD2SXTChqNCgzKfu1dTP7zWD5eQQgLoloAVy+LSJP2sdOe2Gldx2Ke5ok2ezUVscVAulp1nA92wD2937IJLSkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8DAeXaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8DAeXaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1FBC2BBFC;
	Mon, 27 May 2024 19:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837863;
	bh=nL7Clfvm5g9+qIXuZCkETP52hg3q3GwUQVAU3gElwV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8DAeXaKxAgtNAxA2I3qbLWGNLetnZvC5NDHfNlqSJNRZMK7JXMZyjg4inJONhdJb
	 inpB/Fi/tfXXWoaCZkDs5TpPYK6ygWvrWTKh7yZr6mfvVDfxDZPBOmHXiDIP7u+Xfy
	 35S1Q1XkA4h+E9jROykODQ1fdI1h0XhpM8hJEOYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 133/493] libfs: Fix simple_offset_rename_exchange()
Date: Mon, 27 May 2024 20:52:15 +0200
Message-ID: <20240527185634.823338780@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 23cdd0eed3f1fff3af323092b0b88945a7950d8e ]

User space expects the replacement (old) directory entry to have
the same directory offset after the rename.

Suggested-by: Christian Brauner <brauner@kernel.org>
Fixes: a2e459555c5f ("shmem: stable directory offsets")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20240415152057.4605-2-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index d3d31197c8e43..c9516f3e14bb7 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -294,6 +294,18 @@ int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry)
 	return 0;
 }
 
+static int simple_offset_replace(struct offset_ctx *octx, struct dentry *dentry,
+				 long offset)
+{
+	int ret;
+
+	ret = mtree_store(&octx->mt, offset, dentry, GFP_KERNEL);
+	if (ret)
+		return ret;
+	offset_set(dentry, offset);
+	return 0;
+}
+
 /**
  * simple_offset_remove - Remove an entry to a directory's offset map
  * @octx: directory offset ctx to be updated
@@ -351,6 +363,9 @@ int simple_offset_empty(struct dentry *dentry)
  * @new_dir: destination parent
  * @new_dentry: destination dentry
  *
+ * This API preserves the directory offset values. Caller provides
+ * appropriate serialization.
+ *
  * Returns zero on success. Otherwise a negative errno is returned and the
  * rename is rolled back.
  */
@@ -368,11 +383,11 @@ int simple_offset_rename_exchange(struct inode *old_dir,
 	simple_offset_remove(old_ctx, old_dentry);
 	simple_offset_remove(new_ctx, new_dentry);
 
-	ret = simple_offset_add(new_ctx, old_dentry);
+	ret = simple_offset_replace(new_ctx, old_dentry, new_index);
 	if (ret)
 		goto out_restore;
 
-	ret = simple_offset_add(old_ctx, new_dentry);
+	ret = simple_offset_replace(old_ctx, new_dentry, old_index);
 	if (ret) {
 		simple_offset_remove(new_ctx, old_dentry);
 		goto out_restore;
@@ -387,10 +402,8 @@ int simple_offset_rename_exchange(struct inode *old_dir,
 	return 0;
 
 out_restore:
-	offset_set(old_dentry, old_index);
-	mtree_store(&old_ctx->mt, old_index, old_dentry, GFP_KERNEL);
-	offset_set(new_dentry, new_index);
-	mtree_store(&new_ctx->mt, new_index, new_dentry, GFP_KERNEL);
+	(void)simple_offset_replace(old_ctx, old_dentry, old_index);
+	(void)simple_offset_replace(new_ctx, new_dentry, new_index);
 	return ret;
 }
 
-- 
2.43.0



