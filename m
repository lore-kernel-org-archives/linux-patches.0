Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828936;
	b=ZAQ/6oNksYsXHjJIpKDqOvSMPDoz0jhu4hMv34SivxMyoRZ0c/6PZibiDcqOWhqeioOm
	 ilWYNI1T/eHvugNKftEW5pSZAN+R3F9PXsJ3c/5CH9Lvq6jkypd9LMtKNqEjLwl8HPEfs
	 fMwtJ7nedzDDw0o2A4+uAlKDTcWcOPl6Z6JKOEpfIF3pnULrAJay0sW68m82zhABiTsEE
	 hLeLh8u0V4ZIInJa4TngQqV2zq+rjHTBtnibhp+bSE2DIAjI3B0C24y0rROt/BDG6PQ+8
	 uBs+iwdqTrQw3o+xe1lwjy9k1y49DXJ266NZkTdn3sfiI/iHawrhKjubFqIRsjPkl4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iX704EJYJm9DnSdz6JL4M+sQMDZzgzT5Yw+DZiIC8NE=;
	b=WzDyv5a9SlQvdqNvf48rZojyxDTpV1UiDQudhNUK6Vq7sH+wW4FHwnSrW+4cpTpt1Sbc
	 1aCgTpTFsmQE3Hqch1I95H21Te5zY+DKfY48nmFir5x8Il2wU7WR6KfhIPylBKodTvLE1
	 b4Vn+/OR7A4c6FcJL7XgysZBCK0HbYtaPWOhx+s7+PuMzMB/fPnKcrelzanLFrO1VYAZ6
	 +Gu+wSKrsLWTGeOpa7iIxWPvDKAS39ylRWn0L3nArz/V9KY2eJvPgIJm69KOTlOWY1VUu
	 d9LW9wWdoIAlZhKkbmy36bNfSoWVSgWj3r9IevZ0rn+BkuEPgCsvPV0kFytXdS8or0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=du1kZvB4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB392607043C;
	Wed,  4 Nov 2026 21:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=du1kZvB4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF671F000C1;
	Wed,  4 Nov 2026 21:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828935;
	bh=iX704EJYJm9DnSdz6JL4M+sQMDZzgzT5Yw+DZiIC8NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=du1kZvB4FGfH5hBUuV1BfCbqn6o7rnbI7iTS/rg01udzsu0yrSJkVU0K1upvXtCHl
	 y4FEQ5BEb6LwYczRG0VEnwm4GSvOow1EZ7gXveMA3cfvimhUg6lOgXfWk3pZs69z8c
	 KUoRUC/jEP38eW3lFDmaCZ/AtQX3QFadQH8HwGa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 336/547] xfs: reduce new btree slack factor if free space is negative
Date: Wed,  4 Nov 2026 16:08:40 -0500
Message-ID: <20261104211047.778679720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 80f13dc7225eec318da7499c7a562d7a34d25e6a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/newbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -71,7 +71,7 @@ xrep_newbt_estimate_slack(
 		free = sc->sa.pag->pagf_freeblks;
 		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
 	} else {
-		free = xfs_sum_freecounter_raw(sc->mp, XC_FREE_BLOCKS);
+		free = xfs_sum_freecounter(sc->mp, XC_FREE_BLOCKS);
 		sz = sc->mp->m_sb.sb_dblocks;
 	}
 


