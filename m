Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FEB49553B;
	Sat, 12 Sep 2026 19:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240704; cv=none; b=aPRMgG7GCOUZ5GjrgdYP4I67PMruNGPiziSlX/a78JXHZZ0datiQ2Fq6Mhwa130/l0WJZ2Po1eZUinlSKL5bCSj/0b+dZ4fkqrdlggZ6fQX9ogvTLghhE9hTCwT6GBHLf+ZTGMqSiZDwb0p3zJShe3QPjuHHyB09bqMO1V/2lHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240704; c=relaxed/simple;
	bh=JUY/ghVsI786Ehn/N0eioz2zXUrz885rlet4HHnricE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUJcUsFRhZehHsKcumvWaKb0Nn4FAqVNjCR2zdcYo+aP/Mb2h9eouXWs5ICO3HC/Sdsqj5g2yHgIyHUtgst0m2gCXT+CUQjSrePwftCRzybGRYGWRL73dZ7c4Op3+dK0R946l9IjoO0YB6teHZB1LiMwemHdtCxdQGwFjAmvRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEMgVRSW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEMgVRSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287481F00893;
	Sat, 12 Sep 2026 19:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240703;
	bh=N9YylSWGT5YD05O3r0dJLIEFOhO5wH8wDgQ/+wBNY6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEMgVRSWOtOEiJSU2XXI7QGe846iP0pFV40FnFxFY8hh0sLSKCQRt1hHCpSjShKJa
	 kcliw9qC3147Ik9N2zPniRGp4eEl9CL+i+yyfyj7wGSNy+0kdwxGtO5wv4JTXI4wME
	 nD1Sc1AF4F/9aAORlYLO0/W9Hyd4Tadsvd4biTcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 922/935] net: fec: only stop PTP if it was initialized
Date: Sat, 12 Sep 2026 09:05:52 +0200
Message-ID: <20260912065547.966265898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 263e3755f5c3a..9f32ad95f3290 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4088,7 +4088,8 @@ fec_probe(struct platform_device *pdev)
 failed_irq:
 	fec_enet_deinit(ndev);
 failed_init:
-	fec_ptp_stop(pdev);
+	if (fep->bufdesc_ex)
+		fec_ptp_stop(pdev);
 failed_reset:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -4129,7 +4130,8 @@ fec_drv_remove(struct platform_device *pdev)
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



