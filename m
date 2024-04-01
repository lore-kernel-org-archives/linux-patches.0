Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6491CA8F;
	Mon,  1 Apr 2024 16:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987368; cv=none; b=a7RdLVNIL9QFZ+plwRGn0Qhm3JCe9GyJI7JE9/3vUPFxXmNvTVOCyrV5CnsK5vhajncr+5m9E7OsYytSeIbiLZ2T5OPmn7mFAssa6ufeqRJm4IgeLqTIm0nqve5CmKSUfCOAEE3buSzHFsgtTAqzUIIa3WMaVm1zvdkbuPYKV10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987368; c=relaxed/simple;
	bh=sqk4Z0rXxVvyPzoxrpngK526vqzStNTiB8GTYu9Q62Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r24DFj9PlrVxWBMs1JBIr8N1YsvrvhYtWOrlnM1sIOWS2UKJ+/PC93msepVFxGdL7JtH088LP8BELDXFSHi1p1UmiVPnyihedgl40PnhOuMzCEXzxYc7eZKUB6bjIO9VIRSGV/uRD0mNMBKSdaf8N4ag7vSNtVK6PFLqUpawXik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEwvQ6wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEwvQ6wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01821C433F1;
	Mon,  1 Apr 2024 16:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987368;
	bh=sqk4Z0rXxVvyPzoxrpngK526vqzStNTiB8GTYu9Q62Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEwvQ6wkbc9/y1xhpWeZbmonbkPWvbLpO+IWrBh6m3NPLlwTyvhgDZCSu/5Uf8bqH
	 7ox3C0Svjz2Gl6JU3HRq/LwDMic36lEQEJdAPFckybRsCW8TYsMpS9EqwkTX3rXBKG
	 tkmCUrGHsotrQ7kTPN7VSOvp6msGVaUTknByeC6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 228/399] btrfs: add set_folio_extent_mapped() helper
Date: Mon,  1 Apr 2024 17:43:14 +0200
Message-ID: <20240401152555.987091416@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit dfba9f47730604a46c284f6099a11c5686b6289d ]

Turn set_page_extent_mapped() into a wrapper around this version.
Saves a call to compound_head() for callers who already have a folio
and removes a couple of users of page->mapping.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 86211eea8ae1 ("btrfs: qgroup: validate btrfs_qgroup_inherit parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 12 ++++++++----
 fs/btrfs/extent_io.h |  1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7761d7d93ba98..8b88cd08ab053 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -936,17 +936,21 @@ static int attach_extent_buffer_folio(struct extent_buffer *eb,
 
 int set_page_extent_mapped(struct page *page)
 {
-	struct folio *folio = page_folio(page);
+	return set_folio_extent_mapped(page_folio(page));
+}
+
+int set_folio_extent_mapped(struct folio *folio)
+{
 	struct btrfs_fs_info *fs_info;
 
-	ASSERT(page->mapping);
+	ASSERT(folio->mapping);
 
 	if (folio_test_private(folio))
 		return 0;
 
-	fs_info = btrfs_sb(page->mapping->host->i_sb);
+	fs_info = btrfs_sb(folio->mapping->host->i_sb);
 
-	if (btrfs_is_subpage(fs_info, page->mapping))
+	if (btrfs_is_subpage(fs_info, folio->mapping))
 		return btrfs_attach_subpage(fs_info, folio, BTRFS_SUBPAGE_DATA);
 
 	folio_attach_private(folio, (void *)EXTENT_FOLIO_PRIVATE);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 46050500529bf..2c9d6570b0a38 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -221,6 +221,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 void extent_readahead(struct readahead_control *rac);
 int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 		  u64 start, u64 len);
+int set_folio_extent_mapped(struct folio *folio);
 int set_page_extent_mapped(struct page *page);
 void clear_page_extent_mapped(struct page *page);
 
-- 
2.43.0



