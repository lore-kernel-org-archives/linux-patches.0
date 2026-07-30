Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E55C43B6FC;
	Thu, 30 Jul 2026 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421704; cv=none; b=Xm5in9asscYIu3Uf1SarUWrd5gkiflF3wrFGpvZ/6mP60Oo3ioxKHMHsSW87Yx+mSRvMgY28SdkWJykGzFb1uIpCEkU5OtcqQrPeQlHSXm7SqLpRVZwWfCnHmoeNBBK61TfWD/JovFmuiMawQJt+Mfd47JWTc52hQ8k99j6HHeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421704; c=relaxed/simple;
	bh=NOyggLAkpXxR7neYS4OYBGegcGUkCheGzSVF+ZRf1Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5psC4gjuNZohR+3dbcR5BcO55ag1/OdbSQ4mDp8kaQatOC6k+sGoct79dhSkc/MpLY2d+gf8NGkmb9ERqCznR0WD9WdvAWNlhQoGayzWzAyRjqhTZ28zLJRcXB0EILCH9jfey/+stJXBoqG0cALaQaULv5VGI5ZZNr81nE0l1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFRnJhqW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFRnJhqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DC81F000E9;
	Thu, 30 Jul 2026 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421703;
	bh=SGpfVVTc/E8Jbw9S7MT4YOWQ5GJ5mXqgscQBXJg92Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFRnJhqWDebUp59fJGxxSkqzNmPfHOiJKpFIFIiASjN2owFMRVGJYRnKi7qjmq062
	 6KreS1Xm+8ju/SX72rIXsQHDTRR/syPtrpiofcVxLukAvjTsqQJJCHMmqW+jEtFKgv
	 NxVQ6f3q9F2Nj7YZ0qQFs4raie4+5I45UkbuuZc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Dave Chen <davechen@synology.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 193/744] btrfs: fix u32 to s64 type conversion in dirty_metadata_bytes accounting
Date: Thu, 30 Jul 2026 16:07:46 +0200
Message-ID: <20260730141448.384482958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Dave Chen <davechen@synology.com>

[ Upstream commit 8b5a09ceb61b18b1f0797cd30a549d7dc85d8d50 ]

The percpu_counter dirty_metadata_bytes is updated by negating eb->len
and passing it to percpu_counter_add_batch(), whose amount parameter is
s64.  Since commit 84cda1a6087d ("btrfs: cache folio size and shift in
extent_buffer"), eb->len is u32.  The u32 result of -eb->len, when
widened to the s64 parameter, becomes a large positive value instead of
the intended negative value.  For eb->len == 16384 the counter adds
+4294950912 instead of subtracting 16384.

The counter therefore grows on every metadata writeback instead of
shrinking by the extent buffer size, permanently exceeding
BTRFS_DIRTY_METADATA_THRESH and causing __btrfs_btree_balance_dirty()
to trigger balance_dirty_pages_ratelimited() unconditionally, adding
unnecessary writeback pressure.

Cast eb->len to s64 before negation at both call sites so the
subtraction is performed in signed 64-bit arithmetic.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Fixes: 84cda1a6087d ("btrfs: cache folio size and shift in extent_buffer")
Signed-off-by: Dave Chen <davechen@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2275189b786055..f0bfa8a6218a71 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1963,7 +1963,7 @@ static noinline_for_stack bool lock_extent_buffer_for_io(struct extent_buffer *e
 
 		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
 		percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
-					 -eb->len,
+					 -(s64)eb->len,
 					 fs_info->dirty_metadata_batch);
 		ret = true;
 	} else {
@@ -3778,7 +3778,7 @@ void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 		return;
 
 	buffer_tree_clear_mark(eb, PAGECACHE_TAG_DIRTY);
-	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -eb->len,
+	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes, -(s64)eb->len,
 				 fs_info->dirty_metadata_batch);
 
 	for (int i = 0; i < num_extent_folios(eb); i++) {
-- 
2.53.0



