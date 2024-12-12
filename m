Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976E8215782;
	Thu, 12 Dec 2024 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021443; cv=none; b=mfrblx/KmA66/nAKJCSe/vi/mBJ85Dsg2aZKTnRXZPoAMkmweBkw1ZNjVl5gftWvh5jK593iPwcGnTF7b0bx3UMCpHPl/98h7Jt1fGVDx+VGRIoJRRFx1r32NPNFdzjTuQd36GrqOqSHqFluqpgACoZ9E8YRli6QdTs7EBU6o5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021443; c=relaxed/simple;
	bh=4al7AiiJ+EYsuKcmyBB7+FS/NwQu762MlUzFtGrLQ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXDWbwmOf8R1MdTrSP/4yVK1vDDq9KU41+0V8oV9SAJUIRV/MRAQOcQxzwD51qDp9ifmfve55LvbpeysYH3qy51dLKPv6UbiyqgMDOPlGe+OhoIIwsUfj1+OmSb+wT74XEi2mYK3qVB8KlvA3kuAgosYqfkNcdTw8GamnAbd0ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AprkdEWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AprkdEWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC68FC4CECE;
	Thu, 12 Dec 2024 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021443;
	bh=4al7AiiJ+EYsuKcmyBB7+FS/NwQu762MlUzFtGrLQ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AprkdEWk3Ei0md6vr87HBc6qsSJC4HZC/OPJ8kBRcHLXDg3onQ3fvQGJ8BQXY0kZQ
	 Oz9kXaEXKxwahNn3ntU1FUA7aZUty32GDpqS9RugTOaJTBgKF5p5zQnJ8CvWtI9rw1
	 cJYc2CuuMPuxidEMNCAJrR/NWddWJNCrrmWHJAak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Jakub Acs <acsjakub@amazon.de>
Subject: [PATCH 6.1 738/772] udf: Fold udf_getblk() into udf_bread()
Date: Thu, 12 Dec 2024 16:01:23 +0100
Message-ID: <20241212144420.425153374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

commit 32f123a3f34283f9c6446de87861696f0502b02e upstream.

udf_getblk() has a single call site. Fold it there.

Signed-off-by: Jan Kara <jack@suse.cz>
[acsjakub: backport-adjusting changes
 udf_getblk() has changed between 6.1 and the backported commit, namely
 in commit 541e047b14c8 ("udf: Use udf_map_block() in udf_getblk()")
 Backport using the form of udf_getblk present in 6.1., that means use
 udf_get_block() instead of udf_map_block() and use dummy in buffer_new()
 and buffer_mapped(). ]
Closes: https://syzkaller.appspot.com/bug?extid=a38e34ca637c224f4a79
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -369,29 +369,6 @@ abort:
 	return err;
 }
 
-static struct buffer_head *udf_getblk(struct inode *inode, udf_pblk_t block,
-				      int create, int *err)
-{
-	struct buffer_head *bh;
-	struct buffer_head dummy;
-
-	dummy.b_state = 0;
-	dummy.b_blocknr = -1000;
-	*err = udf_get_block(inode, block, &dummy, create);
-	if (!*err && buffer_mapped(&dummy)) {
-		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
-		if (buffer_new(&dummy)) {
-			lock_buffer(bh);
-			memset(bh->b_data, 0x00, inode->i_sb->s_blocksize);
-			set_buffer_uptodate(bh);
-			unlock_buffer(bh);
-			mark_buffer_dirty_inode(bh, inode);
-		}
-		return bh;
-	}
-
-	return NULL;
-}
 
 /* Extend the file with new blocks totaling 'new_block_bytes',
  * return the number of extents added
@@ -1108,11 +1085,30 @@ struct buffer_head *udf_bread(struct ino
 			      int create, int *err)
 {
 	struct buffer_head *bh = NULL;
+	struct buffer_head dummy;
+
+	dummy.b_state = 0;
+	dummy.b_blocknr = -1000;
 
-	bh = udf_getblk(inode, block, create, err);
-	if (!bh)
+	*err = udf_get_block(inode, block, &dummy, create);
+	if (*err || !buffer_mapped(&dummy))
 		return NULL;
 
+	bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
+	if (!bh) {
+		*err = -ENOMEM;
+		return NULL;
+	}
+
+	if (buffer_new(&dummy)) {
+		lock_buffer(bh);
+		memset(bh->b_data, 0x00, inode->i_sb->s_blocksize);
+		set_buffer_uptodate(bh);
+		unlock_buffer(bh);
+		mark_buffer_dirty_inode(bh, inode);
+		return bh;
+	}
+
 	if (bh_read(bh, 0) >= 0)
 		return bh;
 


