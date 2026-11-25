Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622348;
	b=vZS7HVYgJT6HSSy9xYnJH4Emw7sHExxnSmVnyyNaJbiujLHJLafF9pJdFB/wBzGsPhXI
	 h4IuxPcbhXo/OZfZUN5bXfnxqXedw4pmZVTF63ylNMP1DuHB4iUwU45ASIu+NIVHNWMLE
	 XVViHqJw87F2MeQVoUp6PPo4KR5iTLzloa1L7w5GQGydtXFVr8LVMvWyat49ApYXXomGC
	 P8gYq/fuf1dUQgvUlkskeUveKKkesl4Bo1doliNnVqdI4hLlQhwOvSKPAQ/m0g7vPeP/V
	 8GEaJgJoDnZYew6kV5bzDZGf243VVVHUcGx+jraxANZpwR9dq8kWDh+QfFDeVC0kx5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9qHHfHBehMDxTwL28LVKFE/PgOzA5WUtMMseCByKR8=;
	b=cq4fNS6r6BkX4bt8SrfnJ3WebAp9fUK8OKXnwFreCM7+6DspZDbxIp3LoQu5T6hCfCdQ
	 Aswp0nECvj/4doTnyHcK45mQ1Z82hDLLh4E/XmWI02c8omsYUeClZDrBsoaBzmpm/tYMx
	 Okj617WuGN9x+ixBLe4xmnAb7nyf8fqZ+f0mwqIOhCfFjMX4Rdz0Lt09zkkyy6Lej+7qG
	 6CrPsakbJDflPJdqs5SSyeobcvkuPMO1kAPxUEWJau6YApT1XuTcsuirk/S1KSaXTmzvu
	 iC0atcNqlxSXSsmXxVq2v9pC3qmfcBJUHMcL34lF4uv4NysgtJ9o5yJ7ooWPwEq785g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rae1lulX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82677606A32A;
	Wed, 25 Nov 2026 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rae1lulX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E6A1F000C0;
	Wed, 25 Nov 2026 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622348;
	bh=i9qHHfHBehMDxTwL28LVKFE/PgOzA5WUtMMseCByKR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rae1lulXxuXAH5XISsjwH6ah79AWIHHCvQj2XwvEW2WXWTfPjRlz9VGQynmQ0M9LI
	 R9PPZ47DMNXGya22lHAKVHbk8sufACJUtND0orUPoouN6iS5Akdi546kNBJbpZ1EU3
	 71WzxosLL4niXod2TW6G69wl4U1fuyc6Se+mQ1os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 510/990] wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor
Date: Wed, 25 Nov 2026 15:31:17 +0100
Message-ID: <20261125143834.045427855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the wifi7 function name and path with the older ath12k_hal_tx_cmd_ext_desc_setup() in dp_tx.c, since the wifi7 split is absent here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index abc84ca8467a2..92bb9fc420264 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -115,7 +115,7 @@ static void ath12k_hal_tx_cmd_ext_desc_setup(struct ath12k_base *ab,
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



