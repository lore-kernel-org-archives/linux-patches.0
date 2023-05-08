Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D725168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73F3C433EF;
	Mon,  8 May 2023 11:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544467;
	bh=6YVj0NxgcOJaJWuG7TKnMuyPUoLsBZezOE5j5+cJXWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9IxgXasyHO6D7ssCLaTmBpZ/OKVP0aolUwd7oi4OWbWk3/Bbj/BPsNlp/6VjO8YX
	 YgrE0Uj+WV+QvfLN9ay6oh/NnzPV61UKHmi8YrXY/4k/mmSZ01fZlgaTmVK3GKAj6Q
	 nUz//mpD9xPgIEulHvc6I078vf6zDDKdROZTFj2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 412/694] wifi: iwlwifi: mvm: fix A-MSDU checks
Date: Mon,  8 May 2023 11:44:07 +0200
Message-Id: <20230508094446.625082235@linuxfoundation.org>
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
index b55b1b17f4d19..9fc2d5d8b7d75 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5525,7 +5525,10 @@ static bool iwl_mvm_mac_can_aggregate(struct ieee80211_hw *hw,
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



