Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F54E273D9A;
	Tue, 21 Oct 2025 19:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076610; cv=none; b=i4VazcuHiFz4T/dku1/GDvagNgYWcTU2AEXfuqCRIXyKMSM1u6mmF6oVI2ErONHZxTKrfQ4B4vtmxoaJxJ6yT5bCCWvJ73H1C5xcIW/ha296GMNWUOY3+fuWfqMEUBjW52u6Y8iCES2d5L1ZQ+Y+wb1MYCRPS5VHM5NqNKUh0UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076610; c=relaxed/simple;
	bh=KHU4JOguGYuy+WDXeKEUBr7M985KAM2FUfSVuNGI40E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVG6xWl9kDu0qST+w6e+7Oj9l0j5Ha2W+LDV812ky7EFsfOrG7OO0enkAXCBiDECNRdm1bSno0ViZJNTkR18YNxxP2PZqJ0yYyXNAHNGXjawhBKkMnuGSOQtwTEGci+Z6+TjlI2F1KcDkWhM/AWB65IsQX6CbcLhuV1WVgbz6x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiWktfEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiWktfEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846ADC4CEF1;
	Tue, 21 Oct 2025 19:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076610;
	bh=KHU4JOguGYuy+WDXeKEUBr7M985KAM2FUfSVuNGI40E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiWktfEjtLHNNDesXeTwQpUerbjGjAqR3cnWWe7Ptby9gfiTS/6LTxjGpd6djLEp2
	 ml0ZwxvPzr3rSHiAzf/7HUicym2g6xpIDmHATuhJGAHeFRRM/cax7hFOW2eZ16mGYr
	 kw5RxbhQiAaacu0OGWyEuRns4nG2Pa1dD0DSAblE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/105] xfs: use deferred intent items for reaping crosslinked blocks
Date: Tue, 21 Oct 2025 21:51:36 +0200
Message-ID: <20251021195023.717426500@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit cd32a0c0dcdf634f2e0e71f41c272e19dece6264 ]

When we're removing rmap records for crosslinked blocks, use deferred
intent items so that we can try to free/unmap as many of the old data
structure's blocks as we can in the same transaction as the commit.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[ adjusted xfs_rmap_free_extent() and xfs_refcount_free_cow_extent() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -20,6 +20,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag.h"
@@ -376,9 +377,21 @@ xreap_agextent_iter(
 	if (crosslinked) {
 		trace_xreap_dispose_unmap_extent(sc->sa.pag, agbno, *aglenp);
 
-		rs->force_roll = true;
-		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
-				*aglenp, rs->oinfo);
+		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
+			/*
+			 * If we're unmapping CoW staging extents, remove the
+			 * records from the refcountbt, which will remove the
+			 * rmap record as well.
+			 */
+			xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+			rs->force_roll = true;
+			return 0;
+		}
+
+		xfs_rmap_free_extent(sc->tp, sc->sa.pag->pag_agno, agbno,
+				*aglenp, rs->oinfo->oi_owner);
+		rs->deferred++;
+		return 0;
 	}
 
 	trace_xreap_dispose_free_extent(sc->sa.pag, agbno, *aglenp);


