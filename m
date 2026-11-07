Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061409;
	b=NrLePAuGz5Nq3GK0g2tuHZok8SH2BlKrju+OaGRd3EBJy0St39VN7mcxVRH1CQpYj7+C
	 ceai0AOrxR/ozw03C6VkGVyiHtk/ZoFB6TNX8cBdvLLO1KTLJf/oMJO1/5wp5bTdRZ5Na
	 fAb3Bv8eJmYxU/zh/m8/iCqvEgmmczFhW8+/cR4CZbTV4zyoccMczEAigN7zDUmzGC192
	 eJPPmpYqM2rGCMZI8yN+3TeZiCWHsfRQDfjnzKCDCuvDBoqoHBQy/Zxyjt/2AaOt1YuXP
	 OW9HL6ethX1NZDhOreEg+9iI4QYsGSa35kms84r94Yk9kvuvKatLqEs42yY8UdxeMDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhtuYZOq7O8/t34kekPrkb6/7M+um44sMk2qZv55L40=;
	b=ohj9Tp1zvS+1BJWfTkTtz+XwiIAiYTwePB4M1EQcHI+tnV728iP2Pk733KoL6GNIGlon
	 58yGod/lHq2huvmCGXuwXIktFzVHP5MpKBVb8+/oJjifKknKYGadflIgOrj+GZpChsNj6
	 UDXCXf1iZj/UjRxHst3dm7Pt1IDX5Movr2saakh1VQs0ZgKMscc9IgHjPnIaVKphG87ED
	 N0VEHxcao4r5Q75vWAYrNLHMkREzh3jy7ZXc/1lcnb2HbH2SluQMRvLL/1o67EOF58RD+
	 8CMgVUCQfSbUc/C6XdM43N2e5iPfjSUT9eUUeEwfP3h8RuFI3ILWy9vbRQ/ucYGotgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5fI7mbZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEAA606A332;
	Sat,  7 Nov 2026 14:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5fI7mbZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1D01F0089F;
	Sat,  7 Nov 2026 14:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061409;
	bh=DhtuYZOq7O8/t34kekPrkb6/7M+um44sMk2qZv55L40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5fI7mbZR317/fBM+uANNc9vgfbUuKxmHSgnBAlr649m/fO3qIEVqeNnod65CDiPH
	 6MJdUwfNi6PcgfSjJXh1inZX96zqxqMw4WEudTU5cljI+dbeOkcg0qd2JAtUPU/r1P
	 987s55z4WthP7Re607ffBYsGn9jKPuq1GbqZMPMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0524/1536] xfs: dont cross reference rmapbt with bitmaps if theyre incomplete
Date: Sat,  7 Nov 2026 08:42:20 -0500
Message-ID: <20261107135012.141410496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit d7b92cbe566f6fe54368f62e4b515d9f80c43a18 ]

LOLLM points out that runtime errors (e.g. ENOMEM) when we're trying to
compute space usag bitmaps are silently dropped by the rmapbt scrubber.
We ought to flag that as an incomplete scrub instead of reporting
cross-referencing errors based on faulty data.

Cc: stable@vger.kernel.org # v6.4
Fixes: fed050f3452da0 ("xfs: cross-reference rmap records with ag btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/rmap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index ba5bbc3fb754d..09eb9b23fed0b 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -493,11 +493,18 @@ xchk_rmapbt_walk_ag_metadata(
 	 * If there's an error, set XFAIL and disable the bitmap
 	 * cross-referencing checks, but proceed with the scrub anyway.
 	 */
-	if (error)
-		xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
-				sc->sa.rmap_cur->bc_nlevels - 1, &error);
-	else
-		cr->bitmaps_complete = true;
+	if (error) {
+		if (!xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
+				sc->sa.rmap_cur->bc_nlevels - 1, &error)) {
+			/* only set incomplete if we didn't set xfail */
+			if (error)
+				xchk_set_incomplete(sc);
+		}
+
+		return 0;
+	}
+
+	cr->bitmaps_complete = true;
 	return 0;
 }
 
@@ -567,7 +574,8 @@ xchk_rmapbt(
 	if (error)
 		goto out;
 
-	xchk_rmapbt_check_bitmaps(sc, cr);
+	if (cr->bitmaps_complete)
+		xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
 	xagb_bitmap_destroy(&cr->refcbt_owned);
-- 
2.53.0



