Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E9E79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBA7C433C1;
	Wed, 30 Nov 2022 18:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834226;
	bh=FKGhaVxwAGwu5iaiTqEH7+OEvdPrGig4qQdjDqnvSWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3ehFHyqr3zDlKKPXyx2V1Pjd+vy+sUJq8kc13sAF8PtpGjeWGBuKtc5iaXAxh+5+
	 cVZ9qWdRVBlY/mvy+Zc9OD1CLGr3ghQaEaxFhEmWHgQm968mPpkPaDQ6U18D5F6dRv
	 3/AZSZbd0FigMffPxVMHP95rshyjATlkKpW12wBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 168/289] ext4: fix use-after-free in ext4_ext_shift_extents
Date: Wed, 30 Nov 2022 19:22:33 +0100
Message-Id: <20221130180547.941353141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

commit f6b1a1cf1c3ee430d3f5e47847047ce789a690aa upstream.

If the starting position of our insert range happens to be in the hole
between the two ext4_extent_idx, because the lblk of the ext4_extent in
the previous ext4_extent_idx is always less than the start, which leads
to the "extent" variable access across the boundary, the following UAF is
triggered:
==================================================================
BUG: KASAN: use-after-free in ext4_ext_shift_extents+0x257/0x790
Read of size 4 at addr ffff88819807a008 by task fallocate/8010
CPU: 3 PID: 8010 Comm: fallocate Tainted: G            E     5.10.0+ #492
Call Trace:
 dump_stack+0x7d/0xa3
 print_address_description.constprop.0+0x1e/0x220
 kasan_report.cold+0x67/0x7f
 ext4_ext_shift_extents+0x257/0x790
 ext4_insert_range+0x5b6/0x700
 ext4_fallocate+0x39e/0x3d0
 vfs_fallocate+0x26f/0x470
 ksys_fallocate+0x3a/0x70
 __x64_sys_fallocate+0x4f/0x60
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
==================================================================

For right shifts, we can divide them into the following situations：

1. When the first ee_block of ext4_extent_idx is greater than or equal to
   start, make right shifts directly from the first ee_block.
    1) If it is greater than start, we need to continue searching in the
       previous ext4_extent_idx.
    2) If it is equal to start, we can exit the loop (iterator=NULL).

2. When the first ee_block of ext4_extent_idx is less than start, then
   traverse from the last extent to find the first extent whose ee_block
   is less than start.
    1) If extent is still the last extent after traversal, it means that
       the last ee_block of ext4_extent_idx is less than start, that is,
       start is located in the hole between idx and (idx+1), so we can
       exit the loop directly (break) without right shifts.
    2) Otherwise, make right shifts at the corresponding position of the
       found extent, and then exit the loop (iterator=NULL).

Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
Cc: stable@vger.kernel.org # v4.2+
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20220922120434.1294789-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5183,6 +5183,7 @@ ext4_ext_shift_extents(struct inode *ino
 	 * and it is decreased till we reach start.
 	 */
 again:
+	ret = 0;
 	if (SHIFT == SHIFT_LEFT)
 		iterator = &start;
 	else
@@ -5226,14 +5227,21 @@ again:
 					ext4_ext_get_actual_len(extent);
 		} else {
 			extent = EXT_FIRST_EXTENT(path[depth].p_hdr);
-			if (le32_to_cpu(extent->ee_block) > 0)
+			if (le32_to_cpu(extent->ee_block) > start)
 				*iterator = le32_to_cpu(extent->ee_block) - 1;
-			else
-				/* Beginning is reached, end of the loop */
+			else if (le32_to_cpu(extent->ee_block) == start)
 				iterator = NULL;
-			/* Update path extent in case we need to stop */
-			while (le32_to_cpu(extent->ee_block) < start)
+			else {
+				extent = EXT_LAST_EXTENT(path[depth].p_hdr);
+				while (le32_to_cpu(extent->ee_block) >= start)
+					extent--;
+
+				if (extent == EXT_LAST_EXTENT(path[depth].p_hdr))
+					break;
+
 				extent++;
+				iterator = NULL;
+			}
 			path[depth].p_ext = extent;
 		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,


