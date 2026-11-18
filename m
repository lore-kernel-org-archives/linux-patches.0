Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038829;
	b=I51FjCSzkVhctMPmmZY0DrF8IT6oFDyuM5rV9aT6REEHD008tD60Jo3l4MgpNSX7FmLD
	 /FQWTNaIgMUa64gAb1j+IjhnWxogLmDRh4ktm8IDCLpLI79Ob8wWDmslApFIk9t5OxB64
	 0ChEM+9rNBszmMjEgs/QGER53oZyPGtPfX6H8CS8R5iENyN5OLcT5k2OHiEZSI+FoyMuB
	 vs0MHUGhSjnvcjisYaXHbqgpKL7TdN431ddTh+93H96wUx8PPqeU0tLe+qdmEwnNqlmjz
	 St7dLxHBOQHN1SkhHGCAmoTzA2iU/2ViINtA2OCVn+cRY8EcTua/fo+eve5mn+4MlHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=45i5abFSuhLxTgA9DepstgoXz+MdVgBFVisOIZQReRQ=;
	b=sXe+o/rig+f+3x5OljXnyB2ScEGS3+EXakA79zxV00yJEsTUBjeHDXgZmj41dyEmjQex
	 h9oHyWnNx6+YeDPYSWUscFtVGhTuj7rq4VimkpB7vUYDt8r16YyDc5S54BR8BjX5L3xK8
	 Dy7/0pRakP+QaZPFe7f0fuPRQk5jOi/OMCiA9iTiGfIEJPxRtcRDCPEcpaXK7H7rP0cx/
	 xZOVGq7MBgFLEeETUgNrxIRPM2zCtbEH7sY6Grtz98p/sCPQRcbL7LvYiOgHw7Hl2SLiK
	 RL2ct7NS0azUqAkjQ44lvtOdQLEvbuNbh/o4+A0W5eGykmoHPRSSrFi0nx/be3f3jnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBlB9OG2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683F3606A31C;
	Wed, 18 Nov 2026 21:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBlB9OG2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC59C1F000C4;
	Wed, 18 Nov 2026 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038829;
	bh=45i5abFSuhLxTgA9DepstgoXz+MdVgBFVisOIZQReRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBlB9OG2+gVsjt3L5QjNStt2Ep1m2GjGjLeYsDrAEO73HQtqFVRP8sjoPiOqJoqHL
	 GZGN0mVURC8N1J/rkdjMT6QRQOUoToWN87AnpdVk3LpiXnZ+VsG91wOX+NOFXQbUWd
	 G4F9x6EDf8VoVQoUorUImPjDt7BMFtK+brTZRo34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dgc@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1883/3318] xfs: dont skip free extents of the longest length in a whole-AG FITRIM
Date: Wed, 18 Nov 2026 15:41:45 +0100
Message-ID: <20261118150418.479785507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted trim cursor fields restart_bno and count to ar_startblock and ar_blockcount. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d5787991bb5b4..80d4a39e69008 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -175,12 +175,11 @@ xfs_trim_gather_extents(
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
 
 	/*
-	 * Look up the extent length requested in the AGF and start with it.
+	 * A by-len walk starts at the last record of the longest
+	 * length (ar_startblock is NULLAGBLOCK until the first batch
+	 * ends) and then where the previous batch stopped.
 	 */
-	if (tcur->ar_startblock == NULLAGBLOCK)
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
-	else
-		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
+	error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
 				tcur->ar_blockcount, &i);
 	if (error)
 		goto out_del_cursor;
-- 
2.53.0



