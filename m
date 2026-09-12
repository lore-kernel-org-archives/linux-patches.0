Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD31F1534;
	Sat, 12 Sep 2026 08:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201683; cv=none; b=WtnFrBaB4226/N8VKM6l9CJ5FTMa8/Dvo6bs2XjtycR/vH3oTUNWzTh0hv/e7S8L+lqP6gVALcaepPL1+fMHuT9le0dqMxNlVo+UpTovG43gOKbLw0g2X6cfOZJc/xaLM7mHQCbw5QXotcc7x6TR7TLLO9CABMr8pQUh/0lkaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201683; c=relaxed/simple;
	bh=MUed3728BIXxlIlzK2tep71YKWr3K6R9SoStBX7NUFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezSKyDnY+f6pmJPWuHJ9B+kZLs4BMG0cwpvNWPp+qZIWnPZDrC3r1qCUXY9u9LE7HCKgk1WjAEQRlcQTnpbNiM8pFO1giljK8tn/fCrjAtVCmopqKR7wdHMOFa5pkpbEFORTEvtaGADl6O36KxaV/t/jrzt06bebynQJKT9XvB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGEG7gNU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGEG7gNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5F01F000FF;
	Sat, 12 Sep 2026 08:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201681;
	bh=1uneqALPX8mtcWNgH+m+kQlkXnpO5duTIM9N28FjkiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGEG7gNUol4ptKrenCU2VfS3sVeZ8IZ2tnq5GREGrEi14JdawbODf30VCviBAmNmp
	 zSz1JTtcj5lPcwpx1QNNMf6gJpCbqvs/mCQ5KajMe617DN38c2S1wXi09yQWXsQ+i8
	 VVOHduefzZtWxzeC2D1O91MzgUK9NRvc6LXpyiug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Al Viro <viro@zeniv.linux.org.uk>,
	syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1044/1815] ocfs2: do not use make_bad_inode() in ocfs2_read_inode_block_full()
Date: Sat, 12 Sep 2026 08:46:34 +0200
Message-ID: <20260912065713.526778225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d48ace65322001b41bb5322442a21425ef4407d4 ]

This reverts commit 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation
failure during read").

Since 'make_bad_inode()' resets inode type to S_IFREG, doing this for
directory inode during active VFS lookup is likely to confuse the latter,
including VFS_BUG_ON_INODE() triggered in this case.

Link: https://lore.kernel.org/20260709060101.207262-1-dmantipov@yandex.ru
Fixes: 58b6fcd2ab34 ("ocfs2: mark inode bad upon validation failure during read")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: syzbot+d222f4b7129379c3d5bc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d222f4b7129379c3d5bc
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 815bf3f659da0..41db7dd39ed96 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1952,8 +1952,6 @@ int ocfs2_read_inode_block_full(struct inode *inode, struct buffer_head **bh,
 	rc = ocfs2_read_blocks(INODE_CACHE(inode), OCFS2_I(inode)->ip_blkno,
 			       1, &tmp, flags, ocfs2_validate_inode_block);
 
-	if (rc < 0)
-		make_bad_inode(inode);
 	/* If ocfs2_read_blocks() got us a new bh, pass it up. */
 	if (!rc && !*bh)
 		*bh = tmp;
-- 
2.53.0



