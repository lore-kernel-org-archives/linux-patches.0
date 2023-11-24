Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC7C31740;
	Fri, 24 Nov 2023 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhtlRHNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094F4C433C7;
	Fri, 24 Nov 2023 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849072;
	bh=8W1YtIUpcnLwsHVghNWLS3h1mNno4o/UHgcp6yfvX6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhtlRHNSBkzd58s4wJTzx4a57ExqMBkZvTM+bqLx3xEoDdTcK51tHI1vK8hJAxegV
	 eX7cK2XCk4DlLiK+p0fw5ltoxGmH6KykZEkokDLLVwYodcPtOxU7d3NPiyS/06XnR9
	 buRYok8ra8vUCKBPx0LZrvS/qAJNvFn7esjTyr4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/530] wifi: iwlwifi: mvm: fix size check for fw_link_id
Date: Fri, 24 Nov 2023 17:43:23 +0000
Message-ID: <20231124172029.189766443@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit e25bd1853cc8308158d97e5b3696ea3689fa0840 ]

Check that fw_link_id does not exceed the size of link_id_to_link_conf
array. There's no any codepath that can cause that, but it's still
safer to verify in case fw_link_id gets corrupted.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231017115047.3385bd11f423.I2d30fdb464f951c648217553c47901857a0046c7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index 6e1ad65527d12..4ab55a1fcbf04 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -60,7 +60,7 @@ int iwl_mvm_add_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (link_info->fw_link_id == IWL_MVM_FW_LINK_ID_INVALID) {
 		link_info->fw_link_id = iwl_mvm_get_free_fw_link_id(mvm,
 								    mvmvif);
-		if (link_info->fw_link_id == IWL_MVM_FW_LINK_ID_INVALID)
+		if (link_info->fw_link_id >= ARRAY_SIZE(mvm->link_id_to_link_conf))
 			return -EINVAL;
 
 		rcu_assign_pointer(mvm->link_id_to_link_conf[link_info->fw_link_id],
@@ -243,7 +243,7 @@ int iwl_mvm_remove_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	int ret;
 
 	if (WARN_ON(!link_info ||
-		    link_info->fw_link_id == IWL_MVM_FW_LINK_ID_INVALID))
+		    link_info->fw_link_id >= ARRAY_SIZE(mvm->link_id_to_link_conf)))
 		return -EINVAL;
 
 	RCU_INIT_POINTER(mvm->link_id_to_link_conf[link_info->fw_link_id],
-- 
2.42.0



