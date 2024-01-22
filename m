Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C07D154C05;
	Tue, 23 Jan 2024 00:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969415; cv=none; b=cfe1x+rSIeINKbT2+rgS4qZjfTXhKAfKJ1Deu7Rn6YcuiFuLXs/u/DauIKXHSUr++Gmd7vpGP/X9607rXi1NQHtwz+9VwJO12Q7rUB68XXG7P5VPhe7+1FqmqsfQqMTHlSVIEuQsV2QVfRH9IgzQn4OnlzcxVNN0I7ptoOFWPBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969415; c=relaxed/simple;
	bh=Yfom9pyzJaigB/on7uXwN00R7P3N2RzHxCHjFvAbsFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dof2tiCYVNz6vwCU6cGRRbO3dSksVgPoN/lNvm0AIkHHEsWxx0YYm0LGTKO0/Fnsi/rs0uPpqwaNjxeReF3lsMNltFAe4YtjDV3CJupFxcE6Si5j1yECXqk8A9dYghwaTNk0sIy8v1yVnJZm0SA9a0Z4S6Y8eApxKgXd/C8pRkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Vhl9eja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Vhl9eja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E153CC433B1;
	Tue, 23 Jan 2024 00:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969415;
	bh=Yfom9pyzJaigB/on7uXwN00R7P3N2RzHxCHjFvAbsFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Vhl9ejaPlcqOtNK+oPkFmKoGcDCdgBJH8iw7+a97BH7JOokD+QnqGA8JuSppcPtH
	 zPsc5kCsAE1SL5woM6Eu3sfIOEp0YkGFfq84eBINFrTa+TCZFrvoDFkGkW9AiJTLAY
	 ZTJsrXHn0vOqfZMP6ZFF970z2u4AhyXiip2j/IXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 230/641] wifi: cfg80211: parse all ML elements in an ML probe response
Date: Mon, 22 Jan 2024 15:52:14 -0800
Message-ID: <20240122235825.130452175@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit d18125b640309e925441ce49559be33867ae6b29 ]

A probe response from a transmitting AP in an Multi-BSSID setup will
contain more than one Multi-Link element. Most likely, only one of these
elements contains per-STA profiles.

Fixes: 2481b5da9c6b ("wifi: cfg80211: handle BSS data contained in ML probe responses")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240102213313.6635eb152735.I94289002d4a2f7b6b44dfa428344854e37b0b29c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 8cd3eef76f2b..0d6c3fc1238a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2591,10 +2591,12 @@ cfg80211_tbtt_info_for_mld_ap(const u8 *ie, size_t ielen, u8 mld_id, u8 link_id,
 	return false;
 }
 
-static void cfg80211_parse_ml_sta_data(struct wiphy *wiphy,
-				       struct cfg80211_inform_single_bss_data *tx_data,
-				       struct cfg80211_bss *source_bss,
-				       gfp_t gfp)
+static void
+cfg80211_parse_ml_elem_sta_data(struct wiphy *wiphy,
+				struct cfg80211_inform_single_bss_data *tx_data,
+				struct cfg80211_bss *source_bss,
+				const struct element *elem,
+				gfp_t gfp)
 {
 	struct cfg80211_inform_single_bss_data data = {
 		.drv_data = tx_data->drv_data,
@@ -2603,7 +2605,6 @@ static void cfg80211_parse_ml_sta_data(struct wiphy *wiphy,
 		.bss_source = BSS_SOURCE_STA_PROFILE,
 	};
 	struct ieee80211_multi_link_elem *ml_elem;
-	const struct element *elem;
 	struct cfg80211_mle *mle;
 	u16 control;
 	u8 *new_ie;
@@ -2613,15 +2614,7 @@ static void cfg80211_parse_ml_sta_data(struct wiphy *wiphy,
 	const u8 *pos;
 	u8 i;
 
-	if (!source_bss)
-		return;
-
-	if (tx_data->ftype != CFG80211_BSS_FTYPE_PRESP)
-		return;
-
-	elem = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_MULTI_LINK,
-				      tx_data->ie, tx_data->ielen);
-	if (!elem || !ieee80211_mle_size_ok(elem->data + 1, elem->datalen - 1))
+	if (!ieee80211_mle_size_ok(elem->data + 1, elem->datalen - 1))
 		return;
 
 	ml_elem = (void *)elem->data + 1;
@@ -2756,6 +2749,25 @@ static void cfg80211_parse_ml_sta_data(struct wiphy *wiphy,
 	kfree(mle);
 }
 
+static void cfg80211_parse_ml_sta_data(struct wiphy *wiphy,
+				       struct cfg80211_inform_single_bss_data *tx_data,
+				       struct cfg80211_bss *source_bss,
+				       gfp_t gfp)
+{
+	const struct element *elem;
+
+	if (!source_bss)
+		return;
+
+	if (tx_data->ftype != CFG80211_BSS_FTYPE_PRESP)
+		return;
+
+	for_each_element_extid(elem, WLAN_EID_EXT_EHT_MULTI_LINK,
+			       tx_data->ie, tx_data->ielen)
+		cfg80211_parse_ml_elem_sta_data(wiphy, tx_data, source_bss,
+						elem, gfp);
+}
+
 struct cfg80211_bss *
 cfg80211_inform_bss_data(struct wiphy *wiphy,
 			 struct cfg80211_inform_bss *data,
-- 
2.43.0



