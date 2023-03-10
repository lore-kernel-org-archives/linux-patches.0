Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CC0847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6C6C433EF;
	Fri, 10 Mar 2023 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456522;
	bh=3cmznv8an2kdzhfWa1qltY0CQ3ppfedg+qrQnlgV8og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RW/JeGmU9ZaN3z/Cw3typkzhJQkuq4YQFzUXOLPuAiOcj7vWsMCFK2qPLXdJ/CCp6
	 xqqd+Es7c1napqdQtW8bBIGPX3tx0jWQHvXRLDTUm2UnHt9FJV/9DEbdEjwFkS8vOi
	 2ciu/IKW6AlxpvZpVVEF8MBiQCF74zR2IUZGLlpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 031/211] ubifs: do_rename: Fix wrong space budget when target inodes nlink > 1
Date: Fri, 10 Mar 2023 14:36:51 +0100
Message-Id: <20230310133719.685709748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 25fce616a61fc2f1821e4a9ce212d0e064707093 ]

If target inode is a special file (eg. block/char device) with nlink
count greater than 1, the inode with ui->data will be re-written on
disk. However, UBIFS losts target inode's data_len while doing space
budget. Bad space budget may let make_reservation() return with -ENOSPC,
which could turn ubifs to read-only mode in do_writepage() process.

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216494
Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 94634b872e382..5e6bcce94e641 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1324,6 +1324,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlink) {
 		ubifs_assert(c, inode_is_locked(new_inode));
 
+		/* Budget for old inode's data when its nlink > 1. */
+		req.dirtied_ino_d = ALIGN(ubifs_inode(new_inode)->data_len, 8);
 		err = ubifs_purge_xattrs(new_inode);
 		if (err)
 			return err;
-- 
2.39.2



