Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA77A20ED;
	Sat, 12 Sep 2026 08:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202839; cv=none; b=CYjzi1p7oaWCo7Za83x5Qy4M7+xEvB5EeV7RWaU7gbt2MQUYZxvekiwVWI2O8AcQpjE+G3hMpceLl7TtAVt+Op4v8ioVLtbpkW0MBdBZ49i2bd/xr9S2+QCwUnqc7U9taHVy0hdUjbWcB/9t89Dj4qaJKbNzaHEAvUTsqJqZvsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202839; c=relaxed/simple;
	bh=gW8C/87Pvzer1p62sbQuT+VeUJd/vD/cRVQlmWzqdBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDfFFBBxvfIF600mW4tzdLfNg0eNPNLlh+P0wG2ZneqiY1bR6e93dYdE+lZAaRgBusNlI988qzyIkDvMGrMANw/QgJv3kwV62n9G141UmsKm22qV6lFqmXlyUT/D2Xkl2QxjkzGAcVzmpkZpIp1b+7Zw6LAm5N2GaCLfqnj6D+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4tOFptm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4tOFptm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684651F00893;
	Sat, 12 Sep 2026 08:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202835;
	bh=S/ok3YdVC9YQJ4RdfyNrPbcYAeZCEbfVguxfnODb6Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4tOFptm3T0sFXp4jHHfGxWhIfLbOKTQ7iikiPtdvPyQ/WFKF6mBP1F52fI53rIX0
	 M3KYHVbUMJzW3OnKqGQlYIaWhlUi5gdsvAioTOhEqWpjNSej7eeTDKwGUeYkiehfPG
	 go6N0U1ToW1B6IHEbLm0fvPt63v8UQC0cCTn3P2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1232/1815] btrfs: zoned: dont clobber the extent buffer when zeroing it out
Date: Sat, 12 Sep 2026 08:49:42 +0200
Message-ID: <20260912065717.934774121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit db4b9eefc8ee0bcaeee4d5e6a7313905f6a2fe7c ]

On a zoned filesystem a freed-but-still-dirty tree block is written out
as zeros (EXTENT_BUFFER_ZONED_ZEROOUT) only to keep the zone write
pointer advancing. btree_csum_one_bio() implemented this by memzeroing
the extent buffer's own folios before submission.

That destroys the in-memory buffer while it may still be referenced. In
particular btrfs_free_tree_block() can run on it afterwards and reads
the header to add a delayed reference; once the header has been zeroed
it frees bytenr 0 and corrupts the extent tree (the
btrfs_header_bytenr(buf) != 0 ASSERT in btrfs_free_tree_block(), or an
"unable to find ref" abort). It is flaky and reproduces under fsstress,
e.g. generic/461 and generic/013.

Write the zeros to disk from the shared zero page instead and leave the
extent buffer content untouched, so any later reference - including the
delayed reference from btrfs_free_tree_block() - still sees a valid
header. end_bbio_meta_write() now clears writeback on the buffer's own
folios, as the bio no longer carries them.

Fixes: aa6313e6ff2b ("btrfs: zoned: don't clear dirty flag of extent buffer")
Assisted-by: LLM (debugging, commit message)
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c   | 13 +++++++------
 fs/btrfs/extent_io.c | 31 ++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ca55c886d6068..de6e23b88b406 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -271,14 +271,15 @@ int btree_csum_one_bio(struct btrfs_bio *bbio)
 		return -EIO;
 
 	/*
-	 * If an extent_buffer is marked as EXTENT_BUFFER_ZONED_ZEROOUT, don't
-	 * checksum it but zero-out its content. This is done to preserve
-	 * ordering of I/O without unnecessarily writing out data.
+	 * An extent_buffer marked EXTENT_BUFFER_ZONED_ZEROOUT is written out as
+	 * zeros to preserve ordering of I/O without persisting the now
+	 * unnecessary block. The bio is fed from the shared zero page (see
+	 * write_one_eb()), so there is nothing to checksum here. Crucially, the
+	 * buffer's own content is left intact: it may still be referenced, e.g.
+	 * btrfs_free_tree_block() reads its header to add a delayed reference.
 	 */
-	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
-		memzero_extent_buffer(eb, 0, eb->len);
+	if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
 		return 0;
-	}
 
 	if (WARN_ON_ONCE(found_start != eb->start))
 		return -EIO;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index df341a605ac0c..ae6294fedd2d7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2379,14 +2379,17 @@ static struct extent_buffer *find_extent_buffer_nolock(
 static void end_bbio_meta_write(struct btrfs_bio *bbio)
 {
 	struct extent_buffer *eb = bbio->private;
-	struct folio_iter fi;
 
 	if (bbio->bio.bi_status != BLK_STS_OK)
 		set_btree_ioerr(eb);
 
-	bio_for_each_folio_all(fi, &bbio->bio) {
-		btrfs_meta_folio_clear_writeback(fi.folio, eb);
-	}
+	/*
+	 * Clear writeback on the buffer's own folios. The bio may carry the
+	 * shared zero page instead (EXTENT_BUFFER_ZONED_ZEROOUT), so iterate
+	 * the extent buffer folios rather than the bio folios.
+	 */
+	for (int i = 0; i < num_extent_folios(eb); i++)
+		btrfs_meta_folio_clear_writeback(eb->folios[i], eb);
 
 	buffer_tree_clear_mark(eb, PAGECACHE_TAG_WRITEBACK);
 	clear_and_wake_up_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
@@ -2427,7 +2430,8 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_bio *bbio;
 
-	prepare_eb_write(eb);
+	if (!test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
+		prepare_eb_write(eb);
 
 	bbio = btrfs_bio_alloc(INLINE_EXTENT_BUFFER_PAGES,
 			       REQ_OP_WRITE | REQ_META | wbc_to_write_flags(wbc),
@@ -2447,8 +2451,21 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 		btrfs_meta_folio_set_writeback(folio, eb);
 		if (!folio_test_dirty(folio))
 			wbc->nr_to_write -= folio_nr_pages(folio);
-		bio_add_folio_nofail(&bbio->bio, folio, range_len,
-				     offset_in_folio(folio, range_start));
+		if (test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags)) {
+			u32 off = 0;
+
+			while (off < range_len) {
+				u32 add = min_t(u32, PAGE_SIZE, range_len - off);
+
+				bio_add_folio_nofail(&bbio->bio,
+						     page_folio(ZERO_PAGE(0)),
+						     add, 0);
+				off += add;
+			}
+		} else {
+			bio_add_folio_nofail(&bbio->bio, folio, range_len,
+					     offset_in_folio(folio, range_start));
+		}
 		wbc_account_cgroup_owner(wbc, folio, range_len);
 		folio_unlock(folio);
 	}
-- 
2.53.0



