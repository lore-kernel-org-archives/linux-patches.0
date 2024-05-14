Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A135213AD3E;
	Tue, 14 May 2024 11:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684918; cv=none; b=i28Gd/n3TuB8OY53pT/OYKHO0CVCfP14ypsrlLPjiAE12E/HLYUruTA3jXYipEjS2pkUsMR6+P8ppiJVfqzmdLMOjrGV591C32NZ61lIb0p5aU6+LG2F9Abg/aACgrZJzl8EwXU8onQMq0NQkmBhVsN122qvFbIABJJh215kmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684918; c=relaxed/simple;
	bh=vYiIY28ZzDLZ7tyqhnV4lzwmQPu6XEZDLmAwAx9baXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1+tUOpAWg0CnTeFaSUse3aXmT/VUp0WAheiQulAxnjAYEPVSKqFXRET9zsKWgZ7rqCbFY2hd3ZuszjHz0BkZifuRLp7J5ZrdXEKRXOF40Ymz2u+xGoRDWyeX63utsGTFuxk9dRrNHmk3qYP1UjRn2X7S4NCIM3yngUa3KdDmeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXvFyZnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXvFyZnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B8C2BD10;
	Tue, 14 May 2024 11:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684918;
	bh=vYiIY28ZzDLZ7tyqhnV4lzwmQPu6XEZDLmAwAx9baXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXvFyZnr913aF0XAGFM6mnQVYNeQuJsoatUnbhFPNQ1JIid3HQqBF+tmTr/YiIaEQ
	 cjk3/oJ9LGiWSiUpvVkEuPLeOa1KCQCrOZ2UBUD4JIvNV885rCY9ut+3bjOHzmFyif
	 7p4lPJpgP8sw25q7T89aODTYA0PahghByzl/WhNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/301] wifi: iwlwifi: mvm: guard against invalid STA ID on removal
Date: Tue, 14 May 2024 12:16:19 +0200
Message-ID: <20240514101036.328852908@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index 1ccbe8c1eeb42..278454c116fee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -853,10 +853,15 @@ int iwl_mvm_mld_rm_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
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



