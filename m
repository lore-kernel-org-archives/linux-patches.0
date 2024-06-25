Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD0C1494D1;
	Tue, 25 Jun 2024 09:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308368; cv=none; b=oRn89K97qHJq4N1J4OCOT9KcgRPM5hm+AG6SlfGtfTre3KJfyVlhFoxx4Gu5EB+14oKUmaUbaOABR0B3Ptz+HWZ9+Z7CYCrrE+7VLi3qa9Sc/QLTov48AHU4mubMV5AE3ngCHaZ5yc6f8X5BjerfkFi3SM98Mz9Vf13CFowFp/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308368; c=relaxed/simple;
	bh=YgIlgp471FWP2JIyl1RZK+anSPLMX7jSt1s8cekljhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6R6/qynhaB2hcujfFAB0mqxvk7Ue/nuqvQ7NQd0AmZUh+UAS7VXqxAgh6ZSAo+ze8xRpq2fE3OINNaplIt9d+Zi2KpIfRlROq7MbGEcEfPoSDTkGHTesm2JAe5xv7rWxUbp/ReWHLhHnsH3O2ZI9DnpW+LmGbyuYFGcpsUs4WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr7CCLs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr7CCLs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8137C32781;
	Tue, 25 Jun 2024 09:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308368;
	bh=YgIlgp471FWP2JIyl1RZK+anSPLMX7jSt1s8cekljhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gr7CCLs/u/RTxg9FA+5tWKTk8yyr3L9k67310GW/iNYA6yvvMAe2Cpt/WQe6Jbx3r
	 kIoZPs+DAkmVMd3h9d02AQR8sqa7vQSHMNMJnMv328p8Lk60R6Mvwf8nMBB1+1GGos
	 0D34f0bnSHFHLBUAdOoajRtIenQ9ePyNbJ04n9jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a43d4f48b8397d0e41a9@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 067/250] ext4: do not create EA inode under buffer lock
Date: Tue, 25 Jun 2024 11:30:25 +0200
Message-ID: <20240625085550.637441285@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 0a46ef234756dca04623b7591e8ebb3440622f0b ]

ext4_xattr_set_entry() creates new EA inodes while holding buffer lock
on the external xattr block. This is problematic as it nests all the
allocation locking (which acquires locks on other buffers) under the
buffer lock. This can even deadlock when the filesystem is corrupted and
e.g. quota file is setup to contain xattr block as data block. Move the
allocation of EA inode out of ext4_xattr_set_entry() into the callers.

Reported-by: syzbot+a43d4f48b8397d0e41a9@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240321162657.27420-2-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 113 +++++++++++++++++++++++-------------------------
 1 file changed, 53 insertions(+), 60 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 9fdd134220736..78f06f86c3835 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1619,6 +1619,7 @@ static struct inode *ext4_xattr_inode_lookup_create(handle_t *handle,
 static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 				struct ext4_xattr_search *s,
 				handle_t *handle, struct inode *inode,
+				struct inode *new_ea_inode,
 				bool is_block)
 {
 	struct ext4_xattr_entry *last, *next;
@@ -1626,7 +1627,6 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 	size_t min_offs = s->end - s->base, name_len = strlen(i->name);
 	int in_inode = i->in_inode;
 	struct inode *old_ea_inode = NULL;
-	struct inode *new_ea_inode = NULL;
 	size_t old_size, new_size;
 	int ret;
 
@@ -1711,38 +1711,11 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 			old_ea_inode = NULL;
 			goto out;
 		}
-	}
-	if (i->value && in_inode) {
-		WARN_ON_ONCE(!i->value_len);
-
-		new_ea_inode = ext4_xattr_inode_lookup_create(handle, inode,
-					i->value, i->value_len);
-		if (IS_ERR(new_ea_inode)) {
-			ret = PTR_ERR(new_ea_inode);
-			new_ea_inode = NULL;
-			goto out;
-		}
-	}
 
-	if (old_ea_inode) {
 		/* We are ready to release ref count on the old_ea_inode. */
 		ret = ext4_xattr_inode_dec_ref(handle, old_ea_inode);
-		if (ret) {
-			/* Release newly required ref count on new_ea_inode. */
-			if (new_ea_inode) {
-				int err;
-
-				err = ext4_xattr_inode_dec_ref(handle,
-							       new_ea_inode);
-				if (err)
-					ext4_warning_inode(new_ea_inode,
-						  "dec ref new_ea_inode err=%d",
-						  err);
-				ext4_xattr_inode_free_quota(inode, new_ea_inode,
-							    i->value_len);
-			}
+		if (ret)
 			goto out;
-		}
 
 		ext4_xattr_inode_free_quota(inode, old_ea_inode,
 					    le32_to_cpu(here->e_value_size));
@@ -1866,7 +1839,6 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 	ret = 0;
 out:
 	iput(old_ea_inode);
-	iput(new_ea_inode);
 	return ret;
 }
 
@@ -1929,9 +1901,21 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 	size_t old_ea_inode_quota = 0;
 	unsigned int ea_ino;
 
-
 #define header(x) ((struct ext4_xattr_header *)(x))
 
+	/* If we need EA inode, prepare it before locking the buffer */
+	if (i->value && i->in_inode) {
+		WARN_ON_ONCE(!i->value_len);
+
+		ea_inode = ext4_xattr_inode_lookup_create(handle, inode,
+					i->value, i->value_len);
+		if (IS_ERR(ea_inode)) {
+			error = PTR_ERR(ea_inode);
+			ea_inode = NULL;
+			goto cleanup;
+		}
+	}
+
 	if (s->base) {
 		int offset = (char *)s->here - bs->bh->b_data;
 
@@ -1940,6 +1924,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 						      EXT4_JTR_NONE);
 		if (error)
 			goto cleanup;
+
 		lock_buffer(bs->bh);
 
 		if (header(s->base)->h_refcount == cpu_to_le32(1)) {
@@ -1966,7 +1951,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			}
 			ea_bdebug(bs->bh, "modifying in-place");
 			error = ext4_xattr_set_entry(i, s, handle, inode,
-						     true /* is_block */);
+					     ea_inode, true /* is_block */);
 			ext4_xattr_block_csum_set(inode, bs->bh);
 			unlock_buffer(bs->bh);
 			if (error == -EFSCORRUPTED)
@@ -2034,29 +2019,13 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 		s->end = s->base + sb->s_blocksize;
 	}
 
-	error = ext4_xattr_set_entry(i, s, handle, inode, true /* is_block */);
+	error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
+				     true /* is_block */);
 	if (error == -EFSCORRUPTED)
 		goto bad_block;
 	if (error)
 		goto cleanup;
 
-	if (i->value && s->here->e_value_inum) {
-		/*
-		 * A ref count on ea_inode has been taken as part of the call to
-		 * ext4_xattr_set_entry() above. We would like to drop this
-		 * extra ref but we have to wait until the xattr block is
-		 * initialized and has its own ref count on the ea_inode.
-		 */
-		ea_ino = le32_to_cpu(s->here->e_value_inum);
-		error = ext4_xattr_inode_iget(inode, ea_ino,
-					      le32_to_cpu(s->here->e_hash),
-					      &ea_inode);
-		if (error) {
-			ea_inode = NULL;
-			goto cleanup;
-		}
-	}
-
 inserted:
 	if (!IS_LAST_ENTRY(s->first)) {
 		new_bh = ext4_xattr_block_cache_find(inode, header(s->base),
@@ -2198,17 +2167,16 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 cleanup:
 	if (ea_inode) {
-		int error2;
-
-		error2 = ext4_xattr_inode_dec_ref(handle, ea_inode);
-		if (error2)
-			ext4_warning_inode(ea_inode, "dec ref error=%d",
-					   error2);
+		if (error) {
+			int error2;
 
-		/* If there was an error, revert the quota charge. */
-		if (error)
+			error2 = ext4_xattr_inode_dec_ref(handle, ea_inode);
+			if (error2)
+				ext4_warning_inode(ea_inode, "dec ref error=%d",
+						   error2);
 			ext4_xattr_inode_free_quota(inode, ea_inode,
 						    i_size_read(ea_inode));
+		}
 		iput(ea_inode);
 	}
 	if (ce)
@@ -2266,14 +2234,38 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 {
 	struct ext4_xattr_ibody_header *header;
 	struct ext4_xattr_search *s = &is->s;
+	struct inode *ea_inode = NULL;
 	int error;
 
 	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
 		return -ENOSPC;
 
-	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
-	if (error)
+	/* If we need EA inode, prepare it before locking the buffer */
+	if (i->value && i->in_inode) {
+		WARN_ON_ONCE(!i->value_len);
+
+		ea_inode = ext4_xattr_inode_lookup_create(handle, inode,
+					i->value, i->value_len);
+		if (IS_ERR(ea_inode))
+			return PTR_ERR(ea_inode);
+	}
+	error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
+				     false /* is_block */);
+	if (error) {
+		if (ea_inode) {
+			int error2;
+
+			error2 = ext4_xattr_inode_dec_ref(handle, ea_inode);
+			if (error2)
+				ext4_warning_inode(ea_inode, "dec ref error=%d",
+						   error2);
+
+			ext4_xattr_inode_free_quota(inode, ea_inode,
+						    i_size_read(ea_inode));
+			iput(ea_inode);
+		}
 		return error;
+	}
 	header = IHDR(inode, ext4_raw_inode(&is->iloc));
 	if (!IS_LAST_ENTRY(s->first)) {
 		header->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
@@ -2282,6 +2274,7 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 		header->h_magic = cpu_to_le32(0);
 		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
 	}
+	iput(ea_inode);
 	return 0;
 }
 
-- 
2.43.0



