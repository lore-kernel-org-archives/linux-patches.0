Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065187;
	b=MmJ43qWHIoaBea2bKfoAWSsPOUpYLEkAov3EDHb5znFk2BhtcJKog2rqjaLc/IX/6BZL
	 1jL5VCqfjiLkoP9v1bo5Z3qqA64WpWHwZkaTUMajIwFRDcGVnO69IWdd0A/c/hUwnMACS
	 DCKjx8yfL0VFZQYf1X0YMxiLNx0qFvAS1pWJf8IPmGQMugmRi35zKoULc4L7J69Hd6bGA
	 LBv7GqAKxMfdtjM4++I61dR5poPilac9BSnQOpsY9jDb3anF2zNMGmkn1OV+8JRxuJgE3
	 Q+3vLq3pqafRDTmEm2+PP+o4iCCyjUUAcxmV21hhxcpvhb+tdIYoNk9TEiJQ8/B9pWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/5wNocl6IE6fyS+A0Ga4ErfkjWuuCXFv4eSqK4ue7QU=;
	b=Vr/fee7pFIiQDc8te6ZlOWqbEgaMBIzCt2IY/9MOzdgWZXAhhMQLLNZOskDrxtjJeNKd
	 jDCxNxclGEJ4Mojh+DKUbLIB3tJKF8gSB6VWK8UyDAMTx4Pr4PbptUpvRNdpBZkDWns10
	 N2mICzElwkzt94HSIU/7WF9wnz9D/4UmfjNcBw9XGSfK/ApuFK2r9SKfkOb3QL4RCBFdC
	 2L5Enc709p1oQigpIr9+jnBI3B0W3xADwWTYsdkaFMMo3bQNYn9721BTOZO9qRf+T5XHz
	 sDWtMAv0Zkgguy7widPhWfAQbhnaggDTuO647w5LUVOGPRUHsjUO1tSRzk6pjjlfm+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gRtS/uyV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA53606A335;
	Sat,  7 Nov 2026 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRtS/uyV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4971F0089F;
	Sat,  7 Nov 2026 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065186;
	bh=/5wNocl6IE6fyS+A0Ga4ErfkjWuuCXFv4eSqK4ue7QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRtS/uyVQruL+/hU6ZNez1n6lLC9+Y+CRyAME3OPsB7ANp6ND6C4uxNx004OO90XL
	 isOI5I+nKd6SnHVAM/hsQ0pf+8NaYCS+3iqqompZtpXBdu9zT8mGinIWl5j0W2lebk
	 fsGcXOQ9HDn+D/X6agrTrAcMrjXgrOfqAF2R+1LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0990/1257] exfat: mark straddling folio RO and zero the post-EOF range
Date: Sat,  7 Nov 2026 08:54:46 -0500
Message-ID: <20261107135006.709014705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 1043264c3cfa43b0668f7472a749868c1e21749b ]

When extending a file across a non-page-aligned EOF, the folio
containing the old EOF must be marked RO so that subsequent mmap
writes trigger ->page_mkwrite() and update valid_size.

The straddling folio remains mapped to the same filesystem block
after the file is extended. As a result, the existing writable PTE
may remain in place, allowing mmap writes to bypass ->page_mkwrite()
and leave valid_size unchanged.

Furthermore, writes to the post-EOF range may occur between
truncate_pagecache() and locking the folio. So the post-EOF range
should be zeroed after marking the straddling folio RO, and using
truncate_pagecache() to zero out the post-EOF range is redundant.

Introduce exfat_pagecache_isize_extended() to mark the straddling
folio RO and zero the post-EOF range after clearing writable mapping.
This ensures that data written beyond the old EOF before the extension
is not exposed as valid file data, and that subsequent mmap writes
trigger ->page_mkwrite() to update valid_size.

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Cc: stable@vger.kernel.org
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 72 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 9 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index d24f0650bfc88..f106db945d8dd 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -17,11 +17,70 @@
 #include <linux/fileattr.h>
 #include <linux/iomap.h>
 #include <linux/pagemap.h>
+#include <linux/rmap.h>
 
 #include "exfat_raw.h"
 #include "exfat_fs.h"
 #include "iomap.h"
 
+/*
+ * Unlike pagecache_isize_extended(), this function updates i_size while
+ * holding the straddling folio lock, and does not skip the straddling
+ * folio when the filesystem block size is >= PAGE_SIZE or when 'from'
+ * and 'to' fall within the same filesystem block.
+ *
+ * This ensures that the folio is marked RO and the post-EOF range is
+ * zeroed before readers or writeback can observe the updated i_size.
+ */
+static void exfat_pagecache_isize_extended(struct inode *inode, loff_t from,
+					   loff_t to)
+{
+	struct folio *folio;
+
+	if (!(from & (PAGE_SIZE - 1))) {
+		i_size_write(inode, to);
+		return;
+	}
+
+	folio = filemap_lock_folio(inode->i_mapping, from >> PAGE_SHIFT);
+
+	/* Folio not cached? Nothing to do */
+	if (IS_ERR(folio)) {
+		i_size_write(inode, to);
+		return;
+	}
+
+	/*
+	 * See folio_clear_dirty_for_io() for details why folio_mark_dirty()
+	 * is needed.
+	 */
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+
+	/*
+	 * Zero the post-EOF range before publishing the new size. Writeback
+	 * normally does this, but the extension would expose the tail to
+	 * readers before writeback gets a chance to zero it.
+	 */
+	if (folio_test_dirty(folio)) {
+		loff_t offset, end;
+
+		offset = from - folio_pos(folio);
+		end = min_t(loff_t, to - folio_pos(folio),
+			    folio_size(folio));
+		folio_zero_segment(folio, offset, end);
+	}
+
+	/*
+	 * Publish the new size after zeroing the tail. Uptodate folios can
+	 * be read without taking the folio lock.
+	 */
+	i_size_write(inode, to);
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 static int exfat_cont_expand(struct inode *inode, loff_t size)
 {
 	int ret;
@@ -32,8 +91,6 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 	struct exfat_chain clu;
 	loff_t oldsize = i_size_read(inode);
 
-	truncate_pagecache(inode, oldsize);
-
 	ret = inode_newsize_ok(inode, size);
 	if (ret)
 		return ret;
@@ -81,15 +138,12 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 
 out:
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
-	/* Expanded range not zeroed, do not update valid_size */
-	i_size_write(inode, size);
 	/*
-	 * When extending file size, call truncate_pagecache() first,
-	 * then update i_size, and call pagecache_isize_extended()
-	 * to ensures the straddling folio is properly marked RO so
-	 * page_mkwrite() is called and post-EOF area is zeroed.
+	 * When extending file size, call exfat_pagecache_isize_extended()
+	 * to update i_size and ensure the straddling folio is properly
+	 * marked RO so page_mkwrite() is called and post-EOF area is zeroed.
 	 */
-	pagecache_isize_extended(inode, oldsize, inode->i_size);
+	exfat_pagecache_isize_extended(inode, oldsize, size);
 
 	inode->i_blocks = round_up(size, sbi->cluster_size) >> 9;
 	mark_inode_dirty(inode);
-- 
2.53.0



