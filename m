Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F11265CCD;
	Tue, 30 Sep 2025 14:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243785; cv=none; b=D1x79C8D8fsLTXlKGhs9q5fhsDBjgxGx/5g0zkX4mdgAGNiTTNZyiuN5tm+Cdt14paK2/UgYbbh7pRm6hUsBqUegQ0+DR8vkezKYAiBwtAbXfefpJve4Id8T6pRg5fLFHbFAJNzGCSBIPgKMvF6wDtAwFe2FQtRdYD+GK4VfskE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243785; c=relaxed/simple;
	bh=Ge6TIYYL2JIMOAeg7hBQdP1vy7mwhd4X5c5KdIcxz0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho0CZ47tQxX0YgMhtnPwNCTcCNAPHETH3kA6sv245+vLy+AAhbtmx0gI3c8PMP0FwtoUQ5th7bX+9TdUmXMTFzscZKF1rSBm7AbhAXIujktpsEcwVpUeF3BKss6sDVfSEhxwM0vUlrR249Z6BnJ9PuwcKwUjofd7fRhBXvQPRwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFB/9MIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFB/9MIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3190EC4CEF0;
	Tue, 30 Sep 2025 14:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243784;
	bh=Ge6TIYYL2JIMOAeg7hBQdP1vy7mwhd4X5c5KdIcxz0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFB/9MICWEQjhQgbWnXF2NGc53SedPfQi6Quzhk6mm3NbS3JpO4DMXk7v5ksdLWeD
	 4q5Bx3X4hJvwO8Z3GOgk53Sm1pMFiDbWWYA9aWHAZAJ/uRdLzCo0gfpwnCQfaHCzLp
	 wz0Eh9D+HXxU3hlq7wjNtUfKzSMfAoUEE1dDKa4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Richard Leitner <richard.leitner@skidata.com>,
	Simon Horman <horms@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/81] net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()
Date: Tue, 30 Sep 2025 16:46:19 +0200
Message-ID: <20250930143820.389214130@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 03e79de4608bdd48ad6eec272e196124cefaf798 ]

The function of_phy_find_device may return NULL, so we need to take
care before dereferencing phy_dev.

Fixes: 64a632da538a ("net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Richard Leitner <richard.leitner@skidata.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250904091334.53965-1-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f8a0966332805..7b2ab0cc562cc 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2018,7 +2018,8 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
 		 */
 		phy_dev = of_phy_find_device(fep->phy_node);
 		phy_reset_after_clk_enable(phy_dev);
-		put_device(&phy_dev->mdio.dev);
+		if (phy_dev)
+			put_device(&phy_dev->mdio.dev);
 	}
 }
 
-- 
2.51.0



