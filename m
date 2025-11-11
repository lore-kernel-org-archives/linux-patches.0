Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3127430276C;
	Tue, 11 Nov 2025 01:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823840; cv=none; b=ZSAsHyEEIfcsDS0fwIMzAikjnOLj3t+voWCTLaTIsTJvJtlN0gayXhrf1JZMdca337O7wJRtCBxFZPZ/Dfoik7yGeA2lVU545UvdRpRN1maLppBI6wYPaq+PFiHEBurQfiTzQR13SoboQODfosbuLVGrldjraIItDIRV+QR/jVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823840; c=relaxed/simple;
	bh=0xs34VXVIoxAdLt5ZJsBz1OFgeWNBtBuaUNYU9iFDPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqrwtRakYtzRy8NN1hLkX/yFPjFexedg2oaHq5zX1qLouVL3FGiKOtiTQEGzA39ommMvgrmrPkjtiQIJbjZhcNGzq2c6SCY8da5UmlKsubiYeROEfI7h329k0B8FyJDu3PFHqU/QykoQuxZlQeDGuH4YriCsuw4EsNrZnCY9QqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvTEts84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvTEts84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5278C19421;
	Tue, 11 Nov 2025 01:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823840;
	bh=0xs34VXVIoxAdLt5ZJsBz1OFgeWNBtBuaUNYU9iFDPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvTEts84OgD7B/HnfE4eTG8WXGdeuwkYxDpD8Wseldpb7H26Ni6BmL1sxQldE3EzH
	 14EI2oSV517YjGRej6Bjl2zkDv46FOS9qXzMghOqqOPs+YVXLibHzH5fyipe5zyf6R
	 aXrCNV7cKmaZl5H4Mw9weezIhAJlkbWBzr6MnmnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 382/849] wifi: iwlwifi: mld: trigger mlo scan only when not in EMLSR
Date: Tue, 11 Nov 2025 09:39:12 +0900
Message-ID: <20251111004545.669343214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>

[ Upstream commit 14a4aca568f6e78af7564c6fc5f1ecc1a5a32c33 ]

When beacon loss happens or the RSSI drops, trigger MLO scan only
if not in EMLSR. The link switch was meant to be done when we are
not in EMLSR and we can try to switch to a better link.
If in EMLSR, we exit first and then trigger MLO scan.

Signed-off-by: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250826184046.f6ae8e3882cf.I60901c16487371b8e62019bd0bf25c45ab23752f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c  |  7 +++++--
 drivers/net/wireless/intel/iwlwifi/mld/stats.c | 11 +++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 960dcd208f005..131190977d4b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -573,8 +573,11 @@ void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
 	if (missed_bcon_since_rx > IWL_MLD_MISSED_BEACONS_THRESHOLD) {
 		ieee80211_cqm_beacon_loss_notify(vif, GFP_ATOMIC);
 
-		/* try to switch links, no-op if we don't have MLO */
-		iwl_mld_int_mlo_scan(mld, vif);
+		/* Not in EMLSR and we can't hear the link.
+		 * Try to switch to a better link. EMLSR case is handled below.
+		 */
+		if (!iwl_mld_emlsr_active(vif))
+			iwl_mld_int_mlo_scan(mld, vif);
 	}
 
 	/* no more logic if we're not in EMLSR */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/stats.c b/drivers/net/wireless/intel/iwlwifi/mld/stats.c
index cbc64db5eab6f..7b8709716324a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/stats.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/stats.c
@@ -379,11 +379,14 @@ static void iwl_mld_update_link_sig(struct ieee80211_vif *vif, int sig,
 
 	/* TODO: task=statistics handle CQM notifications */
 
-	if (sig < IWL_MLD_LOW_RSSI_MLO_SCAN_THRESH)
-		iwl_mld_int_mlo_scan(mld, vif);
-
-	if (!iwl_mld_emlsr_active(vif))
+	if (!iwl_mld_emlsr_active(vif)) {
+		/* We're not in EMLSR and our signal is bad,
+		 * try to switch link maybe. EMLSR will be handled below.
+		 */
+		if (sig < IWL_MLD_LOW_RSSI_MLO_SCAN_THRESH)
+			iwl_mld_int_mlo_scan(mld, vif);
 		return;
+	}
 
 	/* We are in EMLSR, check if we need to exit */
 	exit_emlsr_thresh =
-- 
2.51.0



