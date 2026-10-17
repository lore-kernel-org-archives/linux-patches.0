Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D003CAE9B;
	Sat, 17 Oct 2026 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258540; cv=none; b=B1Hu7PpJ/Zg6ODaEbKIK7/tuKkM3IzXbQ/kvBzxEK117h+yJ8tl0CNI4OyAT29VhPchKzUm2+lUjwvrygVNHuE4ZrV9zkpz+8TtZQ2nxnkfMIN+0LVtCwoefwJv5hacFfJk8csqFp91OdMchVWKYAhJfGq2sycMT8ymAROmJNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258540; c=relaxed/simple;
	bh=a4uCFiaW9lEUP19Z+V8Ounr3Tj7mIEQjYt9hWJf/Cnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnyYV6oxnHTZORJEpbQoVVOnb1OFjrVAiIvp+Ry376QVrZY00hCqrp10ZubkpbcxXrGM1dv+G8GbVRQB7C6QaYnIBS2adYHPn50z4cagzRl25MFBpvYU3E+ep+oy5tobSO6hyTQ6NXGu0yTQ0seO/R7MDoRZcISoIkfq7TdSnZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHbiMvKB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHbiMvKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76541F000C4;
	Sat, 17 Oct 2026 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258539;
	bh=tZvEMr0DwIDnUl5E7FxZA3ZpK4bCvIw9DP3W1qvc0QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHbiMvKBwduaALMRmrJN7P+nzeh6pJsgfYfRHs0dWrTfHAtt/DDgUdt4cSVsXusn4
	 p1SVWdSxNM5gcFP3/KJg1fHPUXODDU+sTeR2y9014B+4hKTB2soHzNCxkE+WuUBkZ9
	 gtZe8w9JKYajShKQQpvtKwEz/W96X5xjM2AdiMpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0917/1674] fs/ntfs3: Accumulated refactoring changes
Date: Sat, 17 Oct 2026 17:53:09 +0200
Message-ID: <20261017160454.669665309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit bac89bb33d91cdd75092e15cf59fe6be34571142 ]

Changes made to improve readability and debuggability.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 08ce2fee1b86 ("ntfs3: fix circular locking dependency in run_unpack_ex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/bitmap.c  | 62 +++++++++++++---------------------------------
 fs/ntfs3/frecord.c |  1 -
 fs/ntfs3/fsntfs.c  |  2 +-
 fs/ntfs3/run.c     |  6 ++---
 4 files changed, 21 insertions(+), 50 deletions(-)

diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index 29b585f443f3e..65d05e6a05665 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -710,20 +710,17 @@ int wnd_set_free(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 {
 	int err = 0;
 	struct super_block *sb = wnd->sb;
-	size_t bits0 = bits;
 	u32 wbits = 8 * sb->s_blocksize;
 	size_t iw = bit >> (sb->s_blocksize_bits + 3);
 	u32 wbit = bit & (wbits - 1);
 	struct buffer_head *bh;
+	u32 op;
 
-	while (iw < wnd->nwnd && bits) {
-		u32 tail, op;
-
+	for (; iw < wnd->nwnd && bits; iw++, bit += op, bits -= op, wbit = 0) {
 		if (iw + 1 == wnd->nwnd)
 			wbits = wnd->bits_last;
 
-		tail = wbits - wbit;
-		op = min_t(u32, tail, bits);
+		op = min_t(u32, wbits - wbit, bits);
 
 		bh = wnd_map(wnd, iw);
 		if (IS_ERR(bh)) {
@@ -736,20 +733,15 @@ int wnd_set_free(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 		ntfs_bitmap_clear_le(bh->b_data, wbit, op);
 
 		wnd->free_bits[iw] += op;
+		wnd->total_zeroes += op;
 
 		set_buffer_uptodate(bh);
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		put_bh(bh);
 
-		wnd->total_zeroes += op;
-		bits -= op;
-		wbit = 0;
-		iw += 1;
+		wnd_add_free_ext(wnd, bit, op, false);
 	}
-
-	wnd_add_free_ext(wnd, bit, bits0, false);
-
 	return err;
 }
 
@@ -760,20 +752,17 @@ int wnd_set_used(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 {
 	int err = 0;
 	struct super_block *sb = wnd->sb;
-	size_t bits0 = bits;
 	size_t iw = bit >> (sb->s_blocksize_bits + 3);
 	u32 wbits = 8 * sb->s_blocksize;
 	u32 wbit = bit & (wbits - 1);
 	struct buffer_head *bh;
+	u32 op;
 
-	while (iw < wnd->nwnd && bits) {
-		u32 tail, op;
-
+	for (; iw < wnd->nwnd && bits; iw++, bit += op, bits -= op, wbit = 0) {
 		if (unlikely(iw + 1 == wnd->nwnd))
 			wbits = wnd->bits_last;
 
-		tail = wbits - wbit;
-		op = min_t(u32, tail, bits);
+		op = min_t(u32, wbits - wbit, bits);
 
 		bh = wnd_map(wnd, iw);
 		if (IS_ERR(bh)) {
@@ -785,21 +774,16 @@ int wnd_set_used(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 
 		ntfs_bitmap_set_le(bh->b_data, wbit, op);
 		wnd->free_bits[iw] -= op;
+		wnd->total_zeroes -= op;
 
 		set_buffer_uptodate(bh);
 		mark_buffer_dirty(bh);
 		unlock_buffer(bh);
 		put_bh(bh);
 
-		wnd->total_zeroes -= op;
-		bits -= op;
-		wbit = 0;
-		iw += 1;
+		if (!RB_EMPTY_ROOT(&wnd->start_tree))
+			wnd_remove_free_ext(wnd, bit, op);
 	}
-
-	if (!RB_EMPTY_ROOT(&wnd->start_tree))
-		wnd_remove_free_ext(wnd, bit, bits0);
-
 	return err;
 }
 
@@ -852,15 +836,13 @@ static bool wnd_is_free_hlp(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 	size_t iw = bit >> (sb->s_blocksize_bits + 3);
 	u32 wbits = 8 * sb->s_blocksize;
 	u32 wbit = bit & (wbits - 1);
+	u32 op;
 
-	while (iw < wnd->nwnd && bits) {
-		u32 tail, op;
-
+	for (; iw < wnd->nwnd && bits; iw++, bits -= op, wbit = 0) {
 		if (unlikely(iw + 1 == wnd->nwnd))
 			wbits = wnd->bits_last;
 
-		tail = wbits - wbit;
-		op = min_t(u32, tail, bits);
+		op = min_t(u32, wbits - wbit, bits);
 
 		if (wbits != wnd->free_bits[iw]) {
 			bool ret;
@@ -875,10 +857,6 @@ static bool wnd_is_free_hlp(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 			if (!ret)
 				return false;
 		}
-
-		bits -= op;
-		wbit = 0;
-		iw += 1;
 	}
 
 	return true;
@@ -928,6 +906,7 @@ bool wnd_is_used(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 	size_t iw = bit >> (sb->s_blocksize_bits + 3);
 	u32 wbits = 8 * sb->s_blocksize;
 	u32 wbit = bit & (wbits - 1);
+	u32 op;
 	size_t end;
 	struct rb_node *n;
 	struct e_node *e;
@@ -945,14 +924,11 @@ bool wnd_is_used(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 		return false;
 
 use_wnd:
-	while (iw < wnd->nwnd && bits) {
-		u32 tail, op;
-
+	for (; iw < wnd->nwnd && bits; iw++, bits -= op, wbit = 0) {
 		if (unlikely(iw + 1 == wnd->nwnd))
 			wbits = wnd->bits_last;
 
-		tail = wbits - wbit;
-		op = min_t(u32, tail, bits);
+		op = min_t(u32, wbits - wbit, bits);
 
 		if (wnd->free_bits[iw]) {
 			bool ret;
@@ -966,10 +942,6 @@ bool wnd_is_used(struct wnd_bitmap *wnd, size_t bit, size_t bits)
 			if (!ret)
 				goto out;
 		}
-
-		bits -= op;
-		wbit = 0;
-		iw += 1;
 	}
 	ret = true;
 
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 7952ef0c585bb..00faacc33b088 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1975,7 +1975,6 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	if (end > alloc_size)
 		end = alloc_size;
 
-
 	while (vbo < end) {
 		if (idx == -1) {
 			ok = run_lookup_entry(&run, vcn, &lcn, &clen, &idx);
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 3909c95d9bedd..513c04be1caf8 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2711,4 +2711,4 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 out:
 	kfree(uni);
 	return err;
-}
\ No newline at end of file
+}
diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index 535a094e822ee..8d05f3f276db4 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1131,9 +1131,9 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
 		err = wnd_set_used_safe(wnd, lcn, len, &done);
 		if (zone) {
 			/* Restore zone. Lock mft run. */
-			struct rw_semaphore *lock;
-			lock = is_mounted(sbi) ? &sbi->mft.ni->file.run_lock :
-						 NULL;
+			struct rw_semaphore *lock =
+				is_mounted(sbi) ? &sbi->mft.ni->file.run_lock :
+						  NULL;
 			if (lock)
 				down_read(lock);
 			ntfs_refresh_zone(sbi);
-- 
2.53.0



