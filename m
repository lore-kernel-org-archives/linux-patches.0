Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA56349CF3;
	Sat, 12 Sep 2026 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232131; cv=none; b=fTGuuu8WSY1lGJz1mo+gcvd5vZVuNpQoxjqTJpRkRW8HfE36CY4qxtdG61XgjdT05blG05+18YwUYZH8EQgcAYDRFvPoJZcLjErB6fsS+PvBPdZYEpduSg1ZgMv1ITEZygvXIPFwsJCooLHQM5YAof+SxakQP825xsQYn47lQfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232131; c=relaxed/simple;
	bh=IaP98TiYXEZXKiySEMXCt1R22TfFCVvqnlI4tXRgZOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6KMq0yhDu0FHC9baUmvCPC6o71jRfQvFeeE1f4VG0hbE5y71BT3bYbBzmnR6NWKUJHYzEd2aLBo35DVC3oUh/Mjxc8A6EwHvFZgQmT+Wjdur7T97RA0kDvhIONFATkJPmsa19kKXl6DybTUNOVHBB0gQCQ6ub9A2Rh43F5yiMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLM4mpya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLM4mpya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF3B1F00893;
	Sat, 12 Sep 2026 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232128;
	bh=oaLnecJZB6whMjuUSOGmiW+6x1U39gEBKbI/Z+a3lcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLM4mpya05G8m90GYaFYCXWcsgbBEpG5Jw8Wt0Z87evwgqdQQ57urNn3eL07yfbtO
	 8vw+TFLVE5hecITf86BEOT+hJzpkJih39Ydnc1pm47wx8ELyV0LCgyzaCG9VHzFQeN
	 Fz//KAf9X2KpPNFPTBk8lgIBnjgEmk9eFO8rcP6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1138/1191] net: fec: only stop PTP if it was initialized
Date: Sat, 12 Sep 2026 09:04:26 +0200
Message-ID: <20260912065613.709948672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d1510af6aff1b..71cf5ed9e8ebb 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4184,7 +4184,8 @@ fec_probe(struct platform_device *pdev)
 failed_irq:
 	fec_enet_deinit(ndev);
 failed_init:
-	fec_ptp_stop(pdev);
+	if (fep->bufdesc_ex)
+		fec_ptp_stop(pdev);
 failed_reset:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -4226,7 +4227,8 @@ fec_drv_remove(struct platform_device *pdev)
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



