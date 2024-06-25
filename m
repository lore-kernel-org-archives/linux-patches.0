Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39D3149E0A;
	Tue, 25 Jun 2024 09:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309204; cv=none; b=MkdGcphUfLIrVS+jyjDvi1Ys4AdhBI2W1WSh8oCiQJjsP928o4K36JBJy67JOmlJCPU8ElREhcZ1j0YuJRq/inNjNwG5dGuaOHI8UMGOOu+XhWX8sFOxNSFGyjnbdjs02jUZa0kbk30FKWAt93ac8KyyN7fIu+krtlp11Sh3O3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309204; c=relaxed/simple;
	bh=pn28iGsCjxZC/Dt/+IWK5u8XuOfgJbf3NerOBDxpqas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtQUu8gYiegiFnIfWty+3vQAPy1zU1ekp3MEQmVadrYMCZxPt1th9fVQPrTQ5axhI2foqTOBtbVISr3HQjGmWGLU0AP0RmDAfnpgmVQZ1HnCyKEYa4AWg4sc4o+99ThY2Dg2fB+bLxkVMvfUYG/Z1QjgP1ehclQnBR/iqDGpTcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNDgtzNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNDgtzNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733BAC32781;
	Tue, 25 Jun 2024 09:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309203;
	bh=pn28iGsCjxZC/Dt/+IWK5u8XuOfgJbf3NerOBDxpqas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNDgtzNdJjHS0ZyHgeGeis5MU7R6j1BL4rGhjCbEcjNlprekrJS0glWE2GOLzeuGi
	 FmveIht9HvNOOWCJ5AdHVPod8fCNn98RM5osodw/EBdWq71gE+VXiaeqoXoyGwenq2
	 SmjIX2JibPJ2nONFMLQJJvqpaUyCVNf+l1R3og+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 131/192] ext4: fix slab-out-of-bounds in ext4_mb_find_good_group_avg_frag_lists()
Date: Tue, 25 Jun 2024 11:33:23 +0200
Message-ID: <20240625085542.189183696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit 13df4d44a3aaabe61cd01d277b6ee23ead2a5206 upstream.

We can trigger a slab-out-of-bounds with the following commands:

    mkfs.ext4 -F /dev/$disk 10G
    mount /dev/$disk /tmp/test
    echo 2147483647 > /sys/fs/ext4/$disk/mb_group_prealloc
    echo test > /tmp/test/file && sync

==================================================================
BUG: KASAN: slab-out-of-bounds in ext4_mb_find_good_group_avg_frag_lists+0x8a/0x200 [ext4]
Read of size 8 at addr ffff888121b9d0f0 by task kworker/u2:0/11
CPU: 0 PID: 11 Comm: kworker/u2:0 Tainted: GL 6.7.0-next-20240118 #521
Call Trace:
 dump_stack_lvl+0x2c/0x50
 kasan_report+0xb6/0xf0
 ext4_mb_find_good_group_avg_frag_lists+0x8a/0x200 [ext4]
 ext4_mb_regular_allocator+0x19e9/0x2370 [ext4]
 ext4_mb_new_blocks+0x88a/0x1370 [ext4]
 ext4_ext_map_blocks+0x14f7/0x2390 [ext4]
 ext4_map_blocks+0x569/0xea0 [ext4]
 ext4_do_writepages+0x10f6/0x1bc0 [ext4]
[...]
==================================================================

The flow of issue triggering is as follows:

// Set s_mb_group_prealloc to 2147483647 via sysfs
ext4_mb_new_blocks
  ext4_mb_normalize_request
    ext4_mb_normalize_group_request
      ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc
  ext4_mb_regular_allocator
    ext4_mb_choose_next_group
      ext4_mb_choose_next_group_best_avail
        mb_avg_fragment_size_order
          order = fls(len) - 2 = 29
        ext4_mb_find_good_group_avg_frag_lists
          frag_list = &sbi->s_mb_avg_fragment_size[order]
          if (list_empty(frag_list)) // Trigger SOOB!

At 4k block size, the length of the s_mb_avg_fragment_size list is 14,
but an oversized s_mb_group_prealloc is set, causing slab-out-of-bounds
to be triggered by an attempt to access an element at index 29.

Add a new attr_id attr_clusters_in_group with values in the range
[0, sbi->s_clusters_per_group] and declare mb_group_prealloc as
that type to fix the issue. In addition avoid returning an order
from mb_avg_fragment_size_order() greater than MB_NUM_ORDERS(sb)
and reduce some useless loops.

Fixes: 7e170922f06b ("ext4: Add allocation criteria 1.5 (CR1_5)")
CC: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20240319113325.3110393-5-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    4 ++++
 fs/ext4/sysfs.c   |   13 ++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -831,6 +831,8 @@ static int mb_avg_fragment_size_order(st
 		return 0;
 	if (order == MB_NUM_ORDERS(sb))
 		order--;
+	if (WARN_ON_ONCE(order > MB_NUM_ORDERS(sb)))
+		order = MB_NUM_ORDERS(sb) - 1;
 	return order;
 }
 
@@ -1008,6 +1010,8 @@ static void ext4_mb_choose_next_group_be
 	 * goal length.
 	 */
 	order = fls(ac->ac_g_ex.fe_len) - 1;
+	if (WARN_ON_ONCE(order - 1 > MB_NUM_ORDERS(ac->ac_sb)))
+		order = MB_NUM_ORDERS(ac->ac_sb);
 	min_order = order - sbi->s_mb_best_avail_max_trim_order;
 	if (min_order < 0)
 		min_order = 0;
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -29,6 +29,7 @@ typedef enum {
 	attr_trigger_test_error,
 	attr_first_error_time,
 	attr_last_error_time,
+	attr_clusters_in_group,
 	attr_feature,
 	attr_pointer_ui,
 	attr_pointer_ul,
@@ -207,13 +208,14 @@ EXT4_ATTR_FUNC(sra_exceeded_retry_limit,
 
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, inode_readahead,
 		 ext4_sb_info, s_inode_readahead_blks);
+EXT4_ATTR_OFFSET(mb_group_prealloc, 0644, clusters_in_group,
+		 ext4_sb_info, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
 EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
 EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
 EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
-EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(mb_max_linear_groups, s_mb_max_linear_groups);
 EXT4_RW_ATTR_SBI_UI(extent_max_zeroout_kb, s_extent_max_zeroout_kb);
 EXT4_ATTR(trigger_fs_error, 0200, trigger_test_error);
@@ -392,6 +394,7 @@ static ssize_t ext4_attr_show(struct kob
 				(unsigned long long)
 			percpu_counter_sum(&sbi->s_sra_exceeded_retry_limit));
 	case attr_inode_readahead:
+	case attr_clusters_in_group:
 	case attr_pointer_ui:
 		if (!ptr)
 			return 0;
@@ -469,6 +472,14 @@ static ssize_t ext4_attr_store(struct ko
 		else
 			*((unsigned int *) ptr) = t;
 		return len;
+	case attr_clusters_in_group:
+		ret = kstrtouint(skip_spaces(buf), 0, &t);
+		if (ret)
+			return ret;
+		if (t > sbi->s_clusters_per_group)
+			return -EINVAL;
+		*((unsigned int *) ptr) = t;
+		return len;
 	case attr_pointer_ul:
 		if (!ptr)
 			return 0;


