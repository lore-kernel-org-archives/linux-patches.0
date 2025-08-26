Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1358341AA1;
	Tue, 26 Aug 2025 14:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218599; cv=none; b=TY24X4XhNZQz4Vw4D083D7WopC78CSqd/ZqjaEjQISbJJF3X8FeAJVzcUoTydl3SCNai6803t9F0afvz3jb9ZdY/LphmvcwiUSGsXYquPrt8wudK7SlJvcoCeT8hASqvZm7iQtazrnIrLMqS9oxxloKefEWGhvcDJalFLbIhNyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218599; c=relaxed/simple;
	bh=M0O2iPzb+9vnjt2b6olFQuUt5tqHo/g/wNDUHZXAWwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxiSWIk+C/0FTe81FBHpyqtDcaS0WRacc4xJ5tsYSr8SZKw9vqV4g1pAHdgCiRM2u3vhoEavca8VTc2YgS0ErrJBXJEbhTBW5gENUdO1ErPiwt+S3QZfLp0Uw6sfUe8CTDsFepNUF2f2ok6Sv6RCvPJQC8Lextih3qnX/YNfKXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWIC+/al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWIC+/al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B93BC4CEF1;
	Tue, 26 Aug 2025 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218598;
	bh=M0O2iPzb+9vnjt2b6olFQuUt5tqHo/g/wNDUHZXAWwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWIC+/alUG0951oNG60o+peNQKPMDNeFn5YqUcLIQ7SU1ATq4wt+7se8OU+b3y69F
	 TkOl1BTsIcI0GNOyWioBXNIa/6X8KHGbvykEFSY5RA45omGRQeSlUBZx5MCQbeAVMZ
	 MdUIU3g/GEfWJKmz8qpnFesT4zikql4BHSyH9UyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 062/403] nilfs2: reject invalid file types when reading inodes
Date: Tue, 26 Aug 2025 13:06:28 +0200
Message-ID: <20250826110907.579495215@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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
@@ -525,11 +525,18 @@ static int __nilfs_read_inode(struct sup
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
 	nilfs_ifile_unmap_inode(root->ifile, ino, bh);
 	brelse(bh);


