Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C0119D065;
	Wed, 30 Jul 2025 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868352; cv=none; b=q6WXD49LuZVLMoc78v/zfDtWXHyDucXX4g1m3gHuuisATCD9XDyN3EMV5LuCSh6++T+H2mamH1R/f6Sq5kRwv9hrSnergL8saHbK0Jo+qlHZ66LsnWEqazbY/S9tSN414bY2ko6EJR9cuextXQA+/l1fsnreuhxx11gHV9Hdv4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868352; c=relaxed/simple;
	bh=ohAo/zbUOmDiNPNH8KeM2dCk6UZ/0mlrbiujMbIruuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrt435N3WE+abwCx7LZNkfjyr8aoh3dD/gDXEf720wEq00nUx4qZMNEHzzr6GUblgO+l/Nvq+qFcYoJAMdQTa5NlpoKl4p/Fcbr++gxw/iKarwApf2yyGDz5+KJZgg5ChbWCO65zvosfvoD4ZJvnVb8NJd31fhGVgXgIQ5QMN5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9l8JIZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9l8JIZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA74C4CEE7;
	Wed, 30 Jul 2025 09:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868352;
	bh=ohAo/zbUOmDiNPNH8KeM2dCk6UZ/0mlrbiujMbIruuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9l8JIZfoYf4NSDs0sxPTkyf39p02oF88HkPmNwREyvjybFMnCrs0g484WLHw9F7Y
	 Nx8xE76JkYk+irQ8c+lEBChdDKN3L9xaZtZxo/z/mWeOCmZsb2mFqQaE6cyDXXtw7e
	 QfHHVPM560ODrpbNU48Uzt8aNPxs9Zp4Ovyb9BZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 43/76] nilfs2: reject invalid file types when reading inodes
Date: Wed, 30 Jul 2025 11:35:36 +0200
Message-ID: <20250730093228.506188643@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


