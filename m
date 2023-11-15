Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406593A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4hl7j6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A7DC433C7;
	Wed, 15 Nov 2023 19:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078031;
	bh=QAu4t9YX8x87af/xwIyDx+BqdShRrOcMK5LD9C67kFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4hl7j6PuNeZHNvXYWPzuMZTw/DKmWaHp7pH2vNQp/7U4tHno+wDwdO0fM90GzATZ
	 qEd3dDP1SAx85IDflvSbZsWVarBkpvheAobWQ4m9hQ2HRP+ToNzOTKjzv1KArDYw5s
	 LGMNmsS2cabtYto+oSh/n1Pi3gMkZ0grSg4W5g08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/379] wifi: iwlwifi: pcie: synchronize IRQs before NAPI
Date: Wed, 15 Nov 2023 14:22:23 -0500
Message-ID: <20231115192649.170733903@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 37fb29bd1f90f16d1abc95c0e9f0ff8eec9829ad ]

When we want to synchronize the NAPI, which was added in
commit 5af2bb3168db ("wifi: iwlwifi: call napi_synchronize()
before freeing rx/tx queues"), we also need to make sure we
can't actually reschedule the NAPI. Yes, this happens while
interrupts are disabled, but interrupts may still be running
or pending. Also call iwl_pcie_synchronize_irqs() to ensure
we won't reschedule the NAPI.

Fixes: 4cf2f5904d97 ("iwlwifi: queue: avoid memory leak in reset flow")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231017115047.a0f4104b479a.Id5c50a944f709092aa6256e32d8c63b2b8d8d3ac@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 6d2cbbd256064..8b9e4b9c5a2e9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -156,6 +156,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
+		iwl_pcie_synchronize_irqs(trans);
 		iwl_pcie_rx_napi_sync(trans);
 		iwl_txq_gen2_tx_free(trans);
 		iwl_pcie_rx_stop(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e6a3dfd550257..39ab6526e6b85 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1261,6 +1261,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
+		iwl_pcie_synchronize_irqs(trans);
 		iwl_pcie_rx_napi_sync(trans);
 		iwl_pcie_tx_stop(trans);
 		iwl_pcie_rx_stop(trans);
-- 
2.42.0



