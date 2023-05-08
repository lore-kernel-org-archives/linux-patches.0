Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CB3168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5DFC433EF;
	Mon,  8 May 2023 10:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542224;
	bh=qZhaOgWI4hzW7GgedjyCDl3YYLgj9MEApgEWqrwAw/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipnMivprHv04GB3NxpHYp8oHCLyDF+mR0rhVqNJc0Mq3EbkQVKT8htZmRz00/Pgkg
	 ZWIphR3L+/xdGnO7DmPrYlqhdutGfQDDh9AagJbVwLhThE0jfNHbO24yB8LTqrlq0R
	 tcWitP25Yh8kWVRQsDMTECdw59ofWgsnouVzszpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 366/663] wifi: iwlwifi: mvm: fix A-MSDU checks
Date: Mon,  8 May 2023 11:43:12 +0200
Message-Id: <20230508094440.016308207@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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

[ Upstream commit d34d11aea2d5d71a66f2f90507c3f7202b964175 ]

Since Gl A-step devices use the old checksum hardware,
we shouldn't use the Bz code to check for A-MSDU
combining ability; fix that.

Fixes: ec18e7d4d20d ("wifi: iwlwifi: mvm: use old checksum for Bz A-step")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230413102635.8c445b943fee.Ibf772102ca712f59e2ee0cdd4c344011fcf445aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1d46a2b345eb3..a29e685aac4ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5518,7 +5518,10 @@ static bool iwl_mvm_mac_can_aggregate(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
-	if (mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
+	if (mvm->trans->trans_cfg->device_family > IWL_DEVICE_FAMILY_BZ ||
+	    (mvm->trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_BZ &&
+	     !(CSR_HW_REV_TYPE(mvm->trans->hw_rev) == IWL_CFG_MAC_TYPE_GL &&
+	       mvm->trans->hw_rev_step == SILICON_A_STEP)))
 		return iwl_mvm_tx_csum_bz(mvm, head, true) ==
 		       iwl_mvm_tx_csum_bz(mvm, skb, true);
 
-- 
2.39.2



