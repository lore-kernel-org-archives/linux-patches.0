Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D71633EC
	for <patches@lists.linux.dev>; Fri,  9 May 2025 02:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746758826; cv=none; b=ZrNsreUuu9EjCUdm9D2swlZkIPSW79kv6Vmte2P4Oob6quW9j+oECIS8/3HLiQ2oXSUb+WGbSOVES8Xbu77zB9k2PP7yjRW8ghuvLY3idt/Lh95rEZy6z2Ev87+udxc5+/AobNEkMulFu9j/IBzaWxLoveR2H1v1WmxGYMNYiWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746758826; c=relaxed/simple;
	bh=YQSTXvAsk3kEwLsre9pFQg2X6xB3u0nbpW6UTL4YXlY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Z5JjTASlDNhzY/yuQv45FZ5tk5uv7dt4b8W0UZ/MVtdK4X4TgyCvs4g/g6ZNc8CEhagcF4giR+RbwT/cM6m8tE7v+M8w7m/Bl+FNEyMfcHa3mqHUQYY0qGePGQ4IjoRnqXgUnOZtU6erdg3Z0p/45hpahgKZmyKsLuxogB97bhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5491K4NS005031;
	Fri, 9 May 2025 02:46:59 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46d8c16v7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 09 May 2025 02:46:58 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Thu, 8 May 2025 19:46:57 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Thu, 8 May 2025 19:46:55 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <jaegeuk@kernel.org>, <chao@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <jianqi.ren.cn@windriver.com>
Subject: [PATCH 6.1.y] f2fs: fix to cover read extent cache access with lock
Date: Fri, 9 May 2025 10:46:54 +0800
Message-ID: <20250509024654.3233384-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=NIjV+16g c=1 sm=1 tr=0 ts=681d6ca2 cx=c_pps a=/ZJR302f846pc/tyiSlYyQ==:117 a=/ZJR302f846pc/tyiSlYyQ==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=neBg-OAXQ6Q9hM991mYA:9
 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: OMY2IBDys1QeeY5WjJrS-1oeglW7LmlT
X-Proofpoint-ORIG-GUID: OMY2IBDys1QeeY5WjJrS-1oeglW7LmlT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDAyNiBTYWx0ZWRfX4J2iRquCwYUl Bd0Vz2Hc15poZSi7WZd9dvk6NOSS5FcaEdzqAtSgR7JXdqHfIqFRXKiXI2WZAeLo0RxTndMvj5M 1gdPfZdOlH7/qCLwsR66juS2NngSHtee0f2LYJZ5ExqoeseSJTyK3HzMBBOa0uxhJnHyO3hyt/e
 0Z6SPe0+GUOnMeM8e0VjjcDDbNKO8mdLnpOF0+KyEOeDCuoU9bX6cIk/avIzJjqgSqK/VBq+t20 2GG0IlF0Rs5wIxvkjWPk2oqoO+iIHsZV9f1byLjWQ6KoYRsOzg3S5gG5urrCacyRHVVrrtLG+qU OrhuoEYGfBFnCJ1u0xYa0RxfJMGsn16GfpCflQiVjWHTD9dldKpfm1W/nS3wf2vjjfZquViAR/F
 VO4HzKsvEc5R08lKDlypx4gfVqt2IKfpbo6Bq/oC6KZ1aCfvyS9k0gPESELFNHI6T3ruIh4G
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_01,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 spamscore=0 malwarescore=0
 clxscore=1011 adultscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505090026

From: Chao Yu <chao@kernel.org>

[ Upstream commit d7409b05a64f212735f0d33f5f1602051a886eab ]

syzbot reports a f2fs bug as below:

BUG: KASAN: slab-use-after-free in sanity_check_extent_cache+0x370/0x410 fs/f2fs/extent_cache.c:46
Read of size 4 at addr ffff8880739ab220 by task syz-executor200/5097

CPU: 0 PID: 5097 Comm: syz-executor200 Not tainted 6.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 sanity_check_extent_cache+0x370/0x410 fs/f2fs/extent_cache.c:46
 do_read_inode fs/f2fs/inode.c:509 [inline]
 f2fs_iget+0x33e1/0x46e0 fs/f2fs/inode.c:560
 f2fs_nfs_get_inode+0x74/0x100 fs/f2fs/super.c:3237
 generic_fh_to_dentry+0x9f/0xf0 fs/libfs.c:1413
 exportfs_decode_fh_raw+0x152/0x5f0 fs/exportfs/expfs.c:444
 exportfs_decode_fh+0x3c/0x80 fs/exportfs/expfs.c:584
 do_handle_to_path fs/fhandle.c:155 [inline]
 handle_to_path fs/fhandle.c:210 [inline]
 do_handle_open+0x495/0x650 fs/fhandle.c:226
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

We missed to cover sanity_check_extent_cache() w/ extent cache lock,
so, below race case may happen, result in use after free issue.

- f2fs_iget
 - do_read_inode
  - f2fs_init_read_extent_tree
  : add largest extent entry in to cache
					- shrink
					 - f2fs_shrink_read_extent_tree
					  - __shrink_extent_tree
					   - __detach_extent_node
					   : drop largest extent entry
  - sanity_check_extent_cache
  : access et->largest w/o lock

let's refactor sanity_check_extent_cache() to avoid extent cache access
and call it before f2fs_init_read_extent_tree() to fix this issue.

Reported-by: syzbot+74ebe2104433e9dc610d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/00000000000009beea061740a531@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 fs/f2fs/extent_cache.c | 45 ++++++++++++++++++++----------------------
 fs/f2fs/f2fs.h         |  2 +-
 fs/f2fs/inode.c        |  8 ++++----
 3 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index f13143efc4b1..d7202de5401e 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -15,26 +15,23 @@
 #include "node.h"
 #include <trace/events/f2fs.h>
 
-bool sanity_check_extent_cache(struct inode *inode)
+bool sanity_check_extent_cache(struct inode *inode, struct page *ipage)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct extent_info *ei;
+	struct f2fs_extent *i_ext = &F2FS_INODE(ipage)->i_ext;
+	struct extent_info ei;
 
-	if (!fi->extent_tree[EX_READ])
-		return true;
+	get_read_extent_info(&ei, i_ext);
 
-	ei = &fi->extent_tree[EX_READ]->largest;
+	if (!ei.len)
+		return true;
 
-	if (ei->len &&
-		(!f2fs_is_valid_blkaddr(sbi, ei->blk,
-					DATA_GENERIC_ENHANCE) ||
-		!f2fs_is_valid_blkaddr(sbi, ei->blk + ei->len - 1,
-					DATA_GENERIC_ENHANCE))) {
-		set_sbi_flag(sbi, SBI_NEED_FSCK);
+	if (!f2fs_is_valid_blkaddr(sbi, ei.blk, DATA_GENERIC_ENHANCE) ||
+	    !f2fs_is_valid_blkaddr(sbi, ei.blk + ei.len - 1,
+					DATA_GENERIC_ENHANCE)) {
 		f2fs_warn(sbi, "%s: inode (ino=%lx) extent info [%u, %u, %u] is incorrect, run fsck to fix",
 			  __func__, inode->i_ino,
-			  ei->blk, ei->fofs, ei->len);
+			  ei.blk, ei.fofs, ei.len);
 		return false;
 	}
 	return true;
@@ -444,24 +441,22 @@ void f2fs_init_read_extent_tree(struct inode *inode, struct page *ipage)
 
 	if (!__may_extent_tree(inode, EX_READ)) {
 		/* drop largest read extent */
-		if (i_ext && i_ext->len) {
+		if (i_ext->len) {
 			f2fs_wait_on_page_writeback(ipage, NODE, true, true);
 			i_ext->len = 0;
 			set_page_dirty(ipage);
 		}
-		goto out;
+		set_inode_flag(inode, FI_NO_EXTENT);
+		return;
 	}
 
 	et = __grab_extent_tree(inode, EX_READ);
 
-	if (!i_ext || !i_ext->len)
-		goto out;
-
 	get_read_extent_info(&ei, i_ext);
 
 	write_lock(&et->lock);
-	if (atomic_read(&et->node_cnt))
-		goto unlock_out;
+	if (atomic_read(&et->node_cnt) || !ei.len)
+		goto skip;
 
 	en = __attach_extent_node(sbi, et, &ei, NULL,
 				&et->root.rb_root.rb_node, true);
@@ -473,11 +468,13 @@ void f2fs_init_read_extent_tree(struct inode *inode, struct page *ipage)
 		list_add_tail(&en->list, &eti->extent_list);
 		spin_unlock(&eti->extent_lock);
 	}
-unlock_out:
+skip:
+	/* Let's drop, if checkpoint got corrupted. */
+	if (f2fs_cp_error(sbi)) {
+		et->largest.len = 0;
+		et->largest_updated = true;
+	}
 	write_unlock(&et->lock);
-out:
-	if (!F2FS_I(inode)->extent_tree[EX_READ])
-		set_inode_flag(inode, FI_NO_EXTENT);
 }
 
 void f2fs_init_extent_tree(struct inode *inode)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 840a45855451..c9f401b5c706 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4130,7 +4130,7 @@ void f2fs_leave_shrinker(struct f2fs_sb_info *sbi);
 /*
  * extent_cache.c
  */
-bool sanity_check_extent_cache(struct inode *inode);
+bool sanity_check_extent_cache(struct inode *inode, struct page *ipage);
 struct rb_entry *f2fs_lookup_rb_tree(struct rb_root_cached *root,
 				struct rb_entry *cached_re, unsigned int ofs);
 struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index b8296b0414fc..b4aa0b88e668 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -448,15 +448,15 @@ static int do_read_inode(struct inode *inode)
 
 	init_idisk_time(inode);
 
-	/* Need all the flag bits */
-	f2fs_init_read_extent_tree(inode, node_page);
-
-	if (!sanity_check_extent_cache(inode)) {
+	if (!sanity_check_extent_cache(inode, node_page)) {
 		f2fs_put_page(node_page, 1);
 		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
 		return -EFSCORRUPTED;
 	}
 
+	/* Need all the flag bits */
+	f2fs_init_read_extent_tree(inode, node_page);
+
 	f2fs_put_page(node_page, 1);
 
 	stat_inc_inline_xattr(inode);
-- 
2.34.1

