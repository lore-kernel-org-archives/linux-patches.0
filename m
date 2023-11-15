Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE703C462
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zL5XXRRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7DDC433C9;
	Wed, 15 Nov 2023 19:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077124;
	bh=YJnpRv/A/FXD0QiClyoamxD0soaZojfcKe5wL1xWyDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zL5XXRRm3wxZZifMnFl+8lhQRj8XT6aj+h2GQB3MkNWvqsGbbcKnL+GmUmvZLIs9P
	 OSwmMeXk+HsQPS1+xJVg/5XEutvpxfY1T4pcTjUQ/oyv7R6JIRGlTiCI6fcflA+DAl
	 vZYMnoYjvbk0kJ1lFB3hzKtH1P+a1E2a0BbSXXkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/603] wifi: iwlwifi: mvm: fix removing pasn station for responder
Date: Wed, 15 Nov 2023 14:11:17 -0500
Message-ID: <20231115191622.394218436@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit ff2687612c21a87a58c76099f3d59f8db376b995 ]

In case of MLD operation the station should be removed using the
mld api.

Fixes: fd940de72d49 ("wifi: iwlwifi: mvm: FTM responder MLO support")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230926110319.7eb353abb95c.I2b30be09b99f5a2379956e010bafaa465ff053ba@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c
index b49781d1a07a7..10b9219b3bfd3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2022 Intel Corporation
+ * Copyright (C) 2018-2023 Intel Corporation
  */
 #include <net/cfg80211.h>
 #include <linux/etherdevice.h>
@@ -302,7 +302,12 @@ static void iwl_mvm_resp_del_pasn_sta(struct iwl_mvm *mvm,
 				      struct iwl_mvm_pasn_sta *sta)
 {
 	list_del(&sta->list);
-	iwl_mvm_rm_sta_id(mvm, vif, sta->int_sta.sta_id);
+
+	if (iwl_mvm_has_mld_api(mvm->fw))
+		iwl_mvm_mld_rm_sta_id(mvm, sta->int_sta.sta_id);
+	else
+		iwl_mvm_rm_sta_id(mvm, vif, sta->int_sta.sta_id);
+
 	iwl_mvm_dealloc_int_sta(mvm, &sta->int_sta);
 	kfree(sta);
 }
-- 
2.42.0



