Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D862628C;
	Mon, 23 Jun 2025 21:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713781; cv=none; b=hWs0m6nW6fifOT+GgS3zyjgY00V/b/gmx8DJ2BDq0Bmrvk6OVaW3MI1MaIxkFAfuMOCVLUl0AU9LO4MwjV35TlSA5omcR5eTeZztV0rFYfUaCuiNMgx8fhGykxjuFMUChBv8laWXxQtfD9dvXbLMGBob/bpL3cj+F0m73eUZQHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713781; c=relaxed/simple;
	bh=bNo6Q/Kl+EZgRz5zFiov81yNQUFscwuY8+BExovazMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4mRBhFAmmRUHkFVlsb05EQaNuJ6ZGD1+8Y+j90jqEPweuS1QiYV5UWvAXF4pFQxSEuuGr1BNyCIyn0jkN+mJnygqif7/b+9ai7cf17S9pYLbrrQw3t1D9uLOjZmObUonr6lKV/+ZnlDwRO2GXT/dIqg35HIIepXTaSVD3snVec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6diXQf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6diXQf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5787C4CEF0;
	Mon, 23 Jun 2025 21:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713781;
	bh=bNo6Q/Kl+EZgRz5zFiov81yNQUFscwuY8+BExovazMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6diXQf906kaeWDPAZM2clST8BXs3Z/9EKS/yRFJ5H7ePYGXf8U6M9a2xP880IUQo
	 q1FQBxJEsfck/G7ymL4LMBReQDCi/uP9uaayIE3EPekngbJHCPYuE4sIhgOOGbIClN
	 fi60g8rogPdgU1H8OVu+RoU673dRZvAKfFENJCf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 365/592] wifi: iwlwifi: mld: call thermal exit without wiphy lock held
Date: Mon, 23 Jun 2025 15:05:23 +0200
Message-ID: <20250623130709.124320241@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 83128399f3b4926ab73ce8e5081ce6595e9230e9 ]

The driver must not hold the wiphy mutex when unregistering the thermal
devices. Do not hold the lock for the call to iwl_mld_thermal_exit and
only do a lock/unlock to cancel the ct_kill_exit_wk work.

The problem is that iwl_mld_tzone_get_temp needs to take the wiphy lock
while the thermal code is holding its own locks already. When
unregistering the device, the reverse would happen as the driver was
calling thermal_cooling_device_unregister with the wiphy mutex already
held.

It is not likely to trigger this deadlock as it can only happen if the
thermal code is polling the temperature while the driver is being
unloaded. However, lockdep reported it so fix it.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250506194102.3407967-12-miriam.rachel.korenblit@intel.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c     | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mld/thermal.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 7a098942dc802..21f65442638dd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -475,8 +475,9 @@ iwl_op_mode_mld_stop(struct iwl_op_mode *op_mode)
 	iwl_mld_ptp_remove(mld);
 	iwl_mld_leds_exit(mld);
 
-	wiphy_lock(mld->wiphy);
 	iwl_mld_thermal_exit(mld);
+
+	wiphy_lock(mld->wiphy);
 	iwl_mld_low_latency_stop(mld);
 	iwl_mld_deinit_time_sync(mld);
 	wiphy_unlock(mld->wiphy);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
index 1909953a9be98..670ac43528006 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/thermal.c
@@ -419,6 +419,8 @@ static void iwl_mld_cooling_device_unregister(struct iwl_mld *mld)
 
 void iwl_mld_thermal_initialize(struct iwl_mld *mld)
 {
+	lockdep_assert_not_held(&mld->wiphy->mtx);
+
 	wiphy_delayed_work_init(&mld->ct_kill_exit_wk, iwl_mld_exit_ctkill);
 
 #ifdef CONFIG_THERMAL
@@ -429,7 +431,9 @@ void iwl_mld_thermal_initialize(struct iwl_mld *mld)
 
 void iwl_mld_thermal_exit(struct iwl_mld *mld)
 {
+	wiphy_lock(mld->wiphy);
 	wiphy_delayed_work_cancel(mld->wiphy, &mld->ct_kill_exit_wk);
+	wiphy_unlock(mld->wiphy);
 
 #ifdef CONFIG_THERMAL
 	iwl_mld_cooling_device_unregister(mld);
-- 
2.39.5



