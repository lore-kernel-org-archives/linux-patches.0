Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7B23596EA;
	Tue, 16 Dec 2025 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886650; cv=none; b=mk32zBv9QH2Ia0U4RP9/w4xLqtKekUmWmB7pd+xFpUxRzzjkQ4pCEyS6we0zlI5ZiKG1c4XH3a5s0cpeI+af7GDTTDHTZVgOfEDJGfVlQMa8bH4b+cp1juod6T1iLylDAkNPFadjoOTNtm21AbgvIs16I5+noQEAkVtEGvc/S6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886650; c=relaxed/simple;
	bh=N1WGvSNvC2lLoaoE85ZBECTcZjA8SJaIatstdNckKF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZxSgMo8YpAMmlupcxuyGLct5oPIROQZM4drnjoBjAs4IiAmyvaTBt1XfC6hFzeP+CcDAIqkrgprCAvEnJUgEMxC2d2/6C5t5+X+ltACAd9lTQpng22Y0CAbZcShUrozrJIXeMCFVXSTPNc6qhRPnLi4AYJc4vWmUX7N3/dQJ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVj/TS6A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVj/TS6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D00C4CEF5;
	Tue, 16 Dec 2025 12:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886650;
	bh=N1WGvSNvC2lLoaoE85ZBECTcZjA8SJaIatstdNckKF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVj/TS6AFoDbpAn0dT1fyP08VyWcuo/deOESRpGUTtD9XSG7dNrkXKDU4+BU1mGcO
	 Z/VX+LkRGz6Yg4ytj34s9dqc2iNQaBMMXD93h1sbaNh/iIDzPAXNRAZQ0HXpVLjL+d
	 YqcIOxq2xdwWIE7AU7OQjb9jkpRsK3azhMiYAK5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hemalatha Pinnamreddy <hemalatha.pinnamreddy2@amd.com>,
	Raghavendra Prasad Mallela <raghavendraprasad.mallela@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 456/507] ASoC: amd: acp: Audio is not resuming after s0ix
Date: Tue, 16 Dec 2025 12:14:57 +0100
Message-ID: <20251216111401.969167240@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



