Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBB31A00CE;
	Tue, 21 Oct 2025 20:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077012; cv=none; b=EIUSzYFyhdx+TKIiSxJRXSVGkQmdxAV6Q1ESUaTTa9rOb0seQGT/CFqT2FTRlSisw4/5rrr/IW+l2Lwnz7EWKwJfk/5ZugMSx3+RpjTGMMGxQb+AXPPJkplFkFC0JyPdM0XAXne8S0v+WPDK9HD0JYiC1f6OfZe1SLsOpoMJtwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077012; c=relaxed/simple;
	bh=oAurukdgGVYCJa1SQ9siVCICgkQGXVFzAB8SRKUPPzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFihn6HUml1Vv0OnB/gYIarichZoZLKDU5+eTjrLypZJbZzsqLBmliwj9PM/Tyei4fQ194Qo1Y2D6ZS9GRJJ86dCpTcKD0b16vDGTkKB9F8AQKAthS5stziDh5WMbFz6aHK8Ly+CFTh14SeF1cM1kYSaJaZixWZc2EkaTZxGJtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5LgWeLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5LgWeLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B78C4CEF1;
	Tue, 21 Oct 2025 20:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077012;
	bh=oAurukdgGVYCJa1SQ9siVCICgkQGXVFzAB8SRKUPPzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5LgWeLwyDgG1MUgmozSZzKI31QH9llbu/ZuWfvuCLF3V/MoyLjjCOb3KySZbek8l
	 BADQ7c3fI5z3aNCrSrAHTiQqXdyhKBMyzhIdm16eMT7k+9lRWfKNtD+Jdrz/9av5eA
	 KU9yga72FSUuGQAAg/N3jmGwTLIAy+5kFI33Hz7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/136] xfs: use deferred intent items for reaping crosslinked blocks
Date: Tue, 21 Oct 2025 21:51:37 +0200
Message-ID: <20251021195038.585668364@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted xfs_refcount_free_cow_extent() and xfs_rmap_free_extent() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -409,8 +409,6 @@ xreap_agextent_iter(
 	if (crosslinked) {
 		trace_xreap_dispose_unmap_extent(sc->sa.pag, agbno, *aglenp);
 
-		rs->force_roll = true;
-
 		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
 			/*
 			 * If we're unmapping CoW staging extents, remove the
@@ -418,11 +416,14 @@ xreap_agextent_iter(
 			 * rmap record as well.
 			 */
 			xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+			rs->force_roll = true;
 			return 0;
 		}
 
-		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
-				*aglenp, rs->oinfo);
+		xfs_rmap_free_extent(sc->tp, sc->sa.pag->pag_agno, agbno,
+				*aglenp, rs->oinfo->oi_owner);
+		rs->deferred++;
+		return 0;
 	}
 
 	trace_xreap_dispose_free_extent(sc->sa.pag, agbno, *aglenp);


