Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A599426AC1;
	Sun,  1 Sep 2024 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210400; cv=none; b=dh8wdfDNLbJrxFcEOyL6Mghk+yPRxR4wJN2KoQU9bcFmSNdO1F096GJ9KFXBMRVUbWZRCM3CyxS6pHjOwUQy1MN/fEN9stOyJw28BnKeqVehQ3lom9C0ZSstSg6ooVl0oqF0k7Cc1Mw9QYpQs5Gg4XPFr7m9N6mMCXc9/mLLw/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210400; c=relaxed/simple;
	bh=XoLeniHt+UFC/yUp4mCRxn7VOdAfADXgFwLVffi7LYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpI9OB/H5MtEZ2uZDajGRTWZQdzuuhRZO8nFh3n1u1QeP4tnOBCX9D/M6/HQFtQMTZU0UKGxJWRkiFFO1iaexTaHjx/lhNqdTRNDon5HPLEQFhMgtaBYQs2NL3wHm35dH8ADpD8J6G1BaBe2VFLjQNF0xGpWrgUZP8cQjLjg1H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVKR7sSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVKR7sSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2964BC4CEC3;
	Sun,  1 Sep 2024 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210400;
	bh=XoLeniHt+UFC/yUp4mCRxn7VOdAfADXgFwLVffi7LYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVKR7sSH3P7WKI8OMRuW3MVlF1Eqn/FLztsH+6x53XuFP7utTB4VCmsG+4Siaoknj
	 Cov0TaowXtj6UervAkaaxYsikqoGD/22o+DyiVFDtrT4zK1XFZe1pLWoi8/Y5ByTup
	 QkQ8UYJi70Sgkgj8WynId2ZOO/fnf1jvJvLmKVcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 179/215] wifi: mwifiex: duplicate static structs used in driver instances
Date: Sun,  1 Sep 2024 18:18:11 +0200
Message-ID: <20240901160830.127698251@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4328,11 +4328,27 @@ int mwifiex_register_cfg80211(struct mwi
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
@@ -4425,8 +4441,7 @@ int mwifiex_register_cfg80211(struct mwi
 	if (ret < 0) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: wiphy_register failed: %d\n", __func__, ret);
-		wiphy_free(wiphy);
-		return ret;
+		goto err;
 	}
 
 	if (!adapter->regd) {
@@ -4468,4 +4483,9 @@ int mwifiex_register_cfg80211(struct mwi
 
 	adapter->wiphy = wiphy;
 	return ret;
+
+err:
+	wiphy_free(wiphy);
+
+	return ret;
 }


