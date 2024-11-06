Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBFA1EF0A4;
	Wed,  6 Nov 2024 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897346; cv=none; b=coGT+yO+t/SRtgOTDoq+hqUY40h3TjvKS1YDI7Y301JbzV89z78NBaWRdAEKUf4Lb7Rmu8n/G313lezZKJLp+tNn910OKzp7DWr0jOMGrKsj61kNENiqAPaDFVVhrQkw7XWZXB1ICtf3roQ8ZSOdxZrFPVJJ5b6m/gcyV+EGtk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897346; c=relaxed/simple;
	bh=bfWn4882jLlE+BRShzj4Gsqnm1KSRRyWHcSV6jD1TH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EThMZB7+0Y+cyuadYeP4BLzo+XHPKS4n+aAMctuEXUuJHkozzZwal5/q5taFRbNdwOAwAgvPOfTTkNYlZaVEuNpEExe+d5bO7twZCuHxkwtaqiLHRck6SVc9jF6M2JpuygPKNkAKtPrEUONR5JOFlFEK7AeTaZYTJQG3BqdABxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5YYmELv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5YYmELv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55966C4CECD;
	Wed,  6 Nov 2024 12:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897346;
	bh=bfWn4882jLlE+BRShzj4Gsqnm1KSRRyWHcSV6jD1TH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5YYmELvVD/RDV1Ee85Z/XnJdCUU2BuwE7SWNDQtlauSc7+uGq5+8k4vhTvxGV48d
	 N+fIKxOooWVYXR2ap6ffyBB9Oxb/Z54SJTk4DQ91825xBPVXun/Q5/A5KcYSy0IFJM
	 V1Isqz3ZdjTTpAAqVv8ehUPzdb+V5g27WQ6o+Ri8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/151] net: stmmac: dwmac4: Fix high address display by updating reg_space[] from register values
Date: Wed,  6 Nov 2024 13:03:30 +0100
Message-ID: <20241106120309.443882741@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Ley Foon Tan <leyfoon.tan@starfivetech.com>

[ Upstream commit f84ef58e553206b02d06e02158c98fbccba25d19 ]

The high address will display as 0 if the driver does not set the
reg_space[]. To fix this, read the high address registers and
update the reg_space[] accordingly.

Fixes: fbf68229ffe7 ("net: stmmac: unify registers dumps methods")
Signed-off-by: Ley Foon Tan <leyfoon.tan@starfivetech.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241021054625.1791965-1-leyfoon.tan@starfivetech.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c | 8 ++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 84d3a8551b032..071f128aa4907 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -203,8 +203,12 @@ static void _dwmac4_dump_dma_regs(struct stmmac_priv *priv,
 		readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_RX_CONTROL(default_addrs, channel) / 4] =
 		readl(ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_TX_BASE_ADDR_HI(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_TX_BASE_ADDR(default_addrs, channel) / 4] =
 		readl(ioaddr + DMA_CHAN_TX_BASE_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_RX_BASE_ADDR_HI(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_RX_BASE_ADDR(default_addrs, channel) / 4] =
 		readl(ioaddr + DMA_CHAN_RX_BASE_ADDR(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_TX_END_ADDR(default_addrs, channel) / 4] =
@@ -225,8 +229,12 @@ static void _dwmac4_dump_dma_regs(struct stmmac_priv *priv,
 		readl(ioaddr + DMA_CHAN_CUR_TX_DESC(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_CUR_RX_DESC(default_addrs, channel) / 4] =
 		readl(ioaddr + DMA_CHAN_CUR_RX_DESC(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_CUR_TX_BUF_ADDR_HI(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_CUR_TX_BUF_ADDR_HI(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_CUR_TX_BUF_ADDR(default_addrs, channel) / 4] =
 		readl(ioaddr + DMA_CHAN_CUR_TX_BUF_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_CUR_RX_BUF_ADDR_HI(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_CUR_RX_BUF_ADDR_HI(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_CUR_RX_BUF_ADDR(default_addrs, channel) / 4] =
 		readl(ioaddr + DMA_CHAN_CUR_RX_BUF_ADDR(dwmac4_addrs, channel));
 	reg_space[DMA_CHAN_STATUS(default_addrs, channel) / 4] =
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 358e7dcb6a9a9..00476a8e6d132 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -127,7 +127,9 @@ static inline u32 dma_chanx_base_addr(const struct dwmac4_addrs *addrs,
 #define DMA_CHAN_SLOT_CTRL_STATUS(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x3c)
 #define DMA_CHAN_CUR_TX_DESC(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x44)
 #define DMA_CHAN_CUR_RX_DESC(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x4c)
+#define DMA_CHAN_CUR_TX_BUF_ADDR_HI(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x50)
 #define DMA_CHAN_CUR_TX_BUF_ADDR(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x54)
+#define DMA_CHAN_CUR_RX_BUF_ADDR_HI(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x58)
 #define DMA_CHAN_CUR_RX_BUF_ADDR(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x5c)
 #define DMA_CHAN_STATUS(addrs, x)	(dma_chanx_base_addr(addrs, x) + 0x60)
 
-- 
2.43.0



