Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC7D33507A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302042; cv=none; b=DoTBeGYKGifn8MhMG4f1aK8N6RjoqDvtKFUUsHRu8esDsPwNLYF/7nIQVx76RMiMWzhNEdyqyQE8vlshyt5Ujv13O37Jf1mrb5FvuvVZTfdIp0weq63TOja3s2gooL65IFut+0oflVer8ajx3cSkPyOONjDE7xxHangNSZQx5cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302042; c=relaxed/simple;
	bh=Jk3qFgXqpDluHKf/OsckfV18DOQlgZXYSnOX/lA6hSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWUztcsntktxLqRMG2dHjX+5DlNeji6oFmuyh+CioybcFNdS++2mY/WkKQHo5+vFBfxhosashx/0RN7bNyIffIcIiZPxlZbUuv8j4LTFn7zYzF758ivV39KtK59naTfwXEi/KqnEYyg9ZmgUKEHddwEVgK4cL3zW7TnW5PkKxeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoHWHzoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoHWHzoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38944C116D0;
	Sat, 28 Feb 2026 18:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302042;
	bh=Jk3qFgXqpDluHKf/OsckfV18DOQlgZXYSnOX/lA6hSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoHWHzoOm80apnrghMY8+hlxckh7mUQDSjW4+KEiDnKv7SeAU4Bo5O0+bVD2/KYw7
	 nSuyi64MvWJu4kiB6Idk75HbB1LP6j3rR/vasO6OgTcTk5ZCtzoc+M9JUb3HYNoA6W
	 3/KuF2gYQyX0f+AKvIdb8laviWcDcrjNkm8784H3D89wDTm0GjmedVW1IpV5kzm+jV
	 2WCnYy6FFL96xvU8+8uwSoQFGMjbnGNueontTvK2HKEEJmjnunTpgSC55yXC+VRGfL
	 FCqwYlT+dooNZNnT5KoGPa4MYbIhjGaOE2x7o1kAeWjs0ntN6uUOruZJgiBCROxh1l
	 k4OfTZEGbZ0uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/283] gfs2: Add metapath_dibh helper
Date: Sat, 28 Feb 2026 13:02:37 -0500
Message-ID: <20260228180709.1583486-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 7ed276a8f599d..b837a2c2dd571 100644
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

