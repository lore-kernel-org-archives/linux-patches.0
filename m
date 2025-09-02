Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7672F2DC33B;
	Tue,  2 Sep 2025 13:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820113; cv=none; b=p+7OGq8Fg5T94WpTMATR+EBPCS1FgTytr7eaNU6Pilqnabt0LTfDkOsYIp/BcePAcqS1ih2wbKmaaVML1Z7h5+wEeD1kPZ12xKBGjgEnLW/df4n9tXWK/an2n9yS30qkDAIsAby/ez02VE94fRoIfFKVmFH7DQgwmR2yte16xbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820113; c=relaxed/simple;
	bh=KC4mhj6NeFqCDCbqTw1hfu1v27IxgJTeUx9rD1TKgqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvFVjgol8HGP0zGsKxa03Pc9gfHPNxq7iGQWZ0sGkwJlOF2NmI8h08ot4snIq46Iu5Ho/zbzVsH1yz8nv3EIHD/vevMa+4Vcz1aNcltGHuIeWFW274Ay+SK0WrIL5bYOBQ35NXplTZrhNdTHaWX83z8t7MxaFFPFCZ5jZQ3mM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvMdMqIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvMdMqIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02E1C4CEED;
	Tue,  2 Sep 2025 13:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820113;
	bh=KC4mhj6NeFqCDCbqTw1hfu1v27IxgJTeUx9rD1TKgqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvMdMqIWS0r4E7uSxDZn6RU+lJXMcYpyzC8cbppr6NXqNm2w/hKnLsimBfbWx/FOy
	 7sD9Tk83ICve4Q4je+HfDGnsmq9Ltl12oi2kKG2fN0c5ONh2qUrZ7YJfCwktUWXGbx
	 JdwyfTaz4Xwq1VFeIabCxAgN1QiBmED66fya6QSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Mandir <neil.mandir@seco.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 66/95] net: macb: Disable clocks once
Date: Tue,  2 Sep 2025 15:20:42 +0200
Message-ID: <20250902131942.134785198@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2421a7bcd221e..6c2d69ef1a8db 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -5230,14 +5230,11 @@ static void macb_remove(struct platform_device *pdev)
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



