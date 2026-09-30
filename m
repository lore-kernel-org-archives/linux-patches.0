Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C27E403E8C;
	Wed, 30 Sep 2026 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796705; cv=none; b=iP7FXiP8mQHReBoOE/EwCUudiMrGpBnutOFITsF4ZoxGRAKm2vm0ricqp0wg7hHX2aImHWZKLE1nQpSiDKWJrthbQ9OLov3xCYJ4c/rBPX5YRoQ8I6Y7Pt1bFoEmrdOHc1mCUZmTQY3G/TWAq3eFQ4zEUjRWcps0r1Ce3GqYuLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796705; c=relaxed/simple;
	bh=YxgZunL/J+d6+M6wnO1/pfoLHTMWP2VEEvT01lmJNYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNGomc0WqXXCE8BVMtEGNb/HeVbsJjaQz4VBPq9AzlszPDihw4/siC+sxkbaI6ZF06uwOl0PVOn4Tvct9y+8b1mbw3TocZpG8NX4tCeD823fVVAUZuNBeCSO9OYscPQKC89LvcRFdLMP/Sf2SAiBX72VEpMYf/nJt+ou0dpKrag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnOipxfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnOipxfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2061F000FF;
	Wed, 30 Sep 2026 19:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796704;
	bh=RGnJWwtcij3Q9He0m8Nw5K3CemE3zLa6YKr1IBNN3bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnOipxfRrNeOdfE7MTsrIrheOnKDX7qxeD3jTjKHzAoqRmhXZvBIXL0CQDXU1YNI3
	 dQd7AUhSawGry9GYIzd0DMws1Skzonkab64W1HgVaxTIqfd+nIQ1QzLdjvhaPyjWcS
	 vMhhZ6GIVx7Bj71HBLkrWJ6LvqkWn6d8VtyRSQFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1008/1193] net: ethernet: mtk_eth_soc: unregister net_devices in case of probe failure
Date: Wed, 30 Sep 2026 17:28:12 +0200
Message-ID: <20260930152456.639012685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 310d1ac61a4d5a2ca8356a3a48d263acf54503ce ]

If register_netdev() fails for one of the MTK_MAX_DEVS devices in
mtk_probe(), the error path jumps to err_deinit_ppe, skipping
mtk_unreg_dev(). The previously registered net_devices are then freed by
mtk_free_dev() while still in NETREG_REGISTERED state, hitting the
BUG_ON(dev->reg_state != NETREG_UNREGISTERED).

Route the register_netdev() failure to err_unreg_netdev so the net_devices
registered so far are properly unregistered before being freed.

Fixes: 8a8a9e89f801 ("net: ethernet: mediatek: cleanup error path inside mtk_hw_init")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-mtk_eth_soc-netdev-fix-v1-1-5dac50eb65b1@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 8cc5f94b1e8aa..37d9b406ac424 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4265,6 +4265,10 @@ static int mtk_unreg_dev(struct mtk_eth *eth)
 		mac = netdev_priv(eth->netdev[i]);
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
 			unregister_netdevice_notifier(&mac->device_notifier);
+
+		if (eth->netdev[i]->reg_state != NETREG_REGISTERED)
+			continue;
+
 		unregister_netdev(eth->netdev[i]);
 	}
 
@@ -5036,7 +5040,7 @@ static int mtk_probe(struct platform_device *pdev)
 		err = register_netdev(eth->netdev[i]);
 		if (err) {
 			dev_err(eth->dev, "error bringing up device\n");
-			goto err_deinit_ppe;
+			goto err_unreg_netdev;
 		} else
 			netif_info(eth, probe, eth->netdev[i],
 				   "mediatek frame engine at 0x%08lx, irq %d\n",
-- 
2.53.0



