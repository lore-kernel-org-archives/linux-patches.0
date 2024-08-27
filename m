Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77051C688E;
	Tue, 27 Aug 2024 15:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771965; cv=none; b=NBuiEqxGN32n0HTvYqNdy1M+s3zQOXUBd8emB+mxsZfSuUbiFtifQT1cWQm4K4qtdKrSps4v++adNTjsLd9qE2RqIMjRv0zyFiThtXr8+AuaR7ontxfgpuO23gnjg0nh+J+0KQHeFO4FjcYQntFK+pEAHuG+AyYvHIWjRv4motQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771965; c=relaxed/simple;
	bh=99sLLjl2fkiuCDegLgRitqHBpXDhElloHPlyaHsIFik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZtIJIvR9GxY8XpfOOFl494MBgedWSZRT/A8F58G7cWlW8P0IcNxmlVo74+DmEOr2eOx/P1YRZpV1bWuQQfruGJX29B4mfR6SNHnTDUPjay5/jJtgznpLxpWXbF8Udo/aADV785Vlqa9KVaBHRbG6ixO/Clwcba88O3tO1uwmBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNMdp/Zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNMdp/Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465FFC4DDE1;
	Tue, 27 Aug 2024 15:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771965;
	bh=99sLLjl2fkiuCDegLgRitqHBpXDhElloHPlyaHsIFik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNMdp/ZrjTKtMXN6BiT7BpYIgzjbI6xOLSY1/p1DTHNSkISlBVFhhHO6US/Ukpfe+
	 SKcFnMVOVWyGU1ZAvD0lU20gCdXZ3LHfm/s8aopyGv7stwIuGghXOLJlVmGv+TabPb
	 LZaJwPCzXBMsgZcFhFs2aI/8kzXN3iUjnhDBUBDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/321] ext4: fold quota accounting into ext4_xattr_inode_lookup_create()
Date: Tue, 27 Aug 2024 16:36:22 +0200
Message-ID: <20240827143841.059179319@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 8208c41c43ad5e9b63dce6c45a73e326109ca658 ]

When allocating EA inode, quota accounting is done just before
ext4_xattr_inode_lookup_create(). Logically these two operations belong
together so just fold quota accounting into
ext4_xattr_inode_lookup_create(). We also make
ext4_xattr_inode_lookup_create() return the looked up / created inode to
convert the function to a more standard calling convention.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240209112107.10585-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 50 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0df0a3ecba37a..b18035b8887be 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1522,46 +1522,49 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 /*
  * Add value of the EA in an inode.
  */
-static int ext4_xattr_inode_lookup_create(handle_t *handle, struct inode *inode,
-					  const void *value, size_t value_len,
-					  struct inode **ret_inode)
+static struct inode *ext4_xattr_inode_lookup_create(handle_t *handle,
+		struct inode *inode, const void *value, size_t value_len)
 {
 	struct inode *ea_inode;
 	u32 hash;
 	int err;
 
+	/* Account inode & space to quota even if sharing... */
+	err = ext4_xattr_inode_alloc_quota(inode, value_len);
+	if (err)
+		return ERR_PTR(err);
+
 	hash = ext4_xattr_inode_hash(EXT4_SB(inode->i_sb), value, value_len);
 	ea_inode = ext4_xattr_inode_cache_find(inode, value, value_len, hash);
 	if (ea_inode) {
 		err = ext4_xattr_inode_inc_ref(handle, ea_inode);
-		if (err) {
-			iput(ea_inode);
-			return err;
-		}
-
-		*ret_inode = ea_inode;
-		return 0;
+		if (err)
+			goto out_err;
+		return ea_inode;
 	}
 
 	/* Create an inode for the EA value */
 	ea_inode = ext4_xattr_inode_create(handle, inode, hash);
-	if (IS_ERR(ea_inode))
-		return PTR_ERR(ea_inode);
+	if (IS_ERR(ea_inode)) {
+		ext4_xattr_inode_free_quota(inode, NULL, value_len);
+		return ea_inode;
+	}
 
 	err = ext4_xattr_inode_write(handle, ea_inode, value, value_len);
 	if (err) {
 		if (ext4_xattr_inode_dec_ref(handle, ea_inode))
 			ext4_warning_inode(ea_inode, "cleanup dec ref error %d", err);
-		iput(ea_inode);
-		return err;
+		goto out_err;
 	}
 
 	if (EA_INODE_CACHE(inode))
 		mb_cache_entry_create(EA_INODE_CACHE(inode), GFP_NOFS, hash,
 				      ea_inode->i_ino, true /* reusable */);
-
-	*ret_inode = ea_inode;
-	return 0;
+	return ea_inode;
+out_err:
+	iput(ea_inode);
+	ext4_xattr_inode_free_quota(inode, NULL, value_len);
+	return ERR_PTR(err);
 }
 
 /*
@@ -1669,16 +1672,11 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 	if (i->value && in_inode) {
 		WARN_ON_ONCE(!i->value_len);
 
-		ret = ext4_xattr_inode_alloc_quota(inode, i->value_len);
-		if (ret)
-			goto out;
-
-		ret = ext4_xattr_inode_lookup_create(handle, inode, i->value,
-						     i->value_len,
-						     &new_ea_inode);
-		if (ret) {
+		new_ea_inode = ext4_xattr_inode_lookup_create(handle, inode,
+					i->value, i->value_len);
+		if (IS_ERR(new_ea_inode)) {
+			ret = PTR_ERR(new_ea_inode);
 			new_ea_inode = NULL;
-			ext4_xattr_inode_free_quota(inode, NULL, i->value_len);
 			goto out;
 		}
 	}
-- 
2.43.0



