Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD355471414;
	Tue, 21 Jul 2026 20:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664475; cv=none; b=b3FynQM3XfgeHOKoq2pW/LBQDd0J5mGemY6no0qUxoT75WdC3Hhj3p4WWqN5XC8F9O0+zgnmPLFiyz7OqqIL39NEUOhVJh1t0BUJSjb3DeSdJ2nEHnzaJnNQ4HqqSSqJHqE0evVBWNGC7k/nyTbf6hqUrv0ObAHmdjAY0CsCsKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664475; c=relaxed/simple;
	bh=Oqnh1ToxZP7gkSjgMwHxkoCwYsryiQAGWK1OS0JdHrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRDr/9LqYFaIXvu7Us2RkKMry2rI02m75LdYwkt8Lmp880VDRnR5Huw25CUFS/s3/Wvzn60rhmO4s1jBFpZHSeySVAto0d/XGHxMui7cDrldsdTl8uTbNh8Z5Wgy1EWuEdqcPSjXS4pJJolNyiL62GRre6ch7RBhuSX9Y4WSxSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+eMYUUY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+eMYUUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB8E1F00A3A;
	Tue, 21 Jul 2026 20:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664472;
	bh=pQWh4Feaz5hCGIVTm++OLGM5E2cmskqd3tUUss3/L6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+eMYUUYeyC9tf7X8skdMs8tDAKXm8jQAImqDGFf+T+XbwV3oZnobP5Bi+am289fn
	 RvIcA+D+MIkQOhYXHz/wCd8KggRZ6Wwda8NB5o1DpmA7dlUTrtwUJhSlQooQrLTliE
	 9QytvWFINh4SUj0hC2RzYfLTjBQtllAdP1xjvG/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1214/1276] btrfs: concentrate the error handling of submit_one_sector()
Date: Tue, 21 Jul 2026 17:27:37 +0200
Message-ID: <20260721152513.235016797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 44820d80026e0b509007d41c83d42f1213ee8589 ]

Currently submit_one_sector() has only one failure path from
btrfs_get_extent().

However the error handling is split into two parts, one inside
submit_one_sector(), which clears the dirty flag and finishes the
writeback for the fs block.

The other part is to submit any remaining bio inside bio_ctrl and mark
the ordered extent finished for the fs block.

There is no special reason that we must split the error handling, let's
just concentrate all the error handling into submit_one_sector().

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1417,7 +1417,7 @@ out:
 
 /*
  * Return 0 if we have submitted or queued the sector for submission.
- * Return <0 for critical errors.
+ * Return <0 for critical errors, and the involved sector will be cleaned up.
  *
  * Caller should make sure filepos < i_size and handle filepos >= i_size case.
  */
@@ -1440,8 +1440,31 @@ static int submit_one_sector(struct btrf
 	ASSERT(filepos < i_size);
 
 	em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
-	if (IS_ERR(em))
-		return PTR_ERR_OR_ZERO(em);
+	if (IS_ERR(em)) {
+		/*
+		 * bio_ctrl may contain a bio crossing several folios.
+		 * Submit it immediately so that the bio has a chance
+		 * to finish normally, other than marked as error.
+		 */
+		submit_one_bio(bio_ctrl);
+
+		/*
+		 * When submission failed, we should still clear the folio dirty.
+		 * Or the folio will be written back again but without any
+		 * ordered extent.
+		 */
+		btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
+		btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
+		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
+
+		/*
+		 * Since there is no bio submitted to finish the ordered
+		 * extent, we have to manually finish this sector.
+		 */
+		btrfs_mark_ordered_io_finished(inode, folio, filepos,
+					       fs_info->sectorsize, false);
+		return PTR_ERR(em);
+	}
 
 	extent_offset = filepos - em->start;
 	em_end = extent_map_end(em);
@@ -1559,19 +1582,6 @@ static noinline_for_stack int extent_wri
 		}
 		ret = submit_one_sector(inode, folio, cur, bio_ctrl, i_size);
 		if (unlikely(ret < 0)) {
-			/*
-			 * bio_ctrl may contain a bio crossing several folios.
-			 * Submit it immediately so that the bio has a chance
-			 * to finish normally, other than marked as error.
-			 */
-			submit_one_bio(bio_ctrl);
-			/*
-			 * Failed to grab the extent map which should be very rare.
-			 * Since there is no bio submitted to finish the ordered
-			 * extent, we have to manually finish this sector.
-			 */
-			btrfs_mark_ordered_io_finished(inode, folio, cur,
-						       fs_info->sectorsize, false);
 			if (!found_error)
 				found_error = ret;
 			continue;
@@ -1587,8 +1597,8 @@ static noinline_for_stack int extent_wri
 	 * Here we set writeback and clear for the range. If the full folio
 	 * is no longer dirty then we clear the PAGECACHE_TAG_DIRTY tag.
 	 *
-	 * If we hit any error, the corresponding sector will still be dirty
-	 * thus no need to clear PAGECACHE_TAG_DIRTY.
+	 * If we hit any error, the corresponding sector will have its dirty
+	 * flag cleared and writeback finished, thus no need to handle the error case.
 	 */
 	if (!submitted_io && !found_error) {
 		btrfs_folio_set_writeback(fs_info, folio, start, len);


