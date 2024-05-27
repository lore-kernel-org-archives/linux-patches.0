Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5169015FCE9;
	Mon, 27 May 2024 19:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837817; cv=none; b=mxHmMY3A73FRfmVdhUiI52vla7xjEmu5z8CKKJFWyrrocq2vXf0HnzWFELSTjdviIVO/ewAas7Kkv54nbtj7TTEfBo+i1pYe7cVUMAEcoQJVo8W9xH/rknz8Icqmtp4qHZCRSk/o9PIykT5uIf48vszlULh3vI9u1iCqX7B/1lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837817; c=relaxed/simple;
	bh=4cmPmWwci5qvLOhcXNMT+JRccvLnsfS/BhSvz11tDSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5F+fWWk0YVijPmxp4hZ/KSYsKyR2F7WQu2U4xIrsJhChckAZynrDj2ig05hTp/evg23IYwsye0M6ZxnB7hsPZ83iOldSFHKwgE3j/L+BnmyD+A44tmzZktxv1DEndFXSFng+uUCND8zfvm2qC6dI5QMAjEfI+FHhzy6Bq8PAYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s10KUvch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s10KUvch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8CCC2BBFC;
	Mon, 27 May 2024 19:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837817;
	bh=4cmPmWwci5qvLOhcXNMT+JRccvLnsfS/BhSvz11tDSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s10KUvchK7xziW0bT3bU5YHr5zS+dzTLpdFm+CD22D7z882/8NavchQuG6ZgmOe4I
	 SprYlIi05yegWNwfuREXqYEP4Z9cGki5CM4+P+of39u5tcx1rDTy4W6YU6owkTKzd/
	 1lEkoCNb6NRLWgbOz14rZgmLQTsMTyUtJOZSoZPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 129/493] libfs: Define a minimum directory offset
Date: Mon, 27 May 2024 20:52:11 +0200
Message-ID: <20240527185634.710170103@linuxfoundation.org>
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

[ Upstream commit 7beea725a8ca412c6190090ce7c3a13b169592a1 ]

This value is used in several places, so make it a symbolic
constant.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/170820142741.6328.12428356024575347885.stgit@91.116.238.104.host.secureserver.net
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 23cdd0eed3f1 ("libfs: Fix simple_offset_rename_exchange()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 752e24c669d97..f0045db739df8 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -240,6 +240,11 @@ const struct inode_operations simple_dir_inode_operations = {
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
@@ -261,9 +266,7 @@ void simple_offset_init(struct offset_ctx *octx)
 {
 	xa_init_flags(&octx->xa, XA_FLAGS_ALLOC1);
 	lockdep_set_class(&octx->xa.xa_lock, &simple_offset_xa_lock);
-
-	/* 0 is '.', 1 is '..', so always start with offset 2 */
-	octx->next_offset = 2;
+	octx->next_offset = DIR_OFFSET_MIN;
 }
 
 /**
@@ -276,7 +279,7 @@ void simple_offset_init(struct offset_ctx *octx)
  */
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry)
 {
-	static const struct xa_limit limit = XA_LIMIT(2, U32_MAX);
+	static const struct xa_limit limit = XA_LIMIT(DIR_OFFSET_MIN, U32_MAX);
 	u32 offset;
 	int ret;
 
@@ -481,7 +484,7 @@ static int offset_readdir(struct file *file, struct dir_context *ctx)
 		return 0;
 
 	/* In this case, ->private_data is protected by f_pos_lock */
-	if (ctx->pos == 2)
+	if (ctx->pos == DIR_OFFSET_MIN)
 		file->private_data = NULL;
 	else if (file->private_data == ERR_PTR(-ENOENT))
 		return 0;
-- 
2.43.0



