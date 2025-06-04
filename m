Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BAFDDBC;
	Wed,  4 Jun 2025 00:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998387; cv=none; b=bFlsDyqUPX76fZ7R6i8FvjZl/tugfLpFCu557hW4+ZHK7bgnJH8fFOmukLxUuGuY2cpuwl1JA5VdJ/yfa0ipBNw4JHN9OWg0IUYvKzBfwU/MKMvSj7SzltaJKMy15Nqc4oLd4AECUmIK+t7LbShGIFbAOAhIx1PKXkC8wK0lQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998387; c=relaxed/simple;
	bh=TJi0e0mcLBlhRVOEVAoSQArmHv3Ol9atjg1DgDQRUt0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYpSFelbphm8rgwzDvfF+/8w+8GNKvmlce2F7LNFG69ZPKEe0V6ImcsgpV+el7DkuHTg9+KAAKmSDVOcgNy6Cas8G7XxcP0Bcm2WaZVKjBgWdZVQihoAlzkSv5QPJCuFApZ/mcOdSrqMgJO9cA//FcXFq8jedQkMAVlMjQFGEIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLjrCeFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLjrCeFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C88C4CEED;
	Wed,  4 Jun 2025 00:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998387;
	bh=TJi0e0mcLBlhRVOEVAoSQArmHv3Ol9atjg1DgDQRUt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLjrCeFa6FP+RxE+ltABpM178zhAaHZwwPVWTpKLwPNGfPzU+vDhLV2f61esGWNdn
	 BoZ392ktBgJtW/HtDQF2IRaeYOGTkIzUleVHQGrn4KeGuQqy9ssst01EU9IJMFPVoF
	 RpAAqXVbIAI7Ek2dmJMY0Vkdm3x9L9ZaDPvCAbWlggscfObNDbH2t0MBTXGeyjFI91
	 KlJ1Dji7+McMstg8JQ9a9Vy0bgnhWwgX5/uetUC31V6NMpAVURFcSRvqGGprluE0W3
	 LzUfmBNUiHTsk0I7BZGr03vf6/Jb6tOzpYI073/0Pv6P6/0RT6AXuLwNpm0859nrx/
	 gx3DB9h/sAt5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	daniel.gabay@intel.com,
	pagadala.yesu.anjaneyulu@intel.com,
	yedidya.ben.shimol@intel.com
Subject: [PATCH AUTOSEL 6.15 057/118] wifi: iwlwifi: mld: call thermal exit without wiphy lock held
Date: Tue,  3 Jun 2025 20:49:48 -0400
Message-Id: <20250604005049.4147522-57-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

Based on my analysis of the commit message, code changes, and
examination of similar commits, here is my assessment: **YES** This
commit should be backported to stable kernel trees. ## Extensive
Analysis ### 1. **Deadlock Fix Classification** This commit fixes a
**classic AB-BA deadlock** scenario in the iwlwifi driver's thermal
handling. The specific deadlock pattern is: - **Path A**:
`iwl_mld_tzone_get_temp()` acquires wiphy lock while thermal subsystem
holds thermal locks - **Path B**: Driver shutdown holds wiphy lock then
calls `thermal_cooling_device_unregister()` which needs thermal locks
### 2. **Code Change Analysis** The fix involves two key changes in
`/drivers/net/wireless/intel/iwlwifi/mld/mld.c`: ```c // BEFORE
(problematic): wiphy_lock(mld->wiphy); iwl_mld_thermal_exit(mld); //
Called WITH wiphy lock held iwl_mld_low_latency_stop(mld);
wiphy_unlock(mld->wiphy); // AFTER (fixed): iwl_mld_thermal_exit(mld);
// Called WITHOUT wiphy lock wiphy_lock(mld->wiphy);
iwl_mld_low_latency_stop(mld); wiphy_unlock(mld->wiphy); ``` And in
`/drivers/net/wireless/intel/iwlwifi/mld/thermal.c`: ```c void
iwl_mld_thermal_exit(struct iwl_mld *mld) { wiphy_lock(mld->wiphy); //
NEW: Acquire lock only for work cancellation
wiphy_delayed_work_cancel(mld->wiphy, &mld->ct_kill_exit_wk);
wiphy_unlock(mld->wiphy); // NEW: Release before thermal calls #ifdef
CONFIG_THERMAL iwl_mld_cooling_device_unregister(mld); // Called without
wiphy lock iwl_mld_thermal_zone_unregister(mld); // Called without wiphy
lock #endif } ``` ### 3. **Backport Criteria Assessment** ✅ **Fixes an
important bug**: Prevents system deadlocks during driver unload ✅
**Small and contained**: Only reorders existing operations, no
functional changes ✅ **Minimal risk**: The change follows lock ordering
best practices seen in other drivers (ath10k, ath11k) ✅ **Clear side
effects**: None beyond fixing the deadlock ✅ **Critical subsystem**:
WiFi thermal management affects system stability ✅ **Low regression
risk**: Simply reorders operations without changing logic ### 4.
**Comparison with Similar Commits** This commit matches the pattern of
**Similar Commit #3** and **Similar Commit #5** (both marked YES for
backport): - **Similar to #3**: Fixes NULL pointer/crash issues in
thermal device handling - **Similar to #5**: Addresses lock ordering
issues that can cause system problems Unlike the NO commits which
involved API changes or feature additions, this is a pure bugfix. ### 5.
**Risk Assessment** **Very Low Risk**: - No architectural changes - No
new features introduced - Simply reorders existing lock acquisition -
Follows established patterns from other wireless drivers - Includes
proper lockdep assertions (`lockdep_assert_not_held`) ### 6. **Impact
Analysis** **High Impact**: - Prevents potential system hangs during
WiFi driver unload - Affects systems with thermal zone polling enabled -
Could manifest as unresponsive systems during suspend/resume or driver
reload scenarios - Particularly relevant for laptops/embedded systems
with active thermal management ### 7. **Triggering Conditions** The
deadlock can trigger when: - Thermal subsystem is polling temperature
(`iwl_mld_tzone_get_temp()`) - Driver is being unloaded simultaneously -
Both paths attempt to acquire locks in opposite order While the commit
message states "not likely to trigger," the lockdep detection indicates
it's a real issue that could manifest under specific timing conditions.
**Conclusion**: This is a textbook stable backport candidate - it fixes
a real deadlock bug with minimal, well-understood changes that carry
virtually no regression risk while preventing potential system hangs.

 drivers/net/wireless/intel/iwlwifi/mld/mld.c     | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mld/thermal.c | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 73d2166a4c257..3695e16014eba 100644
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

