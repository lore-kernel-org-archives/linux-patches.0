Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967D5148FE6;
	Wed, 30 Jul 2025 09:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869360; cv=none; b=UdeKT5L36iafnEWWSrS7VmHGu2SwsATFZAqwtScpYxNc6sIe1kueXGywPVmpk/I5koCU5qQmZQ61qXtWp2OJ1CNORXUHNhYfMK+qRATDEl7SfYHJn1z2cGyiIkB75TjMe7vf54guQsQZrwqUyVFTd+BMSak5djmCWzOqNrwz65w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869360; c=relaxed/simple;
	bh=a6kbNv2i40SXa2h4jf4XQgR9rDQOaNeAs6v56eDENts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6i/rF3BrQwPPnRFmvUi5w2pL/OM2t2vDK54ShaMw0citmjBmlhLMLXCSsJ1OMLP18m1HK3XvEjz8K/Q+wGtQg6+ERr5DaBjSOa9bhkhj5cX7GNnMX+SZfNFV32CPn41IO6SMv/cZF5J4n3dtyDq/ZJpuGndzAlQnd00oG3JXmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zd2yh3R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zd2yh3R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01CEC4CEE7;
	Wed, 30 Jul 2025 09:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869360;
	bh=a6kbNv2i40SXa2h4jf4XQgR9rDQOaNeAs6v56eDENts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zd2yh3R39NYaeOB1sJnyBLcC9jIVRfvqEEunUd0FgRgGoCZFIvpzfkdWQFP373egX
	 4krGwE+1nHRCp+2TlOovAglTLig1oiogURh7HJcrdRWLrR4iRcyaBqlLYfJ7npQFMK
	 wX+n5VbOvfNyEGyk3avAZRdyTyiXxLxV/KSDtM1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 72/92] nilfs2: reject invalid file types when reading inodes
Date: Wed, 30 Jul 2025 11:36:20 +0200
Message-ID: <20250730093233.538967882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 4aead50caf67e01020c8be1945c3201e8a972a27 upstream.

To prevent inodes with invalid file types from tripping through the vfs
and causing malfunctions or assertion failures, add a missing sanity check
when reading an inode from a block device.  If the file type is not valid,
treat it as a filesystem error.

Link: https://lkml.kernel.org/r/20250710134952.29862-1-konishi.ryusuke@gmail.com
Fixes: 05fe58fdc10d ("nilfs2: inode operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -472,11 +472,18 @@ static int __nilfs_read_inode(struct sup
 		inode->i_op = &nilfs_symlink_inode_operations;
 		inode_nohighmem(inode);
 		inode->i_mapping->a_ops = &nilfs_aops;
-	} else {
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		inode->i_op = &nilfs_special_inode_operations;
 		init_special_inode(
 			inode, inode->i_mode,
 			huge_decode_dev(le64_to_cpu(raw_inode->i_device_code)));
+	} else {
+		nilfs_error(sb,
+			    "invalid file type bits in mode 0%o for inode %lu",
+			    inode->i_mode, ino);
+		err = -EIO;
+		goto failed_unmap;
 	}
 	nilfs_ifile_unmap_inode(raw_inode);
 	brelse(bh);


