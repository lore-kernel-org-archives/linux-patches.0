Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590872;
	b=LOJSSuT46O2zmKuOUlf1pmtgq5+4BPyLVkkYAOPjUhM4yCuNn7xiRNOIZRRTWZ/eMdwN
	 XuYFmSz5AinfQl639h6wii10Z/Okd8DmQdyD3yvQvOuxQjITD4PI+LMhAkrd1YfTCqZ7q
	 yGChk42Tjaic6zvvlq5m93PggpSZLc9LIr/0zXxmxoeohn/bDj/MhqdpyhchgeN7Lvhp6
	 FXd2OmMZDrnPTW7XsToYhZX8fovM706XfYNh8NhoDdtFRbwbLk15kcUxd/QZ7K7wBKnKE
	 Bi7a7BEbQAdxYn73bl2T2RDGZjOqfxB5c/Zzh9E27MJxTe9yTVi5a2/oa+Su8fR6YCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zKas6+KMPXNx6e5iN2I1fTHGXixKmtpMig+V7VRmfoU=;
	b=pj/UJSWdqBmDK4+6EAgNdjt8bkvMffz5cqdzQ2R3vLWGTxtnIuQq8g5WCwWJws/naBX+
	 Xdw2MPeD50OBXcN30rQo4seNFLJ2wIIAn90ci8krCEsnN6jkQ0Yi+dXLiIOCfXIxmHaSf
	 GqDtAvJnV5kY+wK+i94880piVfskRoTtrvil1OWAff4zxJ0MBSp6mMllutp+aR5Rj6tma
	 iPGraUCGSVfpNz4Czmy8JBcgJhRdAGTXd6+BHop7E/O5hWjAU2odlB+wuN0X6OR+p5qYm
	 nDigSP+CFFoQnPbNJa3UnYSF459Gok121dokiRibPjJI/ZAVC2DyPmGKpeEKfXnKxtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlKpmBzW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FF9606D4AA;
	Fri, 13 Nov 2026 17:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlKpmBzW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533051F000C5;
	Fri, 13 Nov 2026 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590871;
	bh=zKas6+KMPXNx6e5iN2I1fTHGXixKmtpMig+V7VRmfoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlKpmBzWMyooMJa6U/Plqxu52CL4HoJtpXGYSNhz+2FrVD8PecDpjutLKd7k0GWrL
	 CSvlxEUWWx6gBfksVV4rHoA03hOKPUaxIT5aHu2vY5Oe+tP0mmNyrSfYrQEZe6l7mo
	 y0CwbPb0r0Ua/HAHsmrf6c2KtvU/BODCZRe0d+TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/670] xfs: flag excessive delalloc rt extents as corruption
Date: Fri, 13 Nov 2026 10:43:53 -0500
Message-ID: <20261113153813.847864906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

[ Upstream commit 2b47be015a5e54f4a3d62afa636ba593de9b67f6 ]

LOLLM observed that we should not allow repairs to proceed if the count
of delayed-allocation realtime extents exceeds the number of free rt
extents because we can't install negative numbers into the superblock.
It's unclear how we could end up in that state in real life, but let's
at least complain loudly about it if we ever encounter it.

Cc: stable@vger.kernel.org # v6.2
Fixes: e74331d6fa2c21 ("xfs: online checking of the free rt extent count")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: removed the xfs_has_zoned() check because zoned filesystem support is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/fscounters.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 98634c668b56c..ac7e6329e46e8 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -606,6 +606,13 @@ xchk_fscounters(
 			try_again = true;
 	}
 
+	if (fsc->frextents < fsc->frextents_delayed) {
+		if (fsc->frozen)
+			xchk_set_incomplete(sc);
+		else
+			try_again = true;
+	}
+
 	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
 			fsc->frextents - fsc->frextents_delayed)) {
 		if (fsc->frozen)
-- 
2.53.0



