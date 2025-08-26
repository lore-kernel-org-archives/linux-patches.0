Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF858462;
	Tue, 26 Aug 2025 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213314; cv=none; b=ZWfOIwCVU5vSMKezNHvfelKQs246mCswTvy9hsgs/VP5gf/SkDaVyEdHKGg9m7WqAxmX/XcZqkoOSr/KG2lER0q96r5sakgTtYlzNi+79tF7qO71n1GmJ6Cw6j2itvg6rvlW/c9NA/RtvCEiuSxPbZ9DiG+9gj8dNbAdQLIeWw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213314; c=relaxed/simple;
	bh=FLiRaPlRMMME2TVvN9RH+5RT51qyevcvCcjuqf3ZbLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9F6liq8XOIedq2FtBQqH0mNf8zb4RCsT6CFdO8BnOywZjafZHBjE7MXoDYh7dNtsRuTvjr8J+2nrDhfoSze6TxAdBiTZDprjkVT8zRswwhffi8s1GAcASbXzPxw4r18nHSA1y9j9TMPV/7peXWtVdD1zWBQk8aHcZj/lnY5sq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeaSI9Ai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeaSI9Ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50977C4CEF1;
	Tue, 26 Aug 2025 13:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213314;
	bh=FLiRaPlRMMME2TVvN9RH+5RT51qyevcvCcjuqf3ZbLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeaSI9AiSK1Ul+jFsG9iw/rpASKhUWjWwvGzQ5VS0dxquGeqaxDhdqjVDkz/SSlcR
	 cr0yp1dCBx6x8dkCfcz/xIlvdwr0b00d6265WsFvrXmcxIUzeGtpiDcCkRDiQRH0+3
	 8mEzSOZgbVhdIcPr9lL6Kdjh6FeI5wVnbJEmN6YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 302/587] ext4: fix largest free orders lists corruption on mb_optimize_scan switch
Date: Tue, 26 Aug 2025 13:07:31 +0200
Message-ID: <20250826111000.606830623@linuxfoundation.org>
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
@@ -1150,33 +1150,28 @@ static void
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
 


