Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E06B6FAF;
	Tue,  5 Dec 2023 03:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUpX5gkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2433BC433C9;
	Tue,  5 Dec 2023 03:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746657;
	bh=uBXCP5gKfzZj/yI7ZzA4S1wgd63jdzrF+qj/vg3DocU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUpX5gkDDeN8aVVVLMrNOEnIeNDDjZycnSrwkKB8sTLYOKh1NuGr7IVtWz3jb719r
	 7sB4RDquVJudv4Br5AUkp4aRjg8QqNTw4bhPZsTjcRnm9HS3jyT696Wzq195TNVZdO
	 jctn5Pq2VZUfnDOARLgTQAqFhUfwTqZxnIzivltE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/134] wifi: iwlwifi: mvm: fix an error code in iwl_mvm_mld_add_sta()
Date: Tue,  5 Dec 2023 12:15:55 +0900
Message-ID: <20231205031540.740234529@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 71b5e40651d89a8685bea1592dfcd2aa61559628 ]

This error path should return -EINVAL instead of success.

Fixes: 57974a55d995 ("wifi: iwlwifi: mvm: refactor iwl_mvm_mac_sta_state_common()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/75e4ea09-db58-462f-bd4e-5ad4e5e5dcb5@moroto.mountain
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index 56f51344c193c..1ccbe8c1eeb42 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -705,8 +705,10 @@ int iwl_mvm_mld_add_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			rcu_dereference_protected(mvm_sta->link[link_id],
 						  lockdep_is_held(&mvm->mutex));
 
-		if (WARN_ON(!link_conf || !mvm_link_sta))
+		if (WARN_ON(!link_conf || !mvm_link_sta)) {
+			ret = -EINVAL;
 			goto err;
+		}
 
 		ret = iwl_mvm_mld_cfg_sta(mvm, sta, vif, link_sta, link_conf,
 					  mvm_link_sta);
-- 
2.42.0



