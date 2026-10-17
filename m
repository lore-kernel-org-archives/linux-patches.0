Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49252E5B2A;
	Sat, 17 Oct 2026 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259146; cv=none; b=BrluK8l4M6zbmTL4vmBOuUHYLXFK+YybAhB6ZOcC7QjPLyRBvfGXSJoY228iEv2MM4ird2U7y2bSW9ul9jE54hzdJB+BGOSJEzbXwGkIE0fXsa8aR+56RMbm90gGyvrbA3ujYuqVzVdcMYTjm+3KBX9xamFhKKi5vJWpagFMY2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259146; c=relaxed/simple;
	bh=QK0HBxVbp/fVO9FSzYleItA/GpLZOU04qxISWWs9eH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqi0Y5UCNdF4iwvnmrePpscp1YER/Yp1BED1+BItMPwo2poK0sR5OX+YU0SX+T1cNuq9ELRK3nMZDuPy5Ax/zA1uQGJNfZm/UHGdXpDBpSThXCcId6TFeKkwQG2WMtG4SJV82WHUSDxzkzWaJJlCzOThKOfuofxOVfi/npgZ7ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxulndNv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxulndNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7451F000C4;
	Sat, 17 Oct 2026 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259145;
	bh=D1pJJo8q/gSOkwoTQP/uua/liqOPCrTTOdPRABSXZ1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxulndNvgqjNrVwMDfzeL94FZHJlV/CMCyCLsiaDjjF8YFv5Bfx1gzE3qSfdt+fny
	 CZicCC9eC1qZuSwVMV/tB6hOPhmiw/9h4IcReMIDp1f/y0dpIuxbNfT0vIaw2iq+81
	 u7JYgnU6hMVw9XuAdmIJBCEWQQ6yV7jx2gwo7Pjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1118/1674] ocfs2: add suballoc slot check in ocfs2_validate_inode_block()
Date: Sat, 17 Oct 2026 17:56:30 +0200
Message-ID: <20261017160459.829394913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit fe7a283b39160153b6d1bd7f61b0a9d5d44987a8 ]

In 'ocfs2_validate_inode_block()', add suballoc slot check similar to one
in 'ocfs2_get_suballoc_slot_bit()', thus preventing an out-of-bounds
accesses for 'local_system_inodes' in 'get_local_system_inode()'.

Most likely this fixes
https://syzkaller.appspot.com/bug?extid=a77d690840e60bc2ddd8 as well.

Link: https://lkml.kernel.org/r/20250826095106.666980-1-dmantipov@yandex.ru
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reported-by: syzbot+900962ac9bf1860033f2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=900962ac9bf1860033f2
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 452a8467be81 ("ocfs2: fix UBSAN array-index-out-of-bounds in ocfs2_sum_rightmost_rec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 1de709515f031..937d149417a1d 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1577,6 +1577,14 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		}
 	}
 
+	if (le16_to_cpu(di->i_suballoc_slot) != (u16)OCFS2_INVALID_SLOT &&
+	    (u32)le16_to_cpu(di->i_suballoc_slot) > OCFS2_SB(sb)->max_slots - 1) {
+		rc = ocfs2_error(sb, "Invalid dinode %llu: suballoc slot %u\n",
+				 (unsigned long long)bh->b_blocknr,
+				 le16_to_cpu(di->i_suballoc_slot));
+		goto bail;
+	}
+
 	rc = 0;
 
 bail:
-- 
2.53.0



