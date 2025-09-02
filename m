Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A331C84C6;
	Tue,  2 Sep 2025 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819768; cv=none; b=XElf7G875+7HNcD0ij2RvNYJhEcxd0UbeY/SQ54XG91vTNjGdlYpllN79JLa7/A4x76SWzKPRR2S2E1qZ/CiQyawlAshen/EKjebV6hK+gBQR9vTQWi7Ypb4eTQBCijDTn9CH6ZmyAFY0Qmch0tb7QyVwTS3Y1Pq2vIsehxgBdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819768; c=relaxed/simple;
	bh=Wga0JiRsDcmMpolaY1gFKDk1puWrjLpTjtj78ZMFxEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBQhyjVjnV2/+20Dl6OXsD+lOiPrD0PzFfOG7vch/pN7Y+WLm9ce3NK6bj6axVUfdCI/qjJJ2W2I1M32oAc+PAKUGRbo4gxCJf07mRHfYHf2A2oJS3kkVkLZH6Gjt9H8wYRWOyb38UyyigKPKtmq13G29qttTpOuxQKKkUotS+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=El5hFIgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="El5hFIgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054D4C4CEED;
	Tue,  2 Sep 2025 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819768;
	bh=Wga0JiRsDcmMpolaY1gFKDk1puWrjLpTjtj78ZMFxEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=El5hFIgbXmYO02w2xGIIzghAZND0RNSwdC9P1r9Z1UuReRK9kpd9U2HQUZzXB+0JY
	 yIt97aExOZVoUx2rmDFsjVVJAh1QeSxDREShEqINPKIZQp7kTe+8ZzNiiSDJ9pn8FW
	 U5gfjirvgCLm2hLK6BzzJJ8JyGJB3iql+V6otveQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Mandir <neil.mandir@seco.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 101/142] net: macb: Disable clocks once
Date: Tue,  2 Sep 2025 15:20:03 +0200
Message-ID: <20250902131952.151195303@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Neil Mandir <neil.mandir@seco.com>

[ Upstream commit dac978e51cce0c1f00a14c4a82f81d387f79b2d4 ]

When the driver is removed the clocks are disabled twice: once in
macb_remove and a second time by runtime pm. Disable wakeup in remove so
all the clocks are disabled and skip the second call to macb_clks_disable.
Always suspend the device as we always set it active in probe.

Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
Signed-off-by: Neil Mandir <neil.mandir@seco.com>
Co-developed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20250826143022.935521-1-sean.anderson@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 3cb50e5385d49..d949d2ba6cb9f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5396,14 +5396,11 @@ static void macb_remove(struct platform_device *pdev)
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
+		device_set_wakeup_enable(&bp->pdev->dev, 0);
 		cancel_work_sync(&bp->hresp_err_bh_work);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
-		if (!pm_runtime_suspended(&pdev->dev)) {
-			macb_clks_disable(bp->pclk, bp->hclk, bp->tx_clk,
-					  bp->rx_clk, bp->tsu_clk);
-			pm_runtime_set_suspended(&pdev->dev);
-		}
+		pm_runtime_set_suspended(&pdev->dev);
 		phylink_destroy(bp->phylink);
 		free_netdev(dev);
 	}
-- 
2.50.1



