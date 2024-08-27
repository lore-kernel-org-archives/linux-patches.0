Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485261C57AB;
	Tue, 27 Aug 2024 14:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769753; cv=none; b=Lc6P8QthInS44MAxX698kZfnS4uqqqL8BNW3LzKZlb5OIY9/2MZUVLKbvQ9HFXtBBzL1OVlEvaSGMcuLuXhtmk+8pB4AfGLLh72ZnmVuW8Op2sRyJnQUrDb7nZSJbSa3ExTQ3eoCrgBOf4Wv4jYNlf2tg6J/lNmL4SWFz+cmxQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769753; c=relaxed/simple;
	bh=XZSi4hKfB/K44fQ6lQpwLbxKGTcIYaYlw2lnLKvPKF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fldu1HwQYtMhhMQMxrXItLsu7S9LRwPQhorR5N7cBOOvFk18QCzTIHKH+h3UCGgcS5YtvKNoGXQlmg9UY3JwuarZzk6SARYUz4rFKfaqR1t/JvB+2nvpHcLb0arfuojQAZtHqmYtCvhXfwm0J/PyAi7PSvQ/28E7PFxSOjS2gJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2bF8S5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2bF8S5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF55CC61049;
	Tue, 27 Aug 2024 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769753;
	bh=XZSi4hKfB/K44fQ6lQpwLbxKGTcIYaYlw2lnLKvPKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2bF8S5HISMsrYbFnYZkNq9E9N2dRZgqm6Z2QoPvrPqEuPYjvr17aB0FHqsJMTsfz
	 45KGyGQp1SIThxO+PmXzOEQrlWhCHgkJeXGNol5t8Oq9+YxcV1Ddkgqcra6W/UaK/n
	 ePvx3kl5g+Yuoanf6iMFs5UVEeI85ZaGP6/lSHnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 026/341] fs/ntfs3: add prefix to bitmap_size() and use BITS_TO_U64()
Date: Tue, 27 Aug 2024 16:34:17 +0200
Message-ID: <20240827143844.403974716@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit 3f5ef5109f6a054ce58b3bec7214ed76c9cc269f upstream.

bitmap_size() is a pretty generic name and one may want to use it for
a generic bitmap API function. At the same time, its logic is
NTFS-specific, as it aligns to the sizeof(u64), not the sizeof(long)
(although it uses ideologically right ALIGN() instead of division).
Add the prefix 'ntfs3_' used for that FS (not just 'ntfs_' to not mix
it with the legacy module) and use generic BITS_TO_U64() while at it.

Suggested-by: Yury Norov <yury.norov@gmail.com> # BITS_TO_U64()
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c  |    4 ++--
 fs/ntfs3/fsntfs.c  |    2 +-
 fs/ntfs3/index.c   |   11 ++++++-----
 fs/ntfs3/ntfs_fs.h |    4 ++--
 fs/ntfs3/super.c   |    2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -654,7 +654,7 @@ int wnd_init(struct wnd_bitmap *wnd, str
 	wnd->total_zeroes = nbits;
 	wnd->extent_max = MINUS_ONE_T;
 	wnd->zone_bit = wnd->zone_end = 0;
-	wnd->nwnd = bytes_to_block(sb, bitmap_size(nbits));
+	wnd->nwnd = bytes_to_block(sb, ntfs3_bitmap_size(nbits));
 	wnd->bits_last = nbits & (wbits - 1);
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
@@ -1347,7 +1347,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 		return -EINVAL;
 
 	/* Align to 8 byte boundary. */
-	new_wnd = bytes_to_block(sb, bitmap_size(new_bits));
+	new_wnd = bytes_to_block(sb, ntfs3_bitmap_size(new_bits));
 	new_last = new_bits & (wbits - 1);
 	if (!new_last)
 		new_last = wbits;
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -522,7 +522,7 @@ static int ntfs_extend_mft(struct ntfs_s
 	ni->mi.dirty = true;
 
 	/* Step 2: Resize $MFT::BITMAP. */
-	new_bitmap_bytes = bitmap_size(new_mft_total);
+	new_bitmap_bytes = ntfs3_bitmap_size(new_mft_total);
 
 	err = attr_set_size(ni, ATTR_BITMAP, NULL, 0, &sbi->mft.bitmap.run,
 			    new_bitmap_bytes, &new_bitmap_bytes, true, NULL);
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1456,8 +1456,8 @@ static int indx_create_allocate(struct n
 
 	alloc->nres.valid_size = alloc->nres.data_size = cpu_to_le64(data_size);
 
-	err = ni_insert_resident(ni, bitmap_size(1), ATTR_BITMAP, in->name,
-				 in->name_len, &bitmap, NULL, NULL);
+	err = ni_insert_resident(ni, ntfs3_bitmap_size(1), ATTR_BITMAP,
+				 in->name, in->name_len, &bitmap, NULL, NULL);
 	if (err)
 		goto out2;
 
@@ -1518,8 +1518,9 @@ static int indx_add_allocate(struct ntfs
 	if (bmp) {
 		/* Increase bitmap. */
 		err = attr_set_size(ni, ATTR_BITMAP, in->name, in->name_len,
-				    &indx->bitmap_run, bitmap_size(bit + 1),
-				    NULL, true, NULL);
+				    &indx->bitmap_run,
+				    ntfs3_bitmap_size(bit + 1), NULL, true,
+				    NULL);
 		if (err)
 			goto out1;
 	}
@@ -2098,7 +2099,7 @@ static int indx_shrink(struct ntfs_index
 	if (in->name == I30_NAME)
 		i_size_write(&ni->vfs_inode, new_data);
 
-	bpb = bitmap_size(bit);
+	bpb = ntfs3_bitmap_size(bit);
 	if (bpb * 8 == nbits)
 		return 0;
 
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -964,9 +964,9 @@ static inline bool run_is_empty(struct r
 }
 
 /* NTFS uses quad aligned bitmaps. */
-static inline size_t bitmap_size(size_t bits)
+static inline size_t ntfs3_bitmap_size(size_t bits)
 {
-	return ALIGN((bits + 7) >> 3, 8);
+	return BITS_TO_U64(bits) * sizeof(u64);
 }
 
 #define _100ns2seconds 10000000
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1341,7 +1341,7 @@ static int ntfs_fill_super(struct super_
 
 	/* Check bitmap boundary. */
 	tt = sbi->used.bitmap.nbits;
-	if (inode->i_size < bitmap_size(tt)) {
+	if (inode->i_size < ntfs3_bitmap_size(tt)) {
 		ntfs_err(sb, "$Bitmap is corrupted.");
 		err = -EINVAL;
 		goto put_inode_out;


