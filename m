Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128E01DED74;
	Tue,  8 Oct 2024 12:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389865; cv=none; b=L45cq/y5XC4oAURv6I8KH7txUgBrFNnzeyXCY3xsPrlm4Q+sNl7jJEoDKUc79aWBemiNiQyTtxcL9BdEnGNFnA6ZbseLLcEyLc3z4EyT/qcRBsDGRepOkK71WWQQlMd1CiPndrgrOUNmBBvsed/R11FTSduV/m6AddWtPY7uSt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389865; c=relaxed/simple;
	bh=Ex+LUWw0WrWeWmQH438SXO8JTfqw8hQO0kvAvEbQ4o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZ9rfHRAjPQtx4NjGvrDWp2WN5DSMNe7FJrT/NoiB6KVrF5ZHM8np9kxELYAQXL8kHN40XK5g+C9l/RI8yr3F0TlvVMMS0f6ftIhBTd45ML4gb4HVhcjWE7sgGbVdSZUWs3+w4M5iyCqQan7TJvn4MYLIKb2hZXBo+4d2SNrcHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGbnQxtw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGbnQxtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B27AC4CEC7;
	Tue,  8 Oct 2024 12:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389864;
	bh=Ex+LUWw0WrWeWmQH438SXO8JTfqw8hQO0kvAvEbQ4o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGbnQxtwlsRIA69ppi6BFpiq5E8Vv+7qWQdUPQATGqNzwSgm2I1f2jfj7X1QJnLBm
	 ZT66QWCiFN/8jdPSl+Tgo//VT08z3groumIDVne/brUiguLVl6BDi7iGTzGUfIoH8K
	 QvNCplntlzp1KaLZHyeom4/dwRNWPG8wopofoALo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 118/482] wifi: iwlwifi: mvm: avoid NULL pointer dereference
Date: Tue,  8 Oct 2024 14:03:01 +0200
Message-ID: <20241008115652.951707704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1d695ece93e9e..51c12d70e8c23 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1195,6 +1195,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	bool is_ampdu = false;
 	int hdrlen;
 
+	if (WARN_ON_ONCE(!sta))
+		return -1;
+
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	fc = hdr->frame_control;
 	hdrlen = ieee80211_hdrlen(fc);
@@ -1202,9 +1205,6 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (IWL_MVM_NON_TRANSMITTING_AP && ieee80211_is_probe_resp(fc))
 		return -1;
 
-	if (WARN_ON_ONCE(!mvmsta))
-		return -1;
-
 	if (WARN_ON_ONCE(mvmsta->deflink.sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
@@ -1335,7 +1335,7 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
 		       struct ieee80211_sta *sta)
 {
-	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	struct iwl_mvm_sta *mvmsta;
 	struct ieee80211_tx_info info;
 	struct sk_buff_head mpdus_skbs;
 	struct ieee80211_vif *vif;
@@ -1344,9 +1344,11 @@ int iwl_mvm_tx_skb_sta(struct iwl_mvm *mvm, struct sk_buff *skb,
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



