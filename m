Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053782D7380;
	Sat, 12 Sep 2026 11:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212549; cv=none; b=Kt+IEBz3HpWVdCsDWRIgJiGkc3PIQMJf3LF1lzfr1ohVfR2Cwx4UkQcLJtxUo5jbemcCd5PoOfF8gUg0qX5BDKO8SvlJ31x8HSsPFBApw8k5s7R7Ou60cI4a5r3aV+Zy5v315v2N9ZZHL2GuGExm/d/YbYJcPtc8/4YsWUjnnSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212549; c=relaxed/simple;
	bh=8zFXpvtTEyjdJGOQk8i/mAnp4OMSRMpV9/xXuDgvDEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a4GQFbM9Z3eD3PXHGpsJO8rfb0/bvXW7LJcPkVaD7ZAW4xFaHZiUhrKYFOzzMzNShFTjubrWRR7kUPj9VkKYhkzxNYsRx8u6m0iNQj+6Jm0BJSJ5M5PRp/1TFznP48aGXJNr4RvJbrP2AU5jVfFiWINhxniQbdC/FJDPeMoWrUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKSAySG3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKSAySG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F4D1F000FF;
	Sat, 12 Sep 2026 11:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212547;
	bh=6mO5+l5BhjZodvKeWf0oyKDrNH4FBQWTUhqbpP+cFzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKSAySG3ZBN8BOiOFfe92aqDRh0YQ7253NA1u6Ewy2xFf1MTzy9SJNL2Aa8WgHUqb
	 ytsGYBODh6Svx9hh4kNjHRH5Xu0yuuR84i5uKaq5HrpMRFXHH0ciFnNbd/A5aWYnTT
	 Udxaaa/yNXI6Bwz8GskfYioJT9xhOXZcb0Ju0/rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1458/1518] net: fec: only stop PTP if it was initialized
Date: Sat, 12 Sep 2026 09:00:27 +0200
Message-ID: <20260912065656.537317825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit dd890ae29299636fb037276fc1b5238698d08b03 ]

fec_ptp_init() is only called when fep->bufdesc_ex is available.
However, fec_probe() unconditionally calls fec_ptp_stop() on the
failed_init path, and fec_drv_remove() unconditionally calls
fec_ptp_stop() during device removal.

Check fep->bufdesc_ex before calling fec_ptp_stop() in both paths
to avoid stopping PTP when it was not initialized.

Fixes: 32cba57ba74b ("net: fec: introduce fec_ptp_stop and use in probe fail path")
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260826103428.32807-1-phucduc.bui@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 7699a970cb25e..b37ab4f826bd2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4642,7 +4642,8 @@ fec_probe(struct platform_device *pdev)
 failed_irq:
 	fec_enet_deinit(ndev);
 failed_init:
-	fec_ptp_stop(pdev);
+	if (fep->bufdesc_ex)
+		fec_ptp_stop(pdev);
 failed_reset:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -4684,7 +4685,8 @@ fec_drv_remove(struct platform_device *pdev)
 			ERR_PTR(ret));
 
 	cancel_work_sync(&fep->tx_timeout_work);
-	fec_ptp_stop(pdev);
+	if (fep->bufdesc_ex)
+		fec_ptp_stop(pdev);
 	unregister_netdev(ndev);
 	fec_enet_mii_remove(fep);
 	if (fep->reg_phy)
-- 
2.53.0



