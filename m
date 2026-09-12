Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A593B2FC0;
	Sat, 12 Sep 2026 20:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243534; cv=none; b=Oea9LKkD/8KkP+9y7ABcK+CKEAGctDbliKMuTZfWIDKRS8C/Nwh78/KngSKUIpSGXGYroQF67s8xFXP7VaEo3bSKNWVPl5YhpcEmzpav0GPmJPHNmRnH5/58VH0SugSdIOD7ohU9HNkZJK48502Ry3lFqvHl5ajoxGop4FoQJPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243534; c=relaxed/simple;
	bh=Gb3Ynl2A/o5UTWa4hrkr24Q4c79A3IJ8XSReDtOMyoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sswI6eSsIkTC0HFq3+aRvInbBKvb03lVeFG4hsoxpkgsCAy4t9QnbKf28gyj2F+vrCxuO/0BslvXjIlh/hIRnQV0xEmg8FIUp6QDV/DAhPcFbMr5Lb+doMR294mafg89jGJlgUSF9Q//pvxtra7Hpdg7GX81a/IxCmIpH2GpHFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttfrDaRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttfrDaRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825841F000FF;
	Sat, 12 Sep 2026 20:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243527;
	bh=0I0G7ULS8pCd/fUtxoAqR3rS0Gz2CSVL0ClU3mKJ5fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttfrDaRHR0JQzy4wtXBeHBnrUxKCg7KoNuzQmNyZ0M4lANFBRmBG94jMaNddLyLQA
	 F0wuqzZojxfr1zWiyEeJfxSFbAzlLWNl1KszfuVmid3NDAU8UUjTkNcM2zevuD4Uet
	 JCwUtz/6aEXNBW8whEuw8AyK7nHNvaUi+jxJNi50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 784/798] net: fec: only stop PTP if it was initialized
Date: Sat, 12 Sep 2026 09:06:52 +0200
Message-ID: <20260912065535.034918300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dfe3e7b1fae51..48b0ad0576d80 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3878,7 +3878,8 @@ fec_probe(struct platform_device *pdev)
 failed_irq:
 	fec_enet_deinit(ndev);
 failed_init:
-	fec_ptp_stop(pdev);
+	if (fep->bufdesc_ex)
+		fec_ptp_stop(pdev);
 failed_reset:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -3918,7 +3919,8 @@ fec_drv_remove(struct platform_device *pdev)
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



