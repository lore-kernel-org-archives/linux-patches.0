Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642FA2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0432C433EF;
	Tue, 18 Apr 2023 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822328;
	bh=GKB3CvPjbC66XIIeCxgUIgQb5ZQ3aGJWM4MYC0VZ5zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v78QfirPp9HmvcXbT+AUTWjtzHXfIPST0Foe5nv+9u+Hbh87Y0bnfPcXl+8XNP2ez
	 M9kFfF2lygiQV2zyHSLbSy5xQpgoSD4sniXPLEOL9Pm9nxkkDPHVP/Lp2xXyumZVXB
	 CBOacg/kyyLwSB92vve+SNByFoiLMZNBl3EUdR1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.2 109/139] net: phy: nxp-c45-tja11xx: add remove callback
Date: Tue, 18 Apr 2023 14:22:54 +0200
Message-Id: <20230418120317.871736126@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

commit a4506722dc39ca840593f14e3faa4c9ba9408211 upstream.

Unregister PTP clock when the driver is removed.
Purge the RX and TX skb queues.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1337,6 +1337,17 @@ no_ptp_support:
 	return ret;
 }
 
+static void nxp_c45_remove(struct phy_device *phydev)
+{
+	struct nxp_c45_phy *priv = phydev->priv;
+
+	if (priv->ptp_clock)
+		ptp_clock_unregister(priv->ptp_clock);
+
+	skb_queue_purge(&priv->tx_queue);
+	skb_queue_purge(&priv->rx_queue);
+}
+
 static struct phy_driver nxp_c45_driver[] = {
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
@@ -1359,6 +1370,7 @@ static struct phy_driver nxp_c45_driver[
 		.set_loopback		= genphy_c45_loopback,
 		.get_sqi		= nxp_c45_get_sqi,
 		.get_sqi_max		= nxp_c45_get_sqi_max,
+		.remove			= nxp_c45_remove,
 	},
 };
 


