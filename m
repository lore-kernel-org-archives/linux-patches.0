Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A7D1D0968;
	Wed,  2 Oct 2024 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879297; cv=none; b=kgAigQf/fpZW/SiL4+4p6RmFRVzlsxkZ8+3dkPLL1fYkYlGlGm/LGhwAg8LplxVGNfFaHIDr0CYWii3oOdDEYju191mUJkOw7RQPv4g+PWbWLlzyAv7xfEcrmEXcEaQwFRL+X31dax6ojM9TadpaRpHoubqbFF4fOIAGeU+SH5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879297; c=relaxed/simple;
	bh=v87+c3bVGhgQldx8OXu+cZISFY+SoKD72NrL3gz5du4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5gckGGPsxoeFu5SAij36PU9aYmCpAHEuMLV2ZdTh1Sp0Tav0hDVeu22ePwnM7ZaxOD49XbVDHHSHM0k/H//8uZYpeTT5dZfOpYDLl0oQIYLyiAg1cdmvlcJBZY2WJOIcFl9EBK21T4jo5QIEEeDhXJSNtlsJek7U1yPucFzgBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVRl9yV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVRl9yV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBEC4CEC2;
	Wed,  2 Oct 2024 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879297;
	bh=v87+c3bVGhgQldx8OXu+cZISFY+SoKD72NrL3gz5du4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVRl9yV/cSvPsTsd51SCmSPOorn1VqaXJ1893E0PJ71q1R+B8lQgMVA1sbYHMwS3u
	 j4rG9cp/fiIwNAuHroWY+Q0FzC3TXJVq/6deLFzOcmTaQLGIDvF7lbLNzZjI4WeR9p
	 fPp2bp+Sl0rKsSA20tyy/2crzrpKbNpGf6pZPJs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/538] net: enetc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Wed,  2 Oct 2024 14:55:10 +0200
Message-ID: <20241002125755.016734996@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f5a4ec505ddb..18e3a9cd4fc01 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2305,12 +2305,11 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
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



