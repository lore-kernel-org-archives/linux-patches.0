Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A9534AB1B;
	Wed,  3 Dec 2025 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779379; cv=none; b=IS85UuJuaoZxsv8P4zrz3/BfZeUFl9V7FUzdbweCLakru8H1cyFzCua7pq2vjdUJUXVmVdWd1CylOZJH6PMgjIGCM5WtFGVcg1hVo+6oD2EMEhysYDGiXaIFb/DRsL4z6UE1/TREUKEhOukxYIC1IOg7twy06+8zNAM/GfqRUDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779379; c=relaxed/simple;
	bh=Tn6eKlY0tYFxcNmHVHTioASjngx/bgZIxYRwuqrhMI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBc64eeigua2AmImE0veZlNYAyE55yeopVKIvT5okccs1iGEt/k83or3cOxatJvr+43dXbbpO96SLMWu+vrv6L0LhkuF/cJpFG57pOo11Zt8g+eT5Nwx1RusebxC0YTMU+zrDmu4dqqXfe3+cAgMR7/zxQyQz1DObo4khVsjwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auYTk1CX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auYTk1CX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C40C4CEF5;
	Wed,  3 Dec 2025 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779379;
	bh=Tn6eKlY0tYFxcNmHVHTioASjngx/bgZIxYRwuqrhMI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auYTk1CXC+KdRjtOKH2Jj6LDaB0OvqSFbWg3w8HHnam4fnEosTNemAzCXtRGFo/bj
	 4p8bfcpjMbUQQllAC3sC5IZEtehBEYP4FpqrwJobN1lQjPaHeScDMiF/tAk+PMcadU
	 opGN959CbOAdDuYmVqI8lXBCr9wuZ0k7tfGhjqiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/568] jfs: Verify inode mode when loading from disk
Date: Wed,  3 Dec 2025 16:24:01 +0100
Message-ID: <20251203152449.474237169@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7a5aa54fba2bd591b22b9b624e6baa9037276986 ]

The inode mode loaded from corrupted disk can be invalid. Do like what
commit 0a9e74051313 ("isofs: Verify inode mode when loading from disk")
does.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index d41891bb617a6..1262b3602cdaf 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -59,9 +59,15 @@ struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 			 */
 			inode->i_link[inode->i_size] = '\0';
 		}
-	} else {
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+	} else {
+		printk(KERN_DEBUG "JFS: Invalid file type 0%04o for inode %lu.\n",
+		       inode->i_mode, inode->i_ino);
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	unlock_new_inode(inode);
 	return inode;
-- 
2.51.0



