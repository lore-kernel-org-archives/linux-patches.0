Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B793D8912;
	Fri,  9 Oct 2026 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555681; cv=none; b=h9SDrqR8MDGx+hkMue0ECDrzp7IcgnFTEJvvo33+f9D9vN0I9wBl8fylstSVC+Vi27e+UK/kv8itZkII6eeyknT6YTjHepSoPrjyjJJLVd4R1lB5QgZgu5ATz7he0NZSEgWzxqrY2CVqaowSYQpDkJpAVmzAAhudbUZYkq4Y2Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555681; c=relaxed/simple;
	bh=je6nw4fwRp9BFh+oAEbS1SJVEuGtsZp4ZwO9XfpuvFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jN8UXhKjI3gbZjTxwg2moLQTIRJxhMc8GNq1CHY5r/2uvdVP4C6qj3SCt6d4GeEYeQxZ4WfRKzwCxxddQ1e99kuY8pb93svJE8fGALStdta29wUexDXLR0qra/uaQOH/yarTCR/XLsfMk/LD0SzyxVyx4ku1/ZI5Fh9v4m/A4zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hCHIuwlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hCHIuwlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C811F000FF;
	Fri,  9 Oct 2026 14:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555679;
	bh=DApPPzOrRbGCpSIgarEeKQWbou2747PqMSaFKalpsro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCHIuwlUYAcLy4xuUWQpSVSWI21aYXsLpO6STZsD4UjHsI4MI/Di5Akc5Wedbh7S8
	 ykSIV2ZeypTi6fsbLe4Gd/fRWM7LGsKqDmWYyJmq3a9I+tWx/+DZ0UqYI0sMiR70gw
	 SSI8HKrR+bo4jCn1J+ZTCLRC1RmR24UyTLDRhi3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baha Mesleh <baha.mesleh@nokia.com>,
	Subrat Pandey <subratp@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/403] octeontx2-af: mcs: Fix SC resource cleanup loop
Date: Fri,  9 Oct 2026 16:07:39 +0200
Message-ID: <20261009140954.380382625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baha Mesleh <baha.mesleh@nokia.com>

[ Upstream commit cdef07f3002f708a345392ee28d0d9bfac8383a1 ]

The SC resource cleanup and statistics loops were incorrectly
iterating over secy.max instead of sc.max, so the highest SC id
could be left allocated across teardown or FLR. Use sc.max as
the loop bound.

Fixes: cfc14181d497 ("octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources")
Signed-off-by: Baha Mesleh <baha.mesleh@nokia.com>
Signed-off-by: Subrat Pandey <subratp@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260922102149.2078168-3-subratp@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 211c10aa5880f..30c672d526a0c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -314,7 +314,7 @@ int mcs_clear_all_stats(struct mcs *mcs, u16 pcifunc, int dir)
 	}
 
 	/* Clear SC stats */
-	for (id = 0; id < map->secy.max; id++) {
+	for (id = 0; id < map->sc.max; id++) {
 		if (map->sc2pf_map[id] != pcifunc)
 			continue;
 		mcs_clear_stats(mcs, MCS_SC_STATS, id, dir);
@@ -738,7 +738,7 @@ int mcs_free_all_rsrc(struct mcs *mcs, int dir, u16 pcifunc)
 	}
 
 	/* free sc entries */
-	for (id = 0; id < map->secy.max; id++) {
+	for (id = 0; id < map->sc.max; id++) {
 		if (map->sc2pf_map[id] != pcifunc)
 			continue;
 		mcs_free_rsrc(&map->sc, map->sc2pf_map, id, pcifunc);
-- 
2.53.0



