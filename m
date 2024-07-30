Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2021A6192;
	Tue, 30 Jul 2024 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357562; cv=none; b=GH7deRfDmOroYhekFxxmHOObkOm6Ld5PXxtoXsXOIIrdJ68ie+xEmESt/rILDKRyR0UNPDPSmUtdLNG578ddEu46wOTEpcJEIb6CeQshs9FOforv9lJNbQwBPtM919zjFmsoNTSfucNfyvqxe1fqTBRp0P127n29XSkU3GW90J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357562; c=relaxed/simple;
	bh=xtC+cXXj6Rn35pbpBH0eswFfQj7YI7NidXBFDOdmEpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wdk6EiZaKbsIlHdEPsBCjOtSKsuFPXTSv0GjnJpnkyvvfB5qy/yTOFtWX0MmJWScxS3JrcBNC3PBFEMl7745S15teXnPI5LpBMTLdgDZnGO71krmHh5RuBCwxazheAaqaMT880P4gnkWSSP3wz1IEhnjRzVgE0ihAmdutYNPcR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYdzpM7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYdzpM7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B55C32782;
	Tue, 30 Jul 2024 16:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357561;
	bh=xtC+cXXj6Rn35pbpBH0eswFfQj7YI7NidXBFDOdmEpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYdzpM7BRfkmbDgcVOVnDu5Xx7X2t4xF0+xbIV7I8/QOZZuqoc9JpnxlrYir/hwln
	 NqA38ZoFmSaWBathDqNGpDC+OXeLNyCxJhZKmYB0M+U2HvYP8th/tJ5bwmv1R9h/bE
	 MBUPAgPTI3YZRohl+UZZwXyLY9m5gLtyyfc2aadU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 304/440] ext4: make sure the first directory block is not a hole
Date: Tue, 30 Jul 2024 17:48:57 +0200
Message-ID: <20240730151627.698900538@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit f9ca51596bbfd0f9c386dd1c613c394c78d9e5e6 upstream.

The syzbot constructs a directory that has no dirblock but is non-inline,
i.e. the first directory block is a hole. And no errors are reported when
creating files in this directory in the following flow.

    ext4_mknod
     ...
      ext4_add_entry
        // Read block 0
        ext4_read_dirblock(dir, block, DIRENT)
          bh = ext4_bread(NULL, inode, block, 0)
          if (!bh && (type == INDEX || type == DIRENT_HTREE))
          // The first directory block is a hole
          // But type == DIRENT, so no error is reported.

After that, we get a directory block without '.' and '..' but with a valid
dentry. This may cause some code that relies on dot or dotdot (such as
make_indexed_dir()) to crash.

Therefore when ext4_read_dirblock() finds that the first directory block
is a hole report that the filesystem is corrupted and return an error to
avoid loading corrupted data from disk causing something bad.

Reported-by: syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ae688d469e36fb5138d0
Fixes: 4e19d6b65fb4 ("ext4: allow directory holes")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240702132349.2600605-3-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -151,10 +151,11 @@ static struct buffer_head *__ext4_read_d
 
 		return bh;
 	}
-	if (!bh && (type == INDEX || type == DIRENT_HTREE)) {
+	/* The first directory block must not be a hole. */
+	if (!bh && (type == INDEX || type == DIRENT_HTREE || block == 0)) {
 		ext4_error_inode(inode, func, line, block,
-				 "Directory hole found for htree %s block",
-				 (type == INDEX) ? "index" : "leaf");
+				 "Directory hole found for htree %s block %u",
+				 (type == INDEX) ? "index" : "leaf", block);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 	if (!bh)
@@ -3133,10 +3134,7 @@ bool ext4_empty_dir(struct inode *inode)
 		EXT4_ERROR_INODE(inode, "invalid size");
 		return false;
 	}
-	/* The first directory block must not be a hole,
-	 * so treat it as DIRENT_HTREE
-	 */
-	bh = ext4_read_dirblock(inode, 0, DIRENT_HTREE);
+	bh = ext4_read_dirblock(inode, 0, EITHER);
 	if (IS_ERR(bh))
 		return false;
 
@@ -3580,10 +3578,7 @@ static struct buffer_head *ext4_get_firs
 		struct ext4_dir_entry_2 *de;
 		unsigned int offset;
 
-		/* The first directory block must not be a hole, so
-		 * treat it as DIRENT_HTREE
-		 */
-		bh = ext4_read_dirblock(inode, 0, DIRENT_HTREE);
+		bh = ext4_read_dirblock(inode, 0, EITHER);
 		if (IS_ERR(bh)) {
 			*retval = PTR_ERR(bh);
 			return NULL;


