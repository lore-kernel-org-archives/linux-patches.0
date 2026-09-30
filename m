Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783F64FECCF;
	Wed, 30 Sep 2026 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787053; cv=none; b=Jt5rY5LRvrq8pjzG2oNHrXYx2I8sEta7zkJNO9P4KOSNqE/w4fpByQot3GespQ+G1S3L7T422C1mJD4z3RGlT/eSsw7JFP8N40CR6VojquQrpGhUENudz7M2kw7+CE5ZlwYitfU6FcLEZ/zc/Q6HYx96GnSjLD8CYtiDfCQ7G+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787053; c=relaxed/simple;
	bh=2xX9UkbOTCxMqjpu7nog5vVEziYrCVgo7ymWLp9Jx+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfNryCGKj91JmCDPm2FRNehFMoI5VJLsRHtJzlrR2kNhPp1Rq/lq0oBAHbGsDRpU2wKhoUlu8WItZvG26wFDX331Fe51BI3zkefF8aRP6qeihKqJCpg42TQarQ3v3KZ4N4eF/m6ip8zev0xkHfNatQEJ+sxyO5b7J7k/bfB4wks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIYHDBVB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIYHDBVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B621F000FF;
	Wed, 30 Sep 2026 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787052;
	bh=vzXxSslJHXNa1CUVNmpKkBuDKpHGNnBa85v55pZhSJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIYHDBVB7C9CCyvbAEUdHz+Li5pqBBbTiH2iUen/zFjG1G/cbhEQ5NfPZEroPluZo
	 32/gQLnyi1ABZg5KhHAdqGwbuZrRpzh+3R6sPLyXXExKEnBZeN0QGwcu6SfkuO0x4D
	 gHYcNemE1FHuiRCag7wLE4poH59Yrisa8zP99nhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 094/457] net: ethernet: mtk_eth_soc: unregister net_devices in case of probe failure
Date: Wed, 30 Sep 2026 17:23:19 +0200
Message-ID: <20260930152348.077173042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
index b2473df74dff0..efc238abb67b3 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4508,6 +4508,10 @@ static int mtk_unreg_dev(struct mtk_eth *eth)
 		mac = netdev_priv(eth->netdev[i]);
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
 			unregister_netdevice_notifier(&mac->device_notifier);
+
+		if (eth->netdev[i]->reg_state != NETREG_REGISTERED)
+			continue;
+
 		unregister_netdev(eth->netdev[i]);
 	}
 
@@ -5339,7 +5343,7 @@ static int mtk_probe(struct platform_device *pdev)
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



