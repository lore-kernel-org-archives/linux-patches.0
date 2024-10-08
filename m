Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0923B1DE3A3;
	Tue,  8 Oct 2024 12:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391573; cv=none; b=iUFW7tl7vW58fJHD0AfhtnFc/IxWvZDt3w3vGYYy8Su7V/NzMa17xamvlnRjedQqIeZLFzwpsXYiHyWSCMpYel9DDkDUaF6THqz2d3/CLFQn8IErFbybU3rdaaU45AZV6S2w0A8Wo0CFBiyhG7lH9rOOVpEAgNMJ3ZEVzUy7sFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391573; c=relaxed/simple;
	bh=PBG55lAqnaQwboJtq43WsDRftctVGuPfcb1wgsPFgzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu+ywukt8sKfBTU1g8m4mLy4MUT4FryKr3FnlIo3LQHs/50juFdOjqUg0UTb433hSFf+ZH5uYLj13/dEA/vwR+E4PapBH8I4W1mxowG3JhpNCHRn9eAaFU0JmOAZkAY6GLQDJTPUbiZE+4TsYez9Mz8m7CV5az5Dx4+/kApnIVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJr0y/Fc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJr0y/Fc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778E6C4CEC7;
	Tue,  8 Oct 2024 12:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391572;
	bh=PBG55lAqnaQwboJtq43WsDRftctVGuPfcb1wgsPFgzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJr0y/Fcg4VFb27FDdXNJuHNJ1kYJ/vwpPw3GFqKjUtpg8+AjrRXSUPY9kk4X85kB
	 Tu6cUi4IFb/+kP0Rq9OmBdVDvDt/azCyU6MZpEITkEJFjDvachFSu6u8N9gerRqitB
	 N79qEdNbBF+oLOPFoMTru7kZ3eEuiFbGcjW7h9jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 139/558] wifi: iwlwifi: mvm: avoid NULL pointer dereference
Date: Tue,  8 Oct 2024 14:02:49 +0200
Message-ID: <20241008115707.835226753@linuxfoundation.org>
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
index 7ff5ea5e7aca5..db926b2f4d8d5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1203,6 +1203,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	bool is_ampdu = false;
 	int hdrlen;
 
+	if (WARN_ON_ONCE(!sta))
+		return -1;
+
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_hdrlen(fc);
@@ -1210,9 +1213,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (IWL_MVM_NON_TRANSMITTING_AP && ieee80211_is_probe_resp(fc))
 		return -1;
 
-	if (WARN_ON_ONCE(!mvmsta))
-		return -1;
-
 	if (WARN_ON_ONCE(mvmsta->deflink.sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
@@ -1343,7 +1343,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
 		       struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_sta *mvmsta;
 	struct ieee80211_tx_info info;
 	struct sk_buff_head mpdus_skbs;
 	struct ieee80211_vif *vif;
@@ -1352,9 +1352,11 @@ int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
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



