Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3AB29B795;
	Wed, 17 Sep 2025 12:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112957; cv=none; b=YsHns8jpHeGpjYsbvF92q6NwZtDMDhC6/a51nEBBanLZfPY0uC0JI6W2PtBU+NEhiUBLYpoz3COn0nGAiLuHbNihg8Srg6OpFBEbP+S8kXMeJZyqhvqggGFX/mHKQBHfYe0a6JmNE6Onp0ldi+Elo/R9EPSgPSvKZ4gJtq/Yy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112957; c=relaxed/simple;
	bh=78bEsefXFXYkAGYJlFSn+fpve5onxg9EoyyraJp9wgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjgpewGm8PcZrTpgU0e6JTUFEylHEIMbdmdLOhbNqwp7zgMPVfDX7uV2yBK8ecNZQI59/BNje3ipH3xAgkJDeUBBcsh9NToDNxKtbadc1M6znrU+NqWdTW/jkN6ySF3dElN3XwmAloI929eyBNEbs4llbzu0ArRUis2WFD5s6ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DK4FvDuo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DK4FvDuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2C5C4CEF0;
	Wed, 17 Sep 2025 12:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112957;
	bh=78bEsefXFXYkAGYJlFSn+fpve5onxg9EoyyraJp9wgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DK4FvDuoof+7Cjajr8/Yx1s1nnxa4OFu+ANkUJTawSU0WWUbtNw6OhqTkiTkd8hqj
	 3u5Wx+1wnkl9SqFTFJX5ATZi/5buoYEhtvq7FTPJrIp6JaerLUUFkVtWB/jN2/PYJx
	 p6K4ko7qsEKGFY241Ikl7mpbxbeV5ND2JzI4kP4w=
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
Subject: [PATCH 6.16 127/189] net: fec: Fix possible NPD in fec_enet_phy_reset_after_clk_enable()
Date: Wed, 17 Sep 2025 14:33:57 +0200
Message-ID: <20250917123354.963294454@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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
index 651b73163b6ee..5f15f42070c53 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2358,7 +2358,8 @@ static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
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



