Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116C1168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41698C433D2;
	Mon,  8 May 2023 11:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544624;
	bh=Ogtcnyue6WqY7ThmAQjKC9J+kmtZ4GOChl8A33PQCm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EpBK6S6deup6i/bv5bT84gAcBIuzb/fZOQKR1Cz8Z2qXAi8Sz8gMcvuvx6IvSjKM8
	 x91EYu9nP9OKR4TfmLO5RzSPnQBUh1z5lhNI+CNitT57IQ2NHYBRR57NbeQ5UVAbrM
	 gEAnRDYjoeqsAN0HkjInN7Ux3ytHQif+G0dyAoxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Yan Wang <rk.code@outlook.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 470/694] net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports
Date: Mon,  8 May 2023 11:45:05 +0200
Message-Id: <20230508094449.035771731@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yan Wang <rk.code@outlook.com>

[ Upstream commit 35226750f7ab9d49140d95bc7d38a2a9b0f4fdfc ]

The system hang because of dsa_tag_8021q_port_setup()->
				stmmac_vlan_rx_add_vid().

I found in stmmac_drv_probe() that cailing pm_runtime_put()
disabled the clock.

First, when the kernel is compiled with CONFIG_PM=y,The stmmac's
resume/suspend is active.

Secondly,stmmac as DSA master,the dsa_tag_8021q_port_setup() function
will callback stmmac_vlan_rx_add_vid when DSA dirver starts. However,
The system is hanged for the stmmac_vlan_rx_add_vid() accesses its
registers after stmmac's clock is closed.

I would suggest adding the pm_runtime_resume_and_get() to the
stmmac_vlan_rx_add_vid().This guarantees that resuming clock output
while in use.

Fixes: b3dcb3127786 ("net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Yan Wang <rk.code@outlook.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d7fcab0570322..f9cd063f1fe30 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6350,6 +6350,10 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(priv->device);
+	if (ret < 0)
+		return ret;
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -6357,16 +6361,18 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	ret = stmmac_vlan_update(priv, is_double);
 	if (ret) {
 		clear_bit(vid, priv->active_vlans);
-		return ret;
+		goto err_pm_put;
 	}
 
 	if (priv->hw->num_vlan) {
 		ret = stmmac_add_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto err_pm_put;
 	}
+err_pm_put:
+	pm_runtime_put(priv->device);
 
-	return 0;
+	return ret;
 }
 
 static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
-- 
2.39.2



