Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421A2322524;
	Mon, 18 Aug 2025 13:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523072; cv=none; b=MDkfmNIGkgeDyKbvYV8cgd2P71caEY/+58Pb/A8yLtwEh/pyP/IAO9bM7EZlGCNMBO9HRxJK4Gt5Y1DZu/FTxqOy15XXaoz0iE1r4uEHGFB61rI3pizVcqtmWiU5hYjUDTd29oKX71cLJCbJC5OA6WzsSH24lQFLMdHKJjzQd4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523072; c=relaxed/simple;
	bh=E/nIv9U7dyBInUs9ktNzuWz1/gLxS/1lU4Z8SUy5ZfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhQtKMdVj0xbuqxxIuONE9o6XBCu2qMvr5h1rQ+ZIooXXG4poa4q2YX34Pk7uFscfgmKpkw2s5n4Cnx56Z5iPSLRvvAxdTUd7PvKXs5Ls/bZoqfMdv1uLzyYlgkoqf1cmVby7qAWiKCFbr9EVOWRgWr/PaR2uUH8e7KxsA5nnXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPxHDPz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPxHDPz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A8DC113D0;
	Mon, 18 Aug 2025 13:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523072;
	bh=E/nIv9U7dyBInUs9ktNzuWz1/gLxS/1lU4Z8SUy5ZfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPxHDPz3lf/mzEm+73h9xxq1uk2Af0Id2RC85UwOHsTZCV2YeyDAoZQjjapBMF+Yf
	 h4TxsM7oweIgNIQ3pDT+b662x7SssBYBVYuRSKpNbdGgWEorN08AjiZwoq8VsQ97Px
	 8USAuy2AxfelPG+0HrRyyVAsnY8I3IZMT8lRZOK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 063/515] net: ti: icssg-prueth: Fix emac link speed handling
Date: Mon, 18 Aug 2025 14:40:49 +0200
Message-ID: <20250818124500.834119196@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 06feac15406f4f66f4c0c6ea60b10d44775d4133 ]

When link settings are changed emac->speed is populated by
emac_adjust_link(). The link speed and other settings are then written into
the DRAM. However if both ports are brought down after this and brought up
again or if the operating mode is changed and a firmware reload is needed,
the DRAM is cleared by icssg_config(). As a result the link settings are
lost.

Fix this by calling emac_adjust_link() after icssg_config(). This re
populates the settings in the DRAM after a new firmware load.

Fixes: 9facce84f406 ("net: ti: icssg-prueth: Fix firmware load sequence.")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Message-ID: <20250805173812.2183161-1-danishanwar@ti.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index 2f5c4335dec3..008d77727400 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -50,6 +50,8 @@
 /* CTRLMMR_ICSSG_RGMII_CTRL register bits */
 #define ICSSG_CTRL_RGMII_ID_MODE                BIT(24)
 
+static void emac_adjust_link(struct net_device *ndev);
+
 static int emac_get_tx_ts(struct prueth_emac *emac,
 			  struct emac_tx_ts_response *rsp)
 {
@@ -266,6 +268,10 @@ static int prueth_emac_common_start(struct prueth *prueth)
 		ret = icssg_config(prueth, emac, slice);
 		if (ret)
 			goto disable_class;
+
+		mutex_lock(&emac->ndev->phydev->lock);
+		emac_adjust_link(emac->ndev);
+		mutex_unlock(&emac->ndev->phydev->lock);
 	}
 
 	ret = prueth_emac_start(prueth);
-- 
2.50.1



