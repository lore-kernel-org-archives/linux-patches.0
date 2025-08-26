Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667DA21ABDC;
	Tue, 26 Aug 2025 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216598; cv=none; b=qUkp2CjzjFYDXzyyqhDpp1FehWRso9h9YcGWWqiEX7nQp/iadSO67Mj7c8ExbCUmgadI792pSkExVEwkq3nb08h12NKndAkG9IDSOlf6Ll0sL+CZZC9zhWd79QM+jX9N1vjCbxALqCxEfXN6z+7Eqg92YkPdWpZh7ijRp4kpRNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216598; c=relaxed/simple;
	bh=9uvrxBrrqG1DoOX5HHJLl0IwgrhJ505GmtKPmpjzl5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caCsiZ2QvLaO+84fStlFqbMQWTo1+FtGB5jQ7gmnZ5l0+APTd3Su564C7IScG5bz6UeQi1nSVk4UfMmaPmRqyWq0EYexvjDvVtBcnh1MntfYkNPAEjOiV4fuWKxfX0EBKtCy/zo+TaQ+1v+oO5+q/xFIwOcdV5Zt2/nt19QU2YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcbdGq6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcbdGq6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BECC4CEF1;
	Tue, 26 Aug 2025 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216598;
	bh=9uvrxBrrqG1DoOX5HHJLl0IwgrhJ505GmtKPmpjzl5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcbdGq6IA0W8yEEH3RYFnzvaa+/Mn0U5418mb2twUvmxXfEKKNolfGqtr9FNZh1TG
	 d0tK5brFiz8lCVPk6YbOTRCF6f9l/Dos09TutfUfs3/LFQWDacL8Zb91sxZaH/cjyA
	 HXC21gomjaIw0cTMtaciK5dKAIAxxVL9F2dBLrvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 440/644] ext4: fix largest free orders lists corruption on mb_optimize_scan switch
Date: Tue, 26 Aug 2025 13:08:51 +0200
Message-ID: <20250826110957.369729908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

commit 7d345aa1fac4c2ec9584fbd6f389f2c2368671d5 upstream.

The grp->bb_largest_free_order is updated regardless of whether
mb_optimize_scan is enabled. This can lead to inconsistencies between
grp->bb_largest_free_order and the actual s_mb_largest_free_orders list
index when mb_optimize_scan is repeatedly enabled and disabled via remount.

For example, if mb_optimize_scan is initially enabled, largest free
order is 3, and the group is in s_mb_largest_free_orders[3]. Then,
mb_optimize_scan is disabled via remount, block allocations occur,
updating largest free order to 2. Finally, mb_optimize_scan is re-enabled
via remount, more block allocations update largest free order to 1.

At this point, the group would be removed from s_mb_largest_free_orders[3]
under the protection of s_mb_largest_free_orders_locks[2]. This lock
mismatch can lead to list corruption.

To fix this, whenever grp->bb_largest_free_order changes, we now always
attempt to remove the group from its old order list. However, we only
insert the group into the new order list if `mb_optimize_scan` is enabled.
This approach helps prevent lock inconsistencies and ensures the data in
the order lists remains reliable.

Fixes: 196e402adf2e ("ext4: improve cr 0 / cr 1 group scanning")
CC: stable@vger.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250714130327.1830534-12-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1082,33 +1082,28 @@ static void
 mb_set_largest_free_order(struct super_block *sb, struct ext4_group_info *grp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	int i;
+	int new, old = grp->bb_largest_free_order;
 
-	for (i = MB_NUM_ORDERS(sb) - 1; i >= 0; i--)
-		if (grp->bb_counters[i] > 0)
+	for (new = MB_NUM_ORDERS(sb) - 1; new >= 0; new--)
+		if (grp->bb_counters[new] > 0)
 			break;
+
 	/* No need to move between order lists? */
-	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) ||
-	    i == grp->bb_largest_free_order) {
-		grp->bb_largest_free_order = i;
+	if (new == old)
 		return;
-	}
 
-	if (grp->bb_largest_free_order >= 0) {
-		write_lock(&sbi->s_mb_largest_free_orders_locks[
-					      grp->bb_largest_free_order]);
+	if (old >= 0 && !list_empty(&grp->bb_largest_free_order_node)) {
+		write_lock(&sbi->s_mb_largest_free_orders_locks[old]);
 		list_del_init(&grp->bb_largest_free_order_node);
-		write_unlock(&sbi->s_mb_largest_free_orders_locks[
-					      grp->bb_largest_free_order]);
+		write_unlock(&sbi->s_mb_largest_free_orders_locks[old]);
 	}
-	grp->bb_largest_free_order = i;
-	if (grp->bb_largest_free_order >= 0 && grp->bb_free) {
-		write_lock(&sbi->s_mb_largest_free_orders_locks[
-					      grp->bb_largest_free_order]);
+
+	grp->bb_largest_free_order = new;
+	if (test_opt2(sb, MB_OPTIMIZE_SCAN) && new >= 0 && grp->bb_free) {
+		write_lock(&sbi->s_mb_largest_free_orders_locks[new]);
 		list_add_tail(&grp->bb_largest_free_order_node,
-		      &sbi->s_mb_largest_free_orders[grp->bb_largest_free_order]);
-		write_unlock(&sbi->s_mb_largest_free_orders_locks[
-					      grp->bb_largest_free_order]);
+			      &sbi->s_mb_largest_free_orders[new]);
+		write_unlock(&sbi->s_mb_largest_free_orders_locks[new]);
 	}
 }
 


