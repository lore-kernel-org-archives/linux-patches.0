Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC584409;
	Mon, 23 Jun 2025 21:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714448; cv=none; b=aYn9XMPbIIAqC7iXod/BgbIzTa9Ix2YaW+RYmtbVoF151le4BFLwMZ7CggkRyljx0AENbk0aWQFW0eCEQuS/5BdIwIInIW2PI/Y6+QEGh/6gbCpZeql0IQgf8GEPrByV56zR8eGoIjNM10WpQfXGR5Rc8zX4reW6NDkyQ2ETzVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714448; c=relaxed/simple;
	bh=sAN/Kss2b+az1lSJ3R+3MnAWr5pkmYi9C/xcDSmLx8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7RzWzxysmqQ0dcAOWKXQ1arAsauur8OrDoiV64VJw9hTaqodkcHsyeQioSP35DGKWhqsw2hWdhZ5hw6WOdwUQlBmM5BzSIrX55lpJ9MPrzYT2pF2b+B3jyi2rxmjLpfKsgF1a+xnz58DptTOdSq5iPJy6fYXHiQsw0EPXS7ZLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apFkAqIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apFkAqIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1621CC4CEEA;
	Mon, 23 Jun 2025 21:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714448;
	bh=sAN/Kss2b+az1lSJ3R+3MnAWr5pkmYi9C/xcDSmLx8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apFkAqIzywnJWOPh1T6c/lYw2WUTA0fkec1EchcAUYGwyMcl3xd2FyYqzpT8UjEZ0
	 Yrj4BS5Jg7NwHCY16NPdx1m+sYwuR3rx5bxjrYou1SIakBgnmRflQEsCucQnQgQItJ
	 AKMP3YtNdvu3MPmxDDBsp/zgGSfkM/j0s2PBmS6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/508] xfs: fix logdev fsmap query result filtering
Date: Mon, 23 Jun 2025 15:04:00 +0200
Message-ID: <20250623130650.069741133@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit a949a1c2a198e048630a8b0741a99b85a5d88136 ]

The external log device fsmap backend doesn't have an rmapbt to query,
so it's wasteful to spend time initializing the rmap_irec objects.
Worse yet, the log could (someday) be longer than 2^32 fsblocks, so
using the rmap irec structure will result in integer overflows.

Fix this mess by computing the start address that we want from keys[0]
directly, and use the daddr-based record filtering algorithm that we
also use for rtbitmap queries.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 202f162515bd5..cdd806d80b7cf 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -437,36 +437,22 @@ xfs_getfsmap_logdev(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rmap_irec		rmap;
 	xfs_daddr_t			rec_daddr, len_daddr;
-	xfs_fsblock_t			start_fsb;
-	int				error;
+	xfs_fsblock_t			start_fsb, end_fsb;
+	uint64_t			eofs;
 
-	/* Set up search keys */
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
 	start_fsb = XFS_BB_TO_FSBT(mp,
 				keys[0].fmr_physical + keys[0].fmr_length);
-	info->low.rm_startblock = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	error = xfs_fsmap_owner_to_rmap(&info->low, keys);
-	if (error)
-		return error;
-	info->low.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (keys[0].fmr_length > 0)
 		info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
 
-	error = xfs_fsmap_owner_to_rmap(&info->high, keys + 1);
-	if (error)
-		return error;
-	info->high.rm_startblock = -1U;
-	info->high.rm_owner = ULLONG_MAX;
-	info->high.rm_offset = ULLONG_MAX;
-	info->high.rm_blockcount = 0;
-	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
-	info->missing_owner = XFS_FMR_OWN_FREE;
-
-	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
+	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_fsb);
+	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_fsb);
 
 	if (start_fsb > 0)
 		return 0;
-- 
2.39.5



