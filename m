Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58533A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzKBXYg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BB6C433C9;
	Wed, 15 Nov 2023 19:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078029;
	bh=11x1W9u/6fcn1QZrJpx9mE+kwTA/f4LH7bhsXLA37wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzKBXYg67Bf5m915wxdkqHU5zufE7Z91qgD5QMDZVUDppjecNUD6KbpFQl2yViXG8
	 QLN2+XFm85Wm3ewb20u3ffy/sybJjTDG83sJiUXqZ2F0qKmOpJVjr4HW/DF0gyvGUe
	 GVg5JQt/qUBPiQeJ6XbUVTqaMCjnSxzjkZPyd+dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Greenman <gregory.greenman@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/379] wifi: iwlwifi: call napi_synchronize() before freeing rx/tx queues
Date: Wed, 15 Nov 2023 14:22:22 -0500
Message-ID: <20231115192649.111883522@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit 5af2bb3168db6b0af9988eb25cccf2e3bc4455e2 ]

When rx/tx queues are being freed, on a different CPU there could be
still rx flow running. Call napi_synchronize() to prevent such a race.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Co-developed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://lore.kernel.org/r/20230416154301.5171ee44dcc1.Iff18718540da412e084e7d8266447d40730600ed@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 37fb29bd1f90 ("wifi: iwlwifi: pcie: synchronize IRQs before NAPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/internal.h |  1 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c   | 18 +++++++++++++++++-
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c   |  1 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c    |  1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index f7e4f868363df..69b95ad5993b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -497,6 +497,7 @@ int iwl_pcie_rx_stop(struct iwl_trans *trans);
 void iwl_pcie_rx_free(struct iwl_trans *trans);
 void iwl_pcie_free_rbs_pool(struct iwl_trans *trans);
 void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq);
+void iwl_pcie_rx_napi_sync(struct iwl_trans *trans);
 void iwl_pcie_rxq_alloc_rbs(struct iwl_trans *trans, gfp_t priority,
 			    struct iwl_rxq *rxq);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index b455e981faa1f..90a46faaaffdf 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2003-2014, 2018-2022 Intel Corporation
+ * Copyright (C) 2003-2014, 2018-2023 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -1053,6 +1053,22 @@ static int iwl_pcie_napi_poll_msix(struct napi_struct *napi, int budget)
 	return ret;
 }
 
+void iwl_pcie_rx_napi_sync(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int i;
+
+	if (unlikely(!trans_pcie->rxq))
+		return;
+
+	for (i = 0; i < trans->num_rx_queues; i++) {
+		struct iwl_rxq *rxq = &trans_pcie->rxq[i];
+
+		if (rxq && rxq->napi.poll)
+			napi_synchronize(&rxq->napi);
+	}
+}
+
 static int _iwl_pcie_rx_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 94f40c4d24217..6d2cbbd256064 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -156,6 +156,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
+		iwl_pcie_rx_napi_sync(trans);
 		iwl_txq_gen2_tx_free(trans);
 		iwl_pcie_rx_stop(trans);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 8e95225cdd605..e6a3dfd550257 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1261,6 +1261,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
+		iwl_pcie_rx_napi_sync(trans);
 		iwl_pcie_tx_stop(trans);
 		iwl_pcie_rx_stop(trans);
 
-- 
2.42.0



