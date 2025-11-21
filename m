Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D2F33506C;
	Fri, 21 Nov 2025 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731029; cv=none; b=dn1kEfxlfvm4aIcFloT5XVpZRweMNP2teyK2bAq1IhF9sxgmL7ET2k4ILLXj9TLAdaCqlZU/wGouDiw8zIGGEU12acoCjXFgG+y30dkweOQowYoyGJ9bJT6vNHLTTC4Oke33dYZBX/pY3v6J2gmA8OL8zvls30zSjHKTqoB/SO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731029; c=relaxed/simple;
	bh=CwVs4SjtVGIhPxuUwRMxfhCseMNcrYwDFq/nW3FuvqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qO8//bjVghQt2bma+GFyIjP4UvnxkXoySXW+L1pwKozcSzNfDger1F485FFnWHyuo3suwpKrg426QtA6K+/tDFzqh73Jm7GxCUv/7aeYzR++aI/D+PHfmWT7nmmlYw0WyYSgHZNF90ba7ssRDN3VSuQ5Pr4wnUb36cfyk6qfmn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNyrvila; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNyrvila"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F440C4CEF1;
	Fri, 21 Nov 2025 13:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731028;
	bh=CwVs4SjtVGIhPxuUwRMxfhCseMNcrYwDFq/nW3FuvqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNyrvilaqnghY9jWTLOzHZJeB8nFtPjhkx+6ktyKiLRe4mU2tfunI/z+SaAvQfnny
	 q1W37ihV6Im3XU2Ku1am1ec6nhtBvFc9EhRIEuIAlVdfXt4ccXC/yOSaoyhp13O5/e
	 tJlc3hV8rZt7ndlNCw1W1sTkcRz2stg+JehnFrcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 065/247] net: ethernet: ti: am65-cpsw-qos: fix IET verify/response timeout
Date: Fri, 21 Nov 2025 14:10:12 +0100
Message-ID: <20251121130156.935355327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit 49b3916465176a5abcb29a0e464825f553d55d58 ]

The CPSW module uses the MAC_VERIFY_CNT bit field in the
CPSW_PN_IET_VERIFY_REG_k register to set the verify/response timeout
count. This register specifies the number of clock cycles to wait before
resending a verify packet if the verification fails.

The verify/response timeout count, as being set by the function
am65_cpsw_iet_set_verify_timeout_count() is hardcoded for 125MHz
clock frequency, which varies based on PHY mode and link speed.

The respective clock frequencies are as follows:
- RGMII mode:
  * 1000 Mbps: 125 MHz
  * 100 Mbps: 25 MHz
  * 10 Mbps: 2.5 MHz
- QSGMII/SGMII mode: 125 MHz (all speeds)

Fix this by adding logic to calculate the correct timeout counts
based on the actual PHY interface mode and link speed.

Fixes: 49a2eb9068246 ("net: ethernet: ti: am65-cpsw-qos: Add Frame Preemption MAC Merge support")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
Link: https://patch.msgid.link/20251106092305.1437347-2-a-garg7@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index fa96db7c1a130..ad06942ce461a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -276,9 +276,31 @@ static int am65_cpsw_iet_set_verify_timeout_count(struct am65_cpsw_port *port)
 	/* The number of wireside clocks contained in the verify
 	 * timeout counter. The default is 0x1312d0
 	 * (10ms at 125Mhz in 1G mode).
+	 * The frequency of the clock depends on the link speed
+	 * and the PHY interface.
 	 */
-	val = 125 * HZ_PER_MHZ;	/* assuming 125MHz wireside clock */
+	switch (port->slave.phy_if) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (port->qos.link_speed == SPEED_1000)
+			val = 125 * HZ_PER_MHZ;	/* 125 MHz at 1000Mbps*/
+		else if (port->qos.link_speed == SPEED_100)
+			val = 25 * HZ_PER_MHZ;	/* 25 MHz at 100Mbps*/
+		else
+			val = (25 * HZ_PER_MHZ) / 10;	/* 2.5 MHz at 10Mbps*/
+		break;
+
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_SGMII:
+		val = 125 * HZ_PER_MHZ;	/* 125 MHz */
+		break;
 
+	default:
+		netdev_err(port->ndev, "selected mode does not supported IET\n");
+		return -EOPNOTSUPP;
+	}
 	val /= MILLIHZ_PER_HZ;		/* count per ms timeout */
 	val *= verify_time_ms;		/* count for timeout ms */
 
-- 
2.51.0



