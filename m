Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF52146D0B7;
	Tue, 21 Jul 2026 17:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656103; cv=none; b=ha3ET67t02sv3BcIU+ykCQkBSGuGcx7hbbX+FqJY6/bP6FHQ4S3tWCx53Ds6+NRK5cQbfzn1R7yk11Zft8jwF84HEWtfFAwdG2vzmPkcjKgvoJAcqTj66DnJPEty/Q6h5QaZmdZUtSJokBzON7RYG9GZAy70u8FDICU4Q2irdpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656103; c=relaxed/simple;
	bh=uUx/yJlvuyNpaaFosDzk3gBeSk8KeN5jLMu7i6zHK9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUItU+EFgHi+APGZFs+wCkt1t2DLVuywJ9h8Dd3RqnICDaF1AinGAuoh7hhH7D1ABqzEiJchQUhu2hg+dqI5mW7BsBE+3chvelGd08FCIQ9kH+zDjS8pKvipUdvTqDmc64GBus/zoP06CM3VXoNtjATf8EalAb3v8Z5r2s7A8h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJCdq0ke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJCdq0ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B01A1F000E9;
	Tue, 21 Jul 2026 17:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656101;
	bh=yxPdOLrzoj2yuPvBx8bB8gbZvLJI6i3yXxrV0HumMZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mJCdq0keyInL8/39vs+LXVWq8kFCKN64nMEfxJChGzvbsp7AEOdnE9LLvzKfMrR8V
	 dk7XfFfEMbftEAxJVeWWWCdv9jqgLl00oGjQGPQ/h8f5wzzWEuKynaH9wLli1oacfw
	 0Tlx6LVGsQux0dWkl4S+wCysvH/0/3URImqC3sJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0260/1611] ocfs2: dont BUG_ON an invalid journal dinode
Date: Tue, 21 Jul 2026 17:06:16 +0200
Message-ID: <20260721152520.893200848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit c0438198c28b1d22c272751af5e717c11d9fa8dd ]

[BUG]
A fuzzed OCFS2 image can corrupt the current slot journal dinode while
mount is still in progress. The mount path first reports the invalid
journal block and then crashes in shutdown:

kernel BUG at fs/ocfs2/journal.c:1034!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:ocfs2_journal_toggle_dirty+0x2d6/0x340 fs/ocfs2/journal.c:1034
Call Trace:
 ocfs2_journal_shutdown+0x414/0xc30 fs/ocfs2/journal.c:1116
 ocfs2_mount_volume fs/ocfs2/super.c:1785 [inline]
 ocfs2_fill_super+0x30a9/0x3cd0 fs/ocfs2/super.c:1083
 get_tree_bdev_flags+0x38b/0x640 fs/super.c:1698
 get_tree_bdev+0x24/0x40 fs/super.c:1721
 ocfs2_get_tree+0x21/0x30 fs/ocfs2/super.c:1184
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 ...

[CAUSE]
ocfs2_journal_toggle_dirty() used to return -EIO when journal->j_bh no
longer contained a valid dinode, because the startup and shutdown paths
already handled that failure. Commit 10995aa2451a
("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.") changed
the check to a BUG_ON() under the assumption that the journal dinode had
already been validated. That turns an unexpected invalid journal dinode
during mount teardown into a kernel crash instead of a normal mount
failure.

[FIX]
Replace the BUG_ON() with WARN_ON() and return -EIO. This keeps the
invariant warning for debugging, but restores the original behavior of
failing startup or shutdown cleanly instead of panicking the kernel.

Link: https://lore.kernel.org/20260512024115.4036371-1-gality369@gmail.com
Fixes: 10995aa2451a ("ocfs2: Morph the haphazard OCFS2_IS_VALID_DINODE() checks.")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
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
 fs/ocfs2/journal.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index e5f58ff2175f41..bbfa41d37ec907 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1027,11 +1027,8 @@ static int ocfs2_journal_toggle_dirty(struct ocfs2_super *osb,
 	struct ocfs2_dinode *fe;
 
 	fe = (struct ocfs2_dinode *)bh->b_data;
-
-	/* The journal bh on the osb always comes from ocfs2_journal_init()
-	 * and was validated there inside ocfs2_inode_lock_full().  It's a
-	 * code bug if we mess it up. */
-	BUG_ON(!OCFS2_IS_VALID_DINODE(fe));
+	if (WARN_ON(!OCFS2_IS_VALID_DINODE(fe)))
+		return -EIO;
 
 	flags = le32_to_cpu(fe->id1.journal1.ij_flags);
 	if (dirty)
-- 
2.53.0



