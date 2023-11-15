Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AAE3C471
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AF/KrkBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE521C433C7;
	Wed, 15 Nov 2023 19:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077208;
	bh=QKPnoLWPspn3UWEfZsLExLiZ2JmacRUg9PV/0OoLCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AF/KrkBQT1Wn2eOYwR6eKSwh0uGL0ouBdd5/fku8rg8ugo5h+XZn10V+IWaJ8FBM/
	 Hv5zLqkzOImZcQqxQg3VWMlRXi6gM9DDIE45C6wzAc/rilC8EWLUMFiJx6jkrjdqsE
	 z5G5mypfYVA+0V6ztP7qAWphHunzFHAzhM0qyj78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/603] wifi: iwlwifi: pcie: synchronize IRQs before NAPI
Date: Wed, 15 Nov 2023 14:11:30 -0500
Message-ID: <20231115191623.229508278@linuxfoundation.org>
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
index fa46dad5fd680..2ecf6db95fb31 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -161,6 +161,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
+		iwl_pcie_synchronize_irqs(trans);
 		iwl_pcie_rx_napi_sync(trans);
 		iwl_txq_gen2_tx_free(trans);
 		iwl_pcie_rx_stop(trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 198933f853c55..583d1011963ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1263,6 +1263,7 @@ static void _iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
+		iwl_pcie_synchronize_irqs(trans);
 		iwl_pcie_rx_napi_sync(trans);
 		iwl_pcie_tx_stop(trans);
 		iwl_pcie_rx_stop(trans);
-- 
2.42.0



