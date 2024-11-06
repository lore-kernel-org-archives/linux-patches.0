Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA41E1E25F8;
	Wed,  6 Nov 2024 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896954; cv=none; b=B6/i76dv6YzzabfLye2pZDI9SX1b69St9/qcNISZURT0T4hkHfI9kOYwSVV+tbmk6aFojTXB/6dW444ITOnbfmbHdGesV84JZZqqZ1yurLkkWlK0O+FmQ+iiHInV7Q6Ux6pJCk/qJho6ikaJ6xHZwhCzxwmOWcJZIEMbuZXNNZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896954; c=relaxed/simple;
	bh=Awh0X6NWgmtW5yHDNi3QuiH2RWez/3YYUe3N8I8YOsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijMNyvX77ZgImZ+8orIwFo2Xq6gScexTzhLoXVV0yYkaJnLFch1COjVW7GfUdDod7sxtGvjLeN1pvXmcOMEqYQJgkBxUB0Q4fQOIGZlmLWMsDhIOouy4V/10g1dImanmikFVqz/OWs7NZPEWgMRpC3SSo0LOTIXnVJQU083PkOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUDukukr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUDukukr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF2FC4CED9;
	Wed,  6 Nov 2024 12:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896953;
	bh=Awh0X6NWgmtW5yHDNi3QuiH2RWez/3YYUe3N8I8YOsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUDukukrifftMSKfPnKcjpQQG7W8vvOeqVLha4HWnmF3P2WMrngT3xNgKkBCALJoW
	 qfCTvP2k4dE57udOdQFPIKRWkP/rva8NYwff1KGV+T/g0U42J4EPJBI7d2CRh+6mH+
	 aUffmuTg0hf/cl9gwXQsxOs1v5Pz0GQmSo/t/nbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/126] wifi: iwlwifi: mvm: disconnect station vifs if recovery failed
Date: Wed,  6 Nov 2024 13:03:39 +0100
Message-ID: <20241106120306.584526239@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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
index 668bb9ce293db..bf305f1e3ea1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1348,6 +1348,13 @@ void iwl_mvm_get_acpi_tables(struct iwl_mvm *mvm)
 
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
@@ -1392,10 +1399,15 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
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



