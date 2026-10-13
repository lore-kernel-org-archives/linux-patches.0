Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1254FC8D7;
	Tue, 13 Oct 2026 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892687; cv=none; b=msaLAJYvgagPepFVx0uBbqUT2Sd6czw0Fuuef+n69jqPakTMDzsXgDkEf0A6u4Iq6S1uh2u221aVyI1HbPB42p2GcQScOZDp4BPhI9DattUbJL/Gi4bdlfi/iHQmWkihuYViZ81e2aYnu1HH/BoRfv4laKq0rgW9GwirnZ4hViQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892687; c=relaxed/simple;
	bh=a81qEbcm7DW9DsMWlWVLYjtPkNuA6RTfoHkD6fvr1/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6RcSwpozfkWH/oaC6QsGEdoylHRw40k34k+2adgq5NVj8TYjEMNn5saLiE4Rkxky7tVefKsGuDLROCaZaklIjnmO8wTHRw2ZcsN+CtbxccXfVu67PytGZHMCpY6IcWCt1N4MyVBpOEEIObN8XQa9h1ERcwHPl/Vg4GriIuq2fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpENZaSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpENZaSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659BC1F00898;
	Tue, 13 Oct 2026 11:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892683;
	bh=T1+UjkvQgBOsyDmdqp/2UvMlCxaM1BOFNwKsPGsMkNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpENZaSpQAPQw4muylONJSQxGytNKtWkmevAGG8dX7Fid5q6IDXlBu/JzTCQbeSt3
	 OuA5el2GJOyS2ZvUJiC14IoojEZJkZ9MOWDRDrkISo/7HHA+Bs+LkKSN4ERWdhQw79
	 2RrmsBKChfqz5q9sZVtzZ+7IvCQmWiPFOUCNKH+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 254/281] net: bcmgenet: if UMAC was suspended in SW_RESET, restore it to SW_RESET
Date: Tue, 13 Oct 2026 13:39:30 +0200
Message-ID: <20261013112901.305876284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit 5857e5a196b069766a39ceb754736326a43bc6bc ]

When the revised suspend/resume sequence was introduced this led to an edge
case where the TX is left disabled in the following sequence.

1. phy link is down, so UMAC is held in reset and then network interface
   is WoL enabled
2. Enter suspend, bcmgenet_wol_power_down_cfg() enables UMAC_RX since MAC
   is in SW_RESET
4. Enter resume, UMAC_RX is left enabled. Since we only enable UMAC_TX
   and UMAC_RX in SW_RESET. The UMAC_TX is never enabled again on link up.

The issue was hit in production and I verified the sequence keeps
the TX  disabled in my standalone test. I tested on an internal
development board with bcm77122, but should be reproducible
on any genet HW that supports power management.

Fixes: 254f3239dd07 ("net: bcmgenet: revise suspend/resume")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260930230634.3132729-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 96d5d4f7f51fe..984432952963a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -253,6 +253,17 @@ int bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+
+	/*
+	 * Mirror wol_power_down_cfg(). If only UMAC_RX
+	 * is enabled, then we must place the UMAC back
+	 * into SW_RESET.
+	 */
+	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if ((reg & CMD_RX_EN) && !(reg & CMD_TX_EN)) {
+		reg |= CMD_SW_RESET;
+		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	}
 	spin_unlock_bh(&priv->reg_lock);
 
 	/* Resume link status tracking */
-- 
2.53.0



