Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43A38F65A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302512; cv=none; b=Rp8rVZ1aq9Be+u6oZir/qLiAIOje9jrrNI8cQJE81RLqd5ZHveYUlkUocVxgMF7Ytlnxy/k1Q9J6BkQghE7JuFMYTFbF1/QobFyqWf2dV+Qp7xWD88LmGjeLgbJ/D2qBI/wcC7gieSkvAF7nMUozR6h4xL9HgLmjDsuKbsudAQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302512; c=relaxed/simple;
	bh=vz4heyLxtzySdTCcMM2oTGqMh1FZh2KsmvrEBzwqW+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3RCZ2jeiXYmoZZmRrV3OrFsC4thIXanq5pHW3d/zM3rrsBj4hOfYQ08zzjUJ3uGgFO1wJ83ytSPASM9BZmBoqyqvXJDKSJvtrLnzvCKhX4sMkEeWy7FwHpX30dY/GRVmHO9XK/AuR0PZfobTOsTcE9xWGn072ibZuKL5YPe/0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vHesaCWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vHesaCWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE4AC19424;
	Sat, 28 Feb 2026 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302512;
	bh=vz4heyLxtzySdTCcMM2oTGqMh1FZh2KsmvrEBzwqW+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHesaCWCcWCjUfEsfyJP0YMdDMxrTcb04SEkHK/h/J6qEYHEmtwrFwtGDHtIcnR0p
	 r882sDlstZgIbi7f00P+pKaCFP3tIjhpwO0lVz69r0vFs7On7rd8zbUyfxTAR5mNkM
	 fB4zPMpsCvnUeU/fnEnbUvFZjFoSPSJetLWdoR6jO8bXETsjgF+q2GO7Et/77ugeej
	 aKcsNVsRfFyt1DqncisP/CQhEEDYc+qcCth7yscy1b7OC+GWjn+/pwQFy+2I8vIG+g
	 y5mwkpjUEjCXevOgMOLE+GSYvaN4g5kopy/tyH3aI8ehVEt1y4BFmZmv/fKDb/5DE+
	 /b7/7vpb+oBRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/164] gfs2: Add metapath_dibh helper
Date: Sat, 28 Feb 2026 13:12:27 -0500
Message-ID: <20260228181505.1600663-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index d2011c3c33fc2..7425c90e47eb5 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -318,6 +318,12 @@ static void gfs2_metapath_ra(struct gfs2_glock *gl, __be64 *start, __be64 *end)
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
@@ -662,7 +668,7 @@ static int __gfs2_iomap_alloc(struct inode *inode, struct iomap *iomap,
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

