Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0421D0E23;
	Tue,  8 Oct 2024 12:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389859; cv=none; b=Do9Ml60HS3+/SG4/kQFJIbz1B3vmKtETbOQsOArrbIoVYoFGN3wiyF2L6g/orC57sjmkcqhRbII4cUFSqrvPQWtig9KJy2BhW0IuX7NE0vuik/EhNnewktvKPHxBh+YFi7JLfzbBDqMQe8VMO8a5PcqQQGq2T1PzyGAKT/OoyI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389859; c=relaxed/simple;
	bh=ZlQBrtyT20A8/IOuQXML892b8ZhbtSCt/S8NkZ3xx5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnCSJU5kxWUEHBUgBA6flm3GCW8DXqUdz50rkxvcsMIzhONlrZ/coT9V7UHnPEUxJ+cmZk/XONp5Ao0KDqZGpmjfCRfa7vLX5cTka/OTYIk95Km9XTRBLUJ8Wqr3y/6ZyMv1r4zk1/EjZKynrFTw2ydsaP+8a1asWQ1SnbGglVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZRr7rT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZRr7rT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A21C4CEC7;
	Tue,  8 Oct 2024 12:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389858;
	bh=ZlQBrtyT20A8/IOuQXML892b8ZhbtSCt/S8NkZ3xx5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZRr7rT4+98unJSGtgo8RS+f+WVUmcxu5lb5DDBalVVmeXBNyRlTuQOn7gyoX+SaR
	 WN69K+q7k4AVDt3N76t+tEp2CwRqv4Yj3kaU3FQ+P6Ws5jZn9Bk884amS8AOjBcYet
	 BlzjqhOkMYb5kBoQopoeIq6r+GhkaZWk2Gl40xlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 116/482] wifi: iwlwifi: mvm: use correct key iteration
Date: Tue,  8 Oct 2024 14:02:59 +0200
Message-ID: <20241008115652.872866213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4f1591d292277eec51d027405a92f0d4ef5e299e ]

In the cases changed here, key iteration isn't done from
an RCU critical section, but rather using the wiphy lock
as protection. Therefore, just use ieee80211_iter_keys().
The link switch case can therefore also use sync commands.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240729201718.69a2d18580c1.I2148e04d4b467d0b100beac8f7e449bfaaf775a5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
index 8a38fc4b0b0f9..455f5f4175064 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
@@ -144,7 +144,7 @@ static void iwl_mvm_mld_update_sta_key(struct ieee80211_hw *hw,
 	if (sta != data->sta || key->link_id >= 0)
 		return;
 
-	err = iwl_mvm_send_cmd_pdu(mvm, cmd_id, CMD_ASYNC, sizeof(cmd), &cmd);
+	err = iwl_mvm_send_cmd_pdu(mvm, cmd_id, 0, sizeof(cmd), &cmd);
 
 	if (err)
 		data->err = err;
@@ -162,8 +162,8 @@ int iwl_mvm_mld_update_sta_keys(struct iwl_mvm *mvm,
 		.new_sta_mask = new_sta_mask,
 	};
 
-	ieee80211_iter_keys_rcu(mvm->hw, vif, iwl_mvm_mld_update_sta_key,
-				&data);
+	ieee80211_iter_keys(mvm->hw, vif, iwl_mvm_mld_update_sta_key,
+			    &data);
 	return data.err;
 }
 
@@ -402,7 +402,7 @@ void iwl_mvm_sec_key_remove_ap(struct iwl_mvm *mvm,
 	if (!sec_key_ver)
 		return;
 
-	ieee80211_iter_keys_rcu(mvm->hw, vif,
-				iwl_mvm_sec_key_remove_ap_iter,
-				(void *)(uintptr_t)link_id);
+	ieee80211_iter_keys(mvm->hw, vif,
+			    iwl_mvm_sec_key_remove_ap_iter,
+			    (void *)(uintptr_t)link_id);
 }
-- 
2.43.0



