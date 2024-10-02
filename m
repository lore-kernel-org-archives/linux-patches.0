Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B871D095B;
	Wed,  2 Oct 2024 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877491; cv=none; b=hSCSblvUDDU7f+Da4fAjqbL+hESoyIOnvJHP94x/D2+vvEC2qa5KR1N94LQ3YwZSRBlmsdsz/oy1SZOhfkei79seUWkpCmtbY8E1TxgCMnJXh9cbPEYON7VgG3/OL1bxLVDjvzVuNTGVeOXR7TA0/dVIJSL7fizH7RMeg3yLA4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877491; c=relaxed/simple;
	bh=CBnS3pkZ2Tm5p9GPp3+AI4je9EESxFnIBG271dlHv0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uiapft42/eSfdonROjBH5tJ1KBn0QhlxkiylndQOlxTNyBvN6bsV0DUQc/wWJsztDtjau/TJX2ITDefo79IyK0TA3qFUQ+gJQE/y+Xz/WgpF0wlxZ0wTgjkTSFjzNq+CNz5haZ99JxzZCQdJuizBtqj+SS7xa3M68SkDX5hKL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1a+nBLAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1a+nBLAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178A9C4CECD;
	Wed,  2 Oct 2024 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877491;
	bh=CBnS3pkZ2Tm5p9GPp3+AI4je9EESxFnIBG271dlHv0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1a+nBLAfRx5rO5TCB4iRDgHUL5mXd8o0Z2xsyBQPnLrOyiBN2p3d8jo6uuQMRvFSN
	 BPSpngk9WyAJSajxALjkRsnUd2czcqmjUM/hHNsCxTzR3yCKW8ALl3MG6LH2jsozGi
	 70H0JMF8JPx2Roqz5FRQrQFYed6+IhAO1zr122ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 095/634] net: enetc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Wed,  2 Oct 2024 14:53:15 +0200
Message-ID: <20241002125814.859221606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5c45f42232d32..f04f42ea60c0f 100644
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



