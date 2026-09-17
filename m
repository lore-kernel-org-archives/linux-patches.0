Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A060F4FDA5A;
	Thu, 17 Sep 2026 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664901; cv=none; b=rLfJuZfFmEJRlXhF6aPXmZR0nTDWwrDklewn6T4LQMFhGPBv9rt8qsGNTBoXBpcZQd0KyN1dXptsEYJvZgNEUhYXY+GWnlAaM6K+ef5n20H+2LVTH0xAPTgev5Ftnlo0kgmkGnu+INqJpj643qh1fwfGDAWSvroRi7Vxy4p7J/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664901; c=relaxed/simple;
	bh=awyIqRBmfBZP/r95Nwt9+SYJA0LkFr0uw0zhxVATCKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXVhkmicK+Npcl5nwr0IVMYhtpv4iu6Mqb/rNZsNlAlSRvYxF9agAckBtLe1/60qjNkLPlifFdOmZZ7Bq+sxIRXi9npq/Ni+17AXm8RQVFXZTxFZ5NJssoW0Al0LVDD8Wq2tEOWxeQGNfJqFWuNYsZtYGsTiC3fzpzuV0JCBbiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivBE8dL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivBE8dL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14591F000FF;
	Thu, 17 Sep 2026 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664900;
	bh=ezkLo+q3jcEWUCobv09ieggUmH7tTMZcNuY5oY8MKcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivBE8dL21f5T0tVs8il8EyEa8aY0mexpJnFS8RIevg6IUMy4EltoAXjOKi8hBm7ci
	 +ID48fgPGVa+5/7Aa7tKIJgoLkih0UqGGzahghrmgvN8UQynJAHiiZmA7SdOCP3Abf
	 ekrpIAUku8xkv0c/8yodnRuJc08AXKSzYKjj0n2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0527/1250] wifi: iwlwifi: mvm: validate TX_CMD response layout
Date: Thu, 17 Sep 2026 16:05:22 +0100
Message-ID: <20260917151606.228195327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index bb97837baedaf..30aee52bf9cb4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1581,6 +1581,17 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
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
@@ -1884,6 +1895,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int queue = SEQ_TO_QUEUE(sequence);
 	struct ieee80211_sta *sta;
 
+	if (WARN_ON_ONCE(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	if (WARN_ON_ONCE(queue < IWL_MVM_DQA_MIN_DATA_QUEUE &&
 			 (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)))
 		return;
@@ -1918,6 +1932,26 @@ void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
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



