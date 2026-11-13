Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590271;
	b=0bJQaqN5wAyd8kQlUE/eiICyRi/XadccnFsP/V9v0ZmHcxBQskwGEEUu2n4U3iQSjFjd
	 6bH1ys25OhPpjIqh3Sh6ArE/Minp08d8YxCKUU8zC0brmXvOlF7o/x+OII5vyxGJk2Bl5
	 6tq8uf3qdDcJnBfrhqAOL58tnh5Ws5K4BJFNO00KK6c0Os3yzD4Mfyrqy4zpZ4GDN7Y8O
	 AeNyRbXN1c5CzEaCkypmhewGil5tNK8ZuSZ+sq/llP+yeP4k3JthPDriVv4f3yQsie2y0
	 rwHVgT1S7ThsZz+s8XWFcSSrQM1tMGGRbJZ+Kb4Nm0W4W4fppxKFv6szPHXQqvot7Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FJF6g4LMOZFHoFIIfLlksWgrm5HjFy7ruJVKn2mNfiE=;
	b=GHyAEcorf4P4Up52ptkpffUxTMpWsDLW0ZVdJI9HfaqEsWeyVXR2TkPFSyeyuurHIj6I
	 1qvwdHU8nILzdHE+RGcRWCn/XZITpO/VsUpUxUZrf5q1HuEpOfj+JxBao621+99TiAMdm
	 h/2wpfCTLneKkcO9uAOtqtG2TjKi6l+WD/tXN5k+h8ram++Wpfzfx1utB1odOqLvskCnZ
	 jaGebWA0zpxeNzGhFc5mSt7fi+Gxg8JkdsnVOhyIuJTNy6moUE+Zr0Djsh/Q4VV1WUQUn
	 SsMQwpzZR5fvOjJu7iJ6aSu4NWD2GTRIa6kuozaq3se3xmUM8OCtkdxiU1vEwOPwitQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oaj50HpK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDF7606A898;
	Fri, 13 Nov 2026 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oaj50HpK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8FA1F000C4;
	Fri, 13 Nov 2026 17:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590271;
	bh=FJF6g4LMOZFHoFIIfLlksWgrm5HjFy7ruJVKn2mNfiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oaj50HpKGA8raGxpJm2YJKu2ScLI8/ExVCxlF7+ykliZgZ02CxDLbV/aaM8bqvCUN
	 j3MBrgK6ix6uWiyd34BLm70+e79S5MNJKSYGEMGEhlqzCBEc1LK9o51S9E+5lAOKFt
	 w7+ML4IniBdhgjALS5AGYx1bFZie+h4dlsixF0tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 262/686] xfs: dont skip free extents of the longest length in a whole-AG FITRIM
Date: Fri, 13 Nov 2026 10:46:35 -0500
Message-ID: <20261113153829.907259140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 5745f4f10a1a16aa5bb020acc38afa33f2d5ff99 ]

Since commit a66d636385d6 ("xfs: fix fstrim offset calculations"), the
by-length walk of an AG in FITRIM starts with
xfs_alloc_lookup_ge(cur, 0, pagf_longest) and walks down. The lookup
lands on the longest free extent with the lowest block number. The
other free extents of that length sort after it and are never
discarded.

Start every by-length batch with xfs_alloc_lookup_le() at restart_bno.

Suggested-by: Dave Chinner <dgc@kernel.org>
Link: https://lore.kernel.org/r/ZgiJWxVcVwag0fIP@dread.disaster.area
Cc: stable@vger.kernel.org
Fixes: a66d636385d6 ("xfs: fix fstrim offset calculations")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index b866329c7a28d..98933c1725214 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -211,12 +211,12 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->restart_bno == NULLAGBLOCK) {
-		/* first time through a by-len starts with max length */
-		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
-		/* nth time through a by-len starts where we left off */
+		/*
+		 * A by-len walk starts at the last record of the longest
+		 * length (restart_bno is NULLAGBLOCK until the first batch
+		 * ends) and then where the previous batch stopped.
+		 */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
 					    tcur->count, &i);
-- 
2.53.0



