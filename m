Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6006C2DC76C;
	Wed, 20 May 2026 17:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297694; cv=none; b=pjwDjXvzwbh9HEKQbt7pn6N7v7XbK/cCIzhYa0h25Rkw7qvM4NCV/EfomQs3/sfsf/C7j9cmYOAdKJECTzgsPFZeT4uFYqK215Wjg1/wj2fpkJXhhBtl1djFpCMDk5ZWUe/I6niX4sO4iQ5RIJcacPd/I05qoiQfEdwVE0+3A8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297694; c=relaxed/simple;
	bh=gQF7gphaSbn6tgpWH7HkSTkGDYuN+x3AYbN1R0s+DOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNONZ7WU67YoxmmjmxzPWEroRcS5miQICleD3BM5jNNLjspQAXL7DZFsYtZWLEMg12eexSExHQI+edBNlV1Xj2jwFLir6OmhSJkaIrcDdE1kt9cZNHnhGZoaTDHdQe2OiPsoIeIBFukEAxFJZOdmgf+QKYuufagIgK8ZRtvtgzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbTwJpId; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbTwJpId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C6B1F000E9;
	Wed, 20 May 2026 17:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297693;
	bh=2Wmlsi/NgVWwDenejyi00vYwMLCxKMXg1yphFHdH/YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbTwJpIdeWvTX5HEO5vnZEo+dS2fc2+I0f+VlCyfGdENa7b/Aj4h0axpXxOgva/lV
	 JMrHJ/esRRZwEy++u6aruRwU/Lxt6EgF2XB+Jv3FZbk9IrEMQAmR71LXE/y4Pkyhw/
	 NkOF14G8tCcQanBS1oUU8tc8Z/Jo61H6O+YfxU6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/957] wifi: mac80211: handle VHT EXT NSS in ieee80211_determine_our_sta_mode()
Date: Wed, 20 May 2026 18:10:09 +0200
Message-ID: <20260520162137.288826433@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit b5b8e295973083abf823fb66647a7c702a8db8a7 ]

A station which has a NSS ratio on the number of streams it is capable of
in 160MHz VHT operation is supposed to use the 'Extended NSS BW Support'
as defined by section '9.4.2.156.2 VHT Capabilities Information field'.

This was missing in ieee80211_determine_our_sta_mode() and so we would
wrongfully downgrade our bandwidth when connecting to an AP that supported
160MHz with messages such as:

	[   37.638346] wlan1: AP XX:XX:XX:XX:XX:XX changed bandwidth in assoc response, new used config is 5280.000 MHz, width 3 (5290.000/0 MHz)

Fixes: 310c8387c638 ("wifi: mac80211: clean up connection process")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://patch.msgid.link/20260327100256.3101348-1-nico.escande@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index deef15c074c83..bcc4090ddc1a5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5897,7 +5897,8 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 
 	if (is_5ghz &&
 	    !(vht_cap.cap & (IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
-			     IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))) {
+			     IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+			     IEEE80211_VHT_CAP_EXT_NSS_BW_MASK))) {
 		conn->bw_limit = IEEE80211_CONN_BW_LIMIT_80;
 		mlme_link_id_dbg(sdata, link_id,
 				 "no VHT 160 MHz capability on 5 GHz, limiting to 80 MHz");
-- 
2.53.0



