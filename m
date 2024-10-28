Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91902AF07;
	Mon, 28 Oct 2024 06:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098148; cv=none; b=UpU2/oZq/AJkMLiSc/6HlXCA5hCY6minaewVnFrsqAPK91r4MJ8egNaxYikTkIwEUhtC/Ht72bgqDhKVkcvzVym8YMfvjVQsQvANxAleiTv0DqStB4MsYKM3F+IYeqPnF2y0ytW9f0p8LFBwl/iU40WSfwQEOtatXqIG6m46bIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098148; c=relaxed/simple;
	bh=qdv3MrGmrzToV/C9onyWWxQQeZjTOl8abDpeGuOggT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrEbF5/qblUa9B+Dp1vk0qpZIUlYzbuQZ3I2dMaqJcHxhDEAEJ6QjRCl+hfAHXbIXuyV4mafTqlQoy+Qu72DIBWFPfPagc+zW0RNfvUvoNFb6a/voTND/Dk35qBVfCPrHVIHDV9sNey0SJML6N48Z117trC7kwwzw3Q5QM+Mrhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKYjyIG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKYjyIG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671AEC4CEC3;
	Mon, 28 Oct 2024 06:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098148;
	bh=qdv3MrGmrzToV/C9onyWWxQQeZjTOl8abDpeGuOggT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKYjyIG3+tWsxHpuP69qulotB3Beq6MEQby8npHzWs5Awl4PGsSX+067D8jp8cctF
	 FDynhlh2D6rMN0y+auaEfDHqi2ye9ve2KydZqt+QdhNqkIg2EEPybYTFT1CRgqMkrG
	 9s+0cFEa5CtvuiSPiK9G3BQX77J3IURWa9Xvnqsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paritosh Dixit <paritoshd@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 061/261] net: stmmac: dwmac-tegra: Fix link bring-up sequence
Date: Mon, 28 Oct 2024 07:23:23 +0100
Message-ID: <20241028062313.558202569@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 362f85136c3ef..6fdd94c8919ec 100644
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



