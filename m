Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E53A304BA0;
	Tue,  2 Sep 2025 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819580; cv=none; b=g+Rlv0y64v2ack6kvqHV8ZDgFu8wJSm7TqWYTNhDliijyVIZUT1ZU4m7u4uZJpy77cpe7A590YSV5SVNaq4jEn+KaNl30pFFE6lDBYGDWnjwaznUpr8MwgBV7R+5eVS9BumBt4XBY2FdbOptvhYNQEnxk3gvzweHkvBOswZxZyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819580; c=relaxed/simple;
	bh=FwrBufRPBB/bgWe1E4Nx1hngGA84TO5swkPjlg/B4UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDLrzGNOxLwv/fIaLQwSDC5/cETwyWEtfWqL3K2AQMytbIReK7uat50DiFwMlpmiYpPmRKXNW8WbdW6r21NPMCzBWNZwsW1GLz2QpE8LL9VZxVm5F1W+cudMne5nO8vqEceLrY6jyhtxMCy9LMU23yRZXzuIBZ3ZEkF2TAHfPkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTq+M6Aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTq+M6Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A108C4CEFD;
	Tue,  2 Sep 2025 13:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819579;
	bh=FwrBufRPBB/bgWe1E4Nx1hngGA84TO5swkPjlg/B4UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTq+M6Awmnhh0CFuzZYEkL5ikkUim388XfV3D3HmJM+jyfxyxbUpZJZ12LMUDZj90
	 p4O1mCHusWUYanVkMJuan6E9NLBZsNqBEzLk6KJO74CwRcJj7wt33KEd3r0NKZZtcS
	 Z9MivspBnWDf5QGQxFKM2ieRVNNuMpvyzJ7Ia8QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 077/142] bnxt_en: Fix stats context reservation logic
Date: Tue,  2 Sep 2025 15:19:39 +0200
Message-ID: <20250902131951.220030366@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit b4fc8faacfea2538184a1dbd616ae9447a361f3d ]

The HW resource reservation logic allows the L2 driver to use the
RoCE resources if the RoCE driver is not registered.  When calculating
the stats contexts available for L2, we should not blindly subtract
the stats contexts reserved for RoCE unless the RoCE driver is
registered.  This bug may cause the L2 rings to be less than the
number requested when we are close to running out of stats contexts.

Fixes: 2e4592dc9bee ("bnxt_en: Change MSIX/NQs allocation policy")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250825175927.459987-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5360c42ad409c..cb76ab78904fc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8009,7 +8009,8 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 	}
 	rx_rings = min_t(int, rx_rings, hwr.grp);
 	hwr.cp = min_t(int, hwr.cp, bp->cp_nr_rings);
-	if (hwr.stat > bnxt_get_ulp_stat_ctxs(bp))
+	if (bnxt_ulp_registered(bp->edev) &&
+	    hwr.stat > bnxt_get_ulp_stat_ctxs(bp))
 		hwr.stat -= bnxt_get_ulp_stat_ctxs(bp);
 	hwr.cp = min_t(int, hwr.cp, hwr.stat);
 	rc = bnxt_trim_rings(bp, &rx_rings, &hwr.tx, hwr.cp, sh);
-- 
2.50.1



