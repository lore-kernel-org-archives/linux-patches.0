Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8CA3AE1A6;
	Mon, 23 Mar 2026 14:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274789; cv=none; b=L9YYSNlMTjD0UX7pO4FrAbVQS8srYKxwbsECchEtFWnEBO5T9Oh0KmiBeljM2BEAyONlLFXgsnM52okKNLfAqy9oYSF63J7uPLUzUvOPLEMygw8P4fGUab8vZ29QM23QRA/M7eESXDVrfw3Q0oNYQRoLF5SHPSHCBEuz3QoVYuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274789; c=relaxed/simple;
	bh=MkD1E/W8P2NWyhDrJABLnCXyxl+8PIb4kQN6iONP1lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbAF2xbEghWwN2cxV1grzuP57HVSw73RH98IypHMCq9IUPKuBALVRnBWWLmOe38MFwKNiuvJT/OB8CaK3MgZ+jtpxp8/Ybn8zYEcWmsAyG7QUNfC4uElvBThF8PfPlBmeJ0kCDlWYYjCeRid98NIBReu8U1b2hZrFPXOFt13RwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0NtNGsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0NtNGsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65A0C2BCB3;
	Mon, 23 Mar 2026 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274789;
	bh=MkD1E/W8P2NWyhDrJABLnCXyxl+8PIb4kQN6iONP1lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0NtNGsN8cAda7Qjq79pRvgYu6JCqVg0Uc+ru1OmkRjPnMSKweo2cz6eUXw/4gcR7
	 bh/s2ymo0KjA0Vt0v5etEF8qZW8SQqBTPdZEgGzFb1AJT8UFs5lbNr8AxKrIwfM0bL
	 h82o83ORvVd3lW2ahzUlM62b/2cua2HesyedVucY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 108/212] wifi: mac80211: remove keys after disabling beaconing
Date: Mon, 23 Mar 2026 14:45:29 +0100
Message-ID: <20260323134507.194296317@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 708bbb45537780a8d3721ca1e0cf1932c1d1bf5f ]

We shouldn't remove keys before disable beaconing, at least when
beacon protection is used, since that would remove keys that are
still used for beacon transmission at the same time. Stop before
removing keys so there's no race.

Fixes: af2d14b01c32 ("mac80211: Beacon protection using the new BIGTK (STA)")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260303150339.574e7887b3ab.I50d708f5aa22584506a91d0da7f8a73ba39fceac@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e18df59951a82..d32eacbb7517d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1872,12 +1872,6 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	__sta_info_flush(sdata, true, link_id, NULL);
 
-	ieee80211_remove_link_keys(link, &keys);
-	if (!list_empty(&keys)) {
-		synchronize_net();
-		ieee80211_free_key_list(local, &keys);
-	}
-
 	ieee80211_stop_mbssid(sdata);
 	RCU_INIT_POINTER(link_conf->tx_bss_conf, NULL);
 
@@ -1889,6 +1883,12 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	ieee80211_link_info_change_notify(sdata, link,
 					  BSS_CHANGED_BEACON_ENABLED);
 
+	ieee80211_remove_link_keys(link, &keys);
+	if (!list_empty(&keys)) {
+		synchronize_net();
+		ieee80211_free_key_list(local, &keys);
+	}
+
 	if (sdata->wdev.links[link_id].cac_started) {
 		chandef = link_conf->chanreq.oper;
 		wiphy_delayed_work_cancel(wiphy, &link->dfs_cac_timer_work);
-- 
2.51.0



