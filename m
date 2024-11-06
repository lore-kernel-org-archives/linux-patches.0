Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70771D2784;
	Wed,  6 Nov 2024 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896018; cv=none; b=FyfIwAVj/AY+8kLkVPQCahxAYzLj6+MhblG7c2tj9Krs6GkgaVGP8Oivq/YL6A72Xo4S6DtV5ce01UNmYrcraOfupEfyp6iCZ40stcTlgDdQEaWqfFaHGubiBPV6nYf4JNQOWt1jVLNLRxbDiO44z5nC+eQpOJ/YtnndZwHrtKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896018; c=relaxed/simple;
	bh=LWwQelKiI9aoiu4s10FQx4GsPyWakaQZfITOtYQwwh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDG+jvdNJwcJOwZHdIMFrFrZt1P6FGWnFs9Bj3O1eRta2pJo2hx+OJ205N6wT1qpIelirHWVdTknhzK/2WqkF+Fidb+cFC5a8GFXzJVz6xOb7Hn7dWXGBBC7r9dZms7YBquYfrER9qpTgxKZDo6XJ+IuA3E/qSwF8UZaJy2mNaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiKwtoy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiKwtoy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBCAC4CECD;
	Wed,  6 Nov 2024 12:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896018;
	bh=LWwQelKiI9aoiu4s10FQx4GsPyWakaQZfITOtYQwwh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiKwtoy4J5iY8zR4n5OZnSEMwI/ML0jkiFTziBZpzfT3qdU4dnZ0Wl9X9kHQJiPUC
	 AHCrM+YJ/dlX7xBoqvAdyC1/gObT1+PcTH0YH0AXgrSo4yvpF1/7QQlMLXtHzXSmpM
	 bq94tQjrehwk1y2ZRW5gE/s76FtRhIgBTjP0N1R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 062/245] iomap: turn iomap_want_unshare_iter into an inline function
Date: Wed,  6 Nov 2024 13:01:55 +0100
Message-ID: <20241106120320.732848528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6db388585e486c0261aeef55f8bc63a9b45756c0 ]

iomap_want_unshare_iter currently sits in fs/iomap/buffered-io.c, which
depends on CONFIG_BLOCK.  It is also in used in fs/dax.c whіch has no
such dependency.  Given that it is a trivial check turn it into an inline
in include/linux/iomap.h to fix the DAX && !BLOCK build.

Fixes: 6ef6a0e821d3 ("iomap: share iomap_unshare_iter predicate code with fsdax")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241015041350.118403-1-hch@lst.de
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 17 -----------------
 include/linux/iomap.h  | 20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index db8061b1a0821..c8e984be39823 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1334,23 +1334,6 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
 
-bool iomap_want_unshare_iter(const struct iomap_iter *iter)
-{
-	/*
-	 * Don't bother with blocks that are not shared to start with; or
-	 * mappings that cannot be shared, such as inline data, delalloc
-	 * reservations, holes or unwritten extents.
-	 *
-	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
-	 * unsharing requires providing a separate source map, and the presence
-	 * of one is a good indicator that unsharing is needed, unlike
-	 * IOMAP_F_SHARED which can be set for any data that goes into the COW
-	 * fork for XFS.
-	 */
-	return (iter->iomap.flags & IOMAP_F_SHARED) &&
-		iter->srcmap.type == IOMAP_MAPPED;
-}
-
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 634f5746ae7bb..034399030609e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -256,6 +256,25 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 	return &i->iomap;
 }
 
+/*
+ * Check if the range needs to be unshared for a FALLOC_FL_UNSHARE_RANGE
+ * operation.
+ *
+ * Don't bother with blocks that are not shared to start with; or mappings that
+ * cannot be shared, such as inline data, delalloc reservations, holes or
+ * unwritten extents.
+ *
+ * Note that we use srcmap directly instead of iomap_iter_srcmap as unsharing
+ * requires providing a separate source map, and the presence of one is a good
+ * indicator that unsharing is needed, unlike IOMAP_F_SHARED which can be set
+ * for any data that goes into the COW fork for XFS.
+ */
+static inline bool iomap_want_unshare_iter(const struct iomap_iter *iter)
+{
+	return (iter->iomap.flags & IOMAP_F_SHARED) &&
+		iter->srcmap.type == IOMAP_MAPPED;
+}
+
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
 int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
@@ -271,7 +290,6 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
-bool iomap_want_unshare_iter(const struct iomap_iter *iter);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, const struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-- 
2.43.0



