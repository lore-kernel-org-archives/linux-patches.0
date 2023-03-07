Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602F6BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC13DC433D2;
	Tue,  7 Mar 2023 18:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212446;
	bh=NJ74QcUob+6BxRPqjTNR1yBFskAuWL/bmKJPPQjq9NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pf6to4pbmU7JNJZxLxAWv3xgYVKCJQ84ktEV0nfTak520GzRRtGjyhO7bMbcAcLSu
	 NxSyJwzULElHkBbJiG3Ecx8qKvkDNcjlH+oQj2ml/8wGbxYCrB/4sKPwex7051McaC
	 S4ISLxDb7FkSoWk3IilmV5xdgQmcAK3zm+cN9Sy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/885] wifi: iwlwifi: mei: fix compilation errors in rfkill()
Date: Tue,  7 Mar 2023 17:52:01 +0100
Message-Id: <20230307170010.133070722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit 9cbd5a8abca904441e36861e3a92961bec41d13f ]

The rfkill() callback was invoked with wrong parameters.
It was missed since MEI is defined now as depending on BROKEN.
Fix that.

Fixes: d288067ede4b ("wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lock")
Fixes: 5aa7ce31bd84 ("wifi: iwlwifi: mei: make sure ownership confirmed message is sent")
Fixes: 95170a46b7dd ("wifi: iwlwifi: mei: don't send SAP commands if AMT is disabled")
Link: https://lore.kernel.org/r/20230126222821.305122-2-gregory.greenman@intel.com
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index c0142093c7682..27eb28290e234 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -784,7 +784,7 @@ static void iwl_mei_handle_amt_state(struct mei_cl_device *cldev,
 	if (mei->amt_enabled)
 		iwl_mei_set_init_conf(mei);
 	else if (iwl_mei_cache.ops)
-		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, false, false);
+		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, false);
 
 	schedule_work(&mei->netdev_work);
 
@@ -825,7 +825,7 @@ static void iwl_mei_handle_csme_taking_ownership(struct mei_cl_device *cldev,
 		 */
 		mei->csme_taking_ownership = true;
 
-		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, true, true);
+		iwl_mei_cache.ops->rfkill(iwl_mei_cache.priv, true);
 	} else {
 		iwl_mei_send_sap_msg(cldev,
 				     SAP_MSG_NOTIF_CSME_OWNERSHIP_CONFIRMED);
@@ -1695,7 +1695,7 @@ int iwl_mei_register(void *priv, const struct iwl_mei_ops *ops)
 			if (mei->amt_enabled)
 				iwl_mei_send_sap_msg(mei->cldev,
 						     SAP_MSG_NOTIF_WIFIDR_UP);
-			ops->rfkill(priv, mei->link_prot_state, false);
+			ops->rfkill(priv, mei->link_prot_state);
 		}
 	}
 	ret = 0;
-- 
2.39.2



