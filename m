Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABBB31B13E;
	Mon, 18 Aug 2025 13:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523813; cv=none; b=WB1Zw7PT28TPqd4yCetEAQhsTKGZq06sFc9lQ5oB/ApcR8+QNxjiqDXfRVz7wYsFlfTIY/BLCEd0X6t4qvdSuJ4mRHNbtsaLHk0N6mDKwoCUpHjH7zRZTWEut+UHueQ8LWroSHBSRexw0zAO++CNSNCGeOX2d8aeaqrhXE96aL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523813; c=relaxed/simple;
	bh=i5Otv4atlznp1GuPYj2zPm7Eh4uooxpjgr0rquhNLPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4B44xJ5m1GQPSvMtpapCf5/pCwU4AmOlPhXYGDE28preGQKkeCOnJTmdEM5N5gANKAMlM0MckhIToM/Re4VYLkLeISOgc0JiCDlxG35fdgr0M+tkCikQnKRxvEg0o0z/Wr0A4iZv+30xrTYY19BGcqBDvQ07+KaZvj/ZGphseo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snFzrttI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snFzrttI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA074C4CEEB;
	Mon, 18 Aug 2025 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523813;
	bh=i5Otv4atlznp1GuPYj2zPm7Eh4uooxpjgr0rquhNLPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snFzrttIfcSjxQ4G9NyieD0R4WRU89OvOMvQRlxhL4IaIT+QSmE6qye2qBU2/XIoE
	 J5gPMiv0ZKj6UHvDncIGKjqsjoZ6ro9dmg7YLiRRRx2FwhMZRZhQOHHI9ssHXHzszv
	 /Gt8NENSoe3bhDS6YQw+PjRWv1x0WVuKnWCI5rSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 280/515] wifi: iwlwifi: mld: dont exit EMLSR when we shouldnt
Date: Mon, 18 Aug 2025 14:44:26 +0200
Message-ID: <20250818124509.204302837@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 0cdb8ff6ebbac55f38933f4621215784887b400e ]

There is a requirement to exit EMLSR if there wasn't enough throughput
in the secondary link.
This is checked in check_tpt_wk, which runs every 5 seconds in a high
throughput scenario (when the throughput blocker isn't set)

It can happen that this worker is running immediately after we entered
EMLSR, and in that case the secondary link didn't have a chance to have
throughput. In that case we will exit EMLSR for no good reason.

Fix this by tracking the time we entered EMLSR, and in the worker make
sure that 5 seconds passed from when we entered EMLSR. If not, don't
check the secondary link throughput.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250612144708.c680f8d7dc37.I8a02d1e8d99df3789da8d5714f19b31a865a61ff@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/iface.h    | 3 +++
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 1 +
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c      | 8 +++++---
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.h b/drivers/net/wireless/intel/iwlwifi/mld/iface.h
index ec14d0736cee..586bfed450c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.h
@@ -84,6 +84,8 @@ enum iwl_mld_emlsr_exit {
  * @last_exit_reason: Reason for the last EMLSR exit
  * @last_exit_ts: Time of the last EMLSR exit (if @last_exit_reason is non-zero)
  * @exit_repeat_count: Number of times EMLSR was exited for the same reason
+ * @last_entry_ts: the time of the last EMLSR entry (if iwl_mld_emlsr_active()
+ *	is true)
  * @unblock_tpt_wk: Unblock EMLSR because the throughput limit was reached
  * @check_tpt_wk: a worker to check if IWL_MLD_EMLSR_BLOCKED_TPT should be
  *	added, for example if there is no longer enough traffic.
@@ -102,6 +104,7 @@ struct iwl_mld_emlsr {
 		enum iwl_mld_emlsr_exit last_exit_reason;
 		unsigned long last_exit_ts;
 		u8 exit_repeat_count;
+		unsigned long last_entry_ts;
 	);
 
 	struct wiphy_work unblock_tpt_wk;
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 2d5233dc3e24..8a020d161f4a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -995,6 +995,7 @@ int iwl_mld_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 		/* Indicate to mac80211 that EML is enabled */
 		vif->driver_flags |= IEEE80211_VIF_EML_ACTIVE;
+		mld_vif->emlsr.last_entry_ts = jiffies;
 
 		if (vif->active_links & BIT(mld_vif->emlsr.selected_links))
 			mld_vif->emlsr.primary = mld_vif->emlsr.selected_primary;
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
index a870e169e265..962a27e8d791 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
@@ -508,10 +508,12 @@ void iwl_mld_emlsr_check_tpt(struct wiphy *wiphy, struct wiphy_work *wk)
 	/*
 	 * TPT is unblocked, need to check if the TPT criteria is still met.
 	 *
-	 * If EMLSR is active, then we also need to check the secondar link
-	 * requirements.
+	 * If EMLSR is active for at least 5 seconds, then we also
+	 * need to check the secondary link requirements.
 	 */
-	if (iwl_mld_emlsr_active(vif)) {
+	if (iwl_mld_emlsr_active(vif) &&
+	    time_is_before_jiffies(mld_vif->emlsr.last_entry_ts +
+				   IWL_MLD_TPT_COUNT_WINDOW)) {
 		sec_link_id = iwl_mld_get_other_link(vif, iwl_mld_get_primary_link(vif));
 		sec_link = iwl_mld_link_dereference_check(mld_vif, sec_link_id);
 		if (WARN_ON_ONCE(!sec_link))
-- 
2.39.5



