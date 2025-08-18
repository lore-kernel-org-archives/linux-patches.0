Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD2031AF15;
	Mon, 18 Aug 2025 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524378; cv=none; b=lZX13NNuDYwsWd+NkEQ+ntrJzFaUveSGBmDzo71gFqqt+NTV6yckFlAF86GaJMpADi2eeC4cTbTIfecV5KldkydK3Yp9u6XGCo9mYS3LpnIzVZRw/dHp+aLzx21FSF/0fe/YrmkddPqqHim8HCNQObxWfVVbI7vJr1nIW5afV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524378; c=relaxed/simple;
	bh=5+uxInoR8EjyXX5WsTnuZf1Ciw1e8EIkVof2zxey5Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUHUs5hhVrOW0QiFtsOvt+ff0ks+da9JJKhIz/wz+ahno9vEiT+3KMN4+FCtKGikYrZrsWc6FQsk+FFUl3641nDJlBA9UaoKAhWoX8EvB5DiXp0tKSMrzgMsNIXsxJVQI/7Bp+ud8XxY8AwIS7dwvYTS/j/JHM7n5o6c2xr0rso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVuEw9A4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVuEw9A4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F77FC116B1;
	Mon, 18 Aug 2025 13:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524377;
	bh=5+uxInoR8EjyXX5WsTnuZf1Ciw1e8EIkVof2zxey5Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVuEw9A4yV8rDFuV2cTGYsZnJEZmdVxaj+y+i5w8mc0bIn6qyRJ8YsmGes5yy7fYw
	 UNQiQYzgphyy/Eae2X8eWRTmteU/w/6LHEdErInjWMc1NjAvA9iig9+udB1i3qmJoQ
	 dpyE6XDkO7yWTUx3ZAYStakSqNSAPmAvp+jePCA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.15 453/515] ext4: fix largest free orders lists corruption on mb_optimize_scan switch
Date: Mon, 18 Aug 2025 14:47:19 +0200
Message-ID: <20250818124515.859252362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


