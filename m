Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45883342CBA;
	Sat, 17 Oct 2026 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254728; cv=none; b=kuGwpHvc0lSOqi1C+e050HJEzynu46yhFVe0k72xKMtnY+xP+FX33kHqkFR/bW/c3n3lsIoJ4PLuGpRiaG6tPDzwbC97UMVJZXTcuHsoKbra8FNJH7s30ldWaFpNvzXymWha/BHe+mEiAZ16xH3MF67GfBui1eo+i+qVCnLmipU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254728; c=relaxed/simple;
	bh=T9EDbcb8OYpL+wJmSmr6vtCQ48V+ObaD5Zm3WELrUwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLRmpnn5DD84xReM3G2VH+NjIcCQTv8lYW01nGswz9jby9dx357f9ziY8WHQm465iF+pXsYgwEt3tpBwg/Hmbq/s8WdnJQ2wee3p3KZd3Gcz9bNsn8xV+bsFpE6D7yVrzTEQABhGgO6LNOhgDFFSLmDawqbnAt6hGitcmPNNmUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieKJk6sm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieKJk6sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B54A1F000C4;
	Sat, 17 Oct 2026 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254727;
	bh=HIZdobjqrIBmfwrYzKwgZ74EEK6X5S6N11SoPuyUex8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieKJk6smHiUq0B/6HYPslE3HcbjdFUQ5P2WXAAYUIoPcxmR8MGYyjZNJD18zo/bmZ
	 LreC8WIP009xzNOJwDrUIawLTsZQWUmnoa2YBFRywg1RTawQfyclpA5lXA+bSroITt
	 8K8yuzgZNbsHVdWDAiXsXnq94qRz16yDMEZ8toTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 515/869] xfs: handle NULL b_addr in xfs_buf_free
Date: Sat, 17 Oct 2026 17:55:56 +0200
Message-ID: <20261017160050.304564064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit d852729c5f4f830fbe7413df032e29459b3daf83 ]

When xfs_buf_alloc_backing_mem() fails, xfs_buf_free() is called with
bp->b_addr still NULL.  The code falls through to the folio_put path
which calls virt_to_folio(NULL), dereferencing an invalid address and
causing a kernel crash.

 Call Trace:
  xfs_buf_free+0x25f/0x510
  xfs_buf_alloc+0xc98/0x19b0
  xfs_buf_find_insert+0x55/0x14d0
  xfs_buf_get_map+0x122b/0x17c0
  xfbtree_init_leaf_block+0x11c/0x4a0
  xfbtree_init+0x1bb/0x460
  xrep_rmap_setup_scan+0x100/0x1f0
  xrep_rmapbt+0x41/0xc0

Fix this by skipping folio_put() when bp->b_addr is NULL.

Fixes: 5076a6040ca1 ("xfs: support in-memory buffer cache targets")
Reported-by: syzbot+94c22d92f72f5a235b7d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=94c22d92f72f5a235b7d
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 52e3535411b27..571cf82566722 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -319,12 +319,14 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_lru));
 
-	if (xfs_buftarg_is_mem(bp->b_target))
-		xmbuf_unmap_page(bp);
-	else if (bp->b_flags & _XBF_PAGES)
+	if (xfs_buftarg_is_mem(bp->b_target)) {
+		if (bp->b_addr)
+			xmbuf_unmap_page(bp);
+	} else if (bp->b_flags & _XBF_PAGES) {
 		xfs_buf_free_pages(bp);
-	else if (bp->b_flags & _XBF_KMEM)
+	} else if (bp->b_flags & _XBF_KMEM) {
 		kfree(bp->b_addr);
+	}
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
-- 
2.53.0



