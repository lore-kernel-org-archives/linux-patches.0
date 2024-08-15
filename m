Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33131A01DA;
	Thu, 15 Aug 2024 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731051; cv=none; b=ebaOTdokIR8tWWqOnN848tMWjV3uw7aEbtASE2zCvXm3yCEqb2QYlr1fGH54yDW4gvJ2c040JbWiIazieoKJSoESPrdx+J+XLweXmSUjTqwT9+HGKqTBKayrwZ6eO6+hqW8nJEjr7vmg01j2ZWRnpkDJK+4/Df25hFj7OSLW6SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731051; c=relaxed/simple;
	bh=UQ4GvpbcY4GKDf73W1TfPOSOUY+49n5coPExqPd0POY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTcVtuxNaZ6rx0MniSQw5fI5aIJm6qDYJ6SYYeXWaTUvnXcCIQLEUIYjygc3QG+dDs+JteD/5jYprZi8dW9S99Ye3vM+jyOm2ZcpskxACkmbwAmRabfKj5vSUFb0Ta3kb9TO6ZoUT2LgWpCLruSXKtsvLW9s24tTudlvU/jePFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxH68FT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxH68FT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7664EC32786;
	Thu, 15 Aug 2024 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731050;
	bh=UQ4GvpbcY4GKDf73W1TfPOSOUY+49n5coPExqPd0POY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxH68FT/ls6sPakEtp8UXbZm5+DRXoSVvC8Wo94YFrt/mbClEbipeL9LimYH6+1nT
	 W0BKfV5ksIaMoyqgAJ+KWbUhnkc4fSmVI52/HeNY/Zui2cunhWb37cqp7biUkJOGLA
	 xtn4bIVTkaHiBYQu7JixyFitIe5yFTggY9NDJws8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 51/67] ext4: convert ext4_da_do_write_end() to take a folio
Date: Thu, 15 Aug 2024 15:26:05 +0200
Message-ID: <20240815131840.271357192@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 4d5cdd757d0c74924b629559fccb68d8803ce995 ]

There's nothing page-specific happening in ext4_da_do_write_end();
it's merely used for its refcount & lock, both of which are folio
properties.  Saves four calls to compound_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20231214053035.1018876-1-willy@infradead.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 83f4414b8f84 ("ext4: sanity check for NULL pointer after ext4_force_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cef119a2476bb..e24afb80c0f6b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2966,7 +2966,7 @@ static int ext4_da_should_update_i_disksize(struct folio *folio,
 
 static int ext4_da_do_write_end(struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
-			struct page *page)
+			struct folio *folio)
 {
 	struct inode *inode = mapping->host;
 	loff_t old_size = inode->i_size;
@@ -2977,12 +2977,13 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	 * block_write_end() will mark the inode as dirty with I_DIRTY_PAGES
 	 * flag, which all that's needed to trigger page writeback.
 	 */
-	copied = block_write_end(NULL, mapping, pos, len, copied, page, NULL);
+	copied = block_write_end(NULL, mapping, pos, len, copied,
+			&folio->page, NULL);
 	new_i_size = pos + copied;
 
 	/*
-	 * It's important to update i_size while still holding page lock,
-	 * because page writeout could otherwise come in and zero beyond
+	 * It's important to update i_size while still holding folio lock,
+	 * because folio writeout could otherwise come in and zero beyond
 	 * i_size.
 	 *
 	 * Since we are holding inode lock, we are sure i_disksize <=
@@ -3000,14 +3001,14 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 
 		i_size_write(inode, new_i_size);
 		end = (new_i_size - 1) & (PAGE_SIZE - 1);
-		if (copied && ext4_da_should_update_i_disksize(page_folio(page), end)) {
+		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
 			ext4_update_i_disksize(inode, new_i_size);
 			disksize_changed = true;
 		}
 	}
 
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 
 	if (old_size < pos)
 		pagecache_isize_extended(inode, old_size, pos);
@@ -3046,10 +3047,10 @@ static int ext4_da_write_end(struct file *file,
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-	if (unlikely(copied < len) && !PageUptodate(page))
+	if (unlikely(copied < len) && !folio_test_uptodate(folio))
 		copied = 0;
 
-	return ext4_da_do_write_end(mapping, pos, len, copied, &folio->page);
+	return ext4_da_do_write_end(mapping, pos, len, copied, folio);
 }
 
 /*
-- 
2.43.0



