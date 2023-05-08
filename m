Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2375168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E621BC433EF;
	Mon,  8 May 2023 11:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544476;
	bh=POKbqvt9fvc6l7RP4ZCjGBg8ML0uBWcn0rP1sofmOEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMU9xLKj2x0k3KIe7x3AmLehzovbs1/m4hMcI97hM5fAEXuoLLemtVM93ZvpM7nh3
	 ZJKKpoQNW+zztpaqadIeP46RF8d/QIrIEx1sJnHu99EcUJxrZL+h2qIQbm3aqODrgU
	 Wh1ZJZBUDoeSc/CovHwTSUBofWXmWcJYtx4jepnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayala Beker <ayala.beker@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 423/694] wifi: iwlwifi: mvm: dont drop unencrypted MCAST frames
Date: Mon,  8 May 2023 11:44:18 +0200
Message-Id: <20230508094447.021261243@linuxfoundation.org>
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

From: Ayala Beker <ayala.beker@intel.com>

[ Upstream commit 8e5a26360cbe29b896b6758518280d41c3704d43 ]

MCAST frames are filtered out by the driver if we are not
authorized yet.
Fix it to filter out only protected frames.

Fixes: 147eb05f24e6 ("iwlwifi: mvm: always tell the firmware to accept MCAST frames in BSS")
Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230413213309.9cedcc27db60.I8fb7057981392660da482dd215e85c15946d3f4b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 49ca1e168fc5b..eee98cebbb46a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -384,9 +384,10 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 		 * Don't even try to decrypt a MCAST frame that was received
 		 * before the managed vif is authorized, we'd fail anyway.
 		 */
-		if (vif->type == NL80211_IFTYPE_STATION &&
+		if (is_multicast_ether_addr(hdr->addr1) &&
+		    vif->type == NL80211_IFTYPE_STATION &&
 		    !mvmvif->authorized &&
-		    is_multicast_ether_addr(hdr->addr1)) {
+		    ieee80211_has_protected(hdr->frame_control)) {
 			IWL_DEBUG_DROP(mvm, "MCAST before the vif is authorized\n");
 			kfree_skb(skb);
 			rcu_read_unlock();
-- 
2.39.2



