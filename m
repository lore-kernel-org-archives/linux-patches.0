Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B481441A575;
	Tue, 21 Jul 2026 19:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662796; cv=none; b=bqYQFCF1pz9vQnnEAb5wojszMS0Z0BXgEqDhGDobYHRa+xCwCcPl1M/JmbKJQRgW5Lo/mDIeghM42o8sQilmOHqrXuLwaCaXy6Oa4cZWoMw2lLqZCPDZPsR6GgVNfnLjjmktfffcYy/EhdLtsG+CjgcxrYRmiWjYMlRW69D7JlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662796; c=relaxed/simple;
	bh=obevhhXlBdvf7yz2FWbKadLpRlFiGIR0GEqfnjlFqxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxL1HA8Lx8EeGOmHlfCpSZKqL4OddrGJuD25lE/IQGYcgZNq0ze7lMfinYtOmpKUj6lc5bHH/ktQWcyAmNIQI+N41HuS/jor5dwKl7dMnqPx25LUmdUUR1B+1cERgm1+jsgTicBrofU64aGEucM3+YP7AR7/Sb1ivICDstN1d/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wbmoVUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wbmoVUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278791F000E9;
	Tue, 21 Jul 2026 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662795;
	bh=VQE+RUVNG6lzMzyIct5de5gyJfgaiSgh5ufWp2Fsc/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wbmoVUgxbgBKcSW2gyK9qnjZDZD+jOW0sHpJhfo/+grj4RQQLT6T1/vILXtW96Ea
	 ZwoBzzLbGRdXzCm1cD4J/pjQNKRVTJk2PYZTMe/BFQ68aW38DgtZvq2O1Vovl2cNMP
	 ZtItWqsevgk++vZbggsh0BPpHffWldf/C3YUiQKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0580/1276] dpaa2-switch: fix VLAN upper check not rejecting bridge join
Date: Tue, 21 Jul 2026 17:17:03 +0200
Message-ID: <20260721152459.094749066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit ed2294f94e34e97342850c40b320833d881c3819 ]

The blamed commit refactored the prechangeupper event handling but
failed to actually return an error in case
dpaa2_switch_prevent_bridging_with_8021q_upper() detected a 802.1q upper
on a port which tries to join a bridge. Fix this by returning err
instead of 0.

Fixes: 45035febc495 ("net: dpaa2-switch: refactor prechangeupper sanity checks")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260616105430.3725910-1-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index a7c8ec0bdfe53f..5faf48a63c857c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2176,7 +2176,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot join a bridge while VLAN uppers are present");
-		return 0;
+		return err;
 	}
 
 	netdev_for_each_lower_dev(upper_dev, other_dev, iter) {
-- 
2.53.0



