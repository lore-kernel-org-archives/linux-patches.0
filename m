Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C990A3BD643;
	Sat, 17 Oct 2026 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260360; cv=none; b=C/sX2b8U4+mk6xdb6cw0kEmALs831c9PE0hTeivsguvfChTLHe46H+3D/OAibrSEGV4fbc4O8i65nKrZjFXcY3vCPdTNIDX8FFx4VKuGKnghzBtKFmPQkkgmMeOkZIuRxiq/JNO75kQtdDMBgwrnRiW+xf/GN2WwLkIcuoYhfA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260360; c=relaxed/simple;
	bh=/evPNe/iNB/E5YT9CGyfRK2XrqT3etJ1o6csHSIHC1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebCnNmRNCfD9qNNgr3HovKiimgLVgKEoT1gFRJkrNcfjH/RQvQ7u6wWZchW1amPKAAFyHBBe4RWW7ui41hmGa198M/FXgcK1zsyoGN0fm3CwVGoDSFbix9XuYLmDPfeXoSZNlIyaz3gt1N/GbGwk+UOpjPJz2YrnQq6r8cb20qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AxSkdI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AxSkdI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225A31F000C4;
	Sat, 17 Oct 2026 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260359;
	bh=2UFv35KVFNYjR9iRiCAVgie2lTD8lJjp0jvTwd//7tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0AxSkdI1QWGfaN54uRXphqtQm61HiH+9olXSPPq3aAxk8pNAdy2NyjKhg7J9J98dp
	 R2ONeex7qZCSqpnWcDBo8WLFmXvqafS/K31SdE/TZBZp5tp2AwZyR74ZXPd4MjZ5zV
	 2yzHlWxqvGBKCIGxaMrKsuC/wr9ea9bbT87LpsyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1519/1674] wifi: iwlwifi: mvm: validate TX_CMD response layout
Date: Sat, 17 Oct 2026 18:03:11 +0200
Message-ID: <20261017160510.110760232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b75baa163ce2a..824f54c354a73 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1632,6 +1632,17 @@ static inline u32 iwl_mvm_get_scd_ssn(struct iwl_mvm *mvm,
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
@@ -1937,6 +1948,9 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	int queue = SEQ_TO_QUEUE(sequence);
 	struct ieee80211_sta *sta;
 
+	if (WARN_ON_ONCE(iwl_mvm_has_new_tx_api(mvm)))
+		return;
+
 	if (WARN_ON_ONCE(queue < IWL_MVM_DQA_MIN_DATA_QUEUE &&
 			 (queue != IWL_MVM_DQA_BSS_CLIENT_QUEUE)))
 		return;
@@ -1971,6 +1985,26 @@ void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
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



