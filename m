Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1223C168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874A8C433D2;
	Mon,  8 May 2023 11:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544578;
	bh=bDWX9z+zJNJa8QFPWH9UFS2muXfYSnV2HnvIv4QT/w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8mxG3ypcEsc+uNJhPoeCy2SrLU73MXoclOk9tq04j70v6Jofidi93hfBtdObgVEL
	 d6Dfi9+vS+vqUawG69MDxeRKs/l8C+mHNSJNd56nOlfP31/MxEEHNcCQkrHJrfhG9M
	 dhup39MqXEkt/mfBDdzlI/H+wRyKnpy3Mc9fVGnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 456/694] wifi: iwlwifi: mvm: fix potential memory leak
Date: Mon,  8 May 2023 11:44:51 +0200
Message-Id: <20230508094448.412575840@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 457d7fb03e6c3d73fbb509bd85fc4b02d1ab405e ]

If we do get multiple notifications from firmware, then
we might have allocated 'notif', but don't free it. Fix
that by checking for duplicates before allocation.

Fixes: 4da46a06d443 ("wifi: iwlwifi: mvm: Add support for wowlan info notification")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230418122405.116758321cc4.I8bdbcbb38c89ac637eaa20dda58fa9165b25893a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 236694b43e8b7..d75fec8d0afd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2719,6 +2719,13 @@ static bool iwl_mvm_wait_d3_notif(struct iwl_notif_wait_data *notif_wait,
 	case WIDE_ID(PROT_OFFLOAD_GROUP, WOWLAN_INFO_NOTIFICATION): {
 		struct iwl_wowlan_info_notif *notif;
 
+		if (d3_data->notif_received & IWL_D3_NOTIF_WOWLAN_INFO) {
+			/* We might get two notifications due to dual bss */
+			IWL_DEBUG_WOWLAN(mvm,
+					 "Got additional wowlan info notification\n");
+			break;
+		}
+
 		if (wowlan_info_ver < 2) {
 			struct iwl_wowlan_info_notif_v1 *notif_v1 = (void *)pkt->data;
 
@@ -2737,13 +2744,6 @@ static bool iwl_mvm_wait_d3_notif(struct iwl_notif_wait_data *notif_wait,
 			notif = (void *)pkt->data;
 		}
 
-		if (d3_data->notif_received & IWL_D3_NOTIF_WOWLAN_INFO) {
-			/* We might get two notifications due to dual bss */
-			IWL_DEBUG_WOWLAN(mvm,
-					 "Got additional wowlan info notification\n");
-			break;
-		}
-
 		d3_data->notif_received |= IWL_D3_NOTIF_WOWLAN_INFO;
 		len = iwl_rx_packet_payload_len(pkt);
 		iwl_mvm_parse_wowlan_info_notif(mvm, notif, d3_data->status,
-- 
2.39.2



