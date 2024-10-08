Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43341DED6F;
	Tue,  8 Oct 2024 13:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393136; cv=none; b=JoMvJNnyOKbmwr2OFzo94/Bo4bb1Cd9ywPJ5hPO+ygGHpnteXHAfLLZ3WDyWiT9hkmHFGGO7Dl+qqs3nA70M6uCrpvH9VP8vdKP7ARsCRtJEaQpsRkpUKCppbrUHv01jdiE5aD4n93vullI40TZA3xl2n+OA/tfHtUldpp+Fobs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393136; c=relaxed/simple;
	bh=7THhpSYiicXtbqZ0NV5ygUXy5uMwkuNAjp0mg3IiqfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDYZbzXJvUmZfJ0JlS7YR5iO7j7/f42pnTJL0hq7ANjS11V3tn7GEyefuEwHNe/2QGfcuQ+fCeKSqYQJD6dM6c3nXLq8ob66cBm9QXf6gAscztFEL2Kazj0EELxCKUXc8ieqJ1Evx6Fo3eO+gIt2Qc04SZtIs2nauYy0GzVva04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwRowln6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwRowln6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FD6C4CEC7;
	Tue,  8 Oct 2024 13:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393136;
	bh=7THhpSYiicXtbqZ0NV5ygUXy5uMwkuNAjp0mg3IiqfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwRowln6mD1Cts/9QrwYuouQ7u3eBTaQ4XUtueE/i38WDmlS+apuqNmM89UB3/cJq
	 x+EGen7Me189kmfkecSI1i5Y3ATQQTkgA4xYHKwQmCrQM2qqRi6H1CSuy47LVWVk/1
	 6WF0Oi96OyKTwVwDvLAQof0W0WXlShpQRrHDVp2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/386] wifi: iwlwifi: mvm: drop wrong STA selection in TX
Date: Tue,  8 Oct 2024 14:05:09 +0200
Message-ID: <20241008115631.987531147@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1c7e1068a7c9c39ed27636db93e71911e0045419 ]

This shouldn't happen at all, since in station mode all MMPDUs
go through the TXQ for the STA, and not this function. There
may or may not be a race in mac80211 through which this might
happen for some frames while a station is being added, but in
that case we can also just drop the frame and pretend the STA
didn't exist yet.

Also, the code is simply wrong since it uses deflink, and it's
not easy to fix it since the mvmvif->ap_sta pointer cannot be
used without the mutex, and perhaps the right link might not
even be known.

Just drop the frame at that point instead of trying to fix it
up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240808232017.45ad105dc7fe.I6d45c82e5758395d9afb8854057ded03c7dc81d7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c    | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d2daea3b1f38a..2d35a8865d00b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -766,20 +766,10 @@ void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	if (ieee80211_is_mgmt(hdr->frame_control))
 		sta = NULL;
 
-	/* If there is no sta, and it's not offchannel - send through AP */
+	/* this shouldn't even happen: just drop */
 	if (!sta && info->control.vif->type == NL80211_IFTYPE_STATION &&
-	    !offchannel) {
-		struct iwl_mvm_vif *mvmvif =
-			iwl_mvm_vif_from_mac80211(info->control.vif);
-		u8 ap_sta_id = READ_ONCE(mvmvif->deflink.ap_sta_id);
-
-		if (ap_sta_id < mvm->fw->ucode_capa.num_stations) {
-			/* mac80211 holds rcu read lock */
-			sta = rcu_dereference(mvm->fw_id_to_mac_id[ap_sta_id]);
-			if (IS_ERR_OR_NULL(sta))
-				goto drop;
-		}
-	}
+	    !offchannel)
+		goto drop;
 
 	if (tmp_sta && !sta && link_id != IEEE80211_LINK_UNSPECIFIED &&
 	    !ieee80211_is_probe_resp(hdr->frame_control)) {
-- 
2.43.0



