Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8A2311C35;
	Tue,  2 Sep 2025 13:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819956; cv=none; b=VpgJAMd0Kkb3LRmpNNrnxJAflhvhZ1sS3NuakHmj5UwCBq2e7tm+U1sclYszaac3afpGKn1hyl6QIRtXTftmwdYdA938DDgNUMy9+5ueBJjJpKCjU/AuCMwcKFgeIjyf9Cpc/em55eI/XfDocYQGEFs8GbdTiFBCu8kMnyeGmaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819956; c=relaxed/simple;
	bh=4lbf9oHwBxRRb6TakzCRbGD+E11EfFjFRkzsRQzKeTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlixvBZfeoanHsoQi9lBtJH2D0ehE365IjDTvtn90En1WhIXatUGQzOkTs2aMG71/0uzDORuEmKjDbtt8x1o4tAeUiHdGxF5ODPUpJe7jKFdyUKFDr/J3VyUGanvpvCxdSTbQWLnpMfbWhG/V0aecHejFICL7qX/yGjaOVgAUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rv/4j79F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rv/4j79F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8F4C4CEED;
	Tue,  2 Sep 2025 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819956;
	bh=4lbf9oHwBxRRb6TakzCRbGD+E11EfFjFRkzsRQzKeTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rv/4j79F1QPf0Lk0w8PrmEqevNpT0eJWsIcMbS175U6BHrxZzTFM3OEYqedzpPr0C
	 3wdk0+5FLDaLGyNEIJORm8N1YNyGBfZzcgwHofGG37G+h5RacEkV800+StYZ86F+cF
	 sPhI0K0VZmzXQRKKLoDSlpeIgNADvI532bUMn0CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 47/95] bnxt_en: Fix stats context reservation logic
Date: Tue,  2 Sep 2025 15:20:23 +0200
Message-ID: <20250902131941.407490297@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b8c6087a5c31e..08886c3a28c61 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7780,7 +7780,8 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
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



