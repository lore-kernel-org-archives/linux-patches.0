Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009F83370FB;
	Fri, 17 Oct 2025 15:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713989; cv=none; b=Y3tmpq0USaESO+0Buh6j8sgJdaovlDB0DH2xy9vh+8PjziMGTzhZVGJlzKoP60vznlabNbM7nP7Wfxqzwv9oiOuLp/1vGT3ggcKc72KqIUo9ZKhfsQLO5gtH6ecHblwA1w9C1U3wsoeAjOiFNQopyvJz1ikXohMjxX1qA3bvEkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713989; c=relaxed/simple;
	bh=gzjY3xcN7URYxPrGSWSr3N3FPMbNdqQcRZ0JnsCkX/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PV7a15wA2tAWsCxIXzje+Y0d2+EijhPCt6Cr956kuv9JGCeGLCJL2WQvFNOP71sCFQ+S3kFymURcK5z7B04loyaaeIocoFwp4nT3g6tt75u1FMkr2u8jlEPvM/Hjs9erhG2zCJVoXeWd+/lO1iyeUqeCH1uc3Tnd7I0V4MegH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIlD8uR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIlD8uR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B31C4CEE7;
	Fri, 17 Oct 2025 15:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713988;
	bh=gzjY3xcN7URYxPrGSWSr3N3FPMbNdqQcRZ0JnsCkX/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIlD8uR1XNSC19Z+kQcFekoUxSZsPq+dj7ISzfAVamCSrJipUYXmfSZeUCn2u8DJc
	 DEwucKKD/+Ng0UCRjD9It1a2IiNAClCOfOGA8YiFG4H8g5ZzfJhkBeOp19QBMoUwFL
	 ZWeXMBfWvzDNWRLQFaVyYN0yNYfQ0nNjudE59oWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/201] Squashfs: add additional inode sanity checking
Date: Fri, 17 Oct 2025 16:53:38 +0200
Message-ID: <20251017145140.497440368@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 9ee94bfbe930a1b39df53fa2d7b31141b780eb5a ]

Patch series "Squashfs: performance improvement and a sanity check".

This patchset adds an additional sanity check when reading regular file
inodes, and adds support for SEEK_DATA/SEEK_HOLE lseek() whence values.

This patch (of 2):

Add an additional sanity check when reading regular file inodes.

A regular file if the file size is an exact multiple of the filesystem
block size cannot have a fragment.  This is because by definition a
fragment block stores tailends which are not a whole block in size.

Link: https://lkml.kernel.org/r/20250923220652.568416-1-phillip@squashfs.org.uk
Link: https://lkml.kernel.org/r/20250923220652.568416-2-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 9f1c14c1de1b ("Squashfs: reject negative file sizes in squashfs_read_inode()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/inode.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -140,8 +140,17 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
+			/*
+			 * the file cannot have a fragment (tailend) and have a
+			 * file size a multiple of the block size
+			 */
+			if ((inode->i_size & (msblk->block_size - 1)) == 0) {
+				err = -EINVAL;
+				goto failed_read;
+			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
 			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
 			if (frag_size < 0) {
@@ -155,7 +164,6 @@ int squashfs_read_inode(struct inode *in
 		}
 
 		set_nlink(inode, 1);
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_fop = &generic_ro_fops;
 		inode->i_mode |= S_IFREG;
 		inode->i_blocks = ((inode->i_size - 1) >> 9) + 1;
@@ -184,8 +192,17 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
 		frag = le32_to_cpu(sqsh_ino->fragment);
 		if (frag != SQUASHFS_INVALID_FRAG) {
+			/*
+			 * the file cannot have a fragment (tailend) and have a
+			 * file size a multiple of the block size
+			 */
+			if ((inode->i_size & (msblk->block_size - 1)) == 0) {
+				err = -EINVAL;
+				goto failed_read;
+			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
 			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
 			if (frag_size < 0) {
@@ -200,7 +217,6 @@ int squashfs_read_inode(struct inode *in
 
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
-		inode->i_size = le64_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_inode_ops;
 		inode->i_fop = &generic_ro_fops;
 		inode->i_mode |= S_IFREG;


