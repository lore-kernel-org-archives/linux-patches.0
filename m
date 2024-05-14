Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43401136651;
	Tue, 14 May 2024 10:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682877; cv=none; b=iWB8m/PojaMwrXG9zWkSiyeMuQCmRwqckiwRPef29BojYvvP8c8P65i+x06P3/eHq8hQj0WREcw9JKEH7xhD8MJJf+qlZ7unsXcQCL4BQ9va4L+s5qxad1UWpnHytgcNtbBhvCQGZYYJelqbwtGtq6GVa+j2UNvYhzsgezM3sOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682877; c=relaxed/simple;
	bh=Sx3/MGUHMGdtohUx4V8LWCuYxx3ngp+8LiQZAYY2OBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzKpGpJCiP9LQxSCXnr4x1i0TAv6Q5skrMAef2wl6sHJyO7p47lQEK0ni8O2GnW8V0LdIaMmcWsmYp52+0GsE1T/KPa44+YVK/Tjd0/UqpMgBN28k/AFoT0bWN/Bx+CbZB/rYVCIdpGkmDGG9U9zxw997mEPW+3t6en7QjhW6Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfGjsbYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfGjsbYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99924C2BD10;
	Tue, 14 May 2024 10:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682877;
	bh=Sx3/MGUHMGdtohUx4V8LWCuYxx3ngp+8LiQZAYY2OBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfGjsbYqnSpuPfQ/OUvpijNB0J2jewBQKbfpASJdzxzfYdZGG95jlPIMLKiDk+dsb
	 J4yTLG/30An5iGiL8U4gPh2OIO64Z7JP1cL7TrDfP06S+wH9nAYSF/JBQGBXZ7K+JD
	 +ZHB+BxbWvCUTHEASRlGzQ2/W20UTQ3P3pIHjq5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 109/336] wifi: iwlwifi: mvm: guard against invalid STA ID on removal
Date: Tue, 14 May 2024 12:15:13 +0200
Message-ID: <20240514101042.719974061@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 17f64517bf5c26af56b6c3566273aad6646c3c4f ]

Guard against invalid station IDs in iwl_mvm_mld_rm_sta_id as that would
result in out-of-bounds array accesses. This prevents issues should the
driver get into a bad state during error handling.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.d523167bda9c.I1cffd86363805bf86a95d8bdfd4b438bb54baddc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index 1628bf55458fc..23e64a757cfe8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -855,10 +855,15 @@ int iwl_mvm_mld_rm_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 int iwl_mvm_mld_rm_sta_id(struct iwl_mvm *mvm, u8 sta_id)
 {
-	int ret = iwl_mvm_mld_rm_sta_from_fw(mvm, sta_id);
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON(sta_id == IWL_MVM_INVALID_STA))
+		return 0;
+
+	ret = iwl_mvm_mld_rm_sta_from_fw(mvm, sta_id);
+
 	RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta_id], NULL);
 	RCU_INIT_POINTER(mvm->fw_id_to_link_sta[sta_id], NULL);
 	return ret;
-- 
2.43.0



