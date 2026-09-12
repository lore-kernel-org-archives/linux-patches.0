Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E989C2D0C94;
	Sat, 12 Sep 2026 10:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210342; cv=none; b=evA13q1wOyW6DY3Ww/4bOT+59P6k5lMRvtwbFgHaLMKCbe+OCIGQg2WG/t+xeyVQ7HaYVdfzMHpKG25yur4VeiPfjF+0gssKLSaIQwV4RaNN/WZuZTUFAO5WycXcI4qk0qHv4EltbJMGjwUR/fBqTlK7c69eeVZx82Mg7/8YsVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210342; c=relaxed/simple;
	bh=zUYAU3HduHujaPvMm04elUIOdXhyXPToDYIH+wBJ78A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsSAe16wxBliVH6MKTq4jcGgkWOblVGO7Uc3CCx12D7XsMi/CEWOlJZgGQHPtq+Tz5J5DQjTVdaJe7Ivc2EUxmh3MisN5V+O/ZDtTY/c8nAgMOCytCTpTP2rrpmVjZL48/PWLxZuQnocJDsnPQ/BqCEzmGFmulcr7dRHo5dhym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neyc82aI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neyc82aI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A710A1F000FF;
	Sat, 12 Sep 2026 10:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210340;
	bh=e5kg/hJ4fI4iQdy32GuSjjxcPlqtKoj2b0ST+1d+/W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neyc82aIjrHzjswvPV32OxQvu+gG2rsUb0SA3g39kHDQz2OcAQAHaXz35m0ptwiHj
	 StF5okUrUqU28cqLwq5WasVT34Hu4ZpbIpDgFu/FBgfbpOnnZlf/zJ3NLfjtVjM92N
	 gB73rUUSPBzpL6RtI89hHW900s8sqrDmqyDT4D74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1004/1518] btrfs: zoned: dont clobber the extent buffer when zeroing it out
Date: Sat, 12 Sep 2026 08:52:53 +0200
Message-ID: <20260912065646.165329220@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b956434208fe6..15b6a67d17ddc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -278,14 +278,15 @@ int btree_csum_one_bio(struct btrfs_bio *bbio)
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
index 80fc2d59bfeb8..90a6b161d7c11 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2182,14 +2182,17 @@ static struct extent_buffer *find_extent_buffer_nolock(
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
@@ -2230,7 +2233,8 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
 	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_bio *bbio;
 
-	prepare_eb_write(eb);
+	if (!test_bit(EXTENT_BUFFER_ZONED_ZEROOUT, &eb->bflags))
+		prepare_eb_write(eb);
 
 	bbio = btrfs_bio_alloc(INLINE_EXTENT_BUFFER_PAGES,
 			       REQ_OP_WRITE | REQ_META | wbc_to_write_flags(wbc),
@@ -2250,8 +2254,21 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
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



