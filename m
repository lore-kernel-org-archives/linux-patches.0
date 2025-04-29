Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0942512E2;
	Tue, 29 Apr 2025 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945231; cv=none; b=es2IU1AAoxAu0YdA47FHRKS2f6x5KaFam0rXuiTerNJwGHrwSsoUwwCSpUJn0sZH4JEd5mUoSEqcNqqTmtcWLLUEQx61fqUyXZ9OaMbydibbnWKD1M8d1w3wHp6UJFyPifHhps6yTFTBekq0d+HTaN82qCsS0TNaXNwCgQyv0a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945231; c=relaxed/simple;
	bh=jKGaYZsumomCmFFxNwRCsDQjXW5jZVextj8eOaERIlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlOT0I5AQ53V3ompN0vBAppEhHtYKG4J1HFVu0yBnVtVYzyHF8wBHOEVRFL7OefaPRK48ILNeEQy/Ytl9q9kg2zya9VZ/G9inb/vjSRb3wSDFUPaqv1uvB9kYLRXyY6UM4EV/ee9vEOA1yi5xXWeT0/M9w3aJPMzjlwnzJv5AV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nY9q3120; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nY9q3120"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED036C4CEED;
	Tue, 29 Apr 2025 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945229;
	bh=jKGaYZsumomCmFFxNwRCsDQjXW5jZVextj8eOaERIlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nY9q3120l0KdmdK/9i2sH+q/kEwMDLy/sHXYkjBzr3tqibs6v0WAC6SuWT7kJxWxT
	 bnZ9svLFsoZSadFHDztJHTghwwEihNjMQWpimDvB9jagOEejdn/0zJolIzCyFkNoq3
	 hW53KkZ5cenYBqKnwYng/e6foJOGU1wUnX0G6kG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/179] ext4: dont treat fhandle lookup of ea_inode as FS corruption
Date: Tue, 29 Apr 2025 18:39:44 +0200
Message-ID: <20250429161051.149457293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 642335f3ea2b3fd6dba03e57e01fa9587843a497 ]

A file handle that userspace provides to open_by_handle_at() can
legitimately contain an outdated inode number that has since been reused
for another purpose - that's why the file handle also contains a generation
number.

But if the inode number has been reused for an ea_inode, check_igot_inode()
will notice, __ext4_iget() will go through ext4_error_inode(), and if the
inode was newly created, it will also be marked as bad by iget_failed().
This all happens before the point where the inode generation is checked.

ext4_error_inode() is supposed to only be used on filesystem corruption; it
should not be used when userspace just got unlucky with a stale file
handle. So when this happens, let __ext4_iget() just return an error.

Fixes: b3e6bcb94590 ("ext4: add EA_INODE checking to ext4_iget()")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241129-ext4-ignore-ea-fhandle-v1-1-e532c0d1cee0@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 68 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0289a9e36d355..8f020c719b18d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4893,22 +4893,43 @@ static inline u64 ext4_inode_peek_iversion(const struct inode *inode)
 		return inode_peek_iversion(inode);
 }
 
-static const char *check_igot_inode(struct inode *inode, ext4_iget_flags flags)
-
+static int check_igot_inode(struct inode *inode, ext4_iget_flags flags,
+			    const char *function, unsigned int line)
 {
+	const char *err_str;
+
 	if (flags & EXT4_IGET_EA_INODE) {
-		if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
-			return "missing EA_INODE flag";
+		if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
+			err_str = "missing EA_INODE flag";
+			goto error;
+		}
 		if (ext4_test_inode_state(inode, EXT4_STATE_XATTR) ||
-		    EXT4_I(inode)->i_file_acl)
-			return "ea_inode with extended attributes";
+		    EXT4_I(inode)->i_file_acl) {
+			err_str = "ea_inode with extended attributes";
+			goto error;
+		}
 	} else {
-		if ((EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL))
-			return "unexpected EA_INODE flag";
+		if ((EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
+			/*
+			 * open_by_handle_at() could provide an old inode number
+			 * that has since been reused for an ea_inode; this does
+			 * not indicate filesystem corruption
+			 */
+			if (flags & EXT4_IGET_HANDLE)
+				return -ESTALE;
+			err_str = "unexpected EA_INODE flag";
+			goto error;
+		}
+	}
+	if (is_bad_inode(inode) && !(flags & EXT4_IGET_BAD)) {
+		err_str = "unexpected bad inode w/o EXT4_IGET_BAD";
+		goto error;
 	}
-	if (is_bad_inode(inode) && !(flags & EXT4_IGET_BAD))
-		return "unexpected bad inode w/o EXT4_IGET_BAD";
-	return NULL;
+	return 0;
+
+error:
+	ext4_error_inode(inode, function, line, 0, err_str);
+	return -EFSCORRUPTED;
 }
 
 struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
@@ -4919,7 +4940,6 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	struct ext4_inode *raw_inode;
 	struct ext4_inode_info *ei;
 	struct inode *inode;
-	const char *err_str;
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 	long ret;
 	loff_t size;
@@ -4944,10 +4964,10 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW)) {
-		if ((err_str = check_igot_inode(inode, flags)) != NULL) {
-			ext4_error_inode(inode, function, line, 0, err_str);
+		ret = check_igot_inode(inode, flags, function, line);
+		if (ret) {
 			iput(inode);
-			return ERR_PTR(-EFSCORRUPTED);
+			return ERR_PTR(ret);
 		}
 		return inode;
 	}
@@ -5218,13 +5238,21 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		ret = -EFSCORRUPTED;
 		goto bad_inode;
 	}
-	if ((err_str = check_igot_inode(inode, flags)) != NULL) {
-		ext4_error_inode(inode, function, line, 0, err_str);
-		ret = -EFSCORRUPTED;
-		goto bad_inode;
+	ret = check_igot_inode(inode, flags, function, line);
+	/*
+	 * -ESTALE here means there is nothing inherently wrong with the inode,
+	 * it's just not an inode we can return for an fhandle lookup.
+	 */
+	if (ret == -ESTALE) {
+		brelse(iloc.bh);
+		unlock_new_inode(inode);
+		iput(inode);
+		return ERR_PTR(-ESTALE);
 	}
-
+	if (ret)
+		goto bad_inode;
 	brelse(iloc.bh);
+
 	unlock_new_inode(inode);
 	return inode;
 
-- 
2.39.5



