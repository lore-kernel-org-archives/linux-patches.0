Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F083B7B98;
	Sat, 17 Oct 2026 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256500; cv=none; b=NdkySZ12E2nJoZeEIYP8iSs6VYdd7H/Y2QMiocghcq5S+T0JbdmHmB0Y5qiferuvVo05TdUnk6knDg91Vm3mMUYOJ3SeYbxNFHHPEQIgXIoko1oD3Y5P4tmscDzRX7dWJlZd5jd1g0BydF9brLU+LqmJAPCJua5keDoiilgg6w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256500; c=relaxed/simple;
	bh=tL/jr4Dbbmv79cMEnJSIqFyp/ZKFAWQbuJStPwciMOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9dpwjX42mArireNR/LMKfpH2BqeLOpkiY+4W7CY5NP9n2QQEDg6q/pa2YydzvBBhK/+LOqbttG5uEghgv3bjzw9VTzZrij3SmMUermxBNXJAS9zLxIYira2ajhYm+1KdU6WUrc0WD8gr65zFkUd0U/U2meFZmME50ablY6XItc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayJmz3zY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayJmz3zY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C2F1F000C4;
	Sat, 17 Oct 2026 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256499;
	bh=3TGn+hNhS7uzY97fgJWIWQvvTqMNkuicqxB9lBGWLBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayJmz3zYYNMjq/Uk3wEQaNdEq/phmOqRW4amqnZOZ1GCGyKS+0szLXok3NdkU9NwC
	 0rXnmLzc/F7oHC72r4SApvVXIUyVT4yIpZrWG54jdBvoDvMzd4AQBy4BCc81BIhe5g
	 wx81iApovf9C/OmhmEDWOs5hm1SuIDhxTUmfVy60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baha Mesleh <baha.mesleh@nokia.com>,
	Subrat Pandey <subratp@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0213/1674] octeontx2-af: mcs: Fix SC resource cleanup loop
Date: Sat, 17 Oct 2026 17:41:25 +0200
Message-ID: <20261017160436.617039384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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



