Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190143839BA;
	Sat, 12 Sep 2026 19:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242667; cv=none; b=FUJpFARTj3vEYYke0w63f5HrmWObdTmmT+nfyiNE/zxartKqHcu4TVGV8NSgBy7lERbbB+OU5Zv7UaxpahnAGlePQhF0pCTBrjDGKS5utbhNOih2d+lRHxdq1+3eaKbH570IZfwbwaqRImCyeChtuG+Cr0ZOlzlm7nZebDIfqEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242667; c=relaxed/simple;
	bh=bw28hpvfScOr/VLxqUEg9n58fxmnPhzRMVQwftusDYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EG0yUjT7De47hCm01gFg1sJeOLw6haZrEOAhMplidRocn6vBRaf9VETkUqGhlnTXlA1dCQTG4YmXbvBOVvNR7U5jnGsH/wFvSBFSUFGa9OkDQ+b8jnOMI7AsM6RJi5xfMct2I4kX5HLsBvR8bjpr7l6CGJxYiCt9o6L9A+Y2fJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KC/A7VUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KC/A7VUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7438E1F000FF;
	Sat, 12 Sep 2026 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242666;
	bh=VKo/jtThwDK/eVItFvp0KIAUHRCzuXM9RzPjZBqRT+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KC/A7VUazayEzOFmWcMmwMGq67RUAGHeEvMiEMfy79m83gKa+liuQ5gkgxzERhYrN
	 g3nn8AT8hPCIbUsyV2qCVbVoxJDFCcaWip31E7FYaayH1LUgHvSaeWeWQCmpsr3CZD
	 cazJZW0EqbLtNzI//APTcMGoLX64w9t7r1iqCQxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 485/798] ext4: skip extra isize expansion during mount to prevent deadlock
Date: Sat, 12 Sep 2026 09:01:53 +0200
Message-ID: <20260912065528.257967020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 7461c60b9c6a839b13ad4c3490681a0cf5aa0637 ]

ext4_try_to_expand_extra_isize() is called from __ext4_mark_inode_dirty()
while holding an active jbd2 handle.  During mount (!SB_ACTIVE), the
expand path may move xattrs to external blocks and release ea_inodes via
iput().  When !SB_ACTIVE, iput() calls write_inode_now() which acquires
s_writepages_rwsem, creating a circular lock dependency:

  s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem

This can be triggered via:

  ext4_process_orphan() -> ext4_truncate() -> ext4_mark_inode_dirty()
    -> ext4_try_to_expand_extra_isize()

or:

  ext4_evict_inode() -> ext4_mark_inode_dirty()
    -> ext4_try_to_expand_extra_isize()

Skip expansion when !SB_ACTIVE.  This is a minor loss of functionality
(extra isize won't grow for these inodes during mount), which e2fsck
can resolve later if needed.

Reported-by: syzbot+5d19358d7eb30ffb0cc5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
Fixes: c8585c6fcaf2 ("ext4: fix races between changing inode journal mode and ext4_writepages")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260623061903.2148767-1-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d56a3c90dc4fe..6aaa29dc8edc5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6015,6 +6015,16 @@ static int ext4_try_to_expand_extra_isize(struct inode *inode,
 	if (ext4_test_inode_state(inode, EXT4_STATE_NO_EXPAND))
 		return -EOVERFLOW;
 
+	/*
+	 * Skip expansion during mount (!SB_ACTIVE).  Expanding extra isize
+	 * may move xattrs to external blocks and release ea_inodes via iput.
+	 * When !SB_ACTIVE, iput triggers write_inode_now() which acquires
+	 * s_writepages_rwsem, causing a deadlock with the caller's active
+	 * jbd2 handle (lock order: s_writepages_rwsem -> jbd2_handle).
+	 */
+	if (unlikely(!(inode->i_sb->s_flags & SB_ACTIVE)))
+		return -EBUSY;
+
 	/*
 	 * In nojournal mode, we can immediately attempt to expand
 	 * the inode.  When journaled, we first need to obtain extra
-- 
2.53.0



