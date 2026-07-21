Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C499846AA6B;
	Tue, 21 Jul 2026 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648152; cv=none; b=Eg2PrRuYkzkzCuUisuJkl+Eqj2t0UBUDdHHjGKmofeXwS0IfMD+JbX1qXxmfUvPSCmQ8uihaQ218DMdQlBKOzwklz8QJLH3MOjZlyeYPaSvdPsyp0cNf53DzIas2m9z60kEMmL2X3zN8K4d7kzbXH/pw+GF9JbFmm0HEYIO0yoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648152; c=relaxed/simple;
	bh=938SylO5c/ny4F81cDHBQUPVJ7yMQgO/H9UaszywY78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZwGteUP8p1A23/Fjq7XtxIZ7erAVL0l79jBKQWiCFkJict4Nl9udxYDCTgT7c2a9dcSdHtourMU3i5cphNUsYxy4y5pptvTSzt0gvIOg0sdEykvsRnyZBS8luo3eUl7keKBT9a+iZruPEKlkLljQvW779g280AjBcbs3Lj1V7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryOFF1ln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryOFF1ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349BA1F000E9;
	Tue, 21 Jul 2026 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648150;
	bh=RAMCCW+H3AS1/kK1DuOBZxnnFi6P07ejMOSqi4NABYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryOFF1lnEtUWJW8sGkep2V5vCMnU/wRfD38rWfYboYHeTHX4AoFXR1LOQz3LB8W98
	 TrHYcP/VDMn+pxd836veYu09gIm4CvX6yKPjzDwvc3BChimMUut5IxCbbAGRsVa9f6
	 eSwp9GrBCVfW6R6YUu1ygwDc0muHVHaZEadbiLBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+217eb327242d08197efb@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0092/2077] hfsplus: Add a sanity check for btree node size
Date: Tue, 21 Jul 2026 16:56:05 +0200
Message-ID: <20260721152554.862821462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 3f95e2661574ff13f099dd13456751933c280628 ]

Syzbot reported an uninit-value bug in [1] with a corrupted HFS+ image,
during the file system mounting process, specifically while loading the
catalog, a corrupted node_size value of 1 caused the rec_off argument
passed to hfs_bnode_read_u16() (within hfs_bnode_find()) to be excessively
large. Consequently, the function failed to return a valid value to
initialize the off variable, triggering the bug [1].

Every node starts from BTree node descriptor: struct hfs_bnode_desc.
So, the size of node cannot be lesser than that. However, technical
specification declares that: "The node size (which is expressed in bytes)
must be power of two, from 512 through 32,768, inclusive." Add a check
for btree node size base on technical specification.

[1]
BUG: KMSAN: uninit-value in hfsplus_bnode_find+0x141c/0x1600 fs/hfsplus/bnode.c:584
 hfsplus_bnode_find+0x141c/0x1600 fs/hfsplus/bnode.c:584
 hfsplus_btree_open+0x169a/0x1e40 fs/hfsplus/btree.c:382
 hfsplus_fill_super+0x111f/0x2770 fs/hfsplus/super.c:553
 get_tree_bdev_flags+0x6e6/0x920 fs/super.c:1694
 get_tree_bdev+0x38/0x50 fs/super.c:1717
 hfsplus_get_tree+0x35/0x40 fs/hfsplus/super.c:709
 vfs_get_tree+0xb3/0x5d0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]

Fixes: 8ad2c6a36ac4 ("hfsplus: validate b-tree node 0 bitmap at mount time")
Reported-by: syzbot+217eb327242d08197efb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=217eb327242d08197efb
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/tencent_5ED373437A697F83A4A446B771577626CD05@qq.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/btree.c         | 2 ++
 include/linux/hfs_common.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index 761c74ccd6531e..394542a47e6009 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -365,6 +365,8 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	}
 
 	size = tree->node_size;
+	if (size < HFSPLUS_NODE_MINSZ || size > HFSPLUS_NODE_MXSZ)
+		goto fail_page;
 	if (!is_power_of_2(size))
 		goto fail_page;
 	if (!tree->node_count)
diff --git a/include/linux/hfs_common.h b/include/linux/hfs_common.h
index 07dfc39630ab91..45fb4c9ff9f5ee 100644
--- a/include/linux/hfs_common.h
+++ b/include/linux/hfs_common.h
@@ -513,6 +513,7 @@ struct hfs_btree_header_rec {
 /* HFS+ BTree misc info */
 #define HFSPLUS_TREE_HEAD			0
 #define HFSPLUS_NODE_MXSZ			32768
+#define HFSPLUS_NODE_MINSZ			512
 #define HFSPLUS_ATTR_TREE_NODE_SIZE		8192
 #define HFSPLUS_BTREE_HDR_NODE_RECS_COUNT	3
 #define HFSPLUS_BTREE_HDR_MAP_REC_INDEX		2	/* Map (bitmap) record in Header node */
-- 
2.53.0



