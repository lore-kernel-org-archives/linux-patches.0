Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98571A6192;
	Tue, 30 Jul 2024 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357091; cv=none; b=bmFBhVPVU2s6jnGosfuOIKGIox+xFFENLZZfBobIknHDYVWkMSd2rSViYFV+clHJtuXh63cOG7IoaYIJSi45ClpEHk/bt7ZAOqAD8NCbgnUHpP1pYKq01ZhKWpIv3ZhLF/qkyinbFG04RWlVoZ1YgwX7jQD35asNKNVyAKxl11I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357091; c=relaxed/simple;
	bh=3ucQ6l6toXeV63tExeD1QjLFYqwvMstG1+aINJ9k0Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAaUaseiyGBIOBIB+Mf07uXdKDzbPrHAiotKpKHychOZ4M65jOryEUvHz081cd656dPGY5TvJXXIdGnE74gNWwgQFUMiYqQ9WURLhHW4mBQCam8aqWgrWtXcSsvsDm2ArLYHFgNE1JVbUL1LaeFlwBvv2EuYZND30nIdd8rs9Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2YSspwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2YSspwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFCCC32782;
	Tue, 30 Jul 2024 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357091;
	bh=3ucQ6l6toXeV63tExeD1QjLFYqwvMstG1+aINJ9k0Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2YSspwH6mZdg/DwK17jHNc4Ovpbo0iiACc6yCrPR48Vt+/2hJKWh0BxPbuhab5m2
	 3LL33oywq02SlOKiYKNh8u5O+EtsIFgdVJWtxgb6fOVQnZKxWV0lrRpmniZEgkPDJk
	 Q2lL2oBJnyIPklRSPgKFcbIQLpzOCIEkxHGVdBqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 217/809] wifi: rtl8xxxu: 8188f: Limit TX power index
Date: Tue, 30 Jul 2024 17:41:33 +0200
Message-ID: <20240730151733.178060662@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
 drivers/net/wireless/realtek/rtl8xxxu/8188f.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c b/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
index bd5a0603b4a23..3abf14d7044f3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/8188f.c
@@ -697,9 +697,14 @@ static void rtl8188fu_init_statistics(struct rtl8xxxu_priv *priv)
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
@@ -713,6 +718,16 @@ static int rtl8188fu_parse_efuse(struct rtl8xxxu_priv *priv)
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



