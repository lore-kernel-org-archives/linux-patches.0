Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50238352081;
	Tue, 26 Aug 2025 14:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218887; cv=none; b=f7VqdIOsDUT6gUzOSdAx47y776Al+1/m7YSmiK2ragrhWWQMM6ps4/FZV6q9cKpPMcRUPaMe0Pm1vX64VlZ90w5Yd0edLHCAFMe2g3Equ1jP4s+nMgNqjsuovCFD8TCI6g1af8y65c1Au8nRRsdu2aQ/OIuYCI9sxiOOiY2WSbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218887; c=relaxed/simple;
	bh=KpnQVM4ky+QjourwraK/giuB1MgtQyKGyAYMFTIxj8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZF6Vaiqw0snqdeQHFib5nRppvNAEcRF1NuWIkqc2XWDc2BqYvH5KMGOPHkAsmn+B5CajJH55CBAbK6GWkkM4PZ2kK1DGUFCHfc9l+mws+R+H+d0/zMkPnykArl7bbi3TUcyS1+8hUe4w6wjBjW9vgTor7FwTLjrinB0ktNCRs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKsmckBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKsmckBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D672EC4CEF1;
	Tue, 26 Aug 2025 14:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218887;
	bh=KpnQVM4ky+QjourwraK/giuB1MgtQyKGyAYMFTIxj8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKsmckBl7BrhkG29IGm3l9PeSD7TCfuQytg8jvLU1+JnWq1t8DkTl84FTXs08gyAy
	 HxzqEKHfSDysMF7nlr7qGERjGpfcJCh9C5bTCi+nICeydcdeeKycCSgCmm6WSXYRq6
	 fhU8t+NE6PZK3gi3YcOIA1tS1GScuOR9SxXuFzSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/403] hfs: fix slab-out-of-bounds in hfs_bnode_read()
Date: Tue, 26 Aug 2025 13:08:17 +0200
Message-ID: <20250826110911.618383345@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <slava@dubeyko.com>

[ Upstream commit a431930c9bac518bf99d6b1da526a7f37ddee8d8 ]

This patch introduces is_bnode_offset_valid() method that checks
the requested offset value. Also, it introduces
check_and_correct_requested_length() method that checks and
correct the requested length (if it is necessary). These methods
are used in hfs_bnode_read(), hfs_bnode_write(), hfs_bnode_clear(),
hfs_bnode_copy(), and hfs_bnode_move() with the goal to prevent
the access out of allocated memory and triggering the crash.

Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250703214912.244138-1-slava@dubeyko.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/bnode.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index 2251286cd83f..2039cb6d5f66 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -15,6 +15,48 @@
 
 #include "btree.h"
 
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
 void hfs_bnode_read(struct hfs_bnode *node, void *buf, int off, int len)
 {
 	struct page *page;
@@ -23,6 +65,20 @@ void hfs_bnode_read(struct hfs_bnode *node, void *buf, int off, int len)
 	int bytes_to_read;
 	void *vaddr;
 
+	if (!is_bnode_offset_valid(node, off))
+		return;
+
+	if (len == 0) {
+		pr_err("requested zero length: "
+		       "NODE: id %u, type %#x, height %u, "
+		       "node_size %u, offset %d, len %d\n",
+		       node->this, node->type, node->height,
+		       node->tree->node_size, off, len);
+		return;
+	}
+
+	len = check_and_correct_requested_length(node, off, len);
+
 	off += node->page_offset;
 	pagenum = off >> PAGE_SHIFT;
 	off &= ~PAGE_MASK; /* compute page offset for the first page */
@@ -83,6 +139,20 @@ void hfs_bnode_write(struct hfs_bnode *node, void *buf, int off, int len)
 {
 	struct page *page;
 
+	if (!is_bnode_offset_valid(node, off))
+		return;
+
+	if (len == 0) {
+		pr_err("requested zero length: "
+		       "NODE: id %u, type %#x, height %u, "
+		       "node_size %u, offset %d, len %d\n",
+		       node->this, node->type, node->height,
+		       node->tree->node_size, off, len);
+		return;
+	}
+
+	len = check_and_correct_requested_length(node, off, len);
+
 	off += node->page_offset;
 	page = node->page[0];
 
@@ -108,6 +178,20 @@ void hfs_bnode_clear(struct hfs_bnode *node, int off, int len)
 {
 	struct page *page;
 
+	if (!is_bnode_offset_valid(node, off))
+		return;
+
+	if (len == 0) {
+		pr_err("requested zero length: "
+		       "NODE: id %u, type %#x, height %u, "
+		       "node_size %u, offset %d, len %d\n",
+		       node->this, node->type, node->height,
+		       node->tree->node_size, off, len);
+		return;
+	}
+
+	len = check_and_correct_requested_length(node, off, len);
+
 	off += node->page_offset;
 	page = node->page[0];
 
@@ -124,6 +208,10 @@ void hfs_bnode_copy(struct hfs_bnode *dst_node, int dst,
 	hfs_dbg(BNODE_MOD, "copybytes: %u,%u,%u\n", dst, src, len);
 	if (!len)
 		return;
+
+	len = check_and_correct_requested_length(src_node, src, len);
+	len = check_and_correct_requested_length(dst_node, dst, len);
+
 	src += src_node->page_offset;
 	dst += dst_node->page_offset;
 	src_page = src_node->page[0];
@@ -143,6 +231,10 @@ void hfs_bnode_move(struct hfs_bnode *node, int dst, int src, int len)
 	hfs_dbg(BNODE_MOD, "movebytes: %u,%u,%u\n", dst, src, len);
 	if (!len)
 		return;
+
+	len = check_and_correct_requested_length(node, src, len);
+	len = check_and_correct_requested_length(node, dst, len);
+
 	src += node->page_offset;
 	dst += node->page_offset;
 	page = node->page[0];
-- 
2.39.5



