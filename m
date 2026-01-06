Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFFD322B93;
	Tue,  6 Jan 2026 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719750; cv=none; b=U0JQQ5V0dG671JfpOg0XdMRg0GmsrcQaKhCH5HQ5gUSmQTXtMOg4LXZ1e+QAYrrTqmEmJuKaDYNhAPzVBRU8LXW4cSJgyx4JkJCEk6VeTT3w9xB5509P191aE3OUN6lAiyAXZ/Qrm/m3BzG+VaUBJJcJ6kl6HLmBRssK3sZwBnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719750; c=relaxed/simple;
	bh=xbezwoH4BVh0Jte/KTroAUKkYSDpVuuyDbtJhdY6L4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXuaw5bxdPnbgaw3HKWpKAk8ZMxwEtvdXkUWAcPFLEtGpLkZRpthfCfORrJLipF0KsTbp3Zdfl3RmbKNwH9ZPw99jj4EpxyizDCpD07eNyKEIGGUGmkt18393kB0fvcWmfbwQrRCawpS+BtANFR1zviQcnWEJ36Oo3jTDNrnmeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/BAO8oI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/BAO8oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AFFC116C6;
	Tue,  6 Jan 2026 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719750;
	bh=xbezwoH4BVh0Jte/KTroAUKkYSDpVuuyDbtJhdY6L4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/BAO8oIUMFNMPVy+WVEDLJSiN0gl1chCgQtLhwRScQoxCSmyRboxJ1ecqdWEG8V6
	 3e8MeKDPiZzc0LHLIUJxdOLtkyiS6upOdEt6QbfR+8v+umQkqXv2vmHu0VX3Dm8jiE
	 pVO9pHYOJM7G62QitP7Qdi4gkuawtkqxkD09MCOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/567] wifi: rtl8xxxu: Fix HT40 channel config for RTL8192CU, RTL8723AU
Date: Tue,  6 Jan 2026 17:56:50 +0100
Message-ID: <20260106170452.384863461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 5511ba3de434892e5ef3594d6eabbd12b1629356 ]

Flip the response rate subchannel. It was backwards, causing low
speeds when using 40 MHz channel width. "iw dev ... station dump"
showed a low RX rate, 11M or less.

Also fix the channel width field of RF6052_REG_MODE_AG.

Tested only with RTL8192CU, but these settings are identical for
RTL8723AU.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/1f46571d-855b-43e1-8bfc-abacceb96043@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 260f720550134..b517df2db6d75 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -1252,7 +1252,7 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 		opmode &= ~BW_OPMODE_20MHZ;
 		rtl8xxxu_write8(priv, REG_BW_OPMODE, opmode);
 		rsr &= ~RSR_RSC_BANDWIDTH_40M;
-		if (sec_ch_above)
+		if (!sec_ch_above)
 			rsr |= RSR_RSC_UPPER_SUB_CHANNEL;
 		else
 			rsr |= RSR_RSC_LOWER_SUB_CHANNEL;
@@ -1321,9 +1321,8 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
 
 	for (i = RF_A; i < priv->rf_paths; i++) {
 		val32 = rtl8xxxu_read_rfreg(priv, i, RF6052_REG_MODE_AG);
-		if (hw->conf.chandef.width == NL80211_CHAN_WIDTH_40)
-			val32 &= ~MODE_AG_CHANNEL_20MHZ;
-		else
+		val32 &= ~MODE_AG_BW_MASK;
+		if (hw->conf.chandef.width != NL80211_CHAN_WIDTH_40)
 			val32 |= MODE_AG_CHANNEL_20MHZ;
 		rtl8xxxu_write_rfreg(priv, i, RF6052_REG_MODE_AG, val32);
 	}
-- 
2.51.0



