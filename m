Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A777214A82
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2768BC433C7;
	Tue, 25 Jul 2023 10:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282451;
	bh=LH2hwoUFKM2bcWoEr3Ue+OY/SGHBF6JkUd2BHQ0tcIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CojgOYqeg2gXiResH72mfOywpDy+OfiKZXx7nFc4rJzG9B8AjB5erxtrv2v45Vr4y
	 z1cjiQmMuTGMs5IKWQDqbXCB8JFE6Y63ujsmDG+GoUwiFE+lTrtKDq61p1BeMGC/ws
	 QfLq8YRCbm5+K0frk0mCRN2EgZqApur8zmvuCktE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 127/227] wifi: iwlwifi: mvm: Add NULL check before dereferencing the pointer
Date: Tue, 25 Jul 2023 12:44:54 +0200
Message-ID: <20230725104520.075809336@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit 7dd50fd5478056929a012c6bf8b3c6f87c7e9e87 ]

While vif pointers are protected by the corresponding "*active"
fields, static checkers can get confused sometimes. Add an explicit
check.

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230614154951.78749ae91fb5.Id3c05d13eeee6638f0930f750e93fb928d5c9dee@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index ac1dae52556f8..19839cc44eb3d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -647,30 +647,32 @@ static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 		return;
 
 	/* enable PM on bss if bss stand alone */
-	if (vifs->bss_active && !vifs->p2p_active && !vifs->ap_active) {
+	if (bss_mvmvif && vifs->bss_active && !vifs->p2p_active &&
+	    !vifs->ap_active) {
 		bss_mvmvif->pm_enabled = true;
 		return;
 	}
 
 	/* enable PM on p2p if p2p stand alone */
-	if (vifs->p2p_active && !vifs->bss_active && !vifs->ap_active) {
+	if (p2p_mvmvif && vifs->p2p_active && !vifs->bss_active &&
+	    !vifs->ap_active) {
 		p2p_mvmvif->pm_enabled = true;
 		return;
 	}
 
-	if (vifs->bss_active && vifs->p2p_active)
+	if (p2p_mvmvif && bss_mvmvif && vifs->bss_active && vifs->p2p_active)
 		client_same_channel =
 			iwl_mvm_have_links_same_channel(bss_mvmvif, p2p_mvmvif);
 
-	if (vifs->bss_active && vifs->ap_active)
+	if (bss_mvmvif && ap_mvmvif && vifs->bss_active && vifs->ap_active)
 		ap_same_channel =
 			iwl_mvm_have_links_same_channel(bss_mvmvif, ap_mvmvif);
 
 	/* clients are not stand alone: enable PM if DCM */
 	if (!(client_same_channel || ap_same_channel)) {
-		if (vifs->bss_active)
+		if (bss_mvmvif && vifs->bss_active)
 			bss_mvmvif->pm_enabled = true;
-		if (vifs->p2p_active)
+		if (p2p_mvmvif && vifs->p2p_active)
 			p2p_mvmvif->pm_enabled = true;
 		return;
 	}
-- 
2.39.2



