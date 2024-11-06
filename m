Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47EA1DF97A;
	Wed,  6 Nov 2024 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897123; cv=none; b=DJJMn5lnZli84LYea5MlbtLVHdnOMLbRo77s0BVZXhXvwiEgouL0/ogwQ8LWKj0nfqtrCPBkWQHp/K7KSTfJVzSP1WM/GSBvp6L8emvuXEBqrVno2Pb7Xv1XYe2aEuL3N5gsC2eSjo7G5gYf6DJcq5YoFn8v3GDCOYxCdXzWDHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897123; c=relaxed/simple;
	bh=dL1qGhqMkDku8T8q7pT9Mw3rCBaiH7GXsR4rk7InsqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR6BknTwoJJZuq6CRGHvIgzsiEs+Ta5LHz10qzTjSHVLNI0gypxCWRq5184n6u64W+9cVx+tpVmuQUeRuRzORBIGa4Ug/5iXcZ4k7BlLqYw3wPKIbT935tvPQ/rpjQWsxaj4muQ8PPYKLZa7pxr13ne8bok1g2ydpVY5c1FWsV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLIoiMhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLIoiMhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C348C4CECD;
	Wed,  6 Nov 2024 12:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897123;
	bh=dL1qGhqMkDku8T8q7pT9Mw3rCBaiH7GXsR4rk7InsqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLIoiMhcpuSBQ/SVB4W2XSq4lkjpTmiyZQV5IgEzoB5mgLaCDlX0a88wWjgnBrbGf
	 lU0vOnUnyY0dPpkPDGOIFavWCR+LCu4ns7WjqnA9AUdUCIpc9agqwVjOnEcnwRXHyv
	 SU7u33FWRneWRnLLXVDKXd2QaXP3jIV7sewRiLnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/126] iomap: convert iomap_unshare_iter to use large folios
Date: Wed,  6 Nov 2024 13:03:59 +0100
Message-ID: <20241106120307.141018181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit a5f31a5028d1e88e97c3b6cdc3e3bf2da085e232 ]

Convert iomap_unshare_iter to create large folios if possible, since the
write and zeroing paths already do that.  I think this got missed in the
conversion of the write paths that landed in 6.6-rc1.

Cc: ritesh.list@gmail.com, willy@infradead.org
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 1833608f39318..674ac79bdb456 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1090,7 +1090,6 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
-	long status = 0;
 	loff_t written = 0;
 
 	/* don't bother with blocks that are not shared to start with */
@@ -1101,28 +1100,33 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		return length;
 
 	do {
-		unsigned long offset = offset_in_page(pos);
-		unsigned long bytes = min_t(loff_t, PAGE_SIZE - offset, length);
 		struct folio *folio;
+		int status;
+		size_t offset;
+		size_t bytes = min_t(u64, SIZE_MAX, length);
 
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			return status;
-		if (iter->iomap.flags & IOMAP_F_STALE)
+		if (iomap->flags & IOMAP_F_STALE)
 			break;
 
-		status = iomap_write_end(iter, pos, bytes, bytes, folio);
-		if (WARN_ON_ONCE(status == 0))
+		offset = offset_in_folio(folio, pos);
+		if (bytes > folio_size(folio) - offset)
+			bytes = folio_size(folio) - offset;
+
+		bytes = iomap_write_end(iter, pos, bytes, bytes, folio);
+		if (WARN_ON_ONCE(bytes == 0))
 			return -EIO;
 
 		cond_resched();
 
-		pos += status;
-		written += status;
-		length -= status;
+		pos += bytes;
+		written += bytes;
+		length -= bytes;
 
 		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
-	} while (length);
+	} while (length > 0);
 
 	return written;
 }
-- 
2.43.0



