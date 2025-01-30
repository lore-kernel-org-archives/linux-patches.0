Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D81E990D;
	Thu, 30 Jan 2025 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246532; cv=none; b=K0MO8zSGSneTBagxRPP+RZ733ppZgkPVjm1gxJn0iJr4H627hBEmfXx8Kc4sWrgTjBYksYyaQQpOzvfYoTYHPhX9fsekiV37p5cLUh3zCL6wNbnE+5MkqpmfYA/nHL49Ph4v8ml39bScyJasFpKLNGwYtuwW8w3mkPKgGnWX30c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246532; c=relaxed/simple;
	bh=z2udORKE3W1ekGdIRM2EveHK0Qtl+ar0phPE9rOEEwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBqzvSSFTW4Uj6FUHFjwul3YZL1xPvnXS0JDmErvl5/rntgnFx1OmdP1pFqiSuuNufA6+z+JNZk6uj4cstoP8O7LS+6rvCCeK6BRNc/CGheq408TCye0hZoJ6/BvXUwi0spbyxv7WiHkaI22DPS2Uta8uC6faaUBIlrt9r3gCus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Vb9foa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Vb9foa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16080C4CED2;
	Thu, 30 Jan 2025 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246531;
	bh=z2udORKE3W1ekGdIRM2EveHK0Qtl+ar0phPE9rOEEwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Vb9foa0mfMvg8Qq9CJ1X6wbYWIs+ci/pHsS/0GhWywEnqHK9r6Xmc3Wo3dDCHMvT
	 mVpleZU6YNu71cbUL7TbBDgq3LRv5c/fjMjmWWvarg6dcE0BEH+KPQVY6Z5OZ2fsEw
	 t2BeTy83YVvO1/7MKdgKE2VeISLrIbRJj1oWaaFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 16/43] libfs: Define a minimum directory offset
Date: Thu, 30 Jan 2025 14:59:23 +0100
Message-ID: <20250130133459.555541361@linuxfoundation.org>
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

[ Upstream commit 7beea725a8ca412c6190090ce7c3a13b169592a1 ]

This value is used in several places, so make it a symbolic
constant.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/170820142741.6328.12428356024575347885.stgit@91.116.238.104.host.secureserver.net
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: ecba88a3b32d ("libfs: Add simple_offset_empty()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -239,6 +239,11 @@ const struct inode_operations simple_dir
 };
 EXPORT_SYMBOL(simple_dir_inode_operations);
 
+/* 0 is '.', 1 is '..', so always start with offset 2 or more */
+enum {
+	DIR_OFFSET_MIN	= 2,
+};
+
 static void offset_set(struct dentry *dentry, u32 offset)
 {
 	dentry->d_fsdata = (void *)((uintptr_t)(offset));
@@ -260,9 +265,7 @@ void simple_offset_init(struct offset_ct
 {
 	xa_init_flags(&octx->xa, XA_FLAGS_ALLOC1);
 	lockdep_set_class(&octx->xa.xa_lock, &simple_offset_xa_lock);
-
-	/* 0 is '.', 1 is '..', so always start with offset 2 */
-	octx->next_offset = 2;
+	octx->next_offset = DIR_OFFSET_MIN;
 }
 
 /**
@@ -275,7 +278,7 @@ void simple_offset_init(struct offset_ct
  */
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry)
 {
-	static const struct xa_limit limit = XA_LIMIT(2, U32_MAX);
+	static const struct xa_limit limit = XA_LIMIT(DIR_OFFSET_MIN, U32_MAX);
 	u32 offset;
 	int ret;
 
@@ -480,7 +483,7 @@ static int offset_readdir(struct file *f
 		return 0;
 
 	/* In this case, ->private_data is protected by f_pos_lock */
-	if (ctx->pos == 2)
+	if (ctx->pos == DIR_OFFSET_MIN)
 		file->private_data = NULL;
 	else if (file->private_data == ERR_PTR(-ENOENT))
 		return 0;


