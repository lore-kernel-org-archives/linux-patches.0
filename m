Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07A9487BF;
	Wed,  5 Feb 2025 14:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765854; cv=none; b=sNIDWW1CQKl9pI95+9R+eDqvGvBKzkTHK7CuPLuSMMuteQeEKvUUn3aou8PQkZdiz+0r8MvwlgnDpJFzwTs4CX3O4CsymfjInGr21wcMQA/7XDBIq91YWqagRJ4N2JpsJaJdWWASEKt9W63fS7+pzEEDFLgbAOW8AwRNvhvu93s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765854; c=relaxed/simple;
	bh=/fXS/nXrOuhND4lnmRDU+Xp9KAwu7bbCPHGG1crlSX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSnNAtjISMohW4S92r9vp/O4+nPq48X+YeJik+n27+lO3EHMaX9pHBqYnALgbNo/C5S4vFO8E4aFpxMnEuyG6lI3u6FEtPmtYWtQd80Eey66i3FCNNv19/AEBdLEDceF3SZXNaSed3DtbfgrhvBmd4CtWFSNLIUrhR6h2Ezf10E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=maauD11z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="maauD11z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC57C4CED1;
	Wed,  5 Feb 2025 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765854;
	bh=/fXS/nXrOuhND4lnmRDU+Xp9KAwu7bbCPHGG1crlSX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maauD11z1q0DoMhHva/jPVHxWysvX5SXfSVUEIvdHrO/jtQSFCP3Dfd72718CYG1H
	 TvUA5KJWKU2AWyJvzbnMJA+gkpAX7icXMf7B6eagtVnX6msAXeGboG5fC/gt3Mknzy
	 Im10KD5WSD8nCamMVcrEKis12KwLSiQ58fmBrH6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 306/393] buffer: make folio_create_empty_buffers() return a buffer_head
Date: Wed,  5 Feb 2025 14:43:45 +0100
Message-ID: <20250205134432.017183056@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 3decb8564eff88a2533f83b01cec2cf9259c3eaf ]

Patch series "Finish the create_empty_buffers() transition", v2.

Pankaj recently added folio_create_empty_buffers() as the folio equivalent
to create_empty_buffers().  This patch set finishes the conversion by
first converting all remaining filesystems to call
folio_create_empty_buffers(), then renaming it back to
create_empty_buffers().  I took the opportunity to make a few
simplifications like making folio_create_empty_buffers() return the head
buffer and extracting get_nth_bh() from nilfs2.

A few of the patches in this series aren't directly related to
create_empty_buffers(), but I saw them while I was working on this and
thought they'd be easy enough to add to this series.  Compile-tested only,
other than ext4.

This patch (of 26):

Almost all callers want to know the first BH that was allocated for this
folio.  We already have that handy, so return it.

Link: https://lkml.kernel.org/r/20231016201114.1928083-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231016201114.1928083-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 367a9bffabe0 ("nilfs2: protect access to buffers with no active references")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c                 | 24 +++++++++++++-----------
 include/linux/buffer_head.h |  4 ++--
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ecd8b47507ff8..4b86e971efd8a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1640,8 +1640,8 @@ EXPORT_SYMBOL(block_invalidate_folio);
  * block_dirty_folio() via private_lock.  try_to_free_buffers
  * is already excluded via the folio lock.
  */
-void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
-				unsigned long b_state)
+struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+		unsigned long blocksize, unsigned long b_state)
 {
 	struct buffer_head *bh, *head, *tail;
 
@@ -1667,6 +1667,8 @@ void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
 	}
 	folio_attach_private(folio, head);
 	spin_unlock(&folio->mapping->private_lock);
+
+	return head;
 }
 EXPORT_SYMBOL(folio_create_empty_buffers);
 
@@ -1768,13 +1770,15 @@ static struct buffer_head *folio_create_buffers(struct folio *folio,
 						struct inode *inode,
 						unsigned int b_state)
 {
+	struct buffer_head *bh;
+
 	BUG_ON(!folio_test_locked(folio));
 
-	if (!folio_buffers(folio))
-		folio_create_empty_buffers(folio,
-					   1 << READ_ONCE(inode->i_blkbits),
-					   b_state);
-	return folio_buffers(folio);
+	bh = folio_buffers(folio);
+	if (!bh)
+		bh = folio_create_empty_buffers(folio,
+				1 << READ_ONCE(inode->i_blkbits), b_state);
+	return bh;
 }
 
 /*
@@ -2678,10 +2682,8 @@ int block_truncate_page(struct address_space *mapping,
 		return PTR_ERR(folio);
 
 	bh = folio_buffers(folio);
-	if (!bh) {
-		folio_create_empty_buffers(folio, blocksize, 0);
-		bh = folio_buffers(folio);
-	}
+	if (!bh)
+		bh = folio_create_empty_buffers(folio, blocksize, 0);
 
 	/* Find the buffer that contains "offset" */
 	offset = offset_in_folio(folio, from);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 44e9de51eedfb..572030db2f061 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -203,8 +203,8 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		bool retry);
 void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
-void folio_create_empty_buffers(struct folio *folio, unsigned long blocksize,
-				unsigned long b_state);
+struct buffer_head *folio_create_empty_buffers(struct folio *folio,
+		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_async_write(struct buffer_head *bh, int uptodate);
-- 
2.39.5



