Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972001F426A;
	Wed,  6 Nov 2024 12:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897512; cv=none; b=Xdfm/ncVpKdHKkJpkgZjF0L6/A3TsyzwMVVieFr42WfmFXZWtAfFBsDw0e1MU1TvwtThssKPRZ8PIWdmpld2oaliKy4C8Rn4k8MkIxzvkrPQnoPSKvBChm+dUtbYKVtwlSMVsXfeSxiaWKLRsK05YHE5DfJA4jfiSiD2UnsBiT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897512; c=relaxed/simple;
	bh=GrfMnHdWVkSn60rWybw59t0kBKu6Bp63wnPQtMuaNo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWDHcLzbDYoEn1WKYZmJJqAr7T9NM87MvL6c6iiqG40xubBy0CmZlZ+UuTtnFQLiWVkG1O1zi85KM7R554ih55UBWP1FUXHfEU0Fm8UIuUCSgkx9GF9MdbHQiTbGy/MdnW/uqEBwoVwkyd6f/dV/+cAiKwdbNa80c4WIkteFGts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smHHwrS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smHHwrS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E821C4CECD;
	Wed,  6 Nov 2024 12:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897512;
	bh=GrfMnHdWVkSn60rWybw59t0kBKu6Bp63wnPQtMuaNo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smHHwrS4oS+vzNCmCwLKnMdCVny/tSzbQU82+Y+NvNoGK9UuoUFhiElgVIMZXCMJn
	 fa717CM0IltjJ1FMkigBDWbyaXJ+2iWJyNcNU3oR/pM7kQtdonBV90D1V15gxrzEFv
	 WtXpa9qv2ENwpoPsRtcQ+BFydVrD+wxxAlobKfrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/151] iomap: improve shared block detection in iomap_unshare_iter
Date: Wed,  6 Nov 2024 13:03:49 +0100
Message-ID: <20241106120309.962841697@linuxfoundation.org>
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
index aedaad4c37d75..7db9bb0d15184 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1273,16 +1273,25 @@ EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
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



