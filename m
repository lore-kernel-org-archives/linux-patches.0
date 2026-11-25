Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625074;
	b=T5QyloEu6d4VGFh2QmMQXWd5DNnkW+swR3+b0CRsb0kTofRO867Xy114NPSwlV+4YkdT
	 ZC+irxgNqcmWR4cOJfpubAVYEy9choi/I29u4m73uizkfmZl4OvotbP2nD07hminurExY
	 Hoznjv6UjiR/3dYYW2uzjoC1eNNISFuXgt/PC7vO2HVJ1cPW50fwe2aUXXWrxmSgB1S0F
	 ahjrsd0sVYFWint0NmMzlhycGmRWP39yeESD4eX64CJaZD342QcpnVCZxG+myV7X7l0cm
	 rsMBe7Z51Ar+fMXp3Ex2e1CsD1ooj82fxtIFQQXRWWLI2rlIA5kmtMyuAER6duGktrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2D18nlUML7/a38yFq2KosKsMJ9X5Bzhw4pg3bLRBO4=;
	b=cityidDewHrajZ9xpr2iKFMLbs9PPsAP/0jLzLgfUeNKZ7vFEtV1uW9X1RgqsECCUUHr
	 D7JH0iDP6wDiDGvvpHmzeWCma/FiOb/ub1qRD8e7ghl/goSGX2DCUEFmwv5vN00Vdf/74
	 TWlxCj9+IAlcxYzrjgLRLpiK2rs0hl7kt11KybhchsYsOb8lZJP6dvBEbDKAeitcBrF/X
	 rEYjM3u3EhNO98U1IRpQDjxFycUwj6d9nmJb8PZtf6PEOnkeLazE5879Bx7ya91syuHvx
	 er8RtSjgQ2BrhCSDK1RfnHpXZoUrCfFDzvfrdd6LwvzH7o8DrJX0N0QEBMgY8cKz7OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gEFgJPRf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772BD606A31E;
	Wed, 25 Nov 2026 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gEFgJPRf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE821F000C0;
	Wed, 25 Nov 2026 16:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625074;
	bh=K2D18nlUML7/a38yFq2KosKsMJ9X5Bzhw4pg3bLRBO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEFgJPRfyhk0NBzUaaFn3E1VYqjzJx2AaK5KjWI2mcwnIj/JyHBhY5xK5r56hndsD
	 zjBWH/r01qUbWE6DiD22skc4r0g+ZU7V5QO8Zp4wveJCfO/3Zz3U+Q9bYTWo42ZhvU
	 q5ixPrQI3xdniCuGa0gESY9WedP5z19OuPmyjTwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/816] wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor
Date: Wed, 25 Nov 2026 15:32:25 +0100
Message-ID: <20261125143858.389757388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 979ecb88ed3528e08dd7f87b90b029374226ca84 ]

ath12k_wifi7_hal_tx_cmd_ext_desc_setup() programs the low 32 bits of the
TX buffer physical address into HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO but
hardcodes the high bits field HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI to 0x0.

dma_addr_t is 64-bit on platforms with CONFIG_ARCH_DMA_ADDR_T_64BIT, so
whenever a TX buffer is mapped above the 4 GB boundary the upper bits of
paddr are dropped and the firmware is handed a truncated address,
leading to potential TX failures.

Write the upper bits of paddr into BUF_PTR_HI to fix this issue.

Issue found during code review, compile tested only.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260818-ath12k-truncated-tx-dma-addr-v1-1-ead978969371@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: Applied the same one-line BUF_PTR_HI change to dp_tx.c and the ath12k_hal_tx_cmd_ext_desc_setup() name, since this tree has no wifi7 subdirectory or function prefix. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index f08ab5a4112c0..2e2f228b74c88 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -111,7 +111,7 @@ static void ath12k_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab,
 {
 	tcl_ext_cmd->info0 = le32_encode_bits(ti->paddr,
 					      HAL_TX_MSDU_EXT_INFO0_BUF_PTR_LO);
-	tcl_ext_cmd->info1 = le32_encode_bits(0x0,
+	tcl_ext_cmd->info1 = le32_encode_bits((u64)ti->paddr >> HAL_ADDR_MSB_REG_SHIFT,
 					      HAL_TX_MSDU_EXT_INFO1_BUF_PTR_HI) |
 			       le32_encode_bits(ti->data_len,
 						HAL_TX_MSDU_EXT_INFO1_BUF_LEN);
-- 
2.53.0



