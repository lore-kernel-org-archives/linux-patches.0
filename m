Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB632264DC;
	Wed, 10 Dec 2025 07:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351911; cv=none; b=IHCK3Gv2Zv1FXlyox3aGQ4yR65A7MGBaiu5qr3TYoLqftd3lOSRFHY7jQ4ReEWrqQXygCvbbORtyvTLN0aHPd8Afa/KcVPVGTKNO0qcGZ8r29HbLPybJwihz2fDOFiGKuTsxdXXl80TsoSDUV1fsjXe6CRzs9XMzFW5GJBrmQS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351911; c=relaxed/simple;
	bh=9hQbhDY4VhjNYr/NiF/RzuGCIb6F0xccwUs1aWBk9v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kwrh1TvDkVBOzyrEKZoLTVxqNIMWJLQycmi1mjl2SLext8qDdt8Alh9FecyCE/UG19V+1iBzVoTn6l2s8J53jwggKVAQx0y2tEYI4isrmApvVLKgq/ZheOX5Gl+ED29lxmgoYYyYNwNyl9HVA3wbtjPwmtHIujL9Ru/Uai3aXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feG+siiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feG+siiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4398BC4CEF1;
	Wed, 10 Dec 2025 07:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351911;
	bh=9hQbhDY4VhjNYr/NiF/RzuGCIb6F0xccwUs1aWBk9v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feG+siiX8hpZKqiybm6uGiTTIx5958c7Sb75Dlyzw9m5TGptTT3z7ejTqVAKa9QW9
	 z3eh5CiHMdktyXbnTFQdNnGPdvdq6d+5M+fDTMJbX2zHVQwpDLXqAe2zXF1D7E+ZPQ
	 sYCQMFx0ZIbbXMwM0Z5wjzckv4nypKqgFCeNV8fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Tigran Aivazian <aivazian.tigran@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 28/49] bfs: Reconstruct file type when loading from disk
Date: Wed, 10 Dec 2025 16:29:58 +0900
Message-ID: <20251210072948.863069842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index db81570c96375..ecf7f74779c6a 100644
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



