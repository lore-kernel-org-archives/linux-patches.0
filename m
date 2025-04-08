Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7B1264FB6;
	Tue,  8 Apr 2025 11:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110644; cv=none; b=d8wgQCuRZ/bnTsQJMybUnuvKnjL6sjljXwsSEq0smdDjFF5YM6HkzqoLXU6AGPqRcvXExyI5EtMdhrXjVPBCnUU9MyRcnxTy5yJas30LV6MfTDJscqRhuqEbRtaSLNxrmWFebk3ezlM4VI7GVCfpgfLAnNDkVQZ1jZGJUYxvoAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110644; c=relaxed/simple;
	bh=abRkFl0RpsXbHcnajzZt5ADc2Bb4zfwf7cNC6JBm7x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M62cvdqfU56+vd9/+71DcR3/4Qp8VJztuiBSPyqsEV+w2rTEZcKgAeEK+asgJ/Q+5OCkm/bD8tXvtknx4vadjrWdjwoBfswhO1S/AJ5xdpjmmt4zi7ScqPa2RrxR64u1fnZVuZ3u7Vd7hYT0pDBSgagIWhNZavar7EHZkDyni/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goKgVRvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goKgVRvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45DAC4CEE5;
	Tue,  8 Apr 2025 11:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110644;
	bh=abRkFl0RpsXbHcnajzZt5ADc2Bb4zfwf7cNC6JBm7x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goKgVRvsRFMwPqiqHUMhC63uvfMx7PzDV9ijYyo1dh2RBMoikfrsNpBrECg7CMgJ/
	 fTeNZMHQYdoSt8xp5Swy21a6Yk2vDFTj/YbYrU78qmv2tGqZERmW5wGWnS9zk74fB6
	 Cl618b0j7yD+zPn4/Cu7h//xEof6NEjgLqwPk35s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 141/731] wifi: rtw89: pci: correct ISR RDU bit for 8922AE
Date: Tue,  8 Apr 2025 12:40:38 +0200
Message-ID: <20250408104917.555855080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 3218f5bd8e2e4abc156493f8121b8db53b49ee9e ]

The interrupt status (ISR) bits of RX desc unavailable (RDU) for 8922AE
are B_BE_RDU_CH1_INT_V1 and B_BE_RDU_CH0_INT_V1. With wrong bits, if it
happens, driver can't recognize the situation and prompt a message.
Fix the definition accordingly.

Fixes: aa70f76120ee ("wifi: rtw89: pci: generalize interrupt status bits of interrupt handlers")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250227131907.9864-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.h    | 56 +++++++++++----------
 drivers/net/wireless/realtek/rtw89/pci_be.c |  2 +-
 2 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.h b/drivers/net/wireless/realtek/rtw89/pci.h
index 4d11c3dd60a5d..79fef5f901408 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -455,34 +455,36 @@
 #define B_BE_RX0DMA_INT_EN BIT(0)
 
 #define R_BE_HAXI_HISR00 0xB0B4
-#define B_BE_RDU_CH6_INT BIT(28)
-#define B_BE_RDU_CH5_INT BIT(27)
-#define B_BE_RDU_CH4_INT BIT(26)
-#define B_BE_RDU_CH2_INT BIT(25)
-#define B_BE_RDU_CH1_INT BIT(24)
-#define B_BE_RDU_CH0_INT BIT(23)
-#define B_BE_RXDMA_STUCK_INT BIT(22)
-#define B_BE_TXDMA_STUCK_INT BIT(21)
-#define B_BE_TXDMA_CH14_INT BIT(20)
-#define B_BE_TXDMA_CH13_INT BIT(19)
-#define B_BE_TXDMA_CH12_INT BIT(18)
-#define B_BE_TXDMA_CH11_INT BIT(17)
-#define B_BE_TXDMA_CH10_INT BIT(16)
-#define B_BE_TXDMA_CH9_INT BIT(15)
-#define B_BE_TXDMA_CH8_INT BIT(14)
-#define B_BE_TXDMA_CH7_INT BIT(13)
-#define B_BE_TXDMA_CH6_INT BIT(12)
-#define B_BE_TXDMA_CH5_INT BIT(11)
-#define B_BE_TXDMA_CH4_INT BIT(10)
-#define B_BE_TXDMA_CH3_INT BIT(9)
-#define B_BE_TXDMA_CH2_INT BIT(8)
-#define B_BE_TXDMA_CH1_INT BIT(7)
-#define B_BE_TXDMA_CH0_INT BIT(6)
-#define B_BE_RPQ1DMA_INT BIT(5)
-#define B_BE_RX1P1DMA_INT BIT(4)
+#define B_BE_RDU_CH5_INT_V1 BIT(30)
+#define B_BE_RDU_CH4_INT_V1 BIT(29)
+#define B_BE_RDU_CH3_INT_V1 BIT(28)
+#define B_BE_RDU_CH2_INT_V1 BIT(27)
+#define B_BE_RDU_CH1_INT_V1 BIT(26)
+#define B_BE_RDU_CH0_INT_V1 BIT(25)
+#define B_BE_RXDMA_STUCK_INT_V1 BIT(24)
+#define B_BE_TXDMA_STUCK_INT_V1 BIT(23)
+#define B_BE_TXDMA_CH14_INT_V1 BIT(22)
+#define B_BE_TXDMA_CH13_INT_V1 BIT(21)
+#define B_BE_TXDMA_CH12_INT_V1 BIT(20)
+#define B_BE_TXDMA_CH11_INT_V1 BIT(19)
+#define B_BE_TXDMA_CH10_INT_V1 BIT(18)
+#define B_BE_TXDMA_CH9_INT_V1 BIT(17)
+#define B_BE_TXDMA_CH8_INT_V1 BIT(16)
+#define B_BE_TXDMA_CH7_INT_V1 BIT(15)
+#define B_BE_TXDMA_CH6_INT_V1 BIT(14)
+#define B_BE_TXDMA_CH5_INT_V1 BIT(13)
+#define B_BE_TXDMA_CH4_INT_V1 BIT(12)
+#define B_BE_TXDMA_CH3_INT_V1 BIT(11)
+#define B_BE_TXDMA_CH2_INT_V1 BIT(10)
+#define B_BE_TXDMA_CH1_INT_V1 BIT(9)
+#define B_BE_TXDMA_CH0_INT_V1 BIT(8)
+#define B_BE_RX1P1DMA_INT_V1 BIT(7)
+#define B_BE_RX0P1DMA_INT_V1 BIT(6)
+#define B_BE_RO1DMA_INT BIT(5)
+#define B_BE_RP1DMA_INT BIT(4)
 #define B_BE_RX1DMA_INT BIT(3)
-#define B_BE_RPQ0DMA_INT BIT(2)
-#define B_BE_RX0P1DMA_INT BIT(1)
+#define B_BE_RO0DMA_INT BIT(2)
+#define B_BE_RP0DMA_INT BIT(1)
 #define B_BE_RX0DMA_INT BIT(0)
 
 /* TX/RX */
diff --git a/drivers/net/wireless/realtek/rtw89/pci_be.c b/drivers/net/wireless/realtek/rtw89/pci_be.c
index cd39eebe81861..12e6a0cbb889b 100644
--- a/drivers/net/wireless/realtek/rtw89/pci_be.c
+++ b/drivers/net/wireless/realtek/rtw89/pci_be.c
@@ -666,7 +666,7 @@ SIMPLE_DEV_PM_OPS(rtw89_pm_ops_be, rtw89_pci_suspend_be, rtw89_pci_resume_be);
 EXPORT_SYMBOL(rtw89_pm_ops_be);
 
 const struct rtw89_pci_gen_def rtw89_pci_gen_be = {
-	.isr_rdu = B_BE_RDU_CH1_INT | B_BE_RDU_CH0_INT,
+	.isr_rdu = B_BE_RDU_CH1_INT_V1 | B_BE_RDU_CH0_INT_V1,
 	.isr_halt_c2h = B_BE_HALT_C2H_INT,
 	.isr_wdt_timeout = B_BE_WDT_TIMEOUT_INT,
 	.isr_clear_rpq = {R_BE_PCIE_DMA_ISR, B_BE_PCIE_RX_RPQ0_ISR_V1},
-- 
2.39.5



