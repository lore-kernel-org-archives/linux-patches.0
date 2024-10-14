Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A451AB51B;
	Mon, 14 Oct 2024 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919413; cv=none; b=WzOF36TszD2+9MkMZ1bNH8Q6OyUgqLx5fs1xodHT3hypYPb+qMKe9ruVsk77A/bgXVI6Ye4CZA51BzniFcT+6IahbQG6DdC+LON6FAHwmoRle5d3JoiDA3DrJUny752kyI8fQCDcJ8BLrnQYIfpmTdjn8HHYsxm3WSguw1dBhZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919413; c=relaxed/simple;
	bh=ybosPgXizbs1iYZuYWFiAkHRudofTDt3SgSVdJm9ifE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xy4Ax0zEbo95vM3IjebWDdwsDq7rZRXhy5lCxF3P5APtC/JaoUEmILDH7hBXzmbZ1o9Yi5W5jZ8tBzO6khAYb8vKRoHXLuQMLbm5ovwOseF2H+nNOxRpySrPcRTmafq5LUvyZuPnME1JVLpXA/8+h3m9nvsaGXyM/vQHLLAdJt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJJCI9Ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJJCI9Ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04463C4CEC3;
	Mon, 14 Oct 2024 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919412;
	bh=ybosPgXizbs1iYZuYWFiAkHRudofTDt3SgSVdJm9ifE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJJCI9ExuIZUO/h4uP285Ply+4AoWMsi86rf0DCiDDm0Su//4ukZO9zwff+6iBf8j
	 0GMnPum//5QsRna6PN0M6blgqjVY5hnGs972gqzP8qmdMqNNUhLx/PRIbgh9EzzSpV
	 abkdASY8k/WYuCpn2HKwJTcgCqBMFbX8Kbeh5UeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 570/798] ocfs2: remove unreasonable unlock in ocfs2_read_blocks
Date: Mon, 14 Oct 2024 16:18:44 +0200
Message-ID: <20241014141240.394054426@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lizhi Xu <lizhi.xu@windriver.com>

commit c03a82b4a0c935774afa01fd6d128b444fd930a1 upstream.

Patch series "Misc fixes for ocfs2_read_blocks", v5.

This series contains 2 fixes for ocfs2_read_blocks().  The first patch fix
the issue reported by syzbot, which detects bad unlock balance in
ocfs2_read_blocks().  The second patch fixes an issue reported by Heming
Zhao when reviewing above fix.


This patch (of 2):

There was a lock release before exiting, so remove the unreasonable unlock.

Link: https://lkml.kernel.org/r/20240902023636.1843422-1-joseph.qi@linux.alibaba.com
Link: https://lkml.kernel.org/r/20240902023636.1843422-2-joseph.qi@linux.alibaba.com
Fixes: cf76c78595ca ("ocfs2: don't put and assigning null to bh allocated outside")
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reported-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab134185af9ef88dfed5
Tested-by: syzbot+ab134185af9ef88dfed5@syzkaller.appspotmail.com
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/buffer_head_io.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -235,7 +235,6 @@ int ocfs2_read_blocks(struct ocfs2_cachi
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(sb, block++);
 			if (bhs[i] == NULL) {
-				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
 				/* Don't forget to put previous bh! */


