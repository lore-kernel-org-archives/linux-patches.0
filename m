Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C281431B81D;
	Mon, 27 Oct 2025 19:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591849; cv=none; b=BEvmVOh0iMr5Sc57uizGhlTRX+iYRPrxfo5+5dSsfjp6ZaorYsbqO3COyL68uzuvSYK45qr2pf1UTniwYC1bElvXgp+/tpD+jE06RVk1lXkFRq4xtQaFZpRtHQah3TNCJh0lQCKCdRkxDo3xrWvrM+DtfHD/6YdNUIxbfooAH10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591849; c=relaxed/simple;
	bh=V3RdiXDsVxN8DDxEFVX3yUm8PVf5O1QkNQBdj0E9qqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qyl3sOK0w0Rd7ZzbAhQz+QjhLkeBgIkKHler/ci8TbWeKDgCVjiAhBsxkseTQbTqDIeFxAT0vdradN4mOYQ76D12BxNS3fF4ClPf7wK3ZYFkVPr0FtAVMteEhd8vcAs/auEYiqRGEw038XLNDlWGFlmUbYEIH4J0eXNlGzId5r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtXl/cO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtXl/cO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3BDC4CEF1;
	Mon, 27 Oct 2025 19:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591849;
	bh=V3RdiXDsVxN8DDxEFVX3yUm8PVf5O1QkNQBdj0E9qqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtXl/cO4AmraGn2x+urnUBDdgvS/2+C2a7fjp5YOjuRfCPqla2oXb6mt9slsyAfIA
	 SAKwTU/lSwqNll8X7BcrO8zJLGRD2dpSp8wtzILex1q7cDNmKmvclasp2eUTXxg8rW
	 Lv3vg+nNCpKIEAWADKQR4AzkhSPJQhPaUHkW4jVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/123] amd-xgbe: Avoid spurious link down messages during interface toggle
Date: Mon, 27 Oct 2025 19:35:01 +0100
Message-ID: <20251027183446.966932312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 2616222e423398bb374ffcb5d23dea4ba2c3e524 ]

During interface toggle operations (ifdown/ifup), the driver currently
resets the local helper variable 'phy_link' to -1. This causes the link
state machine to incorrectly interpret the state as a link change event,
resulting in spurious "Link is down" messages being logged when the
interface is brought back up.

Preserve the phy_link state across interface toggles to avoid treating
the -1 sentinel value as a legitimate link state transition.

Fixes: 88131a812b16 ("amd-xgbe: Perform phy connect/disconnect at dev open/stop")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Link: https://patch.msgid.link/20251010065142.1189310-1-Raju.Rangoju@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index af04c035633ff..32397517807b0 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1172,7 +1172,6 @@ static void xgbe_free_rx_data(struct xgbe_prv_data *pdata)
 
 static int xgbe_phy_reset(struct xgbe_prv_data *pdata)
 {
-	pdata->phy_link = -1;
 	pdata->phy_speed = SPEED_UNKNOWN;
 
 	return pdata->phy_if.phy_reset(pdata);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 19fed56b6ee3f..ebb8b3e5b9a88 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1636,6 +1636,7 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 		pdata->phy.duplex = DUPLEX_FULL;
 	}
 
+	pdata->phy_link = 0;
 	pdata->phy.link = 0;
 
 	pdata->phy.pause_autoneg = pdata->pause_autoneg;
-- 
2.51.0



