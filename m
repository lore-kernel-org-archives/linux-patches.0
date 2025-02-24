Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0626191F66;
	Mon, 24 Feb 2025 14:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408328; cv=none; b=TwGtgmQlMFIDGReuofFxLkUQuqzWvxZLFaPg1/u5uc10JoEZys9jka/FjbZN0GXwebLgCP9CRc1RFDbI8rX1NcnHRwrh5VhjN5s2F7VxutAyYDcBPaatBSWYXZNRzHL37NDnSzA4h0IIAfNtmcugvPZvxVBLIc9LAPHZmArsunM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408328; c=relaxed/simple;
	bh=x6lDKrvIJPwYq5YF61cZTxhT/qyR1xDvTZ8YOK4EIBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGvKGuXcm0rcQmqRWUDzs5rMzPJSLzMw2xMy6K5nmNzMX1IuHv6vOhajFlWp28edrlUgF1sUGI04OAqxIzjiPrttKK8xTkXwQGEKh0y8fiHYobox4cMV/QACmwb7bMWlx5AewDEHoeqQJmgMxu5vDK/27B59719GkgH+71r64Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4QHWMJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4QHWMJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AF9C4CED6;
	Mon, 24 Feb 2025 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408328;
	bh=x6lDKrvIJPwYq5YF61cZTxhT/qyR1xDvTZ8YOK4EIBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4QHWMJEnfWH9DE27FVxgR0sLkx97EvFjky5IVFeYo5p8DLmgW++a4Lg05HgSVekA
	 p1Am65+jmI9ne1vSCx89OVmMBrG5AnK94OP4bR1/LmtdeAHeOi81PU+VoXNa0Q0ljX
	 WKsbAlLMKdzlJ3rD1kqwVu6OaI+0kst6D1eh2pAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/154] btrfs: remove unused btrfs_folio_start_writer_lock()
Date: Mon, 24 Feb 2025 15:33:28 +0100
Message-ID: <20250224142607.435958245@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 8511074c42b6255e03eceb09396338572572f1c7 ]

This function is not really suitable to lock a folio, as it lacks the
proper mapping checks, thus the locked folio may not even belong to
btrfs.

And due to the above reason, the last user inside lock_delalloc_folios()
is already removed, and we can remove this function.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/subpage.c | 47 ----------------------------------------------
 fs/btrfs/subpage.h |  2 --
 2 files changed, 49 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index c4950e04f481a..99341e98bbcc7 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -295,26 +295,6 @@ static void btrfs_subpage_clamp_range(struct folio *folio, u64 *start, u32 *len)
 			     orig_start + orig_len) - *start;
 }
 
-static void btrfs_subpage_start_writer(const struct btrfs_fs_info *fs_info,
-				       struct folio *folio, u64 start, u32 len)
-{
-	struct btrfs_subpage *subpage = folio_get_private(folio);
-	const int start_bit = subpage_calc_start_bit(fs_info, folio, locked, start, len);
-	const int nbits = (len >> fs_info->sectorsize_bits);
-	unsigned long flags;
-	int ret;
-
-	btrfs_subpage_assert(fs_info, folio, start, len);
-
-	spin_lock_irqsave(&subpage->lock, flags);
-	ASSERT(atomic_read(&subpage->readers) == 0);
-	ASSERT(bitmap_test_range_all_zero(subpage->bitmaps, start_bit, nbits));
-	bitmap_set(subpage->bitmaps, start_bit, nbits);
-	ret = atomic_add_return(nbits, &subpage->writers);
-	ASSERT(ret == nbits);
-	spin_unlock_irqrestore(&subpage->lock, flags);
-}
-
 static bool btrfs_subpage_end_and_test_writer(const struct btrfs_fs_info *fs_info,
 					      struct folio *folio, u64 start, u32 len)
 {
@@ -351,33 +331,6 @@ static bool btrfs_subpage_end_and_test_writer(const struct btrfs_fs_info *fs_inf
 	return last;
 }
 
-/*
- * Lock a folio for delalloc page writeback.
- *
- * Return -EAGAIN if the page is not properly initialized.
- * Return 0 with the page locked, and writer counter updated.
- *
- * Even with 0 returned, the page still need extra check to make sure
- * it's really the correct page, as the caller is using
- * filemap_get_folios_contig(), which can race with page invalidating.
- */
-int btrfs_folio_start_writer_lock(const struct btrfs_fs_info *fs_info,
-				  struct folio *folio, u64 start, u32 len)
-{
-	if (unlikely(!fs_info) || !btrfs_is_subpage(fs_info, folio->mapping)) {
-		folio_lock(folio);
-		return 0;
-	}
-	folio_lock(folio);
-	if (!folio_test_private(folio) || !folio_get_private(folio)) {
-		folio_unlock(folio);
-		return -EAGAIN;
-	}
-	btrfs_subpage_clamp_range(folio, &start, &len);
-	btrfs_subpage_start_writer(fs_info, folio, start, len);
-	return 0;
-}
-
 /*
  * Handle different locked folios:
  *
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index 197ec6c0b07b2..6289d6f65b87d 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -100,8 +100,6 @@ void btrfs_subpage_start_reader(const struct btrfs_fs_info *fs_info,
 void btrfs_subpage_end_reader(const struct btrfs_fs_info *fs_info,
 			      struct folio *folio, u64 start, u32 len);
 
-int btrfs_folio_start_writer_lock(const struct btrfs_fs_info *fs_info,
-				  struct folio *folio, u64 start, u32 len);
 void btrfs_folio_end_writer_lock(const struct btrfs_fs_info *fs_info,
 				 struct folio *folio, u64 start, u32 len);
 void btrfs_folio_set_writer_lock(const struct btrfs_fs_info *fs_info,
-- 
2.39.5



