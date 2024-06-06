Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8810B1C2231;
	Thu,  6 Jun 2024 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683561; cv=none; b=RxhYlDMS9XRgklMues33xtHz0eOUGv5RupR7NTt0DT1CBa9H6KfOwzApsIoCuJF5kxCjw45RR2vO6wv/KeQrYlg2KbhN5/nHXPErpS8RZ1wAzmWNHGu+VKfaCIgCBuDMiNtwcWAMCAg7+oBH4q+qRKiKPOi4UltkI6K+TidT7Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683561; c=relaxed/simple;
	bh=WsTB7VtQYHo057Xtf63F3UHKm3SF8ZXcKpeafG7m+cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf69XnXQ4MTC+ja5dmqrE1DRFAXiwwFHdsYEUMWsu5ro3aVuAKOc/kU1krpgawOtwM9RUIHVi2lDrAAmmxbwocrEuDmpyH8HaJCBSfaJlFnA4F10CYVX2q6Gym7/L4FvrJoTaDXh6PqeAxED8SMjCZdmUSeWbM81c2VA3xSfgfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wg1bhOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wg1bhOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F3DC32786;
	Thu,  6 Jun 2024 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683561;
	bh=WsTB7VtQYHo057Xtf63F3UHKm3SF8ZXcKpeafG7m+cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wg1bhOY0pScnsIDeav6j+eA0BsG/lrtzJYbAqO2N4QjyMur2YxDia3KKsM3K0pjl
	 DafGA8dUm6QPV6jfe3fD00Oo3AhHnJ1j9WYJxuZBEI99F4oRQvHnIaOFpr6xqpgBzL
	 FASifyXXExZj61v/xoZCXpknB53XGdvqxQ6J8gVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 503/744] f2fs: separate f2fs_gc_range() to use GC for a range
Date: Thu,  6 Jun 2024 16:02:55 +0200
Message-ID: <20240606131748.576258924@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 2f0209f579d12bd0ea43a01a8696e30a8eeec1da ]

Make f2fs_gc_range() an extenal function to use it for GC for a range.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aa4074e8fec4 ("f2fs: fix block migration when section is not aligned to pow2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 9c150b2dd9ec2..4cf37f51339c3 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1980,10 +1980,34 @@ void f2fs_build_gc_manager(struct f2fs_sb_info *sbi)
 	init_atgc_management(sbi);
 }
 
+static int f2fs_gc_range(struct f2fs_sb_info *sbi,
+		unsigned int start_seg, unsigned int end_seg, bool dry_run)
+{
+	unsigned int segno;
+
+	for (segno = start_seg; segno <= end_seg; segno += SEGS_PER_SEC(sbi)) {
+		struct gc_inode_list gc_list = {
+			.ilist = LIST_HEAD_INIT(gc_list.ilist),
+			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
+		};
+
+		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true);
+		put_gc_inode(&gc_list);
+
+		if (!dry_run && get_valid_blocks(sbi, segno, true))
+			return -EAGAIN;
+
+		if (fatal_signal_pending(current))
+			return -ERESTARTSYS;
+	}
+
+	return 0;
+}
+
 static int free_segment_range(struct f2fs_sb_info *sbi,
-				unsigned int secs, bool gc_only)
+				unsigned int secs, bool dry_run)
 {
-	unsigned int segno, next_inuse, start, end;
+	unsigned int next_inuse, start, end;
 	struct cp_control cpc = { CP_RESIZE, 0, 0, 0 };
 	int gc_mode, gc_type;
 	int err = 0;
@@ -2009,25 +2033,8 @@ static int free_segment_range(struct f2fs_sb_info *sbi,
 		f2fs_allocate_segment_for_resize(sbi, type, start, end);
 
 	/* do GC to move out valid blocks in the range */
-	for (segno = start; segno <= end; segno += SEGS_PER_SEC(sbi)) {
-		struct gc_inode_list gc_list = {
-			.ilist = LIST_HEAD_INIT(gc_list.ilist),
-			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
-		};
-
-		do_garbage_collect(sbi, segno, &gc_list, FG_GC, true);
-		put_gc_inode(&gc_list);
-
-		if (!gc_only && get_valid_blocks(sbi, segno, true)) {
-			err = -EAGAIN;
-			goto out;
-		}
-		if (fatal_signal_pending(current)) {
-			err = -ERESTARTSYS;
-			goto out;
-		}
-	}
-	if (gc_only)
+	err = f2fs_gc_range(sbi, start, end, dry_run);
+	if (err || dry_run)
 		goto out;
 
 	stat_inc_cp_call_count(sbi, TOTAL_CALL);
-- 
2.43.0



