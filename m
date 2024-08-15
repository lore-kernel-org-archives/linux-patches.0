Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB9B1B4C29;
	Thu, 15 Aug 2024 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730965; cv=none; b=qXMfa88+PMHQqWu5hq5WkeJJouPWemNmklaVSBQWUQPC0u1ZySSKoPCylq/CDyIIDOKZy7ETnUkTsCU/CEpM8GMKWtn945aKA6tl14rpWB0yZCVYJ7wv2LZfO5bgoYf210els5jobZMYXU8CHyUpVJA8snwKkv9nIpqMWUi8Gnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730965; c=relaxed/simple;
	bh=p2DkVgOFLeFc9+ggu84nZFIoKJbyWxUIw01roJwjJvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNtqcfJ73Zc83siVK7ohQz6qbjVMeyfvUHgXzj2aaEVFXb35cJtRHYx7L0x0HGlPaM6hrX6JmeW+IWfKQ1J50AhL0s+7o5KMRjHigP/iM7BO8Cha32gQ2/o4PeM2N9kVRHQO8Tvy/Zyb3BFM6HCFE3BndWYhDY6qU5ZbUqXuB2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4Yp/aEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4Yp/aEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CC2C32786;
	Thu, 15 Aug 2024 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730965;
	bh=p2DkVgOFLeFc9+ggu84nZFIoKJbyWxUIw01roJwjJvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4Yp/aEAVbTHctOShtczJmjPjjNmtpwOS4y4BnbRanT+jE1CuxrM51L93IHjdYOst
	 e2cGmdpiSESo39zpVIg+J4r1wwYAFHjbrgAZcWwEBbLhaS49S4BIRIqGeUyrNQq8QI
	 bSXSHkYWYIbmyur531Cj/r8aAH6tLNBa3zy23Ots=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 47/67] ext4: fold quota accounting into ext4_xattr_inode_lookup_create()
Date: Thu, 15 Aug 2024 15:26:01 +0200
Message-ID: <20240815131840.121060391@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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
index c58cbe9f7809c..f176c4e8fdcb1 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1571,46 +1571,49 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
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
@@ -1718,16 +1721,11 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
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



