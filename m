Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1452C3A641D;
	Thu, 30 Jul 2026 14:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423098; cv=none; b=dP7o0d6TTgkm3LVP/sqeE1LldPIpnpkHc39B+z/Zbnn9cX5XnK0jxRkSb/g+42e+2W5Mr9CdXd8JtTd11TUGBuZjmEN418EsoQI1uXN3Kcgo50qkrpFU8DcWxIU0IQlJ9IYqXR57C+XeRbBb1JqNJ+oUgy8beVIe0fc8DEYtho8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423098; c=relaxed/simple;
	bh=I3GXY9D2MOSSMTsnP62JQmBpDD4M02FpC4JYdCVc+Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0KS6VAsg1qcuTPQXNGj2r8EPoVwj77MtDnPn30uem2zYYxDzW8QuRSwq6fbxqYAAclaqB+z+qN8TTo85OrycVI3KlkZcTrXdtYOQKG1dT4R7rZy1D19vhxQVILyzQl83kye1jbZ0kSdK4Q903kolF6u99vc2UDv+Kzge+NTpkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uLEBQNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uLEBQNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316871F000E9;
	Thu, 30 Jul 2026 14:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423096;
	bh=GZ7OjkMWe5Z8Y2jNvKK6edLMAV2HTjnrwyNbvwZUnos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uLEBQNeG50rSBM7SIA5fTo2VHXiodn0Vwc0Te9ysxfnbvtAif4T7kxKHTfTyq0z3
	 j5dqEqBcAlMPz1k/weQJYnCIZpnotO+Pv7UGVR4cPSGSBOnEQ1+U5HwS1zqobpY0Bs
	 Oxb+CQIaCLr2SXo9IvttcdYgoIExHyKZjJsqz6WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.1 648/744] iomap: fix out-of-bounds bitmap_set() with zero-length range
Date: Thu, 30 Jul 2026 16:15:21 +0200
Message-ID: <20260730141458.043223352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 9c7d8f7c8994c790fca501dc45ce66e7356cbe05 upstream.

ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
unsigned subtraction underflows to SIZE_MAX, producing a huge
last_blk and nr_blks value that causes bitmap_set() to write far
beyond the ifs->state allocation.

Regarding ifs_set_range_uptodate(), it is temporarily safe because len
cannot be passed in as 0. However, for ifs_set_range_dirty() this is
reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
returns 0 (e.g. user buffer fault) and the folio is already uptodate,
the guard at the top of __iomap_write_end() does not trigger because
!folio_test_uptodate() is false, and iomap_set_range_dirty() is called
with copied == 0.

Add a !len guard to both functions before the computation, so that a
zero-length range is a no-op.

Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
Cc: stable@vger.kernel.org # v6.6
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260714082325.325163-5-yi.zhang@huaweicloud.com
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -67,11 +67,13 @@ static bool ifs_set_range_uptodate(struc
 		struct iomap_folio_state *ifs, size_t off, size_t len)
 {
 	struct inode *inode = folio->mapping->host;
-	unsigned int first_blk = off >> inode->i_blkbits;
-	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
-	unsigned int nr_blks = last_blk - first_blk + 1;
+	unsigned int first_blk, last_blk;
 
-	bitmap_set(ifs->state, first_blk, nr_blks);
+	if (len) {
+		first_blk = off >> inode->i_blkbits;
+		last_blk = (off + len - 1) >> inode->i_blkbits;
+		bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
+	}
 	return ifs_is_fully_uptodate(folio, ifs);
 }
 
@@ -203,13 +205,17 @@ static void ifs_set_range_dirty(struct f
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
-	unsigned int first_blk = (off >> inode->i_blkbits);
-	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
-	unsigned int nr_blks = last_blk - first_blk + 1;
+	unsigned int first_blk, last_blk;
 	unsigned long flags;
 
+	if (!len)
+		return;
+
+	first_blk = off >> inode->i_blkbits;
+	last_blk = (off + len - 1) >> inode->i_blkbits;
 	spin_lock_irqsave(&ifs->state_lock, flags);
-	bitmap_set(ifs->state, first_blk + blks_per_folio, nr_blks);
+	bitmap_set(ifs->state, first_blk + blks_per_folio,
+		   last_blk - first_blk + 1);
 	spin_unlock_irqrestore(&ifs->state_lock, flags);
 }
 


