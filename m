Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7023330B30;
	Fri, 17 Oct 2025 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715883; cv=none; b=LmjgN+u4IjOzKFRBNYTa/EayZ5gTGTPXa1Gj3FmTUnfzLZpmr0Jzd4cPggebPtoSthWJqbatiOUiJ9uzaLTTpCm6Gf8Cl+2kEhjXAwk55yr5TIfw6VKsJ+zQhBZq+YhPIdGWps1hh7Z2wHeI0A4ikvRxweYO34j8SInzJKT7HLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715883; c=relaxed/simple;
	bh=Kf3M8WOVHmWNlju8hfxYgOYethboVlaOMFU8Tgy/994=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3YhJ20qRiHqfz6Rv7P3p8u9CpGg3BxcCBbQ803WHiTf19REFikkymhTnJjC6Xv+4Qw8k/+VyOyXkOKSH5Zrm+HvcinQLy9BjFfawrMJNxgQ4+6sBwtat/j5TQwl+NCwTPJy/FAh3MxfkOhRpCG5xmZZL5mmrz03i0mZqn+WMZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gA9Pv3VX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gA9Pv3VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D689C116B1;
	Fri, 17 Oct 2025 15:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715883;
	bh=Kf3M8WOVHmWNlju8hfxYgOYethboVlaOMFU8Tgy/994=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gA9Pv3VXFOlY+kGwIghQ6Jy01D2xEpNf1+Si7r6biqBqC2W9GyVe4P11nUlk3Wz+y
	 VP36Z0hQiLb+s8WmM9QZF5GE/d/cndiyMjC4tA7a2JUu0HaPzkw/OV87Fy+6TITewG
	 hRpbA7Li9B8N7+hXlar9QYle3AcwJN25o+cRCZaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 369/371] iomap: error out on file IO when there is no inline_data buffer
Date: Fri, 17 Oct 2025 16:55:44 +0200
Message-ID: <20251017145215.435208683@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 6a96fb653b6481ec73e9627ade216b299e4de9ea ]

Return IO errors if an ->iomap_begin implementation returns an
IOMAP_INLINE buffer but forgets to set the inline_data pointer.
Filesystems should never do this, but we could help fs developers (me)
fix their bugs by handling this more gracefully than crashing the
kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/175803480324.966383.7414345025943296442.stgit@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 15 ++++++++++-----
 fs/iomap/direct-io.c   |  3 +++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index fd827398afd2f..6fa653d83f703 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -304,6 +304,9 @@ static int iomap_read_inline_data(const struct iomap_iter *iter,
 	size_t size = i_size_read(iter->inode) - iomap->offset;
 	size_t offset = offset_in_folio(folio, iomap->offset);
 
+	if (WARN_ON_ONCE(!iomap->inline_data))
+		return -EIO;
+
 	if (folio_test_uptodate(folio))
 		return 0;
 
@@ -894,7 +897,7 @@ static bool __iomap_write_end(struct inode *inode, loff_t pos, size_t len,
 	return true;
 }
 
-static void iomap_write_end_inline(const struct iomap_iter *iter,
+static bool iomap_write_end_inline(const struct iomap_iter *iter,
 		struct folio *folio, loff_t pos, size_t copied)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -903,12 +906,16 @@ static void iomap_write_end_inline(const struct iomap_iter *iter,
 	WARN_ON_ONCE(!folio_test_uptodate(folio));
 	BUG_ON(!iomap_inline_data_valid(iomap));
 
+	if (WARN_ON_ONCE(!iomap->inline_data))
+		return false;
+
 	flush_dcache_folio(folio);
 	addr = kmap_local_folio(folio, pos);
 	memcpy(iomap_inline_data(iomap, pos), addr, copied);
 	kunmap_local(addr);
 
 	mark_inode_dirty(iter->inode);
+	return true;
 }
 
 /*
@@ -921,10 +928,8 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t pos = iter->pos;
 
-	if (srcmap->type == IOMAP_INLINE) {
-		iomap_write_end_inline(iter, folio, pos, copied);
-		return true;
-	}
+	if (srcmap->type == IOMAP_INLINE)
+		return iomap_write_end_inline(iter, folio, pos, copied);
 
 	if (srcmap->flags & IOMAP_F_BUFFER_HEAD) {
 		size_t bh_written;
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b84f6af2eb4c8..46aa85af13dc5 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -519,6 +519,9 @@ static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
 	loff_t pos = iomi->pos;
 	u64 copied;
 
+	if (WARN_ON_ONCE(!inline_data))
+		return -EIO;
+
 	if (WARN_ON_ONCE(!iomap_inline_data_valid(iomap)))
 		return -EIO;
 
-- 
2.51.0



