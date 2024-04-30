Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550BD12C462;
	Tue, 30 Apr 2024 10:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474270; cv=none; b=aJcwRwyZ0AUmcWoNYpH+ELBIZ5coGCCQAiokvf3vDElBtexBvV5r+XduZRlncu6YvsIBTZCJ+YeNqoUa4giXu+2Qjih2gXC7RhJ6xagC61Dl73l0Y0pDDCBIy2DI2lxMciyIvLbDlnIhw1/NofNPITjXdrDiaCkktQH4rm6eBq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474270; c=relaxed/simple;
	bh=qfRo+LNYPaXP6ZEsuerj5rkCjcydWd+ebJSyAJUWY38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nl2SWPIW60yYSfE/tHHe4vSWXNw5mfW2QgyYH8OnrTcvMF/O+dTjQRGJJpXiZ1jCrlgqtQBAad5ghdQOVfV9UlPw+2jrp+nC92M0sULqnM+S0KPk0+meBz8GDoXTONPpsxmcgsrUjBtL7IMF7UR5WjuAu0aMIwPKX7TNRA7XC3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p18yduFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p18yduFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72F2C2BBFC;
	Tue, 30 Apr 2024 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474270;
	bh=qfRo+LNYPaXP6ZEsuerj5rkCjcydWd+ebJSyAJUWY38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p18yduFX5lxLWdVnwvtGMuaUsINK9/iDzUbTls0G5oc081pArtNNen9UfTi/Re6p+
	 OV2zo4zzOFhYxRgAKIavIeNESADqUQXk7mSFlwiDZ3akDVoYuOhp7aEzVN2WRkgvnC
	 WOuWhNNjZEdKYO2kPNPGrp8TNKm81HkfHVFycOO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Roger Quadros <rogerq@kernel.org>,
	MD Danish Anwar <danishanwar@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 108/228] net: ti: icssg-prueth: Fix signedness bug in prueth_init_rx_chns()
Date: Tue, 30 Apr 2024 12:38:06 +0200
Message-ID: <20240430103106.921192645@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 4dcd0e83ea1d1df9b2e0174a6d3e795b3477d64e ]

The rx_chn->irq[] array is unsigned int but it should be signed for the
error handling to work.  Also if k3_udma_glue_rx_get_irq() returns zero
then we should return -ENXIO instead of success.

Fixes: 128d5874c082 ("net: ti: icssg-prueth: Add ICSSG ethernet driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://lore.kernel.org/r/05282415-e7f4-42f3-99f8-32fde8f30936@moroto.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index 411898a4f38ca..4a78e8a1cabf4 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -421,12 +421,14 @@ static int prueth_init_rx_chns(struct prueth_emac *emac,
 		if (!i)
 			fdqring_id = k3_udma_glue_rx_flow_get_fdq_id(rx_chn->rx_chn,
 								     i);
-		rx_chn->irq[i] = k3_udma_glue_rx_get_irq(rx_chn->rx_chn, i);
-		if (rx_chn->irq[i] <= 0) {
-			ret = rx_chn->irq[i];
+		ret = k3_udma_glue_rx_get_irq(rx_chn->rx_chn, i);
+		if (ret <= 0) {
+			if (!ret)
+				ret = -ENXIO;
 			netdev_err(ndev, "Failed to get rx dma irq");
 			goto fail;
 		}
+		rx_chn->irq[i] = ret;
 	}
 
 	return 0;
-- 
2.43.0



