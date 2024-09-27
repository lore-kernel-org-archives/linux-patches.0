Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A7A18BC1F;
	Fri, 27 Sep 2024 12:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439905; cv=none; b=YA2aV5jkAG0GTRx0O48SByW1HRejeKbgUNqVfzRM2+sB/3aGaPDzO5RuH+8s1vWLjsmsQzDLDQmX5AvexoS/fcKdZzBYv34p9JCqcg5PEaBwHipIN2MwBnKDiWpZA0CUL0zIWe7RPGq9hGjoRxPtEoXLD+2gqXpMzfGjnh0YQk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439905; c=relaxed/simple;
	bh=plNIofQQdLDCc5PVY7KWTWqUPiW0UKdsUy0sOI5GJWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLCgBqCYtaN5z606fu24D6e5qZlCZvxsvpNCYlk1Xl7t45R1nhue9lmj0FFovqpGE8fxJKGreWHXSOsyfF3dK7ouTfzNt8WKo2xdl/+CIe+fq/X4qf+qu6HhZ7DjiFwsKXTEs2qNjkg6PG0sz4jMrA8mTeVVQ7J17YFJIDU2Eq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LB117zJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LB117zJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B0AC4CECD;
	Fri, 27 Sep 2024 12:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439905;
	bh=plNIofQQdLDCc5PVY7KWTWqUPiW0UKdsUy0sOI5GJWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB117zJhxksBWTxX6A+QxEhjcMEDcuDX7anCpVkDR/7yKi1n55b18i2r6IMcn+mcP
	 fNi10AID6cTSG+nweIZmYeCcgodmdgsosBSVB2OrnZAaG1OOQ6Z3O11rvnHIPuE2M3
	 Nv3G7Y8zmkVW7FN9sjNu17aEvNiyz2U1/apWQ2H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/54] wifi: iwlwifi: mvm: dont wait for tx queues if firmware is dead
Date: Fri, 27 Sep 2024 14:23:10 +0200
Message-ID: <20240927121720.430124022@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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
index f973efbbc3795..d2daea3b1f38a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -5589,6 +5589,10 @@ static void iwl_mvm_flush_no_vif(struct iwl_mvm *mvm, u32 queues, bool drop)
 	int i;
 
 	if (!iwl_mvm_has_new_tx_api(mvm)) {
+		/* we can't ask the firmware anything if it is dead */
+		if (test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
+			     &mvm->status))
+			return;
 		if (drop) {
 			mutex_lock(&mvm->mutex);
 			iwl_mvm_flush_tx_path(mvm,
@@ -5673,8 +5677,11 @@ void iwl_mvm_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
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



