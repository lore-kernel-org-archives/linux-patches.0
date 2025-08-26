Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224A5FBF0;
	Tue, 26 Aug 2025 13:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213312; cv=none; b=MwgQFtxJx0jDbXnB7d3gHFMBznnpxxuvN9Pcqy99fAi6Y1u7MCm+/rYjtL11d79RECrSwu7BRlxkQ8CS1fSBZugxRDjS5i0kEGShSoXrXsiQdbHrtYViP7y7Pn/pQDehKdrbbVTSAGNgB9p6b98rxPG7yIs9XCQqBPlbNWevHmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213312; c=relaxed/simple;
	bh=2LmbMOscTbLWCMjl+XUdg7bJpMeD7Nh+1/0itVsRUkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntukDY3oVj75rcxHpT+cQUFWxjgtfuYhrrSh2PXxaO8Gy7CJcx0neeL5CJmbN2TH/LAQENr6MhLDos9vsVDsVid16QXVWmncstLc4ebvzx3EZs2GqG9U/8cpHp5X1N5yq+OehEcQKbCuFVVFVAFukYI3JB3kJZmbM7YCGpjZRq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qNksoAyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qNksoAyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA917C4CEF1;
	Tue, 26 Aug 2025 13:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213312;
	bh=2LmbMOscTbLWCMjl+XUdg7bJpMeD7Nh+1/0itVsRUkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qNksoAyoCmYXmEgHT19kecoVZQs7/Sw5ksNu9mTW1dmBdCQgxRTB1oRvHxCIDIOmH
	 8Iz427HiEbIbTdulLqoHHS79xP7tRPrgMiRynKCH6y6CgnKHajtn02bQgM1v6UnI0z
	 tR1z6g3F6aZy5MMlSDD6jK+vAuxE4kJ0+/WAKz50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 301/587] ext4: fix zombie groups in average fragment size lists
Date: Tue, 26 Aug 2025 13:07:30 +0200
Message-ID: <20250826111000.582052700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -841,30 +841,30 @@ static void
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


