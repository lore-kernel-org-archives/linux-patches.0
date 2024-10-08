Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9C11DDC24;
	Tue,  8 Oct 2024 12:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391376; cv=none; b=ZbX8xNUNb/Pznz4aG8PC4L9YaV0WqJLyPHOo9sPLbLgsYrYrKaSrmW3eW1M/SQ/UBYWzlsbt/DEKtcg4lASbO/6i96HFwfWcDCqX4TU8wqpnlwJaCtr4xUUONro+mPb6mfeEE5gMkV/m+z2/OAS5HX9N4O4Zoji5juSlLxy9sj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391376; c=relaxed/simple;
	bh=MY12BubPSsjVHyQKPSo/DBV0gGFzq4N+/7Erdoo8t2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIQPOkQPmhQ4LsaLOAabdcdOxb47MmZ1JFJeGrI69ZyCY28eN6SdEJ7qSPB/sfuUCibl8JDl00ivOAy7aCMy1m2PqlRboizcWDUthVk1foVVme50usiYqQzICjnpYrItBP7x0OyB55mdHiVpKT6kzVUyLiNGXigUbX4TJZd3XI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOZJDmjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOZJDmjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAB6C4CEC7;
	Tue,  8 Oct 2024 12:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391375;
	bh=MY12BubPSsjVHyQKPSo/DBV0gGFzq4N+/7Erdoo8t2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOZJDmjHBwxrTaSR05fFnmlGXvzqX7Zr9ZQ+0Xq7y1pw974cvkDGmI6EoMw6mvmYF
	 vS2yfmq5LXnoQtNjxpREV2vbb5AlgS/d4jh74RddhXuR0RH3LZsl2nyC7RRnJxV/el
	 oAzsYxPGjrRB3ZpPBsLWcnXyUDA1n+ebSSQOlb2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 094/558] wifi: iwlwifi: mvm: drop wrong STA selection in TX
Date: Tue,  8 Oct 2024 14:02:04 +0200
Message-ID: <20241008115706.069055450@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 625ccf566e1c2..1ebcc6417ecef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -838,20 +838,10 @@ void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
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



