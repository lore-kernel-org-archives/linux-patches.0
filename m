Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A3B3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zf5cfTT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB63BC433C9;
	Wed, 15 Nov 2023 19:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076179;
	bh=1h+EUXxf1RGqBdWq/pkM5FMzd7Lr9jEfnw4lfn0dr0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zf5cfTT2h6PVyj/vLuG6gbbom0Ufr2e+a6ru5Fth80OVLxNtBWieqSgWjjM15x+we
	 Ptymq6Kh9R29gxRO3TueOs05n0eCeGSbXpDTVe84pjO2Uht8MMi4LawNHImBuHzIeq
	 QLoLCgw8RVHIjZ5xhxxcVU1WNX0j1r6aGYXr8rMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 125/550] wifi: iwlwifi: mvm: use correct sta ID for IGTK/BIGTK
Date: Wed, 15 Nov 2023 14:11:49 -0500
Message-ID: <20231115191609.355551641@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 63ef576c9facf5d92702e249ad213fa73eb434bf ]

We don't (yet) send the IGTK down to the firmware, but when
we do it needs to be with the broadcast station ID, not the
multicast station ID. Same for the BIGTK, which we may send
already if firmware advertises it (but it doesn't yet.)

Fixes: a5de7de7e78e ("wifi: iwlwifi: mvm: enable TX beacon protection")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230926110319.dbc653913353.I82e90c86010f0b9588a180d9835fd11f666f5196@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
index 2c9f2f71b083a..f498206470410 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
@@ -24,10 +24,15 @@ static u32 iwl_mvm_get_sec_sta_mask(struct iwl_mvm *mvm,
 			return 0;
 	}
 
-	/* AP group keys are per link and should be on the mcast STA */
+	/* AP group keys are per link and should be on the mcast/bcast STA */
 	if (vif->type == NL80211_IFTYPE_AP &&
-	    !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+	    !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		/* IGTK/BIGTK to bcast STA */
+		if (keyconf->keyidx >= 4)
+			return BIT(link_info->bcast_sta.sta_id);
+		/* GTK for data to mcast STA */
 		return BIT(link_info->mcast_sta.sta_id);
+	}
 
 	/* for client mode use the AP STA also for group keys */
 	if (!sta && vif->type == NL80211_IFTYPE_STATION)
-- 
2.42.0



