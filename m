Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DC418A6C4;
	Fri, 27 Sep 2024 12:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440251; cv=none; b=AFY6h4iLp2KRmpns1Hsb+aA38bN1US5fAQIX6aUDeIsX1oElTg6Z3Z8leuxC2bVFcSUht52CI9klsfiPOWFFr0/ZPPyMBT5VS+cTEqo4rlLa3SGx8k16qUWCpsxvUL8NqoB/Y9DELOJDNz9nFd9nCA3cuBDqRIbjHsUh6KQPzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440251; c=relaxed/simple;
	bh=spd8h579lH4NNyZJVVO1b62y7td/MhNSFTiFCTTWgU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFfQ3tFtmiYLV8jtEnxTWAjUZXLIW9W+JO7UX+WBL5je0UCu0D4w9VOwB76TnGEIqBqkmMGIbOwxcMSAKUVQu2cPAYeSqsFt0IRJgoeQhSf+P8Fv6xuaNTvl4YzTqIuOFpwu9xVL1wvn4rSFem9S5WWbZe9FMc9nxnq69tnay4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ci84sEWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ci84sEWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B82C4CEC4;
	Fri, 27 Sep 2024 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440251;
	bh=spd8h579lH4NNyZJVVO1b62y7td/MhNSFTiFCTTWgU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ci84sEWpbkfMi3LybQv4yDmCwsgipxpkw/kmBAueS1i+YWgyU+QvM1TaD7LRL9zU0
	 gCqdla0mon++bDrYkhcH5Fj+ZmbhTTSS2DWWQtv0DYKEWhrMsDuq4j7xsJVVTw/Jmi
	 sTp1xOcjeRLqWdySreTujYdPMI4QiloLVoaSDJ6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/73] wifi: iwlwifi: mvm: dont wait for tx queues if firmware is dead
Date: Fri, 27 Sep 2024 14:23:26 +0200
Message-ID: <20240927121720.475638072@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 3a84454f5204718ca5b4ad2c1f0bf2031e2403d1 ]

There is a WARNING in iwl_trans_wait_tx_queues_empty() (that was
recently converted from just a message), that can be hit if we
wait for TX queues to become empty after firmware died. Clearly,
we can't expect anything from the firmware after it's declared dead.

Don't call iwl_trans_wait_tx_queues_empty() in this case. While it could
be a good idea to stop the flow earlier, the flush functions do some
maintenance work that is not related to the firmware, so keep that part
of the code running even when the firmware is not running.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.a7cbd794cee9.I44a739fbd4ffcc46b83844dd1c7b2eb0c7b270f6@changeid
[edit commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 4e8bdd3d701bf..bd4301857ba87 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4800,6 +4800,10 @@ static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 	int i;
 
 	if (!iwl_mvm_has_new_tx_api(mvm)) {
+		/* we can't ask the firmware anything if it is dead */
+		if (test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
+			     &mvm->status))
+			return;
 		if (drop) {
 			mutex_lock(&mvm->mutex);
 			iwl_mvm_flush_tx_path(mvm,
@@ -4881,8 +4885,11 @@ static void iwl_mvm_mac_flush(struct ieee80211_hw *hw,
 
 	/* this can take a while, and we may need/want other operations
 	 * to succeed while doing this, so do it without the mutex held
+	 * If the firmware is dead, this can't work...
 	 */
-	if (!drop && !iwl_mvm_has_new_tx_api(mvm))
+	if (!drop && !iwl_mvm_has_new_tx_api(mvm) &&
+	    !test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
+		      &mvm->status))
 		iwl_trans_wait_tx_queues_empty(mvm->trans, msk);
 }
 
-- 
2.43.0



