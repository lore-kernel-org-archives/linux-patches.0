Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0012C26B084;
	Tue, 25 Mar 2025 12:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906213; cv=none; b=BL63ZHBbhHnJkSfv0o1Pv1ZFJv19h+93SP2f7b/AjN7Dms/ER2EF7K32K1iCcOj2xoiQnkQyXRoIAUNAuvDfvVfcaQKnn7CIFaZFypvF3cqgdt3+dIyEJ8Gy+hZaeQIEYCJP140iYvA4zFnqYFoD5rp2LOKFW+HXbmeP9JoEOM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906213; c=relaxed/simple;
	bh=5RwI4l9yhgkqdS3IwITTrXGS/mM7kBDbQc4ueBiSMss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dT06cTwEQY4XXAGw2sIC6ZQxB0KMbHTXCivnbjMwd5Zjx/K9AOb2CDENV/SL2/uQC7DPV2meqbPon49wy30Vdw3EaDgKO/4T1q3YquTWlvXEAFiXTgGyph70Q6hfJDv3fH3x85G81lL2jvnAD9wSP8Q6xo1ULEbYQEe6FymZG1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7HQBXoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7HQBXoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2862C4CEE9;
	Tue, 25 Mar 2025 12:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906212;
	bh=5RwI4l9yhgkqdS3IwITTrXGS/mM7kBDbQc4ueBiSMss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7HQBXoKWme2EsiivlpUwfAAcfqJV71ShVqPnKWPCIwetajx6zqSKE5vIk0Cs/Oll
	 kaYTMldLJnczml/9/lHloydATBxzY7y1be6E4OZuGuxviEKMfQ+4AsYSkkG/T/f8JT
	 iKWhnLoIgYxgbvhAf1sVCSrKoKDSYXrXA1mOCtQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 76/77] wifi: iwlwifi: mvm: ensure offloading TID queue exists
Date: Tue, 25 Mar 2025 08:23:11 -0400
Message-ID: <20250325122146.438511248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Benjamin Berg <benjamin.berg@intel.com>

commit 78f65fbf421a61894c14a1b91fe2fb4437b3fe5f upstream.

The resume code path assumes that the TX queue for the offloading TID
has been configured. At resume time it then tries to sync the write
pointer as it may have been updated by the firmware.

In the unusual event that no packets have been send on TID 0, the queue
will not have been allocated and this causes a crash. Fix this by
ensuring the queue exist at suspend time.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240218194912.6632e6dc7b35.Ie6e6a7488c9c7d4529f13d48f752b5439d8ac3c4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c  |    9 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |   28 +++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |    3 +-
 3 files changed, 38 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1293,7 +1293,9 @@ static int __iwl_mvm_suspend(struct ieee
 
 		mvm->net_detect = true;
 	} else {
-		struct iwl_wowlan_config_cmd wowlan_config_cmd = {};
+		struct iwl_wowlan_config_cmd wowlan_config_cmd = {
+			.offloading_tid = 0,
+		};
 
 		wowlan_config_cmd.sta_id = mvmvif->deflink.ap_sta_id;
 
@@ -1305,6 +1307,11 @@ static int __iwl_mvm_suspend(struct ieee
 			goto out_noreset;
 		}
 
+		ret = iwl_mvm_sta_ensure_queue(
+			mvm, ap_sta->txq[wowlan_config_cmd.offloading_tid]);
+		if (ret)
+			goto out_noreset;
+
 		ret = iwl_mvm_get_wowlan_config(mvm, wowlan, &wowlan_config_cmd,
 						vif, mvmvif, ap_sta);
 		if (ret)
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1501,6 +1501,34 @@ out_err:
 	return ret;
 }
 
+int iwl_mvm_sta_ensure_queue(struct iwl_mvm *mvm,
+			     struct ieee80211_txq *txq)
+{
+	struct iwl_mvm_txq *mvmtxq = iwl_mvm_txq_from_mac80211(txq);
+	int ret = -EINVAL;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (likely(test_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state)) ||
+	    !txq->sta) {
+		return 0;
+	}
+
+	if (!iwl_mvm_sta_alloc_queue(mvm, txq->sta, txq->ac, txq->tid)) {
+		set_bit(IWL_MVM_TXQ_STATE_READY, &mvmtxq->state);
+		ret = 0;
+	}
+
+	local_bh_disable();
+	spin_lock(&mvm->add_stream_lock);
+	if (!list_empty(&mvmtxq->list))
+		list_del_init(&mvmtxq->list);
+	spin_unlock(&mvm->add_stream_lock);
+	local_bh_enable();
+
+	return ret;
+}
+
 void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk)
 {
 	struct iwl_mvm *mvm = container_of(wk, struct iwl_mvm,
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2022 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2024 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2016 Intel Deutschland GmbH
  */
@@ -577,6 +577,7 @@ void iwl_mvm_modify_all_sta_disable_tx(s
 				       bool disable);
 
 void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_sta_ensure_queue(struct iwl_mvm *mvm, struct ieee80211_txq *txq);
 void iwl_mvm_add_new_dqa_stream_wk(struct work_struct *wk);
 int iwl_mvm_add_pasn_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			 struct iwl_mvm_int_sta *sta, u8 *addr, u32 cipher,


