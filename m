Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBB89447
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70A7C433C8;
	Sun, 16 Jul 2023 20:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539397;
	bh=kFc/nlBAU+uPRG4f3wv1LXhW9qEiEmsPXrboBicvhiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEFtNRtvJhPzalwq32zs/+41wXI5HQJ4Gbz4mIpn6E7tJW2JvZEtXRi2ztGW0lNpj
	 2JYIYIUpiJVmUiGNBG38Q4BkR/6sdFxhCXju1LDT2bLhBfrYjj3mFI/O4KrhNnu80+
	 FNAHf9NbCYyBBYkIxVsGnIxg4mI2Y+FrvlbY0cSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 754/800] btrfs: fix dirty_metadata_bytes for redirtied buffers
Date: Sun, 16 Jul 2023 21:50:07 +0200
Message-ID: <20230716195006.637466790@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit f18cc97845aa4ae0e795c088c979fe1642b3b8e5 upstream.

dirty_metadata_bytes is decremented in both places that clear the dirty
bit in a buffer, but only incremented in btrfs_mark_buffer_dirty, which
means that a buffer that is redirtied using btrfs_redirty_list_add won't
be added to dirty_metadata_bytes, but it will be subtracted when written
out, leading an inconsistency in the counter.

Move the dirty_metadata_bytes from btrfs_mark_buffer_dirty into
set_extent_buffer_dirty to also account for the redirty case, and remove
the now unused set_extent_buffer_dirty return value.

Fixes: d3575156f662 ("btrfs: zoned: redirty released extent buffers")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c   |    7 +------
 fs/btrfs/extent_io.c |    7 ++++---
 fs/btrfs/extent_io.h |    2 +-
 3 files changed, 6 insertions(+), 10 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4683,7 +4683,6 @@ void btrfs_mark_buffer_dirty(struct exte
 {
 	struct btrfs_fs_info *fs_info = buf->fs_info;
 	u64 transid = btrfs_header_generation(buf);
-	int was_dirty;
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	/*
@@ -4698,11 +4697,7 @@ void btrfs_mark_buffer_dirty(struct exte
 	if (transid != fs_info->generation)
 		WARN(1, KERN_CRIT "btrfs transid mismatch buffer %llu, found %llu running %llu\n",
 			buf->start, transid, fs_info->generation);
-	was_dirty = set_extent_buffer_dirty(buf);
-	if (!was_dirty)
-		percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
-					 buf->len,
-					 fs_info->dirty_metadata_batch);
+	set_extent_buffer_dirty(buf);
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	/*
 	 * Since btrfs_mark_buffer_dirty() can be called with item pointer set
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4064,7 +4064,7 @@ void btrfs_clear_buffer_dirty(struct btr
 	WARN_ON(atomic_read(&eb->refs) == 0);
 }
 
-bool set_extent_buffer_dirty(struct extent_buffer *eb)
+void set_extent_buffer_dirty(struct extent_buffer *eb)
 {
 	int i;
 	int num_pages;
@@ -4099,13 +4099,14 @@ bool set_extent_buffer_dirty(struct exte
 					     eb->start, eb->len);
 		if (subpage)
 			unlock_page(eb->pages[0]);
+		percpu_counter_add_batch(&eb->fs_info->dirty_metadata_bytes,
+					 eb->len,
+					 eb->fs_info->dirty_metadata_batch);
 	}
 #ifdef CONFIG_BTRFS_DEBUG
 	for (i = 0; i < num_pages; i++)
 		ASSERT(PageDirty(eb->pages[i]));
 #endif
-
-	return was_dirty;
 }
 
 void clear_extent_buffer_uptodate(struct extent_buffer *eb)
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -263,7 +263,7 @@ void extent_buffer_bitmap_set(const stru
 void extent_buffer_bitmap_clear(const struct extent_buffer *eb,
 				unsigned long start, unsigned long pos,
 				unsigned long len);
-bool set_extent_buffer_dirty(struct extent_buffer *eb);
+void set_extent_buffer_dirty(struct extent_buffer *eb);
 void set_extent_buffer_uptodate(struct extent_buffer *eb);
 void clear_extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_under_io(const struct extent_buffer *eb);


