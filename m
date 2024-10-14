Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630ED1C3054;
	Mon, 14 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917637; cv=none; b=IjD+3FrPPm2BnlZ40LQ5pcVeoaXCvYbD8AZAvZOCS3SfOas1dcyjuIRgyPYwLOazT5Ys1Qxv2Qa48bcMY0ooW2QYaOon6SDQY0uLMKgtAlNaUlNCzzDN4MhihyfG+w6h8YiUi5FOEog7vC1Qcnq8Oty02CIW1oz3HknBfQrSznU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917637; c=relaxed/simple;
	bh=nEnet3MWpvcVKHNBMwv2GphWV4Bhr5iAsOgjcqwm4qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGTz3QRLdX8iML6xuCnWofLaTzvyLP4vXbwTsMZPZPwWzKl40JloIAn1NowoB/ekXoVc1uGZ+SjUi0QX4Wsm9SrAFhDXIosQqK9yG32Cf4IOc81RNGhD3UuZVLHTyH7MPqDMpGu6GBhgD8qM6P9zYTD2hvGXK+8pIJAQx87QWXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zr+B/WHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zr+B/WHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7842C4CEC3;
	Mon, 14 Oct 2024 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917637;
	bh=nEnet3MWpvcVKHNBMwv2GphWV4Bhr5iAsOgjcqwm4qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zr+B/WHMd5RexgN6D+BtTbZ1l/F8Yl6UV7dLvjSJHodR5K5z1Nv4aqEe6LUtNwVEC
	 JcuuD7qnO3PnV6P5bsS+hSutST8dX9lSYClR7LQ1ki3leeYUcPHL6zKLV2mXl79w3H
	 qdrQlZMFe0moo0MgbDNHYiEnf2o83puXbiZUEQWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/798] net: enetc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Mon, 14 Oct 2024 16:10:11 +0200
Message-ID: <20241014141220.182812419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 25c303406e6b4..e811ea33e2727 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2181,12 +2181,11 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
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



