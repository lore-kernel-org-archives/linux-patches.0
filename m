Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9999D32C926;
	Mon, 27 Oct 2025 19:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593097; cv=none; b=afz7pvyT3g5LOjGTfwVFzIfGnMPiJ9dRPwbJBEyRxDIB427yaz07VUQZs8+G/0dO8+Ev27jJQ+zDGLF9wKvTmA+n46iF6gQiVWjQvy4sHTXVpGnhjlUT8OFrjRPVyMHDJ+IaKawRhWEhuQw3zD4iIrspIStTKqw+JYUmMtvt0eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593097; c=relaxed/simple;
	bh=8OR4x7YSCnw5Pcd3KQHszCegWPD739xEUqNx8sAlajU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od0KjMyeGuSOUvpxiBJP00925bPyLK1UN/DJONig2uZ8KjvntXWhvxfzUw6k56bkRUE7fkDsDISZphVZ2boA75KHxd/PJu6GZkhjob8u9K5y0ctZp6GDKdhMYi+OM7T+WCz99ZZFoGnRR51ebzFeKSeQMWWcSKNfG7270I2/GTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EA7lOdZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EA7lOdZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A66BC4CEF1;
	Mon, 27 Oct 2025 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593097;
	bh=8OR4x7YSCnw5Pcd3KQHszCegWPD739xEUqNx8sAlajU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EA7lOdZ3gwyUEHI/T9srRSJyCkUcTvaTTThOPUFciVCF8b79zafRxVdkdOS+cYLar
	 DYcuAEThCibFQtKcfol/fFk4HLPL3RSuPZUKFapScM2KnSugW8ZqrbwKw4ul0mg9hj
	 fzocTDgk7GNV2KhXRksJLzAdZc6hj3ZiZ4gdb3fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+356aed408415a56543cd@syzkaller.appspotmail.com,
	Yang Chenzhi <yang.chenzhi@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 012/184] hfs: validate record offset in hfsplus_bmap_alloc
Date: Mon, 27 Oct 2025 19:34:54 +0100
Message-ID: <20251027183515.269342591@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Chenzhi <yang.chenzhi@vivo.com>

[ Upstream commit 738d5a51864ed8d7a68600b8c0c63fe6fe5c4f20 ]

hfsplus_bmap_alloc can trigger a crash if a
record offset or length is larger than node_size

[   15.264282] BUG: KASAN: slab-out-of-bounds in hfsplus_bmap_alloc+0x887/0x8b0
[   15.265192] Read of size 8 at addr ffff8881085ca188 by task test/183
[   15.265949]
[   15.266163] CPU: 0 UID: 0 PID: 183 Comm: test Not tainted 6.17.0-rc2-gc17b750b3ad9 #14 PREEMPT(voluntary)
[   15.266165] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   15.266167] Call Trace:
[   15.266168]  <TASK>
[   15.266169]  dump_stack_lvl+0x53/0x70
[   15.266173]  print_report+0xd0/0x660
[   15.266181]  kasan_report+0xce/0x100
[   15.266185]  hfsplus_bmap_alloc+0x887/0x8b0
[   15.266208]  hfs_btree_inc_height.isra.0+0xd5/0x7c0
[   15.266217]  hfsplus_brec_insert+0x870/0xb00
[   15.266222]  __hfsplus_ext_write_extent+0x428/0x570
[   15.266225]  __hfsplus_ext_cache_extent+0x5e/0x910
[   15.266227]  hfsplus_ext_read_extent+0x1b2/0x200
[   15.266233]  hfsplus_file_extend+0x5a7/0x1000
[   15.266237]  hfsplus_get_block+0x12b/0x8c0
[   15.266238]  __block_write_begin_int+0x36b/0x12c0
[   15.266251]  block_write_begin+0x77/0x110
[   15.266252]  cont_write_begin+0x428/0x720
[   15.266259]  hfsplus_write_begin+0x51/0x100
[   15.266262]  cont_write_begin+0x272/0x720
[   15.266270]  hfsplus_write_begin+0x51/0x100
[   15.266274]  generic_perform_write+0x321/0x750
[   15.266285]  generic_file_write_iter+0xc3/0x310
[   15.266289]  __kernel_write_iter+0x2fd/0x800
[   15.266296]  dump_user_range+0x2ea/0x910
[   15.266301]  elf_core_dump+0x2a94/0x2ed0
[   15.266320]  vfs_coredump+0x1d85/0x45e0
[   15.266349]  get_signal+0x12e3/0x1990
[   15.266357]  arch_do_signal_or_restart+0x89/0x580
[   15.266362]  irqentry_exit_to_user_mode+0xab/0x110
[   15.266364]  asm_exc_page_fault+0x26/0x30
[   15.266366] RIP: 0033:0x41bd35
[   15.266367] Code: bc d1 f3 0f 7f 27 f3 0f 7f 6f 10 f3 0f 7f 77 20 f3 0f 7f 7f 30 49 83 c0 0f 49 29 d0 48 8d 7c 17 31 e9 9f 0b 00 00 66 0f ef c0 <f3> 0f 6f 0e f3 0f 6f 56 10 66 0f 74 c1 66 0f d7 d0 49 83 f8f
[   15.266369] RSP: 002b:00007ffc9e62d078 EFLAGS: 00010283
[   15.266371] RAX: 00007ffc9e62d100 RBX: 0000000000000000 RCX: 0000000000000000
[   15.266372] RDX: 00000000000000e0 RSI: 0000000000000000 RDI: 00007ffc9e62d100
[   15.266373] RBP: 0000400000000040 R08: 00000000000000e0 R09: 0000000000000000
[   15.266374] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   15.266375] R13: 0000000000000000 R14: 0000000000000000 R15: 0000400000000000
[   15.266376]  </TASK>

When calling hfsplus_bmap_alloc to allocate a free node, this function
first retrieves the bitmap from header node and map node using node->page
together with the offset and length from hfs_brec_lenoff

```
len = hfs_brec_lenoff(node, 2, &off16);
off = off16;

off += node->page_offset;
pagep = node->page + (off >> PAGE_SHIFT);
data = kmap_local_page(*pagep);
```

However, if the retrieved offset or length is invalid(i.e. exceeds
node_size), the code may end up accessing pages outside the allocated
range for this node.

This patch adds proper validation of both offset and length before use,
preventing out-of-bounds page access. Move is_bnode_offset_valid and
check_and_correct_requested_length to hfsplus_fs.h, as they may be
required by other functions.

Reported-by: syzbot+356aed408415a56543cd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67bcb4a6.050a0220.bbfd1.008f.GAE@google.com/
Signed-off-by: Yang Chenzhi <yang.chenzhi@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250818141734.8559-2-yang.chenzhi@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/bnode.c      | 41 ----------------------------------------
 fs/hfsplus/btree.c      |  6 ++++++
 fs/hfsplus/hfsplus_fs.h | 42 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
index 14f4995588ff0..407d5152eb411 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -18,47 +18,6 @@
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
 
-static inline
-bool is_bnode_offset_valid(struct hfs_bnode *node, int off)
-{
-	bool is_valid = off < node->tree->node_size;
-
-	if (!is_valid) {
-		pr_err("requested invalid offset: "
-		       "NODE: id %u, type %#x, height %u, "
-		       "node_size %u, offset %d\n",
-		       node->this, node->type, node->height,
-		       node->tree->node_size, off);
-	}
-
-	return is_valid;
-}
-
-static inline
-int check_and_correct_requested_length(struct hfs_bnode *node, int off, int len)
-{
-	unsigned int node_size;
-
-	if (!is_bnode_offset_valid(node, off))
-		return 0;
-
-	node_size = node->tree->node_size;
-
-	if ((off + len) > node_size) {
-		int new_len = (int)node_size - off;
-
-		pr_err("requested length has been corrected: "
-		       "NODE: id %u, type %#x, height %u, "
-		       "node_size %u, offset %d, "
-		       "requested_len %d, corrected_len %d\n",
-		       node->this, node->type, node->height,
-		       node->tree->node_size, off, len, new_len);
-
-		return new_len;
-	}
-
-	return len;
-}
 
 /* Copy a specified range of bytes from the raw data of a node */
 void hfs_bnode_read(struct hfs_bnode *node, void *buf, int off, int len)
diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index 9e1732a2b92a8..fe6a54c4083c3 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -393,6 +393,12 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 	len = hfs_brec_lenoff(node, 2, &off16);
 	off = off16;
 
+	if (!is_bnode_offset_valid(node, off)) {
+		hfs_bnode_put(node);
+		return ERR_PTR(-EIO);
+	}
+	len = check_and_correct_requested_length(node, off, len);
+
 	off += node->page_offset;
 	pagep = node->page + (off >> PAGE_SHIFT);
 	data = kmap_local_page(*pagep);
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 2311e4be4e865..9dd18de0bc891 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -581,6 +581,48 @@ hfsplus_btree_lock_class(struct hfs_btree *tree)
 	return class;
 }
 
+static inline
+bool is_bnode_offset_valid(struct hfs_bnode *node, int off)
+{
+	bool is_valid = off < node->tree->node_size;
+
+	if (!is_valid) {
+		pr_err("requested invalid offset: "
+		       "NODE: id %u, type %#x, height %u, "
+		       "node_size %u, offset %d\n",
+		       node->this, node->type, node->height,
+		       node->tree->node_size, off);
+	}
+
+	return is_valid;
+}
+
+static inline
+int check_and_correct_requested_length(struct hfs_bnode *node, int off, int len)
+{
+	unsigned int node_size;
+
+	if (!is_bnode_offset_valid(node, off))
+		return 0;
+
+	node_size = node->tree->node_size;
+
+	if ((off + len) > node_size) {
+		int new_len = (int)node_size - off;
+
+		pr_err("requested length has been corrected: "
+		       "NODE: id %u, type %#x, height %u, "
+		       "node_size %u, offset %d, "
+		       "requested_len %d, corrected_len %d\n",
+		       node->this, node->type, node->height,
+		       node->tree->node_size, off, len, new_len);
+
+		return new_len;
+	}
+
+	return len;
+}
+
 /* compatibility */
 #define hfsp_mt2ut(t)		(struct timespec64){ .tv_sec = __hfsp_mt2ut(t) }
 #define hfsp_ut2mt(t)		__hfsp_ut2mt((t).tv_sec)
-- 
2.51.0



