Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6F62D541B;
	Thu, 15 Jan 2026 17:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498924; cv=none; b=J+PJl8M41PCIESHNxeeHJS4QSrvnCaBdYoMnjOv/r3Iguq1DrkGm2VzA0jED0kiw5sU52uptwP3VbTfqzVm3rJFH3aZSGrrHREc2hRc5b5IHGUBmMir9DauuBlACITCu+75MHSU/iJ0Cy4UYCKI81PAbq+/cUJTWvdsjxp3qY6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498924; c=relaxed/simple;
	bh=/Gxz6OW2s5TdpXdOfQ1rLs/Ti8XS/8/52fAZNNAn7p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LujG+WwyWwnIH0SL6XpMcFTkiPXZB3hsI+nmyns/EhwhrgsvGTwlXqn8Lcap6KQQs8CiGbS50q/skpBiS5OEJUxrHW/3rf5GMwioNDzLrX5ck09IKnhwbzqUKIYwYyqXEPO2cRmElfHbc9pDSXJI+C1eYDDx46Qfut81WB6m6V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxhahFj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxhahFj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0D4C116D0;
	Thu, 15 Jan 2026 17:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498924;
	bh=/Gxz6OW2s5TdpXdOfQ1rLs/Ti8XS/8/52fAZNNAn7p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxhahFj86WOg6+Ux2sTqJ/5QO/UOSqJ1UIN8mhA7yZPvdNhfdSN0lSzzLVGrBQwyp
	 HQqEoauNH4Im95f0knbT1Lchrnjb9RVsWh9O9Fz9ZWRtPx1tSo7ouKk8sK8qRodX7c
	 1BcyAPxya956A0iaaGQQk6t8XWNGaY9bBMAIHSS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Tigran Aivazian <aivazian.tigran@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/451] bfs: Reconstruct file type when loading from disk
Date: Thu, 15 Jan 2026 17:43:40 +0100
Message-ID: <20260115164231.583684712@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 34ab4c75588c07cca12884f2bf6b0347c7a13872 ]

syzbot is reporting that S_IFMT bits of inode->i_mode can become bogus when
the S_IFMT bits of the 32bits "mode" field loaded from disk are corrupted
or when the 32bits "attributes" field loaded from disk are corrupted.

A documentation says that BFS uses only lower 9 bits of the "mode" field.
But I can't find an explicit explanation that the unused upper 23 bits
(especially, the S_IFMT bits) are initialized with 0.

Therefore, ignore the S_IFMT bits of the "mode" field loaded from disk.
Also, verify that the value of the "attributes" field loaded from disk is
either BFS_VREG or BFS_VDIR (because BFS supports only regular files and
the root directory).

Reported-by: syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://patch.msgid.link/fabce673-d5b9-4038-8287-0fd65d80203b@I-love.SAKURA.ne.jp
Reviewed-by: Tigran Aivazian <aivazian.tigran@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/bfs/inode.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index fd691e4815c56..fa4e002925852 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -60,7 +60,19 @@ struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
 	di = (struct bfs_inode *)bh->b_data + off;
 
-	inode->i_mode = 0x0000FFFF & le32_to_cpu(di->i_mode);
+	/*
+	 * https://martin.hinner.info/fs/bfs/bfs-structure.html explains that
+	 * BFS in SCO UnixWare environment used only lower 9 bits of di->i_mode
+	 * value. This means that, although bfs_write_inode() saves whole
+	 * inode->i_mode bits (which include S_IFMT bits and S_IS{UID,GID,VTX}
+	 * bits), middle 7 bits of di->i_mode value can be garbage when these
+	 * bits were not saved by bfs_write_inode().
+	 * Since we can't tell whether middle 7 bits are garbage, use only
+	 * lower 12 bits (i.e. tolerate S_IS{UID,GID,VTX} bits possibly being
+	 * garbage) and reconstruct S_IFMT bits for Linux environment from
+	 * di->i_vtype value.
+	 */
+	inode->i_mode = 0x00000FFF & le32_to_cpu(di->i_mode);
 	if (le32_to_cpu(di->i_vtype) == BFS_VDIR) {
 		inode->i_mode |= S_IFDIR;
 		inode->i_op = &bfs_dir_inops;
@@ -70,6 +82,11 @@ struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 		inode->i_op = &bfs_file_inops;
 		inode->i_fop = &bfs_file_operations;
 		inode->i_mapping->a_ops = &bfs_aops;
+	} else {
+		brelse(bh);
+		printf("Unknown vtype=%u %s:%08lx\n",
+		       le32_to_cpu(di->i_vtype), inode->i_sb->s_id, ino);
+		goto error;
 	}
 
 	BFS_I(inode)->i_sblock =  le32_to_cpu(di->i_sblock);
-- 
2.51.0



