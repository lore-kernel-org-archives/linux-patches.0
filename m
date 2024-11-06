Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8A646;
	Wed,  6 Nov 2024 13:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899114; cv=none; b=Rqlt+kJAY5ErO3yc/hP42DcsekNAgpXZwnV/iXyppNIJDVq49IHImFQ6HRdUX3kmZ6TeKP4T8clgxpVHY7uGy4poP3+CHTotrsg5H8WnwGJRt6WdkhkfVUK5qgRBDQTZsLB5iVVujG4MyMK1Zpbx4aWDiYOvovzh4wD16pla4Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899114; c=relaxed/simple;
	bh=C0zbi2d3zJC1J+DsqrcrlQ72lZBK5kwAqCSAGw7ovSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YptNkIfppuAN5b6F3D5RpvSrYkatnrjrQTxuxlTpZkG8XGvd++zPvhMzwuK2iEGaZA50/FLbNQ6fL5bDDf4ij62GRSnUJO0pRzAHyhmDxNs4nvDuqi3G8rTGgEIyLFOEDHFR4QkfUhgER3a+3RAM+wLjDsdDaDF5/6VWKR4I7RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BclIcQZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BclIcQZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D49C4CECD;
	Wed,  6 Nov 2024 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899114;
	bh=C0zbi2d3zJC1J+DsqrcrlQ72lZBK5kwAqCSAGw7ovSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BclIcQZQ4pSTaMPbu4Fatu0/TyvR6d8Fe9/dHh/KMEyOoSB95JKMSTzOfXfbuOb1L
	 oZrBzan4NPwRDiT6kXTpQ6yi3DFzD12ZmAKzntX07AD0U7UaCtvl660jAdV17goSQG
	 oJ67oCNnHarigbX7fBLRgqPAShx6Tt+aO9anpQOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 430/462] wifi: iwlwifi: mvm: disconnect station vifs if recovery failed
Date: Wed,  6 Nov 2024 13:05:23 +0100
Message-ID: <20241106120342.131148214@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit e50a88e5cb8792cc416866496288c5f4d1eb4b1f ]

This will allow to reconnect immediately instead of leaving the
connection in a limbo state.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240128084842.e90531cd3a36.Iebdc9483983c0d8497f9dcf9d79ec37332a5fdcc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 07a6e3b78a65 ("wifi: iwlwifi: mvm: Fix response handling in iwl_mvm_send_recovery_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 27bd9ed48bec4..16bf070566e6c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1182,6 +1182,13 @@ static int iwl_mvm_ppag_init(struct iwl_mvm *mvm)
 }
 #endif /* CONFIG_ACPI */
 
+static void iwl_mvm_disconnect_iterator(void *data, u8 *mac,
+					struct ieee80211_vif *vif)
+{
+	if (vif->type == NL80211_IFTYPE_STATION)
+		ieee80211_hw_restart_disconnect(vif);
+}
+
 void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 {
 	u32 error_log_size = mvm->fw->ucode_capa.error_log_size;
@@ -1226,10 +1233,15 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
 	/* skb respond is only relevant in ERROR_RECOVERY_UPDATE_DB */
 	if (flags & ERROR_RECOVERY_UPDATE_DB) {
 		resp = le32_to_cpu(*(__le32 *)host_cmd.resp_pkt->data);
-		if (resp)
+		if (resp) {
 			IWL_ERR(mvm,
 				"Failed to send recovery cmd blob was invalid %d\n",
 				resp);
+
+			ieee80211_iterate_interfaces(mvm->hw, 0,
+						     iwl_mvm_disconnect_iterator,
+						     mvm);
+		}
 	}
 }
 
-- 
2.43.0



