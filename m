Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1018494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686B0C433F1;
	Thu,  5 Jan 2023 13:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672924154;
	bh=WoJizg100qiYf7/FvA1kI0UcHjJZT6LY1W7AEfS6H1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKSQOjrwZGXRXPZ64PclSFuwqIYQXKLOP75Zx/qwwcj9AEOuLF0zwfsB1U24gvPUn
	 RAsWV0HVo3nLj52A862ifvhGLcSTK1gkNiGaJSx5bdqonflPoaArgK0ux6YB4Se5nD
	 XqDHbAnM1eSyJ5BXgXLh39CuO9v0BYuFbi+3aPwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 4.9 250/251] ext4: avoid BUG_ON when creating xattrs
Date: Thu,  5 Jan 2023 13:56:27 +0100
Message-Id: <20230105125346.319748653@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit b40ebaf63851b3a401b0dc9263843538f64f5ce6 upstream.

Commit fb0a387dcdcd ("ext4: limit block allocations for indirect-block
files to < 2^32") added code to try to allocate xattr block with 32-bit
block number for indirect block based files on the grounds that these
files cannot use larger block numbers. It also added BUG_ON when
allocated block could not fit into 32 bits. This is however bogus
reasoning because xattr block is stored in inode->i_file_acl and
inode->i_file_acl_hi and as such even indirect block based files can
happily use full 48 bits for xattr block number. The proper handling
seems to be there basically since 64-bit block number support was added.
So remove the bogus limitation and BUG_ON.

Cc: Eric Sandeen <sandeen@redhat.com>
Fixes: fb0a387dcdcd ("ext4: limit block allocations for indirect-block files to < 2^32")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221121130929.32031-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -974,19 +974,11 @@ inserted:
 
 			goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-
-			/* non-extent files can't have physical blocks past 2^32 */
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
-
 			block = ext4_new_meta_blocks(handle, inode, goal, 0,
 						     NULL, &error);
 			if (error)
 				goto cleanup;
 
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
-
 			ea_idebug(inode, "creating block %llu",
 				  (unsigned long long)block);
 


