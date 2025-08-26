Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C11514B950;
	Tue, 26 Aug 2025 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214725; cv=none; b=IQ6XO5Maz3oKnKupXLShlo0B3XPipl0LdRDd8wdh5JOfjpczjj3hJVtm+hcI3ykNsFqJ3Ils07UH27rY7DVLZFEPAq3HbzdJIcyJd9uVEAhb+ODfG4zN1Jz9VjfVXxILHl7QUTc7jfdCOX19QDF+B4STXsbW7TwzgcV8kVYNoGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214725; c=relaxed/simple;
	bh=oM1ZPQQHnnYVJHD76O1xLNt3Wr/00rG8GSbbO/tnefc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saUp4QllHiSZgFUYBLHFJZMeEbY6JchMHDUQkZ66RExcynCixG226st4fDW5CgJM5dH3s0V4OWR5IEU0fEI9N9amgu+jy4b5WH2NVnn8UrUJM3rIEu3xeuohmL3tyiFipw/3kZllaJ2LVbbA623NZMEjoY9dkMDG+RKz79dHQs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqk1IZiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqk1IZiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88015C4CEF1;
	Tue, 26 Aug 2025 13:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214724;
	bh=oM1ZPQQHnnYVJHD76O1xLNt3Wr/00rG8GSbbO/tnefc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yqk1IZivLVOi2cZw9SDRNCGEyFAoTmWAFmYHWlAkmuyrcGuKuxCbP2fy21kFhDIdk
	 r5z1VKQFRNQq1BlGxRHP9CSpAqJhHqQIBzyJY72o43mhPAnHn8pNi9sxd3L36G/mZk
	 kzRGmdKFSjrUuquT+N9Y14xljTvHJw/n+8LWwwFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.1 244/482] ext4: fix zombie groups in average fragment size lists
Date: Tue, 26 Aug 2025 13:08:17 +0200
Message-ID: <20250826110936.797924245@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Baokun Li <libaokun1@huawei.com>

commit 1c320d8e92925bb7615f83a7b6e3f402a5c2ca63 upstream.

Groups with no free blocks shouldn't be in any average fragment size list.
However, when all blocks in a group are allocated(i.e., bb_fragments or
bb_free is 0), we currently skip updating the average fragment size, which
means the group isn't removed from its previous s_mb_avg_fragment_size[old]
list.

This created "zombie" groups that were always skipped during traversal as
they couldn't satisfy any block allocation requests, negatively impacting
traversal efficiency.

Therefore, when a group becomes completely full, bb_avg_fragment_size_order
is now set to -1. If the old order was not -1, a removal operation is
performed; if the new order is not -1, an insertion is performed.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250714130327.1830534-11-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -829,30 +829,30 @@ static void
 mb_update_avg_fragment_size(struct super_block *sb, struct ext4_group_info *grp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	int new_order;
+	int new, old;
 
-	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_fragments == 0)
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN))
 		return;
 
-	new_order = mb_avg_fragment_size_order(sb,
-					grp->bb_free / grp->bb_fragments);
-	if (new_order == grp->bb_avg_fragment_size_order)
+	old = grp->bb_avg_fragment_size_order;
+	new = grp->bb_fragments == 0 ? -1 :
+	      mb_avg_fragment_size_order(sb, grp->bb_free / grp->bb_fragments);
+	if (new == old)
 		return;
 
-	if (grp->bb_avg_fragment_size_order != -1) {
-		write_lock(&sbi->s_mb_avg_fragment_size_locks[
-					grp->bb_avg_fragment_size_order]);
+	if (old >= 0) {
+		write_lock(&sbi->s_mb_avg_fragment_size_locks[old]);
 		list_del(&grp->bb_avg_fragment_size_node);
-		write_unlock(&sbi->s_mb_avg_fragment_size_locks[
-					grp->bb_avg_fragment_size_order]);
+		write_unlock(&sbi->s_mb_avg_fragment_size_locks[old]);
+	}
+
+	grp->bb_avg_fragment_size_order = new;
+	if (new >= 0) {
+		write_lock(&sbi->s_mb_avg_fragment_size_locks[new]);
+		list_add_tail(&grp->bb_avg_fragment_size_node,
+				&sbi->s_mb_avg_fragment_size[new]);
+		write_unlock(&sbi->s_mb_avg_fragment_size_locks[new]);
 	}
-	grp->bb_avg_fragment_size_order = new_order;
-	write_lock(&sbi->s_mb_avg_fragment_size_locks[
-					grp->bb_avg_fragment_size_order]);
-	list_add_tail(&grp->bb_avg_fragment_size_node,
-		&sbi->s_mb_avg_fragment_size[grp->bb_avg_fragment_size_order]);
-	write_unlock(&sbi->s_mb_avg_fragment_size_locks[
-					grp->bb_avg_fragment_size_order]);
 }
 
 /*


