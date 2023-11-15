Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C073BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnCS7FnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12316C433CA;
	Wed, 15 Nov 2023 19:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076188;
	bh=/VJ2ZdzkLDG/+6dYMv2r52/RVYnEa5UOZtcu3boNoQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnCS7FnPviykLlrOygPgBKaV8srtoIRb2LRkJ6UBXdDAmsxzI1Jc0ekv7olPD2lFv
	 e3zmEhVgi+eiRPg921C3scyOxmP2HUzslge++DLAIb5X0p94Oe4aJtacgPuA9QLnNH
	 R015np6iF/RCLY5AvE8M3EQjvD9xw9CxtAtrjNeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 130/550] wifi: iwlwifi: mvm: Fix key flags for IGTK on AP interface
Date: Wed, 15 Nov 2023 14:11:54 -0500
Message-ID: <20231115191609.694084438@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 8f9a791a8edd87fa64b35037d9c3bce89a1b8d21 ]

When an IGTK is installed for an AP interface, there is no station
associated with it. However, the MFP flag must be set for the installed
key as otherwise the FW wouldn't use it.

Fix the security key flag to set the MFP flag also when the AP is
an AP interface and the key index matches that of an IGTK.

Fixes: 5c75a208c244 ("wifi: iwlwifi: mvm: support new key API")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20231011130030.f67005e2d4d2.I6832c6e87f3c79fff00689eb10a3a30810e1ee83@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
index f498206470410..ea3e9e9c6e26c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
@@ -96,7 +96,12 @@ u32 iwl_mvm_get_sec_flags(struct iwl_mvm *mvm,
 	if (!sta && vif->type == NL80211_IFTYPE_STATION)
 		sta = mvmvif->ap_sta;
 
-	if (!IS_ERR_OR_NULL(sta) && sta->mfp)
+	/* Set the MFP flag also for an AP interface where the key is an IGTK
+	 * key as in such a case the station would always be NULL
+	 */
+	if ((!IS_ERR_OR_NULL(sta) && sta->mfp) ||
+	    (vif->type == NL80211_IFTYPE_AP &&
+	     (keyconf->keyidx == 4 || keyconf->keyidx == 5)))
 		flags |= IWL_SEC_KEY_FLAG_MFP;
 
 	return flags;
-- 
2.42.0



