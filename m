Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055854;
	b=Kj1UtRIiwOdFSQJZpBCD8vfXU/yqIVmmFARmcFNN2W/vfQL9naAWJtIvFAmgASWLAko1
	 zib2RGQClUmzHrUIzdtZFHP9JdO1tSU5tjk77bz/JLAN7JX8iRsbQbz4TfKbjZL35FW19
	 gRVfe/kLqXsBprauRxcuNqo7oqYFslDKZ5H45FMHP1IeT8KXu1u+sovzY+Tm0I+C6wVAz
	 zhdIV7bsSgS7JkY0rBMdpfaM0XdbQ05xGMaodFHu1jHp5mY119xz1H88G76IdC8rujFFD
	 ZDzAw5gOabefxpjiBQUGbpXlgzGwQwOseas+0iLU/eXKwpfPh0Yqo6FIX2naa0hl6xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mlJdfo70KyG6B/qyQOoeeXyHwbjYQQG+sf8A6Vk/6+g=;
	b=kyUzULGdZvgj0+T/mYBvFoQBFOhaxij51lOvouBCvm5nSw1LaUmxoHDBzCquIh5uRr6O
	 SlX1Crkw4guEJiE3zNb7fYe346XwWajuoBC3KR07QcS2+7wQs/zKaDjBhF61eYE1YjFWB
	 KxmYZtCCxKHnBhypLrs+8NaObRFg0WmufeAff+V0OZ4LSCRM2P71JjhGRLBEPUidofdSk
	 iL19iKAhhGnuCraTru3Hmtn0O4UylNWzwI0pYA6BTROgECDWefr1YGOLC3Bn1HcpmPL/U
	 +rgqPCXgJyRXMcse5W6nrAEmkp3bh6Hd4fnBeGw7S5j0uv5TDY7L1UK2sMEl0MadHPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsToACy3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CCE606A31C;
	Thu, 19 Nov 2026 02:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsToACy3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7831F000C5;
	Thu, 19 Nov 2026 02:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055854;
	bh=mlJdfo70KyG6B/qyQOoeeXyHwbjYQQG+sf8A6Vk/6+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsToACy3Nkoki+wNevIiKceaDCuG1029AP7IezR79+PwOD3EJHFKTgAEjjjPsYBa1
	 p9S/kHhvC+5tjmhU3UjsOj/kGrQ5ETTPTKFCR0Vm5mjW35JS9EdtenifzP7ViXFwC8
	 sV+4owSf51icfgLo65lDBdfKmbmPs+KYrBCCcc8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1781/2214] nilfs2: fix link count underflow when removing corrupted directory
Date: Wed, 18 Nov 2026 15:57:37 +0100
Message-ID: <20261118150122.736489214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 814f5a53b4724798795b15690ff3d1c1d9ac1eb6 ]

When removing an empty directory with a corrupted link count (e.g.,
i_nlink is 1 due to filesystem corruption), nilfs_rmdir() calls
drop_nlink() via nilfs_do_unlink() and then calls drop_nlink() again
on the directory inode.  This second call causes an underflow of
i_nlink, triggering a kernel WARNING in drop_nlink().

Fix this issue by using clear_nlink() instead of drop_nlink() to
finalize the link count reset for the target directory in nilfs_rmdir().
Additionally, log a warning message when i_nlink is not 2 before
removing an empty directory to notify about the link count inconsistency.

Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c388db0347b7fc88fa7a
Fixes: d25006523d0b ("nilfs2: pathname operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/namei.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index a81c24630e263..6f181e1780e07 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -341,10 +341,16 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	err = -ENOTEMPTY;
 	if (nilfs_empty_dir(inode)) {
+		if (unlikely(inode->i_nlink != 2))
+			nilfs_warn(dir->i_sb,
+				"inconsistent empty directory link count %u (ino=%llu)",
+				inode->i_nlink,
+				(unsigned long long)inode->i_ino);
+
 		err = nilfs_do_unlink(dir, dentry);
 		if (!err) {
 			inode->i_size = 0;
-			drop_nlink(inode);
+			clear_nlink(inode);
 			nilfs_mark_inode_dirty(inode);
 			drop_nlink(dir);
 			nilfs_mark_inode_dirty(dir);
-- 
2.53.0



