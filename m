Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12000364AB;
	Sun,  1 Sep 2024 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207775; cv=none; b=Ku8xcPHz+YKQzsZ8Bhl1lmzDGFr6CTD1sO8/U1kiZMRoanLwH5J3Qr9Y5LVbJxrzhXc2mfXtx4faO03GntbScWledgVgatXAYsYP4BOiHcTpr4u1L/WVK/liiQKkmWPxUqmHCJHG7XWu4tpvgaD+VcIItmIr+0Ts/C/NJMeBYDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207775; c=relaxed/simple;
	bh=tWKJ9z8R1LV4tv4DmsIUaAHAgX878Eil3VArETKY/dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivW/dNPQjEM8Qp2Lryn9y5b5lP2k+73Q3HSrAmYIqjSEADvOPiOnQbV1LeiLIK2aYmiGjK/JAwoScaOFUba4N/bIphP6jfRNmvGrEkwUmQal/HJESbLdLoAAzWW6nnaFvZcUelnQ8OdYiBzbsqxJyRDLX3DE3r2CCf/2ZWFedXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bng2jUg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bng2jUg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76859C4CEC3;
	Sun,  1 Sep 2024 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207774;
	bh=tWKJ9z8R1LV4tv4DmsIUaAHAgX878Eil3VArETKY/dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bng2jUg8DjX4V9IyG0lVFqkiI7AZ8h6CtLbVgHaY2/y8p08NJA8gQR4mxZ1y1wf6W
	 PUJVMFLNhMMIpeWxF+1M4gY4I5sEgdXcWJc9WZAIG5qksmI/vaPG+Ncu0ADi6+5IAP
	 X1jCCSqMTvntOcxjULNzX1qqWhoV1oXWPT/VyRDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.19 74/98] wifi: mwifiex: duplicate static structs used in driver instances
Date: Sun,  1 Sep 2024 18:16:44 +0200
Message-ID: <20240901160806.486963650@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4294,11 +4294,27 @@ int mwifiex_register_cfg80211(struct mwi
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
@@ -4386,8 +4402,7 @@ int mwifiex_register_cfg80211(struct mwi
 	if (ret < 0) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: wiphy_register failed: %d\n", __func__, ret);
-		wiphy_free(wiphy);
-		return ret;
+		goto err;
 	}
 
 	if (!adapter->regd) {
@@ -4429,4 +4444,9 @@ int mwifiex_register_cfg80211(struct mwi
 
 	adapter->wiphy = wiphy;
 	return ret;
+
+err:
+	wiphy_free(wiphy);
+
+	return ret;
 }


