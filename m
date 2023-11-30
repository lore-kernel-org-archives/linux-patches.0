Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F6B495C2;
	Thu, 30 Nov 2023 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWWoGoKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A78C433C8;
	Thu, 30 Nov 2023 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361488;
	bh=kcFdUMeKugdzYyMH2TOs3hn9qEkYhnbMJBpSd5TPicM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWWoGoKTQiz6yZqkKxkXYws0G5mwQ/1bXwiVZPpJn/H8DW04LAvg5fiSUgEBfOEna
	 TuH9W2/EIi2dA3ULUg1RWz6y8L6rDgYlAFCiQruFW50/k+8li336X6JgpkN6QK4PJA
	 JDgHZrIK3NN6S70l5sK4FSvNZafgK6TtHxTqO/LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tavian Barnes <tavianator@tavianator.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/112] libfs: getdents() should return 0 after reaching EOD
Date: Thu, 30 Nov 2023 16:21:12 +0000
Message-ID: <20231130162141.117879007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 796432efab1e372d404e7a71cc6891a53f105051 ]

The new directory offset helpers don't conform with the convention
of getdents() returning no more entries once a directory file
descriptor has reached the current end-of-directory.

To address this, copy the logic from dcache_readdir() to mark the
open directory file descriptor once EOD has been reached. Seeking
resets the mark.

Reported-by: Tavian Barnes <tavianator@tavianator.com>
Closes: https://lore.kernel.org/linux-fsdevel/20231113180616.2831430-1-tavianator@tavianator.com/
Fixes: 6faddda69f62 ("libfs: Add directory operations for stable offsets")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/170043792492.4628.15646203084646716134.stgit@bazille.1015granger.net
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 37f2d34ee090b..189447cf4acf5 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -396,6 +396,8 @@ static loff_t offset_dir_llseek(struct file *file, loff_t offset, int whence)
 		return -EINVAL;
 	}
 
+	/* In this case, ->private_data is protected by f_pos_lock */
+	file->private_data = NULL;
 	return vfs_setpos(file, offset, U32_MAX);
 }
 
@@ -425,7 +427,7 @@ static bool offset_dir_emit(struct dir_context *ctx, struct dentry *dentry)
 			  inode->i_ino, fs_umode_to_dtype(inode->i_mode));
 }
 
-static void offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
+static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 {
 	struct offset_ctx *so_ctx = inode->i_op->get_offset_ctx(inode);
 	XA_STATE(xas, &so_ctx->xa, ctx->pos);
@@ -434,7 +436,7 @@ static void offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 	while (true) {
 		dentry = offset_find_next(&xas);
 		if (!dentry)
-			break;
+			return ERR_PTR(-ENOENT);
 
 		if (!offset_dir_emit(ctx, dentry)) {
 			dput(dentry);
@@ -444,6 +446,7 @@ static void offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 		dput(dentry);
 		ctx->pos = xas.xa_index + 1;
 	}
+	return NULL;
 }
 
 /**
@@ -476,7 +479,12 @@ static int offset_readdir(struct file *file, struct dir_context *ctx)
 	if (!dir_emit_dots(file, ctx))
 		return 0;
 
-	offset_iterate_dir(d_inode(dir), ctx);
+	/* In this case, ->private_data is protected by f_pos_lock */
+	if (ctx->pos == 2)
+		file->private_data = NULL;
+	else if (file->private_data == ERR_PTR(-ENOENT))
+		return 0;
+	file->private_data = offset_iterate_dir(d_inode(dir), ctx);
 	return 0;
 }
 
-- 
2.42.0



