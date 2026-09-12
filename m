Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30B524CEEA;
	Sat, 12 Sep 2026 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205393; cv=none; b=X6X58HzlnXtjk6SsmuWanEi7bGnfqRZf9JPNEDBksKJ1Wp1Dh1HgcUmSWdxuhA3yjFz9WPhYP/gZ84b09R/Rm5cj8+00cGSliehPEaC/F3LKt+xjQeFtDFaKgiiwnvIRLUXrmf3cvToSEA2wI8e67QcWHKqwbNMNkUpQ8Gf1AFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205393; c=relaxed/simple;
	bh=utH/TF5TcTgik0uz/CLAIe1abYmxqotVp5B1dK2j3SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj8SkUQYdnva9AfTFBGNBegv5jh3bDAL08MMb5wsNX0JVosj5C3Q+n0vKmchto6HL9a7eXCiMgHsRUVg30+A09yenZodvsDKOS+9fXjmRNq69zql3MXUlXEwP0/GkohN04VgeURCn4Y9zSH4qxjP++IPwsouR3Rn9YJhul1Eo5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWUOYfZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWUOYfZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440D31F000FF;
	Sat, 12 Sep 2026 09:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205392;
	bh=cCdEOLbIVTgNPnOYehc3roicvxM0z5hjbcLx6vo/m1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWUOYfZ4WcYKcgXpZ+64kOonkLEv8YkD1kEJEYixMOSjbGanIeKg3SBB2+9pvh3vt
	 nVp+DAHSrUv6cO8lDRy63DrTWPZ347/LM5sTfFytM7qk1FpbfRle4z75RWpU8qlb2V
	 OTUQoXnjz/6tPzkTjI3Z3wyx6Z67SSlp1icLK5qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1808/1815] net: fec: only stop PTP if it was initialized
Date: Sat, 12 Sep 2026 08:59:18 +0200
Message-ID: <20260912065731.482547464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index ced4dbf8cd90f..794ec427b0ee6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -5457,7 +5457,8 @@ fec_probe(struct platform_device *pdev)
 failed_irq:
 	fec_enet_deinit(ndev);
 failed_init:
-	fec_ptp_stop(pdev);
+	if (fep->bufdesc_ex)
+		fec_ptp_stop(pdev);
 failed_reset:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -5499,7 +5500,8 @@ fec_drv_remove(struct platform_device *pdev)
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



