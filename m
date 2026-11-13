Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590892;
	b=WZURzJB+oEGgHNVyEiQ34BPluJlG6q3cHpsk79uyMUisuigYyNhvfmWwcrv8NHWYfSu4
	 OQ5hmrAfcw5frBwu8gJIX+P2Wt6DDxezuNiGsY1YSWoyDhuJnFmrQqVWT6E7Xcm6TuuWx
	 O+Lk+0d/SwAyyXDlIPw6HPLsHaVvza68S1ZLN8vYAJ9IvvB1cpzgX+GIFUmUfL931+Jfk
	 i/DEJagrpJ97CZ2AUTOLm25aAQ0pBkGrVk/D0qiRznGWz7uFRE41qz/HwRB7ZuBtcf//J
	 xJnL9CtTk4CGSHewZbt0V3jRRSsMPUph3hIcgQxEFiDGgbY1PZsT/nOngvC92p8XvZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MMOUHHD1/C5AbXU5Dl6K4jksW8w7y9DMkicgpWyOm58=;
	b=1eBHYDmPSo8cg8t5zcq35LygWrivmiyqMZLq0ijT62vcqMT+iIi8aZaZq7/lma4eabs2
	 IwKOgyJoc6JYrNKkuMlM9daG/8wds35Hx9H9Y1ujB10wzLlkttdyKurj6iFgmyY1vOcQ4
	 M5EuX72aZpBr46AR79EQxHjkJwbTkKfxxg5fup8ox5Qu3ZfSt1ELWGMBiQOO2+8Pxpk9a
	 80zstxO72m5Y1r3+UmzEldLsaRkxolwNBNEDmyMo9f1bisB9rjBsDYmGs8M2/ksZ7DSWN
	 1DKTfCv6Wz5KH988svfuDUjETJh4dL9lLk3saQQ8MWfDH8OgjheHUrd3s0Y3e7qu0RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpPGkYxi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22F3606D87B;
	Fri, 13 Nov 2026 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpPGkYxi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0721F000C6;
	Fri, 13 Nov 2026 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590892;
	bh=MMOUHHD1/C5AbXU5Dl6K4jksW8w7y9DMkicgpWyOm58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpPGkYxi2YwrEyL3i3CIUujZpfBHdGUrYo7IHe+uU74Ckt6TtjmvY2dreAUfeNjPf
	 om/5iCPMo7taoU6gTsXkLDfFVTegJPMYRbZej1cilCgizFNNt1TONmLhkpq8BEHKWY
	 oufWUMaSoWG3EPWq7zHMS/Ss5RzgOkEcJWngc52M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/670] xfs: reduce new btree slack factor if free space is negative
Date: Fri, 13 Nov 2026 10:44:08 -0500
Message-ID: <20261113153814.760678948@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 80f13dc7225eec318da7499c7a562d7a34d25e6a ]

LOLLM points out that if the incore fdblocks counter is negative, the
assignment to uint64_t will mask this possibly low space situation and
we don't pack the btree blocks as tightly as we probably ought to.  If
it's the case that there's some free space and fdblocks is too low due
to an error in the superblock field, then we can end up failing btree
rebuilds due to ENOSPC unnecessarily.  This is a corner case, but let's
fix it anyway.

Cc: stable@vger.kernel.org # v6.8
Fixes: be408417630427 ("xfs: implement block reservation accounting for btrees we're staging")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Replaced upstream’s xfs_sum_freecounter() call with percpu_counter_sum_positive() on m_fdblocks to match the existing counter API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/newbt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index b818d9b215788..80f9bf7e399b4 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -60,7 +60,7 @@ xrep_newbt_estimate_slack(
 		free = sc->sa.pag->pagf_freeblks;
 		sz = xfs_ag_block_count(sc->mp, sc->sa.pag->pag_agno);
 	} else {
-		free = percpu_counter_sum(&sc->mp->m_fdblocks);
+		free = percpu_counter_sum_positive(&sc->mp->m_fdblocks);
 		sz = sc->mp->m_sb.sb_dblocks;
 	}
 
-- 
2.53.0



