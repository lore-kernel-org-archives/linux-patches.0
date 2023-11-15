Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0883C465
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Im1tGrFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38814C433C9;
	Wed, 15 Nov 2023 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077211;
	bh=bYsxkNxd6Fjq8jby3diRaV7zOQdU1CBkoF4TqP5pVYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Im1tGrFYhaQPgriCYHxBF+zkmFlJKz2e86yfBBCnQefthoPVFTUcwEF3ywPVTgFQN
	 WxM37vSwRU4ohkmg/9xFrbwV3RmUp1IwuD73cuszDGH/PbhtIXZl8ntfPn9tDU605Y
	 bXk/BGYjAufQC7Ia3jHqGBRz5UomvtNVzkvfhHuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yedidya Benshimol <yedidya.ben.shimol@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 146/603] wifi: iwlwifi: mvm: update IGTK in mvmvif upon D3 resume
Date: Wed, 15 Nov 2023 14:11:31 -0500
Message-ID: <20231115191623.293911649@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Yedidya Benshimol <yedidya.ben.shimol@intel.com>

[ Upstream commit ac0c6fdc4c56b669abc1c4a323f1c7a3a1422dd2 ]

During the D3 resume flow, all new rekeys are passed from the FW.
Because the FW supports only one IGTK at a time, every IGTK rekey
update should be done by removing the last IGTK. The mvmvif holds a
pointer to the last IGTK for that reason and thus should be updated
when a new IGTK is passed upon resume.

Fixes: 04f78e242fff ("wifi: iwlwifi: mvm: Add support for IGTK in D3 resume flow")
Signed-off-by: Yedidya Benshimol <yedidya.ben.shimol@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231017115047.8ceaf7e5ece7.Ief444f6a2703ed76648b4d414f12bb4130bab36e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index f6488b4bbe68b..be2602d8c5bfa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2012,6 +2012,16 @@ iwl_mvm_d3_igtk_bigtk_rekey_add(struct iwl_wowlan_status_data *status,
 	if (IS_ERR(key_config))
 		return false;
 	ieee80211_set_key_rx_seq(key_config, 0, &seq);
+
+	if (key_config->keyidx == 4 || key_config->keyidx == 5) {
+		struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+		int link_id = vif->active_links ? __ffs(vif->active_links) : 0;
+		struct iwl_mvm_vif_link_info *mvm_link =
+			mvmvif->link[link_id];
+
+		mvm_link->igtk = key_config;
+	}
+
 	return true;
 }
 
-- 
2.42.0



