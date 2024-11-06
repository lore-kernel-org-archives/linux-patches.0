Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD681CC89D;
	Wed,  6 Nov 2024 12:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897126; cv=none; b=KR+RXR0Jdjk2dGyUO5Ikp7mWFVhJfA2Y9g9dqsQSYvvvMhTnx6GeDlDe0kyoid4eKyTyW57ENWHwZ0iBiAzBH8B00AvOs4kpDiZ95CfazYWZhay8G43Xo7D5AfEdevUzbwVxdjBTKYLqnu46W8CIc/F0h1Pzj89/8naGMdMUIYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897126; c=relaxed/simple;
	bh=iJ6Chp4fxyYs7027X7XOVv+Fe28z8jE+Yfxmd5I8ZRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkB61nqZQ4wkcEQ+yL2XqfyQa++87n5PbXokxRZZbbRrXg+fCDpkshAcGGYWs5PnZy2TrtySbrLIYKkCj/k9d53g4RfzuKw0bj/iqOATZMo/+9DuoBCutUwnjJ6/C1y/phVCVk3y4618Qb+6lvaUf1cSEba3R/oNGXxQ6yw6UVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTxeVPpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTxeVPpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE91C4CECD;
	Wed,  6 Nov 2024 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897126;
	bh=iJ6Chp4fxyYs7027X7XOVv+Fe28z8jE+Yfxmd5I8ZRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTxeVPpnehldM7Sj+nDauYRKY1LDpWp/7gRj5TkYO7kJ3qz57bDV2oC7O/XNZMU7T
	 E4dw0m+DMXiHJRfifHGSVyBCVh7p27GHPGRpFyIVZ0VslHwjWEqeGtPbf1fEClQ0QK
	 AFQSOio2jnmnsjiiStTmVjm77ozKBQWajADTQGYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/126] iomap: improve shared block detection in iomap_unshare_iter
Date: Wed,  6 Nov 2024 13:04:00 +0100
Message-ID: <20241106120307.167601869@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit b53fdb215d13f8e9c29541434bf2d14dac8bcbdc ]

Currently iomap_unshare_iter relies on the IOMAP_F_SHARED flag to detect
blocks to unshare.  This is reasonable, but IOMAP_F_SHARED is also useful
for the file system to do internal book keeping for out of place writes.
XFS used to that, until it got removed in commit 72a048c1056a
("xfs: only set IOMAP_F_SHARED when providing a srcmap to a write")
because unshare for incorrectly unshare such blocks.

Add an extra safeguard by checking the explicitly provided srcmap instead
of the fallback to the iomap for valid data, as that catches the case
where we'd just copy from the same place we'd write to easily, allowing
to reinstate setting IOMAP_F_SHARED for all XFS writes that go to the
COW fork.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240910043949.3481298-3-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 674ac79bdb456..527d3bcfc69a7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1087,16 +1087,25 @@ EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
-	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
 	loff_t written = 0;
 
-	/* don't bother with blocks that are not shared to start with */
+	/* Don't bother with blocks that are not shared to start with. */
 	if (!(iomap->flags & IOMAP_F_SHARED))
 		return length;
-	/* don't bother with holes or unwritten extents */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
+
+	/*
+	 * Don't bother with holes or unwritten extents.
+	 *
+	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
+	 * unsharing requires providing a separate source map, and the presence
+	 * of one is a good indicator that unsharing is needed, unlike
+	 * IOMAP_F_SHARED which can be set for any data that goes into the COW
+	 * fork for XFS.
+	 */
+	if (iter->srcmap.type == IOMAP_HOLE ||
+	    iter->srcmap.type == IOMAP_UNWRITTEN)
 		return length;
 
 	do {
-- 
2.43.0



