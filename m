Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B62C2C0F9C;
	Tue, 26 Aug 2025 14:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217324; cv=none; b=AZhrZTlK+5zwSlAEiQtVRij1ash0NefjrtzvAGpxUfStEPYo2i65/xOg3RRT1xWDD83OE4EYzBjHjNK2v9FMW7olZ4GgwqL2PFkqSQLrhRRVj1U63WpFTEzS3CGPiAMHvLqpDtmJ2v1Kfx0phnGne4lsetjixEbPUbmnDVl0l1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217324; c=relaxed/simple;
	bh=PvxsK4xYXP5soo8yR70TRvHL2cc2h4zCZjKz4GgCqBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fToPXj3fdBhlEPL07M/6poh15Y86GyaGrcHEotnrb96A6FP+jh/Tqrf6zgFOiZBit2MCxK4ooEJQvXMuWbR4RJOoarztVYsleb1YFdTDke50+B4qUn158sHf5ym4aD8UuYhJcu6/I8iL5UGsJK6FseQqjN/mL2JaHuCgCXEhuGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0MyUPkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0MyUPkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16EFEC4CEF1;
	Tue, 26 Aug 2025 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217324;
	bh=PvxsK4xYXP5soo8yR70TRvHL2cc2h4zCZjKz4GgCqBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0MyUPkFX8lI3rNFMhSdE4YMlJlvKb1x69DGM6HcLvHroyx5O9O4nxsVH0YWijzGZ
	 C55d4qhfpd1aelxwe1ai9sEp1/0HXsIVXX+gHfcmsjbY16eOg/0gNj4qUfxkMlGQDz
	 NiEQzE5DLb55AiagzJO1DW8IocWVC1k43wqm++Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 069/523] nilfs2: reject invalid file types when reading inodes
Date: Tue, 26 Aug 2025 13:04:39 +0200
Message-ID: <20250826110926.275664298@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -517,11 +517,18 @@ static int __nilfs_read_inode(struct sup
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


