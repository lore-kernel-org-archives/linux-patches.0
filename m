Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF2E4E7803;
	Fri,  9 Oct 2026 14:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556122; cv=none; b=hAUVbJY91Ru+a+6gIslI00t6NTZronP5KbPgJzHQAh3FYn3nVkrsZe0M1ssgMWFShOIepGjpZSHN0YSYT32AbhXiLnksy8Yz98jMU7VoVf2hG6NrdYblmSCn/cOHdiokZN3ZWS+bYqK943j2YWlFK7Hi45GvI0/IVj2Mme6JFfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556122; c=relaxed/simple;
	bh=PZ5WWdevr7epC6J0b6RH2Q/Ua43ykUr3BAubQZ7/wRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlXyEpKDUOJSitlbLLVgLBkg7SD/eU7hXjVC3ijGyisvU7N/Y8gqq6XrY0a3TEsILMKKaH6erfe2naf3Mzed0Hk9IKyF6UWfhbaDd8/mXvjCKpjqnpHOwAzz+bncXRdNY85ZOi0EK/HeaZwCOZ/5echjho72n4ouo/2jnG3yA4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2PakVCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2PakVCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE7971F000FF;
	Fri,  9 Oct 2026 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556121;
	bh=8p65aUmWa+jgIbFvCY7XgZw6BmJL32F8fg+f5iv1U3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2PakVCfuHRbq6ws8Hc4nCubXfNF3TKGjOHeTfLJcyT1Ohjmkj2Hcnb4WfToyQBy1
	 IfERAT4W69532sHN21Iy2Xfzdfyrg/oJXVefUTogOxJ3rme99nX2ikPfnFlAOV7ke4
	 l17YcTp4f30qEq+5kNmS90uXv4dXpVjByxyNCg8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baha Mesleh <baha.mesleh@nokia.com>,
	Subrat Pandey <subratp@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 124/428] octeontx2-af: mcs: Fix SC resource cleanup loop
Date: Fri,  9 Oct 2026 16:07:41 +0200
Message-ID: <20261009140948.915204285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



