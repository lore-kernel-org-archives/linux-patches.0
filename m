Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622A313A244;
	Tue, 27 May 2025 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365620; cv=none; b=knat9RIv+NCuL/95xm3Qahg3JnsvcsvZQ+R7QPFVF3CfD+mtp0rrA+t7dY2cHNR4ntQqiLTp2EMABz9hBjNJzvVk+dhv9PkVpWsqyxS6fdl8arpy4rFoA10ipivZHvFwe3U9AUKO/jFX71MlskjQLTbBgecFiyxXnGH3z2UJU3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365620; c=relaxed/simple;
	bh=6IOxyOn77HS9wRANmBvpDe+f2IzusSzlkNWDtZK8lik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P90oDjoBoHcB3WrXI2HLWisPflDYIHMYU23foufjjOEowI5QiAnFCfnNJznOUqCE1BfDSZSo+gP8Bdi9OyJJ2PF4JmirVYj30IJNGbLAD9UZAZ1a9FImOsu5lm8JcQ61fsqa+PxlOZp/7Ij6XBQo80TDKCkPy2SID5d6510Tz24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJ+QXh+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJ+QXh+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F132C4CEE9;
	Tue, 27 May 2025 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365619;
	bh=6IOxyOn77HS9wRANmBvpDe+f2IzusSzlkNWDtZK8lik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJ+QXh+NYTVBh2ZBNEHO1tnk7LMFXhwe6Zbu4kMeN8AC4TaAtukkRJ+l45jrSWd8v
	 pcoJ6BJ1WIPCsioqmSR9xii+aQ4acx7XjHqPPa7NLNKNGIVohYJqu0e8qubGv/a11y
	 t9YQ4J4Ipl9BCq7gKnZmGJz1zYmcDVcW1OQzmBn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 435/626] wifi: rtw89: call power_on ahead before selecting firmware
Date: Tue, 27 May 2025 18:25:28 +0200
Message-ID: <20250527162502.681070065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit d078f5857a00c06fa0ddee26d3cb722e938e1688 ]

Driver selects firmware by hardware version, which normally can be read
from registers before selecting firmware. However, certain chips such as
RTL8851B, it needs to read hardware version from efuse while doing
power_on, but do power_on after selecting firmware in current flow.

To resolve this flow problem, move power_on out from
rtw89_mac_partial_init(), and call rtw89_mac_pwr_on() separately at
proper places to have expected flow.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250203072911.47313-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 23 +++++++++++-------
 drivers/net/wireless/realtek/rtw89/mac.c  | 29 ++++++++++++++++-------
 drivers/net/wireless/realtek/rtw89/mac.h  |  1 +
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index f82a26be6fa82..83b22bd0ce81a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4862,8 +4862,6 @@ static int rtw89_chip_efuse_info_setup(struct rtw89_dev *rtwdev)
 
 	rtw89_hci_mac_pre_deinit(rtwdev);
 
-	rtw89_mac_pwr_off(rtwdev);
-
 	return 0;
 }
 
@@ -4944,36 +4942,45 @@ int rtw89_chip_info_setup(struct rtw89_dev *rtwdev)
 
 	rtw89_read_chip_ver(rtwdev);
 
+	ret = rtw89_mac_pwr_on(rtwdev);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to power on\n");
+		return ret;
+	}
+
 	ret = rtw89_wait_firmware_completion(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to wait firmware completion\n");
-		return ret;
+		goto out;
 	}
 
 	ret = rtw89_fw_recognize(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to recognize firmware\n");
-		return ret;
+		goto out;
 	}
 
 	ret = rtw89_chip_efuse_info_setup(rtwdev);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtw89_fw_recognize_elements(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to recognize firmware elements\n");
-		return ret;
+		goto out;
 	}
 
 	ret = rtw89_chip_board_info_setup(rtwdev);
 	if (ret)
-		return ret;
+		goto out;
 
 	rtw89_core_setup_rfe_parms(rtwdev);
 	rtwdev->ps_mode = rtw89_update_ps_mode(rtwdev);
 
-	return 0;
+out:
+	rtw89_mac_pwr_off(rtwdev);
+
+	return ret;
 }
 EXPORT_SYMBOL(rtw89_chip_info_setup);
 
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 04e254bd6b17f..9b09d4b7dea59 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1491,6 +1491,21 @@ static int rtw89_mac_power_switch(struct rtw89_dev *rtwdev, bool on)
 #undef PWR_ACT
 }
 
+int rtw89_mac_pwr_on(struct rtw89_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw89_mac_power_switch(rtwdev, true);
+	if (ret) {
+		rtw89_mac_power_switch(rtwdev, false);
+		ret = rtw89_mac_power_switch(rtwdev, true);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 void rtw89_mac_pwr_off(struct rtw89_dev *rtwdev)
 {
 	rtw89_mac_power_switch(rtwdev, false);
@@ -3918,14 +3933,6 @@ int rtw89_mac_partial_init(struct rtw89_dev *rtwdev, bool include_bb)
 {
 	int ret;
 
-	ret = rtw89_mac_power_switch(rtwdev, true);
-	if (ret) {
-		rtw89_mac_power_switch(rtwdev, false);
-		ret = rtw89_mac_power_switch(rtwdev, true);
-		if (ret)
-			return ret;
-	}
-
 	rtw89_mac_ctrl_hci_dma_trx(rtwdev, true);
 
 	if (include_bb) {
@@ -3958,6 +3965,10 @@ int rtw89_mac_init(struct rtw89_dev *rtwdev)
 	bool include_bb = !!chip->bbmcu_nr;
 	int ret;
 
+	ret = rtw89_mac_pwr_on(rtwdev);
+	if (ret)
+		return ret;
+
 	ret = rtw89_mac_partial_init(rtwdev, include_bb);
 	if (ret)
 		goto fail;
@@ -3989,7 +4000,7 @@ int rtw89_mac_init(struct rtw89_dev *rtwdev)
 
 	return ret;
 fail:
-	rtw89_mac_power_switch(rtwdev, false);
+	rtw89_mac_pwr_off(rtwdev);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 5ba1133b79d64..7974849f41e25 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1120,6 +1120,7 @@ rtw89_write32_port_set(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvif_l
 	rtw89_write32_set(rtwdev, reg, bit);
 }
 
+int rtw89_mac_pwr_on(struct rtw89_dev *rtwdev);
 void rtw89_mac_pwr_off(struct rtw89_dev *rtwdev);
 int rtw89_mac_partial_init(struct rtw89_dev *rtwdev, bool include_bb);
 int rtw89_mac_init(struct rtw89_dev *rtwdev);
-- 
2.39.5



