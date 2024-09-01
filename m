Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAEA1E498;
	Sun,  1 Sep 2024 16:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209020; cv=none; b=R8NQDkAw83yyO0hZf3HaRAqOvbuoMA8oGeiuuISnyJw5LxUQ9SWg++ZissjsCRRBgI2u5+lEUkE9XZFxqhGuGZHmy5gQzUo69F2LA+R4ry0PseTggtO77KbEZpW0Sk9u0bYM/7tIA1j3+qrx3TDvY5pUFaF3eaYLlx68g8Le8xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209020; c=relaxed/simple;
	bh=hLF3NCfUZkMlDHN1Ndj+vEZdp4U704W+X58g45BRG/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCbrqa6RJpiTOkLORwzlypaNp2UXll98sr91ZzgHtFsyGkvn/Qe1z5uYiOKK+II+nIAIyvbb2lruNPY20sw2c0wDjDJg1T1g1K+MjHUXCuRoxmSE/TXBN9zFOu0jupgohH0IKYq9DhW1JcU223N1F2LyjiB7rvpIyqbmU+2gPSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKulpuFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKulpuFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF92C4CEC3;
	Sun,  1 Sep 2024 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209020;
	bh=hLF3NCfUZkMlDHN1Ndj+vEZdp4U704W+X58g45BRG/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKulpuFXiPr4bNZ/GtpgqdTr1OyBp9419vjHUOKcyi+oepHYJQ69P11ASYvdm5ndh
	 ujBpsRNOovInIBTq9yvSAZz8wWZ8b639cBRsCXOwNpMgeKwOtBpcA857y8L3iV/9qU
	 xr9fr1g8eYviISdCDA2UPGcf+059kBSYglmOwrTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 109/134] wifi: mwifiex: duplicate static structs used in driver instances
Date: Sun,  1 Sep 2024 18:17:35 +0200
Message-ID: <20240901160814.187985860@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 27ec3c57fcadb43c79ed05b2ea31bc18c72d798a upstream.

mwifiex_band_2ghz and mwifiex_band_5ghz are statically allocated, but
used and modified in driver instances. Duplicate them before using
them in driver instances so that different driver instances do not
influence each other.

This was observed on a board which has one PCIe and one SDIO mwifiex
adapter. It blew up in mwifiex_setup_ht_caps(). This was called with
the statically allocated struct which is modified in this function.

Cc: stable@vger.kernel.org
Fixes: d6bffe8bb520 ("mwifiex: support for creation of AP interface")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240809-mwifiex-duplicate-static-structs-v1-1-6837b903b1a4@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |   32 +++++++++++++++++++-----
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4319,11 +4319,27 @@ int mwifiex_register_cfg80211(struct mwi
 	if (ISSUPP_ADHOC_ENABLED(adapter->fw_cap_info))
 		wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 
-	wiphy->bands[NL80211_BAND_2GHZ] = &mwifiex_band_2ghz;
-	if (adapter->config_bands & BAND_A)
-		wiphy->bands[NL80211_BAND_5GHZ] = &mwifiex_band_5ghz;
-	else
+	wiphy->bands[NL80211_BAND_2GHZ] = devm_kmemdup(adapter->dev,
+						       &mwifiex_band_2ghz,
+						       sizeof(mwifiex_band_2ghz),
+						       GFP_KERNEL);
+	if (!wiphy->bands[NL80211_BAND_2GHZ]) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	if (adapter->config_bands & BAND_A) {
+		wiphy->bands[NL80211_BAND_5GHZ] = devm_kmemdup(adapter->dev,
+							       &mwifiex_band_5ghz,
+							       sizeof(mwifiex_band_5ghz),
+							       GFP_KERNEL);
+		if (!wiphy->bands[NL80211_BAND_5GHZ]) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	} else {
 		wiphy->bands[NL80211_BAND_5GHZ] = NULL;
+	}
 
 	if (adapter->drcs_enabled && ISSUPP_DRCS_ENABLED(adapter->fw_cap_info))
 		wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta_drcs;
@@ -4411,8 +4427,7 @@ int mwifiex_register_cfg80211(struct mwi
 	if (ret < 0) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: wiphy_register failed: %d\n", __func__, ret);
-		wiphy_free(wiphy);
-		return ret;
+		goto err;
 	}
 
 	if (!adapter->regd) {
@@ -4454,4 +4469,9 @@ int mwifiex_register_cfg80211(struct mwi
 
 	adapter->wiphy = wiphy;
 	return ret;
+
+err:
+	wiphy_free(wiphy);
+
+	return ret;
 }


