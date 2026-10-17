Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35996377A92;
	Sat, 17 Oct 2026 16:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253807; cv=none; b=BXT6F59wB+33DjgvY+xh7JKTNUCiSzTnLo41uu3OgeG9JeopcRbVnM+8PIhiFq+O2bbr91iwF/b/mn0I6cX85szfX0e9gxHmtv6X57bdeu6pcImCwrrH0uXBcYZBD7kbbNEyql5ihixMjcm2gfTlgeIO3yRceo1e3gZG9I/z0yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253807; c=relaxed/simple;
	bh=7qhcG0hKuIurimnY5iNeofaha1B+Sp3XjmphbGV0QeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqkf6jPfCX4qYDfVn2wVIbAG+kCJXVhwFaZfHaYWJvZfubsc0UVuHV0yyVtA3fv/OPx184288NUcmY60Q3aaxpUZcKmFzOEgfqXi784X29s8SZjPA2vWX11x7/7mi4w7J16mWGkfdCZ30yrCbSzv/PCMON5SdqFKbJeZvkJ6hV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkyCugBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkyCugBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8187F1F000C4;
	Sat, 17 Oct 2026 16:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253806;
	bh=6V8MA/d32+G7l6j1HsQeyHH/Jz0UAP70tAWhBWONGsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkyCugBv2P3E1Y1CE+35W9f9h+vUmuDGqKl5w8Bszd1scwDL1oj2jXzj4b2XoChUg
	 k4QHTLoyJ2NZo0T0sN78jxU0JGmpgHBLQB3X7ihH/jje0ixvFGy2b/IDGzz+TT9LSy
	 PUdWkrgs0VSxTFbwG0mTEzC+XKOOZqL8Dwg+Le5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/869] fs/ntfs3: Accumulated refactoring changes
Date: Sat, 17 Oct 2026 17:51:19 +0200
Message-ID: <20261017160043.157204383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 45e8d73d38f8f..ab8615abb981b 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1977,7 +1977,6 @@ int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	if (end > alloc_size)
 		end = alloc_size;
 
-
 	while (vbo < end) {
 		if (idx == -1) {
 			ok = run_lookup_entry(&run, vcn, &lcn, &clen, &idx);
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 170836749de68..c9ff8293fea73 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2716,4 +2716,4 @@ int ntfs_set_label(struct ntfs_sb_info *sbi, u8 *label, int len)
 out:
 	kfree(uni);
 	return err;
-}
\ No newline at end of file
+}
diff --git a/fs/ntfs3/run.c b/fs/ntfs3/run.c
index 12f93f5a3d9bc..18b8767acba5f 100644
--- a/fs/ntfs3/run.c
+++ b/fs/ntfs3/run.c
@@ -1133,9 +1133,9 @@ int run_unpack_ex(struct runs_tree *run, struct ntfs_sb_info *sbi, CLST ino,
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



