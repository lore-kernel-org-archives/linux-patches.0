Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9A1DF978;
	Wed,  6 Nov 2024 12:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895895; cv=none; b=O0nkSkxbqHEifO+k+jQlxHpqmNnso2TfUEV2zqFJxFShJR/yRkNPjaoevFDitvN5TMcmpM225/+Y21DJ2RrGQYBZAloGDbW05/Jp0Qq8qDumZFapVpcanGpuIGNWI6OQE2Hhx5KUmjCF3nJTRJC+UMUIDmzzEq1fXr4tUMM7w54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895895; c=relaxed/simple;
	bh=ba7vP08H5CqCxEwuLk2nkeHMHp0Pk+WtwZxR+DCcigg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc0xNqVOUEOlNafrfYpl7VwsA958Q/BEA2FpaUOKh983xZx+rTQ5Ficj9HKqLjjhBx367ZI0dKYJGTt84RtXIcL2tiGSqYb0UQtuhFXo0Jn34tyD/9NB7oswlf2FYk8TO3h0JyrVInz39yToJcyisRzD2bA7fV0cynyykHj4/uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkcZ4VfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkcZ4VfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772FEC4CECD;
	Wed,  6 Nov 2024 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895894;
	bh=ba7vP08H5CqCxEwuLk2nkeHMHp0Pk+WtwZxR+DCcigg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkcZ4VfW8op9PhlV5kWopfyBRSi635MCZzDBaptV3dfUCUUVgvBrXSyiQYIRqtwIs
	 UrbcWoYbzzbctsbviJvLUHSjvttpDop+idXgj05VzaZ55vAJyN4qsHC7nIVbOVMAtj
	 cJUOVkBiTBtoFU09x6s8MbAklbRZ7YfLBT0G3uyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 020/245] wifi: iwlwifi: mvm: really send iwl_txpower_constraints_cmd
Date: Wed,  6 Nov 2024 13:01:13 +0100
Message-ID: <20241106120319.734219622@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit cbe84e9ad5e28ef083beff7f6edf2e623fac09e4 ]

iwl_mvm_send_ap_tx_power_constraint_cmd is a no-op if the link is not
active (we need to know the band etc.)
However, for the station case it will be called just before we set the
link to active (by calling iwl_mvm_link_changed with
the LINK_CONTEXT_MODIFY_ACTIVE bit set in the 'changed' flags and
active = true), so it will end up doing nothing.

Fix this by calling iwl_mvm_send_ap_tx_power_constraint_cmd before
iwl_mvm_link_changed.

Fixes: 6b82f4e119d1 ("wifi: iwlwifi: mvm: handle TPE advertised by AP")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241010140328.5c235fccd3f1.I2d40dea21e5547eba458565edcb4c354d094d82a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 3c99396ad3692..27980d58e6956 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -347,11 +347,6 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
 		rcu_read_unlock();
 	}
 
-	if (vif->type == NL80211_IFTYPE_STATION)
-		iwl_mvm_send_ap_tx_power_constraint_cmd(mvm, vif,
-							link_conf,
-							false);
-
 	/* then activate */
 	ret = iwl_mvm_link_changed(mvm, vif, link_conf,
 				   LINK_CONTEXT_MODIFY_ACTIVE |
@@ -360,6 +355,11 @@ __iwl_mvm_mld_assign_vif_chanctx(struct iwl_mvm *mvm,
 	if (ret)
 		goto out;
 
+	if (vif->type == NL80211_IFTYPE_STATION)
+		iwl_mvm_send_ap_tx_power_constraint_cmd(mvm, vif,
+							link_conf,
+							false);
+
 	/*
 	 * Power state must be updated before quotas,
 	 * otherwise fw will complain.
-- 
2.43.0



