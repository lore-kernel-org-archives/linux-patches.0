Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAF1C07C4;
	Tue, 15 Oct 2024 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997096; cv=none; b=GCvyeeCTWSiMIIrxSIQNVbeR3niJFndwhuYOkSi+CXrKGHApyKpf1kOiTCcjfJqHH0XGPS13jmMXHAWuZRc4T2u0+PrQFvFLbeVvScQDae085YrgrIzYcpZYTTIAE/fgFeRMeVU3c5O6SS45EonEhK8IcfGrVU2kFlr0Ir2pYUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997096; c=relaxed/simple;
	bh=o4dQCwftlGlMyRUC/Um9nR6O7PG4g6zyN4OwrBP0IL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIuKK24oWNyoTaOIWZHvX/28fCXWCPuP4avtVwVPYvJPmTCl/cpJZ3LJjeJTBZSJwEjaMtkSgR0AH26QA1bZRCneyjW81W7nZCICVcSdW91jYtSH2gTQEJ89NB0Bf6QRRrLBv7Mf7NBf07TXlDNdUEHwO8uvhlZoTaPvQTyO6eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B0YsPno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B0YsPno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699E7C4CECE;
	Tue, 15 Oct 2024 12:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997096;
	bh=o4dQCwftlGlMyRUC/Um9nR6O7PG4g6zyN4OwrBP0IL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2B0YsPno1RArXIIRxKr6yNivyRFknsMUpKy532N5Wg2e81EIXttOzcVFP9lpcgNBF
	 cGFSCg0Fu3uZWb6Lz1ueK50cu+TULgkqyMAf8lBdhkYtHf4ovbgVHoWNqt287ieSY5
	 6yNOenYEKV/q9r8g+xHNCD0F1xryflAbYP1H78zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/518] net: enetc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Tue, 15 Oct 2024 14:39:50 +0200
Message-ID: <20241015123920.324606384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 799a9225997799f7b1b579bc50a93b78b4fb2a01 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: bbb96dc7fa1a ("enetc: Factor out the traffic start/stop procedures")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240911094445.1922476-3-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5f9603d4c0493..18c8621246677 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1333,12 +1333,11 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
 		snprintf(v->name, sizeof(v->name), "%s-rxtx%d",
 			 priv->ndev->name, i);
-		err = request_irq(irq, enetc_msix, 0, v->name, v);
+		err = request_irq(irq, enetc_msix, IRQF_NO_AUTOEN, v->name, v);
 		if (err) {
 			dev_err(priv->dev, "request_irq() failed!\n");
 			goto irq_err;
 		}
-		disable_irq(irq);
 
 		v->tbier_base = hw->reg + ENETC_BDR(TX, 0, ENETC_TBIER);
 		v->rbier = hw->reg + ENETC_BDR(RX, i, ENETC_RBIER);
-- 
2.43.0



