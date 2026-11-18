Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049252;
	b=Q7jopKmzlOPlb0sIQ7yJuJgNjrZ0pOXenWFESLo++ODEIgrAAMamL4BQhRjHtFgvQuGG
	 cDospiYHOpAnr5Xtf0a97Ha5J1h8EumhH0Z31lzI+AH+gJp96d58t8Uvhvx55TkWxHA3x
	 Ds+lW88dfYkI1SBW+hJMCwpqq+bX2hXyxwr8/JGUIPfnHvwAbIFkITw9bVDCL5nYPwHYT
	 3pPAfzkOixQ1wLYMdaflI/TjRkHzRB1qJ1K3UVDMXgROotf8/n50bBDYDSg2mqIDWfJ2F
	 Ci2X7oC4futvgx6fjgh1qXottdWcCOn2XO9AhC5F+buGw/+CbYtafTTj4Ebaa56+s3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tBiQqsdTttuIs5SaxYcCG77GOcdeqrOTUZfwjaAmsYg=;
	b=Kg5wVwBwi4Sr5TaLQYZWNC19iPAEfSvPAnLI/ngrSKzlZ3E9dOD/1VPRZMZSEdCNY3H4
	 5W0+A81zEISVV+0yCqC93mEZfp/L7Y36WEhd99UbFTcakohZieifefDgUUi6oZmIeTsY3
	 HKQmVlewAKTfshWIjOpeUEgB7bUhxJHvBjM8uMbgy5tHcd60ScqvDCFKvx/yn4ENIh4lH
	 twoDqmyjoq9yV3QKwxau2V/RvFi7fol6MYczRRCMhBh+oNFwjkKPtW8C0KgtIe7smne0t
	 uQ6OKGwrFmKD8EkY4glB7nBtzofuLQqREVLLQKfYUleXFWXNAPZUzmzIe8Sk0paypoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyvE5SS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4B6606A320;
	Thu, 19 Nov 2026 00:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyvE5SS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D221F000C4;
	Thu, 19 Nov 2026 00:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049252;
	bh=tBiQqsdTttuIs5SaxYcCG77GOcdeqrOTUZfwjaAmsYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyvE5SS25F3A7cPu6WrkxSZiPJpFCAx93RTE083qIznjrO1/9tw0exANr/CwUU38L
	 rJkZ9VHhjxtEx4ldewNXl7ieAvBXNS1Z3Sm//+4iEzPyX4jxfsIJ0dr21JDAA7PJzh
	 4wDIrrE+XhfJQ1qFRYmPF2fiNzZB0sgBlNR5zeBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2286/2857] nilfs2: fix link count underflow when removing corrupted directory
Date: Wed, 18 Nov 2026 15:55:20 +0100
Message-ID: <20261118150323.784230796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 67d66207fae1d..572e69759575b 100644
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



