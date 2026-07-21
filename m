Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D53783D4;
	Tue, 21 Jul 2026 20:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665606; cv=none; b=Yrr41UD7RkZ2dBkC7cLlDqSSNQurIytzsBlVKDq950TiqJnLjVgoTJ03dK8JEAk1Z2HYSv1kUfoM10bCAyCdhnB0fBN7dYS0IUNXhgZHYhzp2c763fIEtctF/TCcANWA1IScsAOoQUXeKYyORISUXEiP2WZWYZSQZxj47kHCPV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665606; c=relaxed/simple;
	bh=AdUDYY7G2NdW+GG0s8o15p9IhU8cjy9I9xLP6Wxsb4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmsgGT+KS1W5pUjQAptIpab4jev7OGydwP1sUABLXlDTI5/GWWuzcSXgEi0l/mCmq9ErvrobTPrvXXHbNp8ytHpAX7Ji8NIvcOhjwgCX5jJX5tjNhkXdS2S5gTa7dpwcxeBkb6Fe+y5BEwLFEvtRy06VqemMKRSKnubuUc1BVyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2jWyP3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2jWyP3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727F91F000E9;
	Tue, 21 Jul 2026 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665604;
	bh=AJq29apRwVziY1roccfJa3msMU8hnuHPGw3zn/ISfNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2jWyP3l1kPSoUiLKD0jo1lFkRUJg7bppI/sjyQjb2HGaVnzlwHKa9ZO1pDmJVR6R
	 rznTrI0TVYJPD2pKpebaF/4Y6lRQGjnNzuezBxj8uuVDMKkHL5Qg0MBqD1wJ/xpNy9
	 yx2B/wfnKcXjuBfZ0w5iEDn3qrQt4St2uk7uiucM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0324/1266] xfs: fail recovery on a committed log item with no regions
Date: Tue, 21 Jul 2026 17:12:41 +0200
Message-ID: <20260721152449.084752246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 2094dab19d45c487285617b7b68913d0cc0c1211 upstream.

If the first op of a transaction is a bare transaction header
(len == sizeof(struct xfs_trans_header)), xlog_recover_add_to_trans()
adds an item but no region, leaving it on r_itemq with ri_cnt == 0 and
ri_buf == NULL.

The header can be split across op records, so later ops may still add
regions; the item is only invalid if the transaction commits with none.
The runtime commit path never emits such a transaction, so this only
happens on a crafted log.  It came from an AI-assisted code audit of the
recovery parser.

xlog_recover_reorder_trans() calls ITEM_TYPE() on the item, which reads
*(unsigned short *)item->ri_buf[0].iov_base and faults on the NULL
ri_buf.  Reject it there, before the commit handlers that also read
ri_buf[0].

 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:xlog_recover_reorder_trans (fs/xfs/xfs_log_recover.c:1836)
  xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2043)
  xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2501)
  xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3244)
  xlog_recover (fs/xfs/xfs_log_recover.c:3493)
  xfs_log_mount (fs/xfs/xfs_log.c:618)
  xfs_mountfs (fs/xfs/xfs_mount.c:1034)
  xfs_fs_fill_super (fs/xfs/xfs_super.c:1938)
  vfs_get_tree (fs/super.c:1695)
  path_mount (fs/namespace.c:4161)
  __x64_sys_mount (fs/namespace.c:4367)

Fixes: 89cebc847729 ("xfs: validate transaction header length on log recovery")
Cc: stable@vger.kernel.org # v4.3
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1872,6 +1872,15 @@ xlog_recover_reorder_trans(
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
 		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
 
+		/* a committed item with no regions has a NULL ri_buf[0] */
+		if (!item->ri_cnt || !item->ri_buf) {
+			xfs_warn(log->l_mp,
+				"%s: committed log item has no regions",
+				__func__);
+			error = -EFSCORRUPTED;
+			break;
+		}
+
 		item->ri_ops = xlog_find_item_ops(item);
 		if (!item->ri_ops) {
 			xfs_warn(log->l_mp,


