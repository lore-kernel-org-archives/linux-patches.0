Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCB41CC89D;
	Wed, 19 Mar 2025 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394886; cv=none; b=mXzvYXkFfItgyJA7ksIjckQ8+7Xih8m6LGHxt1TLM+C0/uiB1LL2o3LwkJNOZ396wh+n7LaTsCC9b39jVemHQVLhJy68wW3IgXprxBROJtABYwPhyz/EwlPAKYBFmLBXoSXrw2w92KmCAooukrJ5UXCbKuGpmtjP132GstWJcZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394886; c=relaxed/simple;
	bh=Ox0J3c6cYs1ft96R7YhLolj/pBUsycNrvt0kPYaEJsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slL0dzGKbC0JV+Rhud9HdA1bwfX5jpANpt0ZcaV9DkaszY8+TYAx5gwsfWAxVD++uf0C28RkMqcw4kO6v3u4BANtz+xVC56M7FVfY3cjoAGPaFxxIe7kUfUScN8M0OYRXt8rR9UkeS/SLt14tUQdySCp2k5nEqn3A739DTg9Amc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySJJzd6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySJJzd6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4862C4CEE4;
	Wed, 19 Mar 2025 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394885;
	bh=Ox0J3c6cYs1ft96R7YhLolj/pBUsycNrvt0kPYaEJsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySJJzd6j4Y4Aph0T4iF8E+jb/K0JupKF+gDJB3AzOl/TMGawgT7TUjNxB+kd/HuTm
	 AlLn93VAkijo5yaaGB4oBzKNlfxoWkzyTh79o1eU1cSqcQcY+axvZeDVbH4ju63l1l
	 o+QZeST09ac413gbgCn3WqAbwyXzjgo8vmeMq+Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 087/241] btrfs: fix two misuses of folio_shift()
Date: Wed, 19 Mar 2025 07:29:17 -0700
Message-ID: <20250319143029.879559913@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 01af106a076352182b2916b143fc50272600bd81 ]

It is meaningless to shift a byte count by folio_shift().  The folio index
is in units of PAGE_SIZE, not folio_size().  We can use folio_contains()
to make this work for arbitrary-order folios, so remove the assertion
that the folios are of order 0.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0dd24d1289863..95d3cf2e15c84 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -526,8 +526,6 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
 		u64 end;
 		u32 len;
 
-		/* For now only order 0 folios are supported for data. */
-		ASSERT(folio_order(folio) == 0);
 		btrfs_debug(fs_info,
 			"%s: bi_sector=%llu, err=%d, mirror=%u",
 			__func__, bio->bi_iter.bi_sector, bio->bi_status,
@@ -555,7 +553,6 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
 
 		if (likely(uptodate)) {
 			loff_t i_size = i_size_read(inode);
-			pgoff_t end_index = i_size >> folio_shift(folio);
 
 			/*
 			 * Zero out the remaining part if this range straddles
@@ -564,9 +561,11 @@ static void end_bbio_data_read(struct btrfs_bio *bbio)
 			 * Here we should only zero the range inside the folio,
 			 * not touch anything else.
 			 *
-			 * NOTE: i_size is exclusive while end is inclusive.
+			 * NOTE: i_size is exclusive while end is inclusive and
+			 * folio_contains() takes PAGE_SIZE units.
 			 */
-			if (folio_index(folio) == end_index && i_size <= end) {
+			if (folio_contains(folio, i_size >> PAGE_SHIFT) &&
+			    i_size <= end) {
 				u32 zero_start = max(offset_in_folio(folio, i_size),
 						     offset_in_folio(folio, start));
 				u32 zero_len = offset_in_folio(folio, end) + 1 -
@@ -960,7 +959,7 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 		return ret;
 	}
 
-	if (folio->index == last_byte >> folio_shift(folio)) {
+	if (folio_contains(folio, last_byte >> PAGE_SHIFT)) {
 		size_t zero_offset = offset_in_folio(folio, last_byte);
 
 		if (zero_offset) {
-- 
2.39.5



