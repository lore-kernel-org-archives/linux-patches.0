Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F402632B133;
	Tue, 13 Oct 2026 12:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894865; cv=none; b=LNgJ9aMSuBBFLa9O+D7euJ+dFL9RZwhkBkvAV9vGh9ZHjxRBs82md5ZmRiqYNwBvM04OWJ7f02TrxLobbZZleTbCUI4p5S41ozN2o7de8h8Ey3GVPpoBhCchKVvOvIhMgwvydewuhpDli7YcAy9fhwHvK9PlWZIksotXyxucNfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894865; c=relaxed/simple;
	bh=Cym8ZwRfzaM7u1d2grTNjzKHkMwxvpfGYf8obqBmcrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+cIQUJMBvlyiBV5GUJYbJTAKyLMjobEuOB2LAQQrQjzasnpuTdASrbVzC09z5RoDYivNeflct2aQkfP9SrQ10kwHt0X91FT9Q0Rd6HmNFfuTCEGCY9V03CA/xmR8jhTBgiBk+g0HbYNpNNQvv/pVU//SumyJOY9gk/9FSTVkXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWeZzftK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWeZzftK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C43A1F000FF;
	Tue, 13 Oct 2026 12:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894863;
	bh=7c6oVAvBYXR9MxvWiSjO/RG+QuluJAbZD6Y679TkQIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWeZzftKDHlX+c7nz3/4ZwL9mxgOL5XWLRVRhr+3WVCjRKm5z3P/Jac0OFCSukCxg
	 qAJ4LqVsPz1aVPcn7yqZ9s8ErLMsH4AEVlGDumbECkZfo1e/ZA1rZK4/DWWBLuxauj
	 a40hAVnpDEaeITdMpLvwo89X3rkNX2H6ltDEoddg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baha Mesleh <baha.mesleh@nokia.com>,
	Subrat Pandey <subratp@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/497] octeontx2-af: mcs: Fix SC resource cleanup loop
Date: Tue, 13 Oct 2026 13:34:07 +0200
Message-ID: <20261013112909.785650904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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



