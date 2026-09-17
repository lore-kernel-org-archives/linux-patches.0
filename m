Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C5C4E36E6;
	Thu, 17 Sep 2026 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668432; cv=none; b=dKcMtXqlULCML2SqY0O+v3kWj63fsPDU0BQg30CCwSRjLGI7vBXOBR0I4LXsygd0K8rqNpcyMWeZKd1VpvomHfmWSycLfIHNnPZ5Z9qke5gVlGyZuX9DePOFZomRXVkxGGlFTKCwE6HwRL/eDcsn7RFdh+SoKlod0Mcv6CfybqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668432; c=relaxed/simple;
	bh=nQA9EYIfyiAR4O0vtxRKWbj2lX5TI+AiUJ01ETOXX74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ev9f+9zZhKzcuSiGUOZFQYMte0LPF9xrXQvyZGVEXYyYnmt+NktFbBX4XR+iH16wPm6yrsT9wbg8vVrEO6Qs/msJKwHsw4NZBNYoX2d2Q4cBpQ0E2QKGy3PJKOSh9wwxa6sASvBMAoP+cBD19dMyYwMEsdBauhMKbeWUXaOy3mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyZSncdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyZSncdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042151F000FF;
	Thu, 17 Sep 2026 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668431;
	bh=UOrXlYsQB09SNdDc5q41HVbQUTrJAT1DBuPbrW2FNyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyZSncdFPLlXaziH+jWLig9v3LP2HSgYaEkWIXQBoyHd4NaiNfZo3MTLOcg1Ua5j8
	 oVdMK+KJ5u+nEXiu0QJT1K0l5/7W2EM87OHRu0MYkgnCKICY819srBM3w/OhcNMsRg
	 KPPws4SKHWSFcfyl3Yrr/UGo4rGDvbNfZ7V6tzS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0424/1102] wifi: iwlwifi: mvm: validate TX_CMD response layout
Date: Thu, 17 Sep 2026 16:06:07 +0100
Message-ID: <20260917151550.315781127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 8d70881707b47353359df57df12f6de67fdacdd2 ]

TX_CMD parsing uses frame_count to walk status entries and then
read the trailing SCD SSN. Make the minimum-length check follow
that exact runtime layout calculation before parsing the payload.

For new TX API, reject TX_CMD responses with frame_count != 1 and
warn/return in the aggregation handler to document that aggregated
accounting is expected via BA notifications.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.0474ee89bab9.I84f151aabecb8921b587da092f29f78c47128f0f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 34 +++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 5f4942f6cc68e..c1fc45cb7e025 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1690,6 +1690,17 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
 	return val & 0xFFF;
 }
 
+static inline size_t iwl_mvm_tx_resp_min_len(struct iwl_mvm *mvm,
+					     struct iwl_tx_resp *tx_resp)
+{
+	struct agg_tx_status *agg_status =
+		iwl_mvm_get_agg_status(mvm, tx_resp);
+
+	/* The aggregate response ends with a trailing SCD SSN __le32 word. */
+	return (u8 *)(agg_status + tx_resp->frame_count) - (u8 *)tx_resp +
+		sizeof(__le32);
+}
+
 static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 				     struct iwl_rx_packet *pkt)
 {
@@ -1998,6 +2009,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int queue = SEQ_TO_QUEUE(sequence);
 	struct ieee80211_sta *sta;
 
+	if (WARN_ON_ONCE(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	if (WARN_ON_ONCE(queue < IWL_MVM_DQA_MIN_DATA_QUEUE &&
 			 (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)))
 		return;
@@ -2032,6 +2046,26 @@ void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_tx_resp *tx_resp = (void *)pkt->data;
+	size_t min_len;
+
+	if (IWL_FW_CHECK(mvm, !tx_resp->frame_count,
+			 "invalid TX_CMD frame_count %u\n",
+			 tx_resp->frame_count))
+		return;
+
+	if (IWL_FW_CHECK(mvm,
+			 iwl_mvm_has_new_tx_api(mvm) &&
+			 tx_resp->frame_count != 1,
+			 "invalid TX_CMD frame_count %u for new TX API\n",
+			 tx_resp->frame_count))
+		return;
+
+	min_len = iwl_mvm_tx_resp_min_len(mvm, tx_resp);
+	if (IWL_FW_CHECK(mvm, iwl_rx_packet_payload_len(pkt) < min_len,
+			 "invalid TX_CMD len %u (frame_count %u, min %zu)\n",
+			 iwl_rx_packet_payload_len(pkt), tx_resp->frame_count,
+			 min_len))
+		return;
 
 	if (tx_resp->frame_count == 1)
 		iwl_mvm_rx_tx_cmd_single(mvm, pkt);
-- 
2.53.0



