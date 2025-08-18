Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BE831B10A;
	Mon, 18 Aug 2025 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522662; cv=none; b=l8lD4AiDquq/CdtFanaeecCwf3hA4pcnJO9U0I5XMZZXgQN/CL1bxKc7lOXTd+zZSuzzNTdwySdgTlDKis/3N2RmBoRWI2TnpDeFHW014fOnlCSKP2zXsZ5yhVnZaqEELotkxDFa3LiohxEREeB+IYKkEdMyMpUlm8feALPE8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522662; c=relaxed/simple;
	bh=VXog8dtByOnxvpXbW2f8MqaoYyPGOx7zued2YWj/l+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeA5hYO70Toa4s/DWdCPkwMtTQYq3IICVfsuQ373W0RZtVX3NWNbOMeZw4uUpdFo/nxodM71U1KLt7O32u2yo1OZ4uyZy8EbtgSVNjQTWBO/VCbUCAu1fbLNWCq/HZhODm1pISRXFDloI5EJnrjdQ9hZCARjYatrvY/wn5sTdrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LPdIDTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LPdIDTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5892CC4CEEB;
	Mon, 18 Aug 2025 13:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522661;
	bh=VXog8dtByOnxvpXbW2f8MqaoYyPGOx7zued2YWj/l+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LPdIDTylv6AZPIJrKfu6Z/BpgQlLmyK4XVGvUqRQJc0N9wjiyr8HvAxvuJ8ONFCm
	 /eUzWr4EQ+F/v+W9+BYpVYjrGHIAlBSxVxUtAnBm95Zs/rRKFbjQexd6ZdzBMyFAMj
	 t2EG8mXVKl7P28e/yOqbuPl1KEyFH/z+UnHxQr3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 382/444] ext4: fix zombie groups in average fragment size lists
Date: Mon, 18 Aug 2025 14:46:48 +0200
Message-ID: <20250818124503.220469370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


