Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD90414288
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utqg3tz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CCFC433C8;
	Mon, 16 Oct 2023 14:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467910;
	bh=BGs4Idmz5a05ffSKhjj2AtiwX6Qh0+wa99pz8YmarJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utqg3tz3q+F4Ogt0WYX4d8oak2bIqmHLuBALG05O48kLkMByIrhRnKjcuV5XxmWcb
	 fpLlGWZ5JzZ1uBMp1mBDUOizUGBi8fymTK4econ1P051p7lF6aEUKRgwp6H+SJ3Pm9
	 HXUwBA5qVwukvjduoYo9ZMdu2RtJzuG8kuSL0MP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 089/191] rswitch: Fix renesas_eth_sw_remove() implementation
Date: Mon, 16 Oct 2023 10:41:14 +0200
Message-ID: <20231016084017.473808697@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 510b18cf23b9bd8a982ef7f1fb19f3968a2bf787 ]

Fix functions calling order and a condition in renesas_eth_sw_remove().
Otherwise, kernel NULL pointer dereference happens from phy_stop() if
a net device opens.

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 660cbfe344d2c..5024ce9587312 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1942,15 +1942,17 @@ static void rswitch_deinit(struct rswitch_private *priv)
 	rswitch_gwca_hw_deinit(priv);
 	rcar_gen4_ptp_unregister(priv->ptp_priv);
 
-	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
+	rswitch_for_each_enabled_port(priv, i) {
 		struct rswitch_device *rdev = priv->rdev[i];
 
-		phy_exit(priv->rdev[i]->serdes);
-		rswitch_ether_port_deinit_one(rdev);
 		unregister_netdev(rdev->ndev);
-		rswitch_device_free(priv, i);
+		rswitch_ether_port_deinit_one(rdev);
+		phy_exit(priv->rdev[i]->serdes);
 	}
 
+	for (i = 0; i < RSWITCH_NUM_PORTS; i++)
+		rswitch_device_free(priv, i);
+
 	rswitch_gwca_ts_queue_free(priv);
 	rswitch_gwca_linkfix_free(priv);
 
-- 
2.40.1



