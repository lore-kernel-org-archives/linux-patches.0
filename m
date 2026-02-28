Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E866D36C9E5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302297; cv=none; b=QKruC/1bd8Rxt3QynBpgEYTCX/r5Sa4ZcVvrTCfFWSto6n3UPeIq2aL+ra6nIrDM8T0nyvQE8AZCPqKpL8W10mAN2eZbOQcqbnL9W4i5Bs9WaYjxwxSqLoRiKjD/yDJ62PxC7BtzKtSXEgF37k+Dg296w7yASg1fLBa8wqzKxjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302297; c=relaxed/simple;
	bh=LAioGEN/7FFPsAxopcFMLrb3iMNkI53YZOdz37Eyu2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTVeADy03TI7nH/c8jWhMGDVy8BawLk76PyWr/UTYXZAsHrOWiRw0wF/35k8h8FQq0P/oPAxn+5S2Cxrk1FxSASpiN25mu6k6EBsiHeniZGynJl4vUpSEJA2lEWy694emh10BLgnUQ5Oc/cWbac9kUvMjJNHpqumKuEPxglIU+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jeAWS5/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jeAWS5/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0DDC19423;
	Sat, 28 Feb 2026 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302296;
	bh=LAioGEN/7FFPsAxopcFMLrb3iMNkI53YZOdz37Eyu2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeAWS5/vY9r1rA4eZprQqFiGfXg9wIdHjcqBbcziPV4QZtBrmhpHZ0BW0IAJ30bWM
	 NWlRI0aS+BkC3QorGEy48teNswbweFKyEkvh8P7VW6Ftsa5fJc3/QmB0z6uPts2Uzt
	 uSOVAkI5HdC72mfm4vgIC240I03/gXGh0sq4iTZOipXq10YBkUDdMUSh9Tu8nz2Yy2
	 Lup9rDP8FObH6h+sWIJx4xfZ+gFI0dWYkvIPpgwnw/THumdRtflgAxO5Vrvoy3pfXL
	 uSXrPhUfawDEHJjD81AMt4bUVmJz0nGGri3+6fqIKzFuVjJUm9r/ItBhcxH5+M7b9a
	 ulqGeH8fBa+OA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/232] gfs2: Add metapath_dibh helper
Date: Sat, 28 Feb 2026 13:07:43 -0500
Message-ID: <20260228181127.1592657-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 92099f0c92270c8c7a79e6bc6e0312ad248ea331 ]

Add a metapath_dibh() helper for extracting the inode's buffer head from
a metapath.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: faddeb848305 ("gfs2: Fix use-after-free in iomap inline data write path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 9ad11e5bf14c3..9f0dec17fa431 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -317,6 +317,12 @@ static void gfs2_metapath_ra(struct gfs2_glock *gl, __be64 *start, __be64 *end)
 	}
 }
 
+static inline struct buffer_head *
+metapath_dibh(struct metapath *mp)
+{
+	return mp->mp_bh[0];
+}
+
 static int __fillup_metapath(struct gfs2_inode *ip, struct metapath *mp,
 			     unsigned int x, unsigned int h)
 {
@@ -660,7 +666,7 @@ static int __gfs2_iomap_alloc(struct inode *inode, struct iomap *iomap,
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct buffer_head *dibh = mp->mp_bh[0];
+	struct buffer_head *dibh = metapath_dibh(mp);
 	u64 bn;
 	unsigned n, i, blks, alloced = 0, iblks = 0, branch_start = 0;
 	size_t dblks = iomap->length >> inode->i_blkbits;
-- 
2.51.0

