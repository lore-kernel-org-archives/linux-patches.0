Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021203;
	b=KDtoYMHA0cMUebBKdjGW9ymd1xnesTb0JGBkq8PHYLdBewaLtiwTinOZhBCuCOnfINXh
	 ZTMpzvnSTkmgcq2KtFAoKa6QOUW6NPeWDTLIVuWsIESS8k+B+tRquOU+Ivlo65LubG+ul
	 NX1HLZD70zjb1Gb5QcwqqX5xUXo8rpPnY7IC4pdzEztGh9Y1AQvK3vEtE1BD9UzCXYHtY
	 J++7gjmAA0RUv1K0S2p6hy//EdXXz/jY/6ePPxIdvDnWvlW0SuxslOV+ipzaw3LWorq3L
	 xq+GBiZAVhFngcL+c6SsPBOkLnHje/iUL2Pg0w0/IHpTObgMcz58/9cqyue3+PraZSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VwsYJ9qto6ISf3vXtjosSrMH2JjQkTWW8u1W8BQO6zA=;
	b=x9CiQZLye9dVYGbXa79ajnDGeFDpzsuF6+rCuYMwAuM3XSX2RgCx8Y5++PoR4D4NDw3E
	 svDmHllQyJzxuG3AVnBl2gqfe1HjGC9FUnnqBV+yVNOP+3bhbQ1AFqnqgqqB22rlKBScm
	 CLHhIWuipXvibAuqWSXyjLEp88sC9ZyqzLksq1QcjrsOXiB6sgx7xdZOK52yS/thR+tgs
	 h0xFw1I0MJq96CWrW1/tmFgp0CeVN7LMrmL2+nu7hKP8e/cHBs1qYLchO6eIoWmcNUonr
	 qUsMOFg9ZWaX+ZCSXQcEtpchJBT6XrrnbQSatMId07o5l5migeVl8wKCvppOM/Ta73Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyYMPvZR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C80606A333;
	Wed, 18 Nov 2026 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyYMPvZR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320411F000C8;
	Wed, 18 Nov 2026 17:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021203;
	bh=VwsYJ9qto6ISf3vXtjosSrMH2JjQkTWW8u1W8BQO6zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyYMPvZRiErl2g6zqaOZcC2L70G9SKcs1jOKQMarWVEHUFIB9YXY32wqLsDsa2v/n
	 7ZwTFnzuVNs62BYjJFY21siSl3RiiETQW5HQJIYqknYJgMnsZpgWgj31nby56M1sai
	 Uns5RxxF9fr2w/Q1BI+lKhpaKAHa85VB+WGqXt50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2222/2651] ntfs: clear stale pagecache on initialized-size extension
Date: Wed, 18 Nov 2026 15:57:42 +0100
Message-ID: <20261118150405.572567931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 58442927b729acbe2b7c7f7ad888d040c44faa3e ]

iomap_zero_range() skips holes, so EOF-polluted cache data can survive
gap zeroing. Discard the uninitialized cache range before advancing
initialized_size so later reads cannot expose stale bytes.

Perform the cleanup in ntfs_extend_initialized_size() so both file writes
and shared writable mmap preparation use it. Hold the invalidate lock
while reading initialized_size, clearing the cache, zeroing the gap, and
updating the attribute. Release the lock on every exit path.

Fixes: af0db57d4293 ("ntfs: update inode operations")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 3acb20c9bd226..64c415edc398c 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -8,6 +8,7 @@
 
 #include <linux/writeback.h>
 #include <linux/seq_file.h>
+#include <linux/mm.h>
 
 #include "lcnalloc.h"
 #include "time.h"
@@ -2484,38 +2485,50 @@ int ntfs_extend_initialized_size(struct inode *vi, const loff_t offset,
 				 const loff_t new_size)
 {
 	struct ntfs_inode *ni = NTFS_I(vi);
-	loff_t old_init_size;
+	loff_t old_init_size, clear_size;
 	unsigned long flags;
-	int err;
+	int err = 0;
+
+	if (!NInoNonResident(ni))
+		return -EINVAL;
 
+	filemap_invalidate_lock(vi->i_mapping);
 	read_lock_irqsave(&ni->size_lock, flags);
 	old_init_size = ni->initialized_size;
 	read_unlock_irqrestore(&ni->size_lock, flags);
 
-	if (!NInoNonResident(ni))
-		return -EINVAL;
 	if (old_init_size >= new_size)
-		return 0;
+		goto out;
 
 	err = ntfs_attr_map_whole_runlist(ni);
 	if (err)
-		return err;
+		goto out;
 
-	if (!NInoCompressed(ni) && old_init_size < offset) {
-		err = iomap_zero_range(vi, old_init_size,
-				       offset - old_init_size,
-				       NULL, &ntfs_seek_iomap_ops,
-				       &ntfs_iomap_folio_ops, NULL);
-		if (err)
-			return err;
+	if (!NInoCompressed(ni)) {
+		/*
+		 * Zeroing skips holes, so discard cached uninitialized bytes
+		 * before making them visible to writes or shared mappings.
+		 */
+		clear_size = max_t(loff_t, i_size_read(vi), new_size);
+		truncate_pagecache_range(vi, old_init_size, clear_size - 1);
+
+		if (old_init_size < offset) {
+			err = iomap_zero_range(vi, old_init_size,
+					       offset - old_init_size,
+					       NULL, &ntfs_seek_iomap_ops,
+					       &ntfs_iomap_folio_ops, NULL);
+			if (err)
+				goto out;
+		}
 	}
 
-
 	mutex_lock(&ni->mrec_lock);
 	err = ntfs_attr_set_initialized_size(ni, new_size);
 	mutex_unlock(&ni->mrec_lock);
 	if (err)
 		truncate_setsize(vi, old_init_size);
+out:
+	filemap_invalidate_unlock(vi->i_mapping);
 	return err;
 }
 
-- 
2.53.0



