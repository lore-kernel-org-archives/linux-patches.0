Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A352381DC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJo/vHia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2596C433C8;
	Wed, 15 Nov 2023 19:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076928;
	bh=uNr43cE+PGukcM+XEWQybLZfohmwH6MBwTxmVISBoJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJo/vHiaY2y+qTMwveLnmsvPjsrCZNPHpXQrAum8vFttlBeF/MxVNhoUKd5WZnNhF
	 vC1GNBG2mGB1UhDXtvq/IwRuG0wjFoAX20Jd5An/plV650dWagglkYms2w+4UhL2o3
	 DkndEWwMavl5BXhgXVQA3M4u4KvRPlqtfJ0/PLvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/603] wifi: iwlwifi: Use FW rate for non-data frames
Date: Wed, 15 Nov 2023 14:09:57 -0500
Message-ID: <20231115191616.735909450@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 499d02790495958506a64f37ceda7e97345a50a8 ]

Currently we are setting the rate in the tx cmd for
mgmt frames (e.g. during connection establishment).
This was problematic when sending mgmt frames in eSR mode,
as we don't know what link this frame will be sent on
(This is decided by the FW), so we don't know what is the
lowest rate.
Fix this by not setting the rate in tx cmd and rely
on FW to choose the right one.
Set rate only for injected frames with fixed rate,
or when no sta is given.
Also set for important frames (EAPOL etc.) the High Priority flag.

Fixes: 055b22e770dd ("iwlwifi: mvm: Set Tx rate and flags when there is not station")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230913145231.6c7e59620ee0.I6eaed3ccdd6dd62b9e664facc484081fc5275843@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 898dca3936435..8158e6d9ef190 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -536,16 +536,20 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 			flags |= IWL_TX_FLAGS_ENCRYPT_DIS;
 
 		/*
-		 * For data packets rate info comes from the fw. Only
-		 * set rate/antenna during connection establishment or in case
-		 * no station is given.
+		 * For data and mgmt packets rate info comes from the fw. Only
+		 * set rate/antenna for injected frames with fixed rate, or
+		 * when no sta is given.
 		 */
-		if (!sta || !ieee80211_is_data(hdr->frame_control) ||
-		    mvmsta->sta_state < IEEE80211_STA_AUTHORIZED) {
+		if (unlikely(!sta ||
+			     info->control.flags & IEEE80211_TX_CTRL_RATE_INJECT)) {
 			flags |= IWL_TX_FLAGS_CMD_RATE;
 			rate_n_flags =
 				iwl_mvm_get_tx_rate_n_flags(mvm, info, sta,
 							    hdr->frame_control);
+		} else if (!ieee80211_is_data(hdr->frame_control) ||
+			   mvmsta->sta_state < IEEE80211_STA_AUTHORIZED) {
+			/* These are important frames */
+			flags |= IWL_TX_FLAGS_HIGH_PRI;
 		}
 
 		if (mvm->trans->trans_cfg->device_family >=
-- 
2.42.0



