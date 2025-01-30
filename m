Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B347383;
	Thu, 30 Jan 2025 14:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246592; cv=none; b=MAOU4W20IgitBxio+/dieBe7PoRV19YMzqnnRp6flyKnQtTRX8TCVMbMAhnZlfPDAChOPiugMD5INYkTZx7PC0nGyTIAvECo1GBYOiLz1RjoXznB98TTv22EJSHHhtI5n6JkPASmEpcU1P9WXE+HVEmqT81c0dNa64B8pHjfiWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246592; c=relaxed/simple;
	bh=XIGm+p+Qjicu9T40H8U7Vx5Ok5XMchM1PoIiAYqerVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfYigKBdJXJsOpvTosTvQjAzptc5WZEJdLJV2iKRunPvODYhUgds9uB47+G6tRCxlOceF2Ex7AxJfwYmssi3o0GtqhPrvpPtSsl9JlieH0EeaAEYLvsCKvJ3tDH1U6NCdRMUNlZzSbR+vmpFEYrOh0YMmrQKOfiw60fWtK6k7ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhJVB+I0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhJVB+I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3C7C4CED2;
	Thu, 30 Jan 2025 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246592;
	bh=XIGm+p+Qjicu9T40H8U7Vx5Ok5XMchM1PoIiAYqerVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhJVB+I0zVFp4e/fpKvxS12dutbq2XqTRWe3iW646pRTCymALQtZt5OY/y6xMpHLd
	 jGiVGkHdVYHYBclmTF77cuht33Q2CGgvCb6ZZzxbRlQOgmyPbcbT3CYkZQDWs1maII
	 5+XEXTxMzphwWZGAsqF+/CjImM/brBSYhjI9czZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 18/43] libfs: Fix simple_offset_rename_exchange()
Date: Thu, 30 Jan 2025 14:59:25 +0100
Message-ID: <20250130133459.636074785@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ cel: adjusted to apply to origin/linux-6.6.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -294,6 +294,18 @@ int simple_offset_add(struct offset_ctx
 	return 0;
 }
 
+static int simple_offset_replace(struct offset_ctx *octx, struct dentry *dentry,
+				 long offset)
+{
+	void *ret;
+
+	ret = xa_store(&octx->xa, offset, dentry, GFP_KERNEL);
+	if (xa_is_err(ret))
+		return xa_err(ret);
+	offset_set(dentry, offset);
+	return 0;
+}
+
 /**
  * simple_offset_remove - Remove an entry to a directory's offset map
  * @octx: directory offset ctx to be updated
@@ -351,6 +363,9 @@ int simple_offset_empty(struct dentry *d
  * @new_dir: destination parent
  * @new_dentry: destination dentry
  *
+ * This API preserves the directory offset values. Caller provides
+ * appropriate serialization.
+ *
  * Returns zero on success. Otherwise a negative errno is returned and the
  * rename is rolled back.
  */
@@ -368,11 +383,11 @@ int simple_offset_rename_exchange(struct
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
@@ -387,10 +402,8 @@ int simple_offset_rename_exchange(struct
 	return 0;
 
 out_restore:
-	offset_set(old_dentry, old_index);
-	xa_store(&old_ctx->xa, old_index, old_dentry, GFP_KERNEL);
-	offset_set(new_dentry, new_index);
-	xa_store(&new_ctx->xa, new_index, new_dentry, GFP_KERNEL);
+	(void)simple_offset_replace(old_ctx, old_dentry, old_index);
+	(void)simple_offset_replace(new_ctx, new_dentry, new_index);
 	return ret;
 }
 


