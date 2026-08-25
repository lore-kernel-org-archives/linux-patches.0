Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0AA483BC5;
	Tue, 25 Aug 2026 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664861; cv=none; b=eJtOKJIDoLtO7buuEoWoy5nN0LbX8B/wcNyvN6rAEmmXRXQD7mSoa38J/AfAMHP1ehsJC5Htq252st/vTqZUv19niRdlZ2J701T3UpBW1z3Hc0IS2igykrHDV7n3XsPBcnQZTuiUL73odb4buTqWcbRtuy/NPsFBej23AcoDnlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664861; c=relaxed/simple;
	bh=BRTO0XTM+awK+Gz1alIkpiE2a+TlTYqJXCOY2ekgA+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muOChdRSt6VXrqX/7ffSHoj9StRNN7kvb/90vi6AokClrDD9rDfg3XtvlaBq379jPQ5fWcu5thNZn1OzfNdptztZ9sTh9vt/PqndlupsUnTx2iuJ4H4TxsMev1cRQtaCqA7v7Ax9VReGczaieEYICVrRDQdVRC7sEUjfCoVe+qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPfjw/rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPfjw/rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9F21F000E9;
	Tue, 25 Aug 2026 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664860;
	bh=EdAqzDfNIH6v/OR/+ofSIRZNo1astOQFqKTkFUdimfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPfjw/rpDasfqS1/Ouwb5OB9ibKYtqQh7Tno2lZ+p6ZL4PeE+3tvsdoB+7AoGWkfy
	 Xc1b2GBWG9S/lWElTS7qXHHt//MvZWU7YK3sVRWW/FnrNAjwDaQUAjPYrC+VE7V+xy
	 KnQd/VMOsK+5NQQevECR7yKfoBQrH+wSVCB4p4kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Disha Goel <disgoel@linux.ibm.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.1 029/101] ext4: dont enable DAX on new encrypted files
Date: Tue, 25 Aug 2026 15:25:07 +0200
Message-ID: <20260825132543.159462934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit da32af420d6d466e247c43ac0b829edeac7ae0ad upstream.

Currently, when a new encrypted regular file is created, the call to
ext4_set_inode_flags(inode, init=true) in __ext4_new_inode() is made
before EXT4_INODE_ENCRYPT is set.  As a result, it can set S_DAX if the
filesystem is mounted with "-o dax=always".

EXT4_INODE_ENCRYPT then actually gets set a bit later in
__ext4_new_inode(), when it calls fscrypt_set_context() which calls
ext4_set_context().  ext4_set_context() sets EXT4_INODE_ENCRYPT and
calls ext4_set_inode_flags(inode, init=false) to set S_ENCRYPTED too.

This was intended to clear S_DAX as well.  However, this was broken by
commit 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load").  This
causes data written to the file to bypass encryption, also causing
xfstests failures such as generic/548 (when "-o dax=always" is used).

Fix this by simplifying the flow by making __ext4_new_inode() set
EXT4_INODE_ENCRYPT earlier.  This makes it take effect in
ext4_set_inode_flags(inode, init=true), making S_DAX never be set.

Similarly, make EXT4_STATE_MAY_INLINE_DATA never be set in the first
place on new encrypted inodes.  Then it doesn't need to be cleared.

As a result of these simplifications, ext4_set_context() no longer needs
to change inode flags or state when 'handle != NULL'.  Remove that too.

Reported-by: Disha Goel <disgoel@linux.ibm.com>
Reported-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Closes: https://lore.kernel.org/r/20260723085648.1500357-1-ojaswin@linux.ibm.com
Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Tested-by: Disha Goel <disgoel@linux.ibm.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260730175212.36923-1-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/crypto.c |   40 ++++++++++++++++++++--------------------
 fs/ext4/ialloc.c |    4 ++++
 2 files changed, 24 insertions(+), 20 deletions(-)

--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -144,7 +144,13 @@ static int ext4_set_context(struct inode
 	if (inode->i_ino == EXT4_ROOT_INO)
 		return -EPERM;
 
-	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
+	/*
+	 * For new encrypted inodes, S_DAX is never set in the first place.
+	 *
+	 * For existing inodes, this is called only on empty directories.  ext4
+	 * never sets S_DAX on directories.
+	 */
+	if (WARN_ON_ONCE(IS_DAX(inode)))
 		return -EINVAL;
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
@@ -164,27 +170,24 @@ static int ext4_set_context(struct inode
 
 	if (handle) {
 		/*
+		 * __ext4_new_inode() should have already set the encrypt flag
+		 * on the inode and avoided enabling inline data.
+		 */
+		if (WARN_ON_ONCE(!IS_ENCRYPTED(inode)))
+			return -EINVAL;
+		if (WARN_ON_ONCE(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)))
+			return -EINVAL;
+		/*
 		 * Since the inode is new it is ok to pass the
 		 * XATTR_CREATE flag. This is necessary to match the
 		 * remaining journal credits check in the set_handle
 		 * function with the credits allocated for the new
 		 * inode.
 		 */
-		res = ext4_xattr_set_handle(handle, inode,
-					    EXT4_XATTR_INDEX_ENCRYPTION,
-					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-					    ctx, len, XATTR_CREATE);
-		if (!res) {
-			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
-			ext4_clear_inode_state(inode,
-					EXT4_STATE_MAY_INLINE_DATA);
-			/*
-			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-			 * S_DAX may be disabled
-			 */
-			ext4_set_inode_flags(inode, false);
-		}
-		return res;
+		return ext4_xattr_set_handle(handle, inode,
+					     EXT4_XATTR_INDEX_ENCRYPTION,
+					     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+					     ctx, len, XATTR_CREATE);
 	}
 
 	res = dquot_initialize(inode);
@@ -205,10 +208,7 @@ retry:
 				    ctx, len, 0);
 	if (!res) {
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
-		/*
-		 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-		 * S_DAX may be disabled
-		 */
+		/* Update inode->i_flags to set S_ENCRYPTED. */
 		ext4_set_inode_flags(inode, false);
 		res = ext4_mark_inode_dirty(handle, inode);
 		if (res)
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -995,6 +995,8 @@ struct inode *__ext4_new_inode(struct mn
 		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
 		if (err)
 			goto out;
+		if (encrypt)
+			i_flags |= EXT4_ENCRYPT_FL;
 	}
 
 	err = dquot_initialize(inode);
@@ -1304,6 +1306,8 @@ got:
 	ei->i_extra_isize = sbi->s_want_extra_isize;
 	ei->i_inline_off = 0;
 	if (ext4_has_feature_inline_data(sb) &&
+	    /* Encrypted inodes cannot have inline data */
+	    !(ei->i_flags & EXT4_ENCRYPT_FL) &&
 	    (!(ei->i_flags & (EXT4_DAX_FL|EXT4_EA_INODE_FL)) || S_ISDIR(mode)))
 		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = inode;


