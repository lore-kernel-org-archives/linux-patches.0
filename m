Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B99D1DEFEA;
	Tue,  8 Oct 2024 13:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393249; cv=none; b=bvkpfmQSokJ6RV3FzAaMzRyxaHt1O3xpSo+0cp8EzGUJf8+MtOPbRaK9U+NWEKpiDWehj2GjWzAsQllhbMoxclk/li0Hd/DuGocPDY5xRIrMPiZnLbG205JaIqo2vAbj2iJ+MqZL8QxWM12ipGzNamaJ3dio2r+rmF1/BsdhCOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393249; c=relaxed/simple;
	bh=o9/wU2DMdxatRmlpQkd8si3cUUg0rZPcrZPL/f/UwD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtgXW8pOKvcyKews9pk3BtEbi8f+FjgBmH7n3szq0hzsQQIKyTnd3ZuzLEB42dlQ03+cG+NM06iU8NbwBkXeU8OnGk4/jecwryCaC9koGHEO1elNiKEwlK4TQ0sGm0X5bRKm0RJnIdq0y2T91+E0hVJZDyClJUNYZDShVpeMHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7s4K1tG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7s4K1tG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC94C4CEC7;
	Tue,  8 Oct 2024 13:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393249;
	bh=o9/wU2DMdxatRmlpQkd8si3cUUg0rZPcrZPL/f/UwD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7s4K1tGhG4uD2iU3H07w7NzLTZqjtbzvukCivDtMJYYDNHcfcv1nwLu2RF7zjMKO
	 tOuC+T4t3cRY8aPknjeG2N2eW6DhVELAssbU3qDEM+KBacFVvEQDNtel6VYY/L6fAc
	 PPRTcUfxAANHMDRWZMDJ9ekDsvv5pjNpBpsznUMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/386] wifi: iwlwifi: mvm: avoid NULL pointer dereference
Date: Tue,  8 Oct 2024 14:05:42 +0200
Message-ID: <20241008115633.266051069@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 557a6cd847645e667f3b362560bd7e7c09aac284 ]

iwl_mvm_tx_skb_sta() and iwl_mvm_tx_mpdu() verify that the mvmvsta
pointer is not NULL.
It retrieves this pointer using iwl_mvm_sta_from_mac80211, which is
dereferencing the ieee80211_sta pointer.
If sta is NULL, iwl_mvm_sta_from_mac80211 will dereference a NULL
pointer.
Fix this by checking the sta pointer before retrieving the mvmsta
from it. If sta is not NULL, then mvmsta isn't either.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20240825191257.880921ce23b7.I340052d70ab6d3410724ce955eb00da10e08188f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 3adb1acc07191..ce5f2bdde1388 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1145,6 +1145,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	bool is_ampdu = false;
 	int hdrlen;
 
+	if (WARN_ON_ONCE(!sta))
+		return -1;
+
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_hdrlen(fc);
@@ -1152,9 +1155,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (IWL_MVM_NON_TRANSMITTING_AP && ieee80211_is_probe_resp(fc))
 		return -1;
 
-	if (WARN_ON_ONCE(!mvmsta))
-		return -1;
-
 	if (WARN_ON_ONCE(mvmsta->deflink.sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
@@ -1285,7 +1285,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
 		       struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_sta *mvmsta;
 	struct ieee80211_tx_info info;
 	struct sk_buff_head mpdus_skbs;
 	struct ieee80211_vif *vif;
@@ -1294,9 +1294,11 @@ int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct sk_buff *orig_skb = skb;
 	const u8 *addr3;
 
-	if (WARN_ON_ONCE(!mvmsta))
+	if (WARN_ON_ONCE(!sta))
 		return -1;
 
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
 	if (WARN_ON_ONCE(mvmsta->deflink.sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
-- 
2.43.0



