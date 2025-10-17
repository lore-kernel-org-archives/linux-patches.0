Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B292F3208;
	Fri, 17 Oct 2025 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714704; cv=none; b=HBqKzVYTMepkebwUcU7XbC98XlrozZsxoAepFiNHURDiqq+gc2BA0V7SNZHBRaBAy/S09BU1m5aboJz/aw5bA9Gl5Fmsj/4ItaWmfchDRZPM+gcIPxSDhjnHNRdr+5C3Smvwut7WHPghfGNWvtMKOiTJA4UfD17V4sLS8RErc0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714704; c=relaxed/simple;
	bh=PZ0qkQHwxUCWD0zMYJHHOiZHKbOhun7Aual+OboE2uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUgDVGZ34mN7YfnM1aZBr3JvPOoaOGYZMSiA9X74qXxSyLPiG2SrtZN9x1YH0uSwgGLJ1YLdKwAeTvLUawESXIYw+9FicTxMSp2Xe/3Da4Bby3GD2bUNYdXBfitkad3x76DHi87U7DzbOOyi4vXOES0xAaWSoE874VLAMP3SbPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFC3fTjC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFC3fTjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F90C4CEE7;
	Fri, 17 Oct 2025 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714704;
	bh=PZ0qkQHwxUCWD0zMYJHHOiZHKbOhun7Aual+OboE2uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFC3fTjCDSYkuytaIjhrJp679JneO2qc7p33BHOmIFIAV3IOFUpWLccbFLcwWJ6wO
	 rbzwhOTxLOOexVw3Nk0NTlRcSjXrLDC8zBHjESu/obqlCJtKdidRgHnDrMqDj7A4Ou
	 CpxEFkcJjqOqLIyeRjZrA4LqciLb7ohNwtVfwXjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/277] btrfs: fix the incorrect max_bytes value for find_lock_delalloc_range()
Date: Fri, 17 Oct 2025 16:54:03 +0200
Message-ID: <20251017145155.755456973@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

[ Upstream commit 7b26da407420e5054e3f06c5d13271697add9423 ]

[BUG]
With my local branch to enable bs > ps support for btrfs, sometimes I
hit the following ASSERT() inside submit_one_sector():

	ASSERT(block_start != EXTENT_MAP_HOLE);

Please note that it's not yet possible to hit this ASSERT() in the wild
yet, as it requires btrfs bs > ps support, which is not even in the
development branch.

But on the other hand, there is also a very low chance to hit above
ASSERT() with bs < ps cases, so this is an existing bug affect not only
the incoming bs > ps support but also the existing bs < ps support.

[CAUSE]
Firstly that ASSERT() means we're trying to submit a dirty block but
without a real extent map nor ordered extent map backing it.

Furthermore with extra debugging, the folio triggering such ASSERT() is
always larger than the fs block size in my bs > ps case.
(8K block size, 4K page size)

After some more debugging, the ASSERT() is trigger by the following
sequence:

 extent_writepage()
 |  We got a 32K folio (4 fs blocks) at file offset 0, and the fs block
 |  size is 8K, page size is 4K.
 |  And there is another 8K folio at file offset 32K, which is also
 |  dirty.
 |  So the filemap layout looks like the following:
 |
 |  "||" is the filio boundary in the filemap.
 |  "//| is the dirty range.
 |
 |  0        8K       16K        24K         32K       40K
 |  |////////|        |//////////////////////||////////|
 |
 |- writepage_delalloc()
 |  |- find_lock_delalloc_range() for [0, 8K)
 |  |  Now range [0, 8K) is properly locked.
 |  |
 |  |- find_lock_delalloc_range() for [16K, 40K)
 |  |  |- btrfs_find_delalloc_range() returned range [16K, 40K)
 |  |  |- lock_delalloc_folios() locked folio 0 successfully
 |  |  |
 |  |  |  The filemap range [32K, 40K) got dropped from filemap.
 |  |  |
 |  |  |- lock_delalloc_folios() failed with -EAGAIN on folio 32K
 |  |  |  As the folio at 32K is dropped.
 |  |  |
 |  |  |- loops = 1;
 |  |  |- max_bytes = PAGE_SIZE;
 |  |  |- goto again;
 |  |  |  This will re-do the lookup for dirty delalloc ranges.
 |  |  |
 |  |  |- btrfs_find_delalloc_range() called with @max_bytes == 4K
 |  |  |  This is smaller than block size, so
 |  |  |  btrfs_find_delalloc_range() is unable to return any range.
 |  |  \- return false;
 |  |
 |  \- Now only range [0, 8K) has an OE for it, but for dirty range
 |     [16K, 32K) it's dirty without an OE.
 |     This breaks the assumption that writepage_delalloc() will find
 |     and lock all dirty ranges inside the folio.
 |
 |- extent_writepage_io()
    |- submit_one_sector() for [0, 8K)
    |  Succeeded
    |
    |- submit_one_sector() for [16K, 24K)
       Triggering the ASSERT(), as there is no OE, and the original
       extent map is a hole.

Please note that, this also exposed the same problem for bs < ps
support. E.g. with 64K page size and 4K block size.

If we failed to lock a folio, and falls back into the "loops = 1;"
branch, we will re-do the search using 64K as max_bytes.
Which may fail again to lock the next folio, and exit early without
handling all dirty blocks inside the folio.

[FIX]
Instead of using the fixed size PAGE_SIZE as @max_bytes, use
@sectorsize, so that we are ensured to find and lock any remaining
blocks inside the folio.

And since we're here, add an extra ASSERT() to
before calling btrfs_find_delalloc_range() to make sure the @max_bytes is
at least no smaller than a block to avoid false negative.

Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -355,6 +355,13 @@ again:
 	/* step one, find a bunch of delalloc bytes starting at start */
 	delalloc_start = *start;
 	delalloc_end = 0;
+
+	/*
+	 * If @max_bytes is smaller than a block, btrfs_find_delalloc_range() can
+	 * return early without handling any dirty ranges.
+	 */
+	ASSERT(max_bytes >= fs_info->sectorsize);
+
 	found = btrfs_find_delalloc_range(tree, &delalloc_start, &delalloc_end,
 					  max_bytes, &cached_state);
 	if (!found || delalloc_end <= *start || delalloc_start > orig_end) {
@@ -385,13 +392,14 @@ again:
 				   delalloc_end);
 	ASSERT(!ret || ret == -EAGAIN);
 	if (ret == -EAGAIN) {
-		/* some of the folios are gone, lets avoid looping by
-		 * shortening the size of the delalloc range we're searching
+		/*
+		 * Some of the folios are gone, lets avoid looping by
+		 * shortening the size of the delalloc range we're searching.
 		 */
 		free_extent_state(cached_state);
 		cached_state = NULL;
 		if (!loops) {
-			max_bytes = PAGE_SIZE;
+			max_bytes = fs_info->sectorsize;
 			loops = 1;
 			goto again;
 		} else {


