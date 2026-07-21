Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C502E736D;
	Tue, 21 Jul 2026 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654414; cv=none; b=AsNix8FVVzDJ54lQqfequuVg2qmy3/YJY593F9b2zq8fmOGDI42YPoNFwrTo5NZqEr/EV8/Bu0nR/2BmwV4Z+VFId7IFkQZ3akQi0Hvd7VQDfjPh92rGH/YGTR05f45G/S4H4pCGRJ8A0HJJzOflMPXdwSpKQTpUtmxaERXm91A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654414; c=relaxed/simple;
	bh=Xy7viGINIHTqhTkxRNxKJwW5jXV+UviiCtMggln2Tls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqu7NglV7UAFOrut8lpJ4eNjH6tY0BewEr1GEmEOzp8rmGbcXI/DsaTPHHg5q0vW2k2u9upvNhYJ7XC24Ccq1YTtAvBA2fbXTDLMZzvoRgyVZcZlI1xVWuIV3Yr2ApFddh1Koq13B8Dtdv4W8eWLX5FPghQ5jCAC10ccy7nDtwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npOAVJmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npOAVJmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EFD1F000E9;
	Tue, 21 Jul 2026 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654412;
	bh=ARCP0IXjNPilsAG3fGz6jfXwsz+E4z66SSmdDdF/rak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npOAVJmIGi0QVdtg0JxKQkGHeTPuQAfYiow7QDF4Am6qUlB4h7++qpeTmtNTcQy/v
	 hr8teF9cegxDbX0a4YcVjdpfHCZc4XRadfE/BnCwIML8q9lQBJR/Hiq5jd6lyMQsE1
	 3wW37YMLERr3agnRsN8532s1FRsAL+N17vEikm1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1694/2077] ntfs: avoid heap allocation for free-cluster readahead state
Date: Tue, 21 Jul 2026 17:22:47 +0200
Message-ID: <20260721152632.713328106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

commit c05132077df57a384919f61d7f8a8e76d748a6d4 upstream.

get_nr_free_clusters() allocates a temporary file_ra_state before it
publishes the precomputed free cluster count, sets NVolFreeClusterKnown(),
and wakes vol->free_waitq. If that allocation fails, the worker returns
without setting the flag or waking waiters, so callers waiting for the free
count can block indefinitely.

The readahead state is only used synchronously while scanning the bitmap.
Keep it on the stack and pass it by address to the readahead helper. This
eliminates the early allocation failure path instead of adding a special
case that publishes a conservative count and wakes the waitqueue.
Zero-initialize the on-stack state because file_ra_state_init() only sets
ra_pages and prev_pos.

Apply the same treatment to __get_nr_free_mft_records(), which scans the
MFT bitmap with the same short-lived readahead state.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -1955,7 +1955,7 @@ s64 get_nr_free_clusters(struct ntfs_vol
 	struct address_space *mapping = vol->lcnbmp_ino->i_mapping;
 	struct folio *folio;
 	pgoff_t index, max_index;
-	struct file_ra_state *ra;
+	struct file_ra_state ra = { 0 };
 
 	ntfs_debug("Entering.");
 	/* Serialize accesses to the cluster bitmap. */
@@ -1963,11 +1963,7 @@ s64 get_nr_free_clusters(struct ntfs_vol
 	if (NVolFreeClusterKnown(vol))
 		return atomic64_read(&vol->free_clusters);
 
-	ra = kzalloc(sizeof(*ra), GFP_NOFS);
-	if (!ra)
-		return 0;
-
-	file_ra_state_init(ra, mapping);
+	file_ra_state_init(&ra, mapping);
 
 	/*
 	 * Convert the number of bits into bytes rounded up, then convert into
@@ -1986,7 +1982,7 @@ s64 get_nr_free_clusters(struct ntfs_vol
 		 * Get folio from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
 		 */
-		folio = ntfs_get_locked_folio(mapping, index, max_index, ra);
+		folio = ntfs_get_locked_folio(mapping, index, max_index, &ra);
 
 		/* Ignore pages which errored synchronously. */
 		if (IS_ERR(folio)) {
@@ -2025,7 +2021,6 @@ s64 get_nr_free_clusters(struct ntfs_vol
 	else
 		atomic64_set(&vol->free_clusters, nr_free);
 
-	kfree(ra);
 	NVolSetFreeClusterKnown(vol);
 	wake_up_all(&vol->free_waitq);
 	ntfs_debug("Exiting.");
@@ -2080,15 +2075,11 @@ static unsigned long __get_nr_free_mft_r
 	struct address_space *mapping = vol->mftbmp_ino->i_mapping;
 	struct folio *folio;
 	pgoff_t index;
-	struct file_ra_state *ra;
+	struct file_ra_state ra = { 0 };
 
 	ntfs_debug("Entering.");
 
-	ra = kzalloc(sizeof(*ra), GFP_NOFS);
-	if (!ra)
-		return 0;
-
-	file_ra_state_init(ra, mapping);
+	file_ra_state_init(&ra, mapping);
 
 	/* Use multiples of 4 bytes, thus max_size is PAGE_SIZE / 4. */
 	ntfs_debug("Reading $MFT/$BITMAP, max_index = 0x%lx, max_size = 0x%lx.",
@@ -2100,7 +2091,7 @@ static unsigned long __get_nr_free_mft_r
 		 * Get folio from page cache, getting it from backing store
 		 * if necessary, and increment the use count.
 		 */
-		folio = ntfs_get_locked_folio(mapping, index, max_index, ra);
+		folio = ntfs_get_locked_folio(mapping, index, max_index, &ra);
 
 		/* Ignore pages which errored synchronously. */
 		if (IS_ERR(folio)) {
@@ -2132,7 +2123,6 @@ static unsigned long __get_nr_free_mft_r
 	else
 		atomic64_set(&vol->free_mft_records, nr_free);
 
-	kfree(ra);
 	ntfs_debug("Exiting.");
 	return nr_free;
 }


