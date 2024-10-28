Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F9D2C697;
	Mon, 28 Oct 2024 06:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097568; cv=none; b=HPOnL4QfIXI8E25aYA3uZw838zkgZzrASGKE6VVcIINROmtG5q7FF9vcjXbmFacniVRTI+owuyAp2zNO5/t3fXJdcOAiQdodPhZMYfB91gFZwxAEk5Bie3W1CG1Ns08euI5evDpLA6Pmxv8XCh/BI8SrHEF6XdvFOM86YvUT6XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097568; c=relaxed/simple;
	bh=8aY7LsJtNdLbstKGwVKGe9LuuWqQbJ/Nb1fgeKWT5oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XaJrMwq2lQWQ89918+PLA6TugNcgR01EYrR8+d0btjQ9QoDhHoUemfI/wDs8/aLqFZRonzCe27uDlD2N+if0DU1hZ0B1R9aoWWaXzbsLEfOfJG3MYDbqWKwjwMKx74+L072FlzFoeTKaHHjCsXlOC/cQ48UemVzH6wfanMikNLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1/ZwZLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1/ZwZLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5499FC4CEC3;
	Mon, 28 Oct 2024 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097568;
	bh=8aY7LsJtNdLbstKGwVKGe9LuuWqQbJ/Nb1fgeKWT5oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1/ZwZLkkqzfcbnzm7eCNimjyjSD/36e87ElHIMC4AhhfBq5JkaMi8h4CEhDnNih7
	 UJz9c+phQXZRYq8PLL5pMFgCHXo0M8HNWMeXFHBGVBZuaBQfrag9wg0uRa3FgtVb9/
	 KPA+yjyQneQzYcIf0dlStt7c1n4fjsc/daw0Su2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paritosh Dixit <paritoshd@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/208] net: stmmac: dwmac-tegra: Fix link bring-up sequence
Date: Mon, 28 Oct 2024 07:23:50 +0100
Message-ID: <20241028062307.890234845@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paritosh Dixit <paritoshd@nvidia.com>

[ Upstream commit 1cff6ff302f5703a627f9ee1d99131161ea2683e ]

The Tegra MGBE driver sometimes fails to initialize, reporting the
following error, and as a result, it is unable to acquire an IP
address with DHCP:

 tegra-mgbe 6800000.ethernet: timeout waiting for link to become ready

As per the recommendation from the Tegra hardware design team, fix this
issue by:
- clearing the PHY_RDY bit before setting the CDR_RESET bit and then
setting PHY_RDY bit before clearing CDR_RESET bit. This ensures valid
data is present at UPHY RX inputs before starting the CDR lock.
- adding the required delays when bringing up the UPHY lane. Note we
need to use delays here because there is no alternative, such as
polling, for these cases. Using the usleep_range() instead of ndelay()
as sleeping is preferred over busy wait loop.

Without this change we would see link failures on boot sometimes as
often as 1 in 5 boots. With this fix we have not observed any failures
in over 1000 boots.

Fixes: d8ca113724e7 ("net: stmmac: tegra: Add MGBE support")
Signed-off-by: Paritosh Dixit <paritoshd@nvidia.com>
Link: https://patch.msgid.link/20241010142908.602712-1-paritoshd@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
index e0f3cbd36852e..e2d61a3a7712d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
@@ -127,10 +127,12 @@ static int mgbe_uphy_lane_bringup_serdes_up(struct net_device *ndev, void *mgbe_
 	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_AUX_RX_IDDQ;
 	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 
+	usleep_range(10, 20);  /* 50ns min delay needed as per HW design */
 	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_SLEEP;
 	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 
+	usleep_range(10, 20);  /* 500ns min delay needed as per HW design */
 	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_CAL_EN;
 	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
@@ -143,22 +145,30 @@ static int mgbe_uphy_lane_bringup_serdes_up(struct net_device *ndev, void *mgbe_
 		return err;
 	}
 
+	usleep_range(10, 20);  /* 50ns min delay needed as per HW design */
 	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_DATA_EN;
 	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 
 	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
-	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY;
 	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 
+	usleep_range(10, 20);  /* 50ns min delay needed as per HW design */
 	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
-	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
+	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
 	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 
+	usleep_range(10, 20);  /* 50ns min delay needed as per HW design */
 	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 	value |= XPCS_WRAP_UPHY_RX_CONTROL_RX_PCS_PHY_RDY;
 	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
 
+	msleep(30);  /* 30ms delay needed as per HW design */
+	value = readl(mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+	value &= ~XPCS_WRAP_UPHY_RX_CONTROL_RX_CDR_RESET;
+	writel(value, mgbe->xpcs + XPCS_WRAP_UPHY_RX_CONTROL);
+
 	err = readl_poll_timeout(mgbe->xpcs + XPCS_WRAP_IRQ_STATUS, value,
 				 value & XPCS_WRAP_IRQ_STATUS_PCS_LINK_STS,
 				 500, 500 * 2000);
-- 
2.43.0



