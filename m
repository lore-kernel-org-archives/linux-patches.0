Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E818455E;
	Tue, 30 Jul 2024 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356391; cv=none; b=TbJRIHP/ZAYW0o4lXcWRA8fp/pVYuvkEiPoyfUgBrlp+vKbgh4YeyumeA5dkOhHL5eT2YnQ4syPDs08czRhIy+ypAtF0hUzysiKnIUJ4cTYBRMNPBFBPms2Hq/pGG36zudxlzk9Lw/3RIulv1c1wDeSXlqCTPe536qpFGGUSKx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356391; c=relaxed/simple;
	bh=/z1wSD73qeFX8sumlyAJ+K7sc59oFmibG0DMNCNGGEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYN24udtreVQI+7bEGYO1dp4QYkdIc/m/2iMdg+NxPG/fveCj9cixSqdVg1+/dF0SuUlcv0KxUR29xSPxj1ExcHzSFYzKPsuqx9SyYHcnUhEqwKwyCXb029WNDCJIrQnOMNGSVM/VGvIGdusFlArqvY63R5De32No4FLZdIqHQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKHqtxf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKHqtxf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4091CC32782;
	Tue, 30 Jul 2024 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356391;
	bh=/z1wSD73qeFX8sumlyAJ+K7sc59oFmibG0DMNCNGGEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKHqtxf6TMYd+EeoRwAv1fiblMUCxbDFrp221bvU52X9d7YYJggk7FxJqlmpj6P9H
	 hQc3kE3bccPLPTA1cN+xU3iXlaILQdCJF1KLOfCNKDDLS9UYjPcvJ31AGeJCcbEvgj
	 Np8xPSNMxRGeYu9zlmJqHf1Cx4wqkVepRG3omWi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/568] wifi: rtl8xxxu: 8188f: Limit TX power index
Date: Tue, 30 Jul 2024 17:44:11 +0200
Message-ID: <20240730151645.506777969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Martin Kaistra <martin.kaistra@linutronix.de>

[ Upstream commit d0b4b8ef083ca46d5d318e66a30fb80e0abbb90d ]

TX power index is read from the efuse on init, the values get written to
the TX power registers when the channel gets switched.

When the chip has not yet been calibrated, the efuse values are 0xFF,
which on some boards leads to USB timeouts for reading/writing registers
after the first frames have been sent.

The vendor driver (v5.11.5-1) checks for these invalid values and sets
default values instead. Implement something similar in
rtl8188fu_parse_efuse().

Fixes: c888183b21f3 ("wifi: rtl8xxxu: Support new chip RTL8188FU")
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240624140037.231657-1-martin.kaistra@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c    | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
index 1e1c8fa194cb8..0466b8be5df01 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
@@ -713,9 +713,14 @@ static void rtl8188fu_init_statistics(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_OFDM0_FA_RSTC, val32);
 }
 
+#define TX_POWER_INDEX_MAX 0x3F
+#define TX_POWER_INDEX_DEFAULT_CCK 0x22
+#define TX_POWER_INDEX_DEFAULT_HT40 0x27
+
 static int rtl8188fu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
 	struct rtl8188fu_efuse *efuse = &priv->efuse_wifi.efuse8188fu;
+	int i;
 
 	if (efuse->rtl_id != cpu_to_le16(0x8129))
 		return -EINVAL;
@@ -729,6 +734,16 @@ static int rtl8188fu_parse_efuse(struct rtl8xxxu_priv *priv)
 	       efuse->tx_power_index_A.ht40_base,
 	       sizeof(efuse->tx_power_index_A.ht40_base));
 
+	for (i = 0; i < ARRAY_SIZE(priv->cck_tx_power_index_A); i++) {
+		if (priv->cck_tx_power_index_A[i] > TX_POWER_INDEX_MAX)
+			priv->cck_tx_power_index_A[i] = TX_POWER_INDEX_DEFAULT_CCK;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(priv->ht40_1s_tx_power_index_A); i++) {
+		if (priv->ht40_1s_tx_power_index_A[i] > TX_POWER_INDEX_MAX)
+			priv->ht40_1s_tx_power_index_A[i] = TX_POWER_INDEX_DEFAULT_HT40;
+	}
+
 	priv->ofdm_tx_power_diff[0].a = efuse->tx_power_index_A.ht20_ofdm_1s_diff.a;
 	priv->ht20_tx_power_diff[0].a = efuse->tx_power_index_A.ht20_ofdm_1s_diff.b;
 
-- 
2.43.0



