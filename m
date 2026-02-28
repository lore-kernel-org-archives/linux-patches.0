Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D224F39B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302666; cv=none; b=MFihhAVOlUAN8gJS/JfOBafVShz+USE+QCHAUcOQAjWe5JylGgbF3z9FN9NepGGdnGztq+MPkEqDq4YeD7zLo6fDZpdGKtN+SyfTJz6dW3GA80KSut936zfWjj7st3jkfExH4Fl7qtkDF1DcxdXzyEC6btka5XPIlx/7w6IzM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302666; c=relaxed/simple;
	bh=qCa+rJBcmrHxY7D3V62NXWye4CxImmbDBSsg4szL3ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F891Jlc5vz70ivpZqU3NnzB8h/CAjBQjlaAi13z2NSUPsWeTK6JrZDOBYND7KhTS2Z5+KZyaBRH8xPQzNFo9MBldnYrNey1CwF4/ei398BZXOGbeq5KGSA3IZa23jOLzcVMleQq08B6kZdQwvT9owIEk7dbO+DLzaOMwoywTctw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaLpGRA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaLpGRA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DA0C19424;
	Sat, 28 Feb 2026 18:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302666;
	bh=qCa+rJBcmrHxY7D3V62NXWye4CxImmbDBSsg4szL3ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaLpGRA8phADJJMD04otrb1I1tRNYeIHG/pC60j2sz8AFjD/YuYlSQxfFbj/6KTM2
	 frQTW7t7z/9LkqRvXhx++vEpBwO7MkirNMe/9CDIVwozlxyt1wygxu0dHBh0J+noee
	 BI3AkFnRzJoJAThFUifFq+ByMduW244Q9Rf3zxSKf0vC1trKNM4pHpH8rCUb1PP8WW
	 2TesBJwOguf+STCfGIkDxKD3V1gVhgXNAxQTTgYuy/ECOSReVLTNeqgDpvNzCPU3Tt
	 6N5Fo8nu2vaALB/OdvTqwXOibjuCwQT5yYqIs+7FZaJtPvG+5gggA1TxNkvuEVljZt
	 PmHSefxoT+pQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/147] gfs2: Add metapath_dibh helper
Date: Sat, 28 Feb 2026 13:15:21 -0500
Message-ID: <20260228181736.1605592-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index f7d51dd6559c2..1e0e350b5a5a5 100644
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

