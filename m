Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8334A200C9E;
	Wed,  6 Nov 2024 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896794; cv=none; b=K1BeZ2rJZ9Rfkyx0223q8JOTUu3LLLLw7sgkZT+BBpFopxROX963uwc/cuSrBSIBb+VvnnhEDibLnbXSJ/Az6BCAQXVja8AF8HEc+1LUg8ERy3xfBXnFEBo/neKicMbLodeTxckGg/0gWNG/H1BxhwZN88sm9dP590hox+j0yMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896794; c=relaxed/simple;
	bh=Hn6RGmlzcSwzHMQ2K2fTFAjvgVHYpEzGcn05X3osSmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buPQtOBBetmJLp+5rVc4XUjDhoyBU274sjC9Ut/nkpIUZxpyHwz4C7pYRoBUvGltIVaWgh8ymNzDecdMYhj1WFNX+DnFmYDkbU53PRS7iFmR3iMusnTvR3Vg4zwn3Cnzb8+EGvBdS5QEbvdJ8KaR8/vVe+7lT5M1JfpPEqSyfS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA+W4iAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA+W4iAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7391C4CED5;
	Wed,  6 Nov 2024 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896794;
	bh=Hn6RGmlzcSwzHMQ2K2fTFAjvgVHYpEzGcn05X3osSmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA+W4iAS9S8NTIYimf3uaohtkpWJVOkNhv0EfgoGKzykddZa5hoEvvqAl9TLf6ZG2
	 kMocIu0CxUtIQDD/790P7UpJeaIPCHrqWNEzqRbrz1xn6btfOLpt4gNn/mQbedLTCD
	 tUvl6k346ZKlFg5+4G5RIw6rPO3hgWO3G+feIwvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/110] wifi: iwlwifi: mvm: disconnect station vifs if recovery failed
Date: Wed,  6 Nov 2024 13:04:33 +0100
Message-ID: <20241106120305.041534866@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 793208d99b5f9..594c88a9ac496 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1251,6 +1251,13 @@ static void iwl_mvm_lari_cfg(struct iwl_mvm *mvm)
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
@@ -1295,10 +1302,15 @@ void iwl_mvm_send_recovery_cmd(struct iwl_mvm *mvm, u32 flags)
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



