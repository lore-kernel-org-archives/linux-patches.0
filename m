Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCE21EF0A4;
	Wed,  6 Nov 2024 12:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897328; cv=none; b=blVsRoeoAgQhcpd7OZWTQm8Bf9oaqIh7uWtBca09xK9oKSyJ5frekyf/qMNbumA1P+g/Flebryz1VsASrJBhod9bzCzapyP80tSepqdf0vzqHNvTRURi8Taei6sEkdTHWym4Eie7B5QxRMqYETZF4zNM3vkT9WHqX4qp/sW01jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897328; c=relaxed/simple;
	bh=2j3nyefYzmERmLyvVg0R8p9+9eCW5wxl27fZQQPEdcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJgst+bg2EA06LTvTb8q3K01eaWS+0cd4P6zDr+i7Vjzab9whqlm83+26KzXe43R25T1lJVEl317+wT0kEkZVuSZ3m/7EDtR8ULvgw5zfml0fhBu7rii37BsGtAlP5NBjXPkzzahh4DOZOhxmVG+e1PAJmCkSwrNgbdOmR0KaA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTAXCcND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTAXCcND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB69C4CECD;
	Wed,  6 Nov 2024 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897327;
	bh=2j3nyefYzmERmLyvVg0R8p9+9eCW5wxl27fZQQPEdcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTAXCcNDK8g+BIc2WulCuLd74IzbXSJ/3ZFqgjkSXHgMDFowbr9vk6fUMYesNaIeq
	 TdvqF6wQz71PgwQiF7Op4ToGygBmgzJfc0MSFjZzZ33qPionpoxcicKHtSyR2tJHjT
	 P6+TJT92KAvgB7DOKxfJiF5x6HjNH9zCsbBH+740=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/151] wifi: iwlwifi: mvm: disconnect station vifs if recovery failed
Date: Wed,  6 Nov 2024 13:03:25 +0100
Message-ID: <20241106120309.311860711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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
index 51f396287dc69..4bc395a5731b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1394,6 +1394,13 @@ void iwl_mvm_get_acpi_tables(struct iwl_mvm *mvm)
 
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
@@ -1438,10 +1445,15 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
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



