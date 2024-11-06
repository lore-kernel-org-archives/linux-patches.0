Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3F1FA247;
	Wed,  6 Nov 2024 12:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897406; cv=none; b=ZqBSPDyQP5Oh9JVCYw4c1/45tDgWddb1B5Cu3ME2IRHL01pXKHtc7adgttrzEdupcU0hnRRvyFZ0xPxrj4qPHJYtTf+3IIVkMx3mAkqEXKkOws38A4f6cvUlOnCA0GMotvq7Tj/PyLIHUN0Zl6tE+Cxi2JvMxl67d6BSkRYhhRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897406; c=relaxed/simple;
	bh=mvlIY7YsBi9RTqvT9VCOqAnZzOaN4w9aOImd4k3lWPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAj1R/MpCcz7b1jur2Nr8Zs+Dp1xy3rguZ0cdLXGuEXvJl6NMneUHch9UGTtJw4/+EzGa+2oCFNP2A/aj7tQxgLD3QZtRLTo3DUGyQFl31oN1uo7106954SzoLi/9OhFkGkuAtqGKq8w8+J5g4skC/9TrWyzHtqTdQz2S3Zpc+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJZveVIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJZveVIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FD0C4CECD;
	Wed,  6 Nov 2024 12:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897405;
	bh=mvlIY7YsBi9RTqvT9VCOqAnZzOaN4w9aOImd4k3lWPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJZveVIi/fmDYCcF4T8lB1GI4PgKCOndnLPQNe1r0KPeRcHR1Fn/Ac5LJLF54WdbH
	 qS41u4/i52BOz0L8LtzdzkUdJGf//5e5s7a3o3YTybkNA8t/7mEhnk0UlwbVDr200x
	 LeLR/aiPVVk9Vt3ACXx/GW4Qs6qBhcSpAQdSApvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/151] iomap: share iomap_unshare_iter predicate code with fsdax
Date: Wed,  6 Nov 2024 13:03:51 +0100
Message-ID: <20241106120310.017944376@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 6ef6a0e821d3dad6bf8a5d5508762dba9042c84b ]

The predicate code that iomap_unshare_iter uses to decide if it's really
needs to unshare a file range mapping should be shared with the fsdax
version, because right now they're opencoded and inconsistent.

Note that we simplify the predicate logic a bit -- we no longer allow
unsharing of inline data mappings, but there aren't any filesystems that
allow shared inline data currently.

This is a fix in the sense that it should have been ported to fsdax.

Fixes: b53fdb215d13 ("iomap: improve shared block detection in iomap_unshare_iter")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/172796813294.1131942.15762084021076932620.stgit@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c               |  3 +--
 fs/iomap/buffered-io.c | 30 ++++++++++++++++--------------
 include/linux/iomap.h  |  1 +
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d48b4fc7a4838..2f7f5e2d167dd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1268,8 +1268,7 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 	s64 ret = 0;
 	void *daddr = NULL, *saddr = NULL;
 
-	/* don't bother with blocks that are not shared to start with */
-	if (!(iomap->flags & IOMAP_F_SHARED))
+	if (!iomap_want_unshare_iter(iter))
 		return length;
 
 	id = dax_read_lock();
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index eb65953895d24..55619cce05422 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1270,19 +1270,12 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
 
-static loff_t iomap_unshare_iter(struct iomap_iter *iter)
+bool iomap_want_unshare_iter(const struct iomap_iter *iter)
 {
-	struct iomap *iomap = &iter->iomap;
-	loff_t pos = iter->pos;
-	loff_t length = iomap_length(iter);
-	loff_t written = 0;
-
-	/* Don't bother with blocks that are not shared to start with. */
-	if (!(iomap->flags & IOMAP_F_SHARED))
-		return length;
-
 	/*
-	 * Don't bother with delalloc reservations, holes or unwritten extents.
+	 * Don't bother with blocks that are not shared to start with; or
+	 * mappings that cannot be shared, such as inline data, delalloc
+	 * reservations, holes or unwritten extents.
 	 *
 	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
 	 * unsharing requires providing a separate source map, and the presence
@@ -1290,9 +1283,18 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 	 * IOMAP_F_SHARED which can be set for any data that goes into the COW
 	 * fork for XFS.
 	 */
-	if (iter->srcmap.type == IOMAP_HOLE ||
-	    iter->srcmap.type == IOMAP_DELALLOC ||
-	    iter->srcmap.type == IOMAP_UNWRITTEN)
+	return (iter->iomap.flags & IOMAP_F_SHARED) &&
+		iter->srcmap.type == IOMAP_MAPPED;
+}
+
+static loff_t iomap_unshare_iter(struct iomap_iter *iter)
+{
+	struct iomap *iomap = &iter->iomap;
+	loff_t pos = iter->pos;
+	loff_t length = iomap_length(iter);
+	loff_t written = 0;
+
+	if (!iomap_want_unshare_iter(iter))
 		return length;
 
 	do {
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 96dd0acbba44a..846cd2f1454c7 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -271,6 +271,7 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
+bool iomap_want_unshare_iter(const struct iomap_iter *iter);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, const struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-- 
2.43.0



