Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BAE143882;
	Tue, 23 Apr 2024 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908468; cv=none; b=QxcVom9PZVvrN3wFjp1xeTWdPciB+yW8TP3PWA5R77GkyPHlmrcathS2RPhCm85B5dLRt+w9dZao7Qc8/LDRgXviYqcdH/2t/bmaeFLTT2rynQzYtoCBPvpbXgTRAbkhHllkJAj7LPT4ahCXp7Y1j5jzMhJCqXim3ccztH0pCVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908468; c=relaxed/simple;
	bh=7ciXB/K1bw9oP3X0ex0FPALTyK4ZG15uRey+dK42Aho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6ZB0+kNZG3ad+6V7LVrbMEMbdsTwiyQmirffeSY+WNwdpZpDy0kzwYDJFWldUE65oHLkA4hxzD9WZbNAmyCahSTg4ktoMjv1C/qexO4NMLEj/mEB3o8g+Go6BBbzlUjBcxCp5qLAlxAN5VDNsEbSz15SQIjZfMfSQULrE7dukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvkJ/50x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvkJ/50x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A80C32783;
	Tue, 23 Apr 2024 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908468;
	bh=7ciXB/K1bw9oP3X0ex0FPALTyK4ZG15uRey+dK42Aho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvkJ/50x59udSDSUOS4gsq7GIN2284MyWm6+O2RaZQyjcc5Kh+4vAQmqRuuvTHKKv
	 QWO5/ztLi0XT2Um3dPceium1rkSo0DKPsy0QuR4khSgJLpIWmgDUyOO8Wzwj2XXyms
	 KNBVzBL4vYW4q+tT0sY2aNehyg1nKAJH4nNQnQ6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Taylor <julian.taylor@1und1.de>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 009/158] btrfs: do not wait for short bulk allocation
Date: Tue, 23 Apr 2024 14:37:11 -0700
Message-ID: <20240423213856.150819097@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 1db7959aacd905e6487d0478ac01d89f86eb1e51 upstream.

[BUG]
There is a recent report that when memory pressure is high (including
cached pages), btrfs can spend most of its time on memory allocation in
btrfs_alloc_page_array() for compressed read/write.

[CAUSE]
For btrfs_alloc_page_array() we always go alloc_pages_bulk_array(), and
even if the bulk allocation failed (fell back to single page
allocation) we still retry but with extra memalloc_retry_wait().

If the bulk alloc only returned one page a time, we would spend a lot of
time on the retry wait.

The behavior was introduced in commit 395cb57e8560 ("btrfs: wait between
incomplete batch memory allocations").

[FIX]
Although the commit mentioned that other filesystems do the wait, it's
not the case at least nowadays.

All the mainlined filesystems only call memalloc_retry_wait() if they
failed to allocate any page (not only for bulk allocation).
If there is any progress, they won't call memalloc_retry_wait() at all.

For example, xfs_buf_alloc_pages() would only call memalloc_retry_wait()
if there is no allocation progress at all, and the call is not for
metadata readahead.

So I don't believe we should call memalloc_retry_wait() unconditionally
for short allocation.

Call memalloc_retry_wait() if it fails to allocate any page for tree
block allocation (which goes with __GFP_NOFAIL and may not need the
special handling anyway), and reduce the latency for
btrfs_alloc_page_array().

Reported-by: Julian Taylor <julian.taylor@1und1.de>
Tested-by: Julian Taylor <julian.taylor@1und1.de>
Link: https://lore.kernel.org/all/8966c095-cbe7-4d22-9784-a647d1bf27c3@1und1.de/
Fixes: 395cb57e8560 ("btrfs: wait between incomplete batch memory allocations")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -692,31 +692,21 @@ static void end_bbio_data_read(struct bt
 int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
 			   gfp_t extra_gfp)
 {
+	const gfp_t gfp = GFP_NOFS | extra_gfp;
 	unsigned int allocated;
 
 	for (allocated = 0; allocated < nr_pages;) {
 		unsigned int last = allocated;
 
-		allocated = alloc_pages_bulk_array(GFP_NOFS | extra_gfp,
-						   nr_pages, page_array);
-
-		if (allocated == nr_pages)
-			return 0;
-
-		/*
-		 * During this iteration, no page could be allocated, even
-		 * though alloc_pages_bulk_array() falls back to alloc_page()
-		 * if  it could not bulk-allocate. So we must be out of memory.
-		 */
-		if (allocated == last) {
+		allocated = alloc_pages_bulk_array(gfp, nr_pages, page_array);
+		if (unlikely(allocated == last)) {
+			/* No progress, fail and do cleanup. */
 			for (int i = 0; i < allocated; i++) {
 				__free_page(page_array[i]);
 				page_array[i] = NULL;
 			}
 			return -ENOMEM;
 		}
-
-		memalloc_retry_wait(GFP_NOFS);
 	}
 	return 0;
 }


