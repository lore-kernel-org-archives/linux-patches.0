Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E0E1E990D;
	Thu, 30 Jan 2025 14:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246612; cv=none; b=Ui/6v5JAseBRlFsCrf26ZGeRKet/OV3BQEOpii+scgQ4iohFcRkFj9+KfEL66IFhiwc6tjKhGv0y6htEam373yEXMn4mxdocZCiWVf/pM+DZdrTyeOdBJ9HNgvbny9YR34CBU5JMoTE7uWZviICEKxhsX7mMY7grv0WwO/4WUSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246612; c=relaxed/simple;
	bh=sLeSR9UzgQL74RSjRbpyUbr0tPqvwiF/PwHbHvelT+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmE4oh/oWUclXU8dgkWSvBqNzWkrF647YusOB93mBKMNAIU90Wcw+MozCwS7ZmbJQZ0kR7kk156QlvIX3VHSPXm6KcIyO378eNVp4lrlPyGNNIHBmXeObJ3idvcL0Mwrh8rMHB1WFQd7V6H9CZr0KBlZWG5qV5JwxV3W5scqzF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3J+wZjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3J+wZjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D37FC4CED2;
	Thu, 30 Jan 2025 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246612;
	bh=sLeSR9UzgQL74RSjRbpyUbr0tPqvwiF/PwHbHvelT+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3J+wZjqmKr9ebKCb30HU9WXslqJl1nreUD7y2gxkc8Fsiz9WAPeM7MGq+IFTB1ie
	 4TO3OB9G/MlPa6wKrSu6JfksHy+Y820WeiWwibSCGHd7uWcCpq+j4Kek6JkeWBsyGl
	 vvb7TGQX5KPaduDQf8twSzDRTy71mdiAmHFS40jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 15/43] libfs: Re-arrange locking in offset_iterate_dir()
Date: Thu, 30 Jan 2025 14:59:22 +0100
Message-ID: <20250130133459.514969822@linuxfoundation.org>
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

[ Upstream commit 3f6d810665dfde0d33785420618ceb03fba0619d ]

Liam and Matthew say that once the RCU read lock is released,
xa_state is not safe to re-use for the next xas_find() call. But the
RCU read lock must be released on each loop iteration so that
dput(), which might_sleep(), can be called safely.

Thus we are forced to walk the offset tree with fresh state for each
directory entry. xa_find() can do this for us, though it might be a
little less efficient than maintaining xa_state locally.

We believe that in the current code base, inode->i_rwsem provides
protection for the xa_state maintained in
offset_iterate_dir(). However, there is no guarantee that will
continue to be the case in the future.

Since offset_iterate_dir() doesn't build xa_state locally any more,
there's no longer a strong need for offset_find_next(). Clean up by
rolling these two helpers together.

Suggested-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Message-ID: <170785993027.11135.8830043889278631735.stgit@91.116.238.104.host.secureserver.net>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/170820142021.6328.15047865406275957018.stgit@91.116.238.104.host.secureserver.net
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -401,12 +401,13 @@ static loff_t offset_dir_llseek(struct f
 	return vfs_setpos(file, offset, U32_MAX);
 }
 
-static struct dentry *offset_find_next(struct xa_state *xas)
+static struct dentry *offset_find_next(struct offset_ctx *octx, loff_t offset)
 {
 	struct dentry *child, *found = NULL;
+	XA_STATE(xas, &octx->xa, offset);
 
 	rcu_read_lock();
-	child = xas_next_entry(xas, U32_MAX);
+	child = xas_next_entry(&xas, U32_MAX);
 	if (!child)
 		goto out;
 	spin_lock(&child->d_lock);
@@ -429,12 +430,11 @@ static bool offset_dir_emit(struct dir_c
 
 static void *offset_iterate_dir(struct inode *inode, struct dir_context *ctx)
 {
-	struct offset_ctx *so_ctx = inode->i_op->get_offset_ctx(inode);
-	XA_STATE(xas, &so_ctx->xa, ctx->pos);
+	struct offset_ctx *octx = inode->i_op->get_offset_ctx(inode);
 	struct dentry *dentry;
 
 	while (true) {
-		dentry = offset_find_next(&xas);
+		dentry = offset_find_next(octx, ctx->pos);
 		if (!dentry)
 			return ERR_PTR(-ENOENT);
 
@@ -443,8 +443,8 @@ static void *offset_iterate_dir(struct i
 			break;
 		}
 
+		ctx->pos = dentry2offset(dentry) + 1;
 		dput(dentry);
-		ctx->pos = xas.xa_index + 1;
 	}
 	return NULL;
 }


