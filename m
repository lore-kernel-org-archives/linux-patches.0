Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7F237757A;
	Sat, 12 Sep 2026 09:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204455; cv=none; b=WBpJKFJiJaOuNtY05NZAXd+9knwPwvGE8eTqr3d96HC1eMpZOMYkEHf27N23r72rQ6gpnDEPl59pXTRT1OGMeKBE3+Gy3YCqKbmpG357OdGAlE/IpBnAOpKhQdo3rI3SMpXhqECam7Wq//2tccDLPi0P2gSat7Ru99pCxYYwpj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204455; c=relaxed/simple;
	bh=DcwO0gNPuLw4gGFNW0QMA9X2fV0CCmYj4kKZVxnHMy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHfiDa5H/NToCjKkDqZatdU+coRNrjeV4dms4sXClF3bpcLTF+mR8iJw9PreINRpuZoW5FHmyEO9b/MsZRUpMKsRCP3dt03yVXzo1oJxZXOo0JJjByw/MPi8uBzyYTu6txhZv4eWKtNtqsdZhKr/meBLLsdMtq1QWD+H3rl3rjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVJZYXxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVJZYXxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD07F1F000FF;
	Sat, 12 Sep 2026 09:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204453;
	bh=G8fPqSRBzb1eMiQOAtlVZRonk97oEM0GhZ6noSMaIOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVJZYXxg5GsLsVT1eupxN2a2roY5ldDYOYq0PkDd5OaBynO4cgVhG0TsvLVrbj91u
	 8CtymWmMQyoE9FaMQUrqccndmioXXy0gk+bpTb4NWh1UYIc45aEPOXtoaAxv09PYR4
	 Fil0RepzbrLlf45PJKsfq7xN9U17bx/5EgVPZ0PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyeontae Lee <wonju345@naver.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1617/1815] ntfs: serialize resident iomap reads with mrec_lock
Date: Sat, 12 Sep 2026 08:56:07 +0200
Message-ID: <20260912065726.951084150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyeontae Lee <wonju345@naver.com>

[ Upstream commit d9e00c457d4ab8ab59c6e4b8554c921260e4e16c ]

ntfs_read_iomap_begin_resident() walks the MFT record through
ntfs_attr_lookup() -> ntfs_attr_find() without taking ni->mrec_lock,
while ntfs_attr_record_resize(), ntfs_make_room_for_attr() and
ntfs_resident_attr_record_add() memmove() the same base_ni->mrec buffer
under that lock. map_mft_record() only takes a reference and does not
serialize, so the reader can observe torn attribute length and offset
fields while a writer is relocating the records.

KCSAN reports the race between the mmap read fault path and both link()
and unlink():

  BUG: KCSAN: data-race in ntfs_attr_find / ntfs_attr_record_resize

  write to 0xffff888100af1018 of 4 bytes by task 96 on cpu 1:
   ntfs_attr_record_resize+0xd2/0x130
   ntfs_attr_record_rm+0xad/0x530
   ntfs_delete+0x224/0x640
   ntfs_unlink+0x14d/0x280
   vfs_unlink+0x157/0x520

  read to 0xffff888100af1018 of 4 bytes by task 95 on cpu 0:
   ntfs_attr_find+0x104/0x5b0
   ntfs_attr_lookup+0x39c/0x10c0
   ntfs_read_iomap_begin_resident+0xc6/0x230
   ntfs_read_iomap_begin+0x5d/0xa0
   iomap_iter+0x2e2/0x6e0
   iomap_read_folio+0x147/0x2a0
   ntfs_read_folio+0x108/0x170
   filemap_read_folio+0x35/0x100
   filemap_fault+0x993/0x1000

  value changed: 0x00000250 -> 0x000001f0

The address is mrec + 0x18, i.e. mft_record.bytes_in_use, and the change
is the 96 bytes of one $FILE_NAME attribute being removed.

Keep base_ni->mrec_lock from the resident read iomap lookup through
iomap_end(). This protects both the attribute walk and the subsequent copy
from iomap->inline_data, which points into the MFT record. The non-resident
path is left alone: ntfs_lookup() already holds the directory inode's
mrec_lock when it reads an index folio through read_mapping_folio(), and
taking the lock in the shared wrapper deadlocks there with recursive locking
on mrec_lock. The comment above the read_mapping_folio() call in
fs/ntfs/dir.c notes the same hazard.

The seek path uses the same lookup helper but does not dereference
iomap->inline_data. Release the lock before returning from that path,
whereas the regular read path records base_ni in iomap->private and releases
the lock from its iomap_end() callback.

Tested with a reproducer that faults in a 16-byte resident file while
another thread runs link()/unlink() on it. Before: 40 KCSAN reports in
about one second. After: no reports in 180 seconds over 206,090 read
iterations and 423,540 link/unlink cycles. A PROVE_LOCKING build shows no
lockdep splat with the same reproducer running for 60 seconds.

Fixes: b041ca562526 ("ntfs: update iomap and address space operations")
Link: https://lore.kernel.org/all/20260725042421.109599-1-wonju345@naver.com/
Signed-off-by: Hyeontae Lee <wonju345@naver.com>
Co-developed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/iomap.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs/iomap.c b/fs/ntfs/iomap.c
index d0964ac840d9f..e6c2515014c35 100644
--- a/fs/ntfs/iomap.c
+++ b/fs/ntfs/iomap.c
@@ -81,7 +81,7 @@ const struct iomap_write_ops ntfs_iomap_folio_ops = {
 };
 
 static int ntfs_read_iomap_begin_resident(struct inode *inode, loff_t offset, loff_t length,
-		unsigned int flags, struct iomap *iomap)
+		unsigned int flags, struct iomap *iomap, bool keep_mrec_lock)
 {
 	struct ntfs_inode *base_ni, *ni = NTFS_I(inode);
 	struct ntfs_attr_search_ctx *ctx;
@@ -95,6 +95,8 @@ static int ntfs_read_iomap_begin_resident(struct inode *inode, loff_t offset, lo
 	else
 		base_ni = ni;
 
+	mutex_lock(&base_ni->mrec_lock);
+
 	ctx = ntfs_attr_get_search_ctx(base_ni, NULL);
 	if (!ctx) {
 		err = -ENOMEM;
@@ -138,6 +140,13 @@ static int ntfs_read_iomap_begin_resident(struct inode *inode, loff_t offset, lo
 	if (ctx)
 		ntfs_attr_put_search_ctx(ctx);
 
+	if (!err && keep_mrec_lock && iomap->type == IOMAP_INLINE) {
+		iomap->private = base_ni;
+		return 0;
+	}
+
+	mutex_unlock(&base_ni->mrec_lock);
+
 	return err;
 }
 
@@ -261,23 +270,34 @@ static int ntfs_read_iomap_begin_non_resident(struct inode *inode, loff_t offset
 
 static int __ntfs_read_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap,
-		bool need_unwritten)
+		bool need_unwritten, bool keep_mrec_lock)
 {
 	if (NInoNonResident(NTFS_I(inode)))
 		return ntfs_read_iomap_begin_non_resident(inode, offset, length,
 				flags, iomap, need_unwritten);
 	return ntfs_read_iomap_begin_resident(inode, offset, length,
-					     flags, iomap);
+					     flags, iomap, keep_mrec_lock);
 }
 
 static int ntfs_read_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
 	return __ntfs_read_iomap_begin(inode, offset, length, flags, iomap,
-			srcmap, true);
+			srcmap, true, true);
+}
+
+static int ntfs_read_iomap_end(struct inode *inode, loff_t pos, loff_t length,
+		ssize_t written, unsigned int flags, struct iomap *iomap)
+{
+	struct ntfs_inode *base_ni = iomap->private;
+
+	if (base_ni)
+		mutex_unlock(&base_ni->mrec_lock);
+	return written;
 }
 
-static DEFINE_IOMAP_ITER_NEXT(ntfs_read_iomap_next, ntfs_read_iomap_begin);
+static DEFINE_IOMAP_ITER_NEXT_END(ntfs_read_iomap_next,
+		ntfs_read_iomap_begin, ntfs_read_iomap_end);
 
 const struct iomap_ops ntfs_read_iomap_ops = {
 	.iomap_next = ntfs_read_iomap_next,
@@ -320,7 +340,7 @@ static int ntfs_seek_iomap_begin(struct inode *inode, loff_t offset, loff_t leng
 		unsigned int flags, struct iomap *iomap, struct iomap *srcmap)
 {
 	return __ntfs_read_iomap_begin(inode, offset, length, flags, iomap,
-			srcmap, false);
+			srcmap, false, false);
 }
 
 static int ntfs_zero_read_iomap_end(struct inode *inode, loff_t pos, loff_t length,
-- 
2.53.0



