Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04321863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4A4C433EF;
	Wed, 28 Dec 2022 15:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241023;
	bh=09Ef+HDfSjKcEkgULs/H43RSgvV81yVb6U9TEHwVerI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR9ipHDoII2VR93HcmkAUtFiU+4BpeA4ZH5i1FVhItOWiFOsBnYwmjS3sNzJl0HNY
	 RrdwyiHoc8ZH3V6Ind0ej3pfBi+Tm1E0kJ1UGnT30xoIsAFvQnLb0zUO3eLJaw/kzC
	 Ses1mZkp868Oc8zrrA0GfyEpiYMqpDdzKjB+2+JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0196/1146] wifi: mac80211: mlme: fix null-ptr deref on failed assoc
Date: Wed, 28 Dec 2022 15:28:55 +0100
Message-Id: <20221228144335.469554568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 78a6a43aaf87180ec7425a2a90468e1b4d09a1ec ]

If association to an AP without a link 0 fails, then we crash in
tracing because it assumes that either ap_mld_addr or link 0 BSS
is valid, since we clear sdata->vif.valid_links and then don't
add the ap_mld_addr to the struct.

Since we clear also sdata->vif.cfg.ap_addr, keep a local copy of
it and assign it earlier, before clearing valid_links, to fix
this.

Fixes: 81151ce462e5 ("wifi: mac80211: support MLO authentication/association with one link")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d8484cd870de..1fff44ddda8a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5033,6 +5033,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_rx_assoc_resp resp = {
 		.uapsd_queues = -1,
 	};
+	u8 ap_mld_addr[ETH_ALEN] __aligned(2);
 	unsigned int link_id;
 
 	sdata_assert_lock(sdata);
@@ -5199,6 +5200,11 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 				resp.uapsd_queues |= ieee80211_ac_to_qos_mask[ac];
 	}
 
+	if (sdata->vif.valid_links) {
+		ether_addr_copy(ap_mld_addr, sdata->vif.cfg.ap_addr);
+		resp.ap_mld_addr = ap_mld_addr;
+	}
+
 	ieee80211_destroy_assoc_data(sdata,
 				     status_code == WLAN_STATUS_SUCCESS ?
 					ASSOC_SUCCESS :
@@ -5208,8 +5214,6 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	resp.len = len;
 	resp.req_ies = ifmgd->assoc_req_ies;
 	resp.req_ies_len = ifmgd->assoc_req_ies_len;
-	if (sdata->vif.valid_links)
-		resp.ap_mld_addr = sdata->vif.cfg.ap_addr;
 	cfg80211_rx_assoc_resp(sdata->dev, &resp);
 notify_driver:
 	drv_mgd_complete_tx(sdata->local, sdata, &info);
-- 
2.35.1



