Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2833416EB4B;
	Sun,  1 Sep 2024 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207892; cv=none; b=UwjIoGPhwzMmmlJ4OJod3DWO3eTXQ1iQ1V92pTbM9J6ODYmr2qFCpKCAVIlgD6uaYwsAlPnaFU5TYrdS2ek2ZmFfxlVhqg7ckzqq9MEwYmtwW/5suh1lSFOzxtNkmAuk8tz0YIh+E70fPgmi3olkb2lMmRAGAU4yWvjOSc961Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207892; c=relaxed/simple;
	bh=osmAc78uuGpuDsNxYTpUgKxk33u8wjw+uyWCDEW8VPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RozdW6HdsoiTIv0gMxHYiMJLRlsEAmgnAgwOJ4Up8pIp4Ymd5TEiY+FXfSsSg2dRUjWuFrfUeyoFLOlaQuuyJevybzKXs2wNt8Jo0CiNZqz02d8llnlAd139GcqBmKjm1kpKpuuqhU82J3HJ3KGL6L+McyVr1kE6hRXNQBBIyQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwlaDS1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwlaDS1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA8BC4CEC3;
	Sun,  1 Sep 2024 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207892;
	bh=osmAc78uuGpuDsNxYTpUgKxk33u8wjw+uyWCDEW8VPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwlaDS1yPbLebyrkFQjSKyqdFJdhgUjBPFWuR1uwfd4kqITshj1cqid9/anM0d8Gm
	 GcUnP0GT82OrXWGrjyfrkba0WG7EDmTD5VH1wBPDJz58cARsBibcSki2V/DiwbGz3K
	 vakpmE8jAQdVb9QeCptnqfez7mE1PdlaHn3zBEVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Brian Norris <briannorris@chromium.org>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.6 10/93] wifi: mwifiex: duplicate static structs used in driver instances
Date: Sun,  1 Sep 2024 18:15:57 +0200
Message-ID: <20240901160807.746118182@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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
@@ -4362,11 +4362,27 @@ int mwifiex_register_cfg80211(struct mwi
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
@@ -4460,8 +4476,7 @@ int mwifiex_register_cfg80211(struct mwi
 	if (ret < 0) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: wiphy_register failed: %d\n", __func__, ret);
-		wiphy_free(wiphy);
-		return ret;
+		goto err;
 	}
 
 	if (!adapter->regd) {
@@ -4503,4 +4518,9 @@ int mwifiex_register_cfg80211(struct mwi
 
 	adapter->wiphy = wiphy;
 	return ret;
+
+err:
+	wiphy_free(wiphy);
+
+	return ret;
 }


