Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348FC76413;
	Mon,  8 Apr 2024 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581501; cv=none; b=GNzl5CQ9dUsfLXj95urft9muNTX9+fJzKT5+cRR6zniM3TqVZBI9OUQKw5/jysOBcZYHkgllwl/Dr4cz1QBfbYQskugpuxfiAuv9UU/a7b3shBgmgGBIvcA/d1o2Ysm6lSiJiuFGueENgx/W81MfkGOvdhm5XYBntubBGqitn4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581501; c=relaxed/simple;
	bh=7LrHL5C8txertr8OqDQJbseWA59YZ8KeD2hQ5mRjPZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqxK4iZzcHtVnZYw3hHtFJpGqscEvcr9StVoQzGaH7qvhJESNd0oLifWacLo4OxJrXOKmyzNE+EYPX2xdGezAoXSIbHSqNZoPy/3txXcdfk/XrO2NSibAEz9NM1EEf+JbAPKDsTzUkbzAkzNwzBfPUKMpnWqcvXJd4MjM54Vn1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7cEYHhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7cEYHhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FB8C433C7;
	Mon,  8 Apr 2024 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581501;
	bh=7LrHL5C8txertr8OqDQJbseWA59YZ8KeD2hQ5mRjPZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7cEYHhh3XCI7ZmK+HhHzwr8n1F+QAgT40R7gLLglqtA7TJKPsBGHMQXkABlHSsPY
	 qo/3PftadJVcrYic75eMg1FUOuG/tCj2gS67Z1eKU+LFsqMQIq+W691KVoKeBAUmq5
	 C9r6EM/pmKkzernFkM8KE68NEW6ybyeC/bHw8O5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/252] wifi: iwlwifi: disable multi rx queue for 9000
Date: Mon,  8 Apr 2024 14:55:11 +0200
Message-ID: <20240408125307.029712718@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 29fa9a984b6d1075020f12071a89897fd62ed27f ]

Multi rx queue allows to spread the load of the Rx streams on different
CPUs. 9000 series required complex synchronization mechanisms from the
driver side since the hardware / firmware is not able to provide
information about duplicate packets and timeouts inside the reordering
buffer.

Users have complained that for newer devices, all those synchronization
mechanisms have caused spurious packet drops. Those packet drops
disappeared if we simplify the code, but unfortunately, we can't have
RSS enabled on 9000 series without this complex code.

Remove support for RSS on 9000 so that we can make the code much simpler
for newer devices and fix the bugs for them.

The down side of this patch is a that all the Rx path will be routed to
a single CPU, but this has never been an issue, the modern CPUs are just
fast enough to cope with all the traffic.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231017115047.2917eb8b7af9.Iddd7dcf335387ba46fcbbb6067ef4ff9cd3755a7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: e78d78773089 ("wifi: iwlwifi: mvm: include link ID when releasing frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 11 ++++++++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 168eda2132fb8..9dcc1506bd0b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -278,7 +278,7 @@ static inline void iwl_free_rxb(struct iwl_rx_cmd_buffer *r)
 #define IWL_MGMT_TID		15
 #define IWL_FRAME_LIMIT	64
 #define IWL_MAX_RX_HW_QUEUES	16
-#define IWL_9000_MAX_RX_HW_QUEUES	6
+#define IWL_9000_MAX_RX_HW_QUEUES	1
 
 /**
  * enum iwl_wowlan_status - WoWLAN image/device status
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index aaa9840d0d4c5..ee9d14250a261 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -352,7 +352,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	}
 
-	if (iwl_mvm_has_new_rx_api(mvm))
+	/* We want to use the mac80211's reorder buffer for 9000 */
+	if (iwl_mvm_has_new_rx_api(mvm) &&
+	    mvm->trans->trans_cfg->device_family > IWL_DEVICE_FAMILY_9000)
 		ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index bac0228b8c866..92b3e18dbe877 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -963,6 +963,9 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
 	baid = (reorder & IWL_RX_MPDU_REORDER_BAID_MASK) >>
 		IWL_RX_MPDU_REORDER_BAID_SHIFT;
 
+	if (mvm->trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_9000)
+		return false;
+
 	/*
 	 * This also covers the case of receiving a Block Ack Request
 	 * outside a BA session; we'll pass it to mac80211 and that
@@ -2621,9 +2624,15 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	if (!iwl_mvm_reorder(mvm, napi, queue, sta, skb, desc) &&
 	    likely(!iwl_mvm_time_sync_frame(mvm, skb, hdr->addr2)) &&
-	    likely(!iwl_mvm_mei_filter_scan(mvm, skb)))
+	    likely(!iwl_mvm_mei_filter_scan(mvm, skb))) {
+		if (mvm->trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_9000 &&
+		    (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU) &&
+		    !(desc->amsdu_info & IWL_RX_MPDU_AMSDU_LAST_SUBFRAME))
+			rx_status->flag |= RX_FLAG_AMSDU_MORE;
+
 		iwl_mvm_pass_packet_to_mac80211(mvm, napi, skb, queue, sta,
 						link_sta);
+	}
 out:
 	rcu_read_unlock();
 }
-- 
2.43.0



