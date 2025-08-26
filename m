Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED52F1E520C;
	Tue, 26 Aug 2025 13:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215692; cv=none; b=ltFnkJlJ7jMn74u6WobjWCsETjxt4iv8yRORLhmW26wrENhHfi2lUQssYqDQG+Asoblzg4P2RpNCwn7hlzxaWj8kLQL+xatqpi95cI8bY5pVXZiXOnROnHC1eOA4ASyS8pIrUYrqP1iBXJIa+58urMkkaHPntNmAlWV1/P5p4yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215692; c=relaxed/simple;
	bh=/bbH/MT6u2HBmYbpzDYco70cHbzNYnKP8dhS7cZTWUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Enjcg6u4a+M+P9s4sjtaQc4I49RJh9KHCDjmHDZtcmVM8QsplpiHRVkvk23/EHSxiumj7ELxDD9y8WF36BOqM7B+/TdOuvUpcrpKOVas7E9Ptch3FTFgUheHcp9p90jLotiQIgp+NroYEelDDAY2bUtUDfM9gK3jxsJ31NoMK74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRW8JbG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRW8JbG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8233BC116D0;
	Tue, 26 Aug 2025 13:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215691;
	bh=/bbH/MT6u2HBmYbpzDYco70cHbzNYnKP8dhS7cZTWUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRW8JbG0IQo2juUvCuv3TwSeXwW+ZNAfZMNoKjhGTRYuh6Niy0h/mWZ8FZ9oPkPa9
	 yrNqnykEyvchm4URPk9D+ydYrr4QYx5UWDoGI1/AXCcK5uj3WumBnNKCEAANPPsNRU
	 dYADspG/sKOthcsg4Sbkckp3REghrrPiqEhba6Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 098/644] nilfs2: reject invalid file types when reading inodes
Date: Tue, 26 Aug 2025 13:03:09 +0200
Message-ID: <20250826110948.938657604@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


