Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CDB361DD3;
	Tue, 16 Dec 2025 12:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888513; cv=none; b=D2M9wW00sraIAEYUmvW1Ov6YNsu4c0co1jaO7BYVxxuD/M3vBO9LrxGIt+TjxZG4K6K4lMj41NfvqkGFVPlR1Na7Mpwr4sBm0d1MLOWiDRPfTaoOux7zUff3iTtbyZXkkkdbgUAxtccCUMwb2yWD3GA/jGx2DXJFJgjED5urC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888513; c=relaxed/simple;
	bh=+CZOw9N1TrRQ/nwjje8ToelTWXbqhJ7x02er/RWuqkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkZGsqz8ls+EUnph7JqX8LR+ajXUFP+/ir00XLwqw4YirKrft63EHn7Ovtfgjucq2d4T5B7Hjc8RqHLybaq/KbPjpJSp1ncMhE1Kp1HI1++hu2lZor2SiIyYk2zvGBtio9B4RcFUTFniAa/ujiw5XAR/0BbZixuoXgi/r5jOirA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JXoelPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JXoelPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C99C4CEF1;
	Tue, 16 Dec 2025 12:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888512;
	bh=+CZOw9N1TrRQ/nwjje8ToelTWXbqhJ7x02er/RWuqkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JXoelPcjT8p5BUZxR0tjxksadG1d+uHuM9GVQ+07odf1FKlvydRi48okhvKbErhU
	 7+zsBOkDr4dfWUVQDFSKBx789CKRwWGRtRqapoN2d4YDnWEf4oXGs9T+jRlHiZkpZ5
	 IjWTbX6ckKz9DqciCwWh5AGD6F+fa2A/3KyQt1zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>,
	Raghavendra Prasad Mallela <raghavendraprasad.mallela@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 555/614] ASoC: amd: acp: Audio is not resuming after s0ix
Date: Tue, 16 Dec 2025 12:15:22 +0100
Message-ID: <20251216111421.488450881@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>

[ Upstream commit 3ee257aba1d56c3f0f1028669a8ad0f1a477f05b ]

Audio fails to resume after system exits suspend mode
due to accessing incorrect ring buffer address during
resume. This patch resolves issue by selecting correct
address based on the ACP version.

Fixes: f6f7d25b11033 ("ASoC: amd: acp: Add pte configuration for ACP7.0 platform")
Signed-off-by: Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>
Signed-off-by: Raghavendra Prasad Mallela <raghavendraprasad.mallela@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20251203064650.2554625-1-raghavendraprasad.mallela@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-legacy-common.c | 30 +++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/sound/soc/amd/acp/acp-legacy-common.c b/sound/soc/amd/acp/acp-legacy-common.c
index 3078f459e0050..4e477c48d4bdd 100644
--- a/sound/soc/amd/acp/acp-legacy-common.c
+++ b/sound/soc/amd/acp/acp-legacy-common.c
@@ -219,7 +219,10 @@ static int set_acp_i2s_dma_fifo(struct snd_pcm_substream *substream,
 					SP_PB_FIFO_ADDR_OFFSET;
 			reg_fifo_addr = ACP_I2S_TX_FIFOADDR(chip);
 			reg_fifo_size = ACP_I2S_TX_FIFOSIZE(chip);
-			phy_addr = I2S_SP_TX_MEM_WINDOW_START + stream->reg_offset;
+			if (chip->acp_rev >= ACP70_PCI_ID)
+				phy_addr = ACP7x_I2S_SP_TX_MEM_WINDOW_START;
+			else
+				phy_addr = I2S_SP_TX_MEM_WINDOW_START + stream->reg_offset;
 			writel(phy_addr, chip->base + ACP_I2S_TX_RINGBUFADDR(chip));
 		} else {
 			reg_dma_size = ACP_I2S_RX_DMA_SIZE(chip);
@@ -227,7 +230,10 @@ static int set_acp_i2s_dma_fifo(struct snd_pcm_substream *substream,
 					SP_CAPT_FIFO_ADDR_OFFSET;
 			reg_fifo_addr = ACP_I2S_RX_FIFOADDR(chip);
 			reg_fifo_size = ACP_I2S_RX_FIFOSIZE(chip);
-			phy_addr = I2S_SP_RX_MEM_WINDOW_START + stream->reg_offset;
+			if (chip->acp_rev >= ACP70_PCI_ID)
+				phy_addr = ACP7x_I2S_SP_RX_MEM_WINDOW_START;
+			else
+				phy_addr = I2S_SP_RX_MEM_WINDOW_START + stream->reg_offset;
 			writel(phy_addr, chip->base + ACP_I2S_RX_RINGBUFADDR(chip));
 		}
 		break;
@@ -238,7 +244,10 @@ static int set_acp_i2s_dma_fifo(struct snd_pcm_substream *substream,
 					BT_PB_FIFO_ADDR_OFFSET;
 			reg_fifo_addr = ACP_BT_TX_FIFOADDR(chip);
 			reg_fifo_size = ACP_BT_TX_FIFOSIZE(chip);
-			phy_addr = I2S_BT_TX_MEM_WINDOW_START + stream->reg_offset;
+			if (chip->acp_rev >= ACP70_PCI_ID)
+				phy_addr = ACP7x_I2S_BT_TX_MEM_WINDOW_START;
+			else
+				phy_addr = I2S_BT_TX_MEM_WINDOW_START + stream->reg_offset;
 			writel(phy_addr, chip->base + ACP_BT_TX_RINGBUFADDR(chip));
 		} else {
 			reg_dma_size = ACP_BT_RX_DMA_SIZE(chip);
@@ -246,7 +255,10 @@ static int set_acp_i2s_dma_fifo(struct snd_pcm_substream *substream,
 					BT_CAPT_FIFO_ADDR_OFFSET;
 			reg_fifo_addr = ACP_BT_RX_FIFOADDR(chip);
 			reg_fifo_size = ACP_BT_RX_FIFOSIZE(chip);
-			phy_addr = I2S_BT_TX_MEM_WINDOW_START + stream->reg_offset;
+			if (chip->acp_rev >= ACP70_PCI_ID)
+				phy_addr = ACP7x_I2S_BT_RX_MEM_WINDOW_START;
+			else
+				phy_addr = I2S_BT_RX_MEM_WINDOW_START + stream->reg_offset;
 			writel(phy_addr, chip->base + ACP_BT_RX_RINGBUFADDR(chip));
 		}
 		break;
@@ -257,7 +269,10 @@ static int set_acp_i2s_dma_fifo(struct snd_pcm_substream *substream,
 					HS_PB_FIFO_ADDR_OFFSET;
 			reg_fifo_addr = ACP_HS_TX_FIFOADDR;
 			reg_fifo_size = ACP_HS_TX_FIFOSIZE;
-			phy_addr = I2S_HS_TX_MEM_WINDOW_START + stream->reg_offset;
+			if (chip->acp_rev >= ACP70_PCI_ID)
+				phy_addr = ACP7x_I2S_HS_TX_MEM_WINDOW_START;
+			else
+				phy_addr = I2S_HS_TX_MEM_WINDOW_START + stream->reg_offset;
 			writel(phy_addr, chip->base + ACP_HS_TX_RINGBUFADDR);
 		} else {
 			reg_dma_size = ACP_HS_RX_DMA_SIZE;
@@ -265,7 +280,10 @@ static int set_acp_i2s_dma_fifo(struct snd_pcm_substream *substream,
 					HS_CAPT_FIFO_ADDR_OFFSET;
 			reg_fifo_addr = ACP_HS_RX_FIFOADDR;
 			reg_fifo_size = ACP_HS_RX_FIFOSIZE;
-			phy_addr = I2S_HS_RX_MEM_WINDOW_START + stream->reg_offset;
+			if (chip->acp_rev >= ACP70_PCI_ID)
+				phy_addr = ACP7x_I2S_HS_RX_MEM_WINDOW_START;
+			else
+				phy_addr = I2S_HS_RX_MEM_WINDOW_START + stream->reg_offset;
 			writel(phy_addr, chip->base + ACP_HS_RX_RINGBUFADDR);
 		}
 		break;
-- 
2.51.0



