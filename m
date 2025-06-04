Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFF16AA7;
	Wed,  4 Jun 2025 00:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998414; cv=none; b=JGrcdvV67ceZ9LA+uj962LkoyXSMZTrrDR1rHQrYgOfFJwUsEwHI0QRoO/qEcXcTrpbqyW4yjarXlGmEJ5D00jY4iiV6dRRiDJ6+Ugz+vOQVxqxvhDXuxkUhBbP7ruqpzlRqIAulc01ZKxPJTEz4r0dMs8DjieIm0ThbqPErI0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998414; c=relaxed/simple;
	bh=iamkArx9xlfmAUAeCkWN9BxLpYjp4FtRpbN6UebXDpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M6v2888AmjCDImWA3E6xnnZZQv6kdX/Es0g//cq9yOQK8nqQtF4qJtFpsn9XcXV/gCGYyUckfU3LUMTpAEhFeJSRJZy/IxC1/ii5bYI+XGRGgydQvbMNfvgnEp95sgoOrkv7JlFk1YhD98yonABnOIrwLWIv0IyFp0WSRMeDXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jD3nfJNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jD3nfJNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB58C4CEED;
	Wed,  4 Jun 2025 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998413;
	bh=iamkArx9xlfmAUAeCkWN9BxLpYjp4FtRpbN6UebXDpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD3nfJNQ3QzLTTEJVXg2Ej+/xpZAcKxiPe6L63b1rm4LMmiRITNdLeeNa6O/hj37Z
	 NWwLKT3Kztn+JnlS07NLzyRKlsgvn4JCC+WAi6pBdD/bwBlkcw6ZM8L0DWyouh9lP7
	 ndJpzKUE3sOU0+2BFwkWphHLZ3cj9s/xRTDjnucpfc9Q3LnezRzQ9fIG+Vxek0R4UZ
	 27QE+GPQHSbB70uFXup3Z6yqZhGYTi+M8Xl9Hm0FoF8F93FaT2LuHY0T9ykBSlzOgX
	 jjFLq0MoMoYayrLH2ZeftZU4qpp+IdGUnx4Cz6cYuql3hkTM0zvrVh8VnsoZSZvq+H
	 6aI0YHvRaTokA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	benjamin.berg@intel.com,
	arnd@arndb.de
Subject: [PATCH AUTOSEL 6.15 067/118] wifi: iwlwifi: mld: check for NULL before referencing a pointer
Date: Tue,  3 Jun 2025 20:49:58 -0400
Message-Id: <20250604005049.4147522-67-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit f9151f16e140b9c43f076579146679408af6f442 ]

Errors can happen, and it is better not to risk with a NULL pointer
dereference.
Make sure that the links-to-remove pointers are not NULL before
dereferencing it.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250430151952.408652d45cda.I1bb72836dab17895a2e39910e4493d667db0fa80@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me analyze this in detail: **YES** This commit should be
backported to stable kernel trees. Here's my extensive analysis: ## Code
Analysis The commit adds a NULL pointer check in the
`iwl_mld_change_vif_links()` function: **Before:** ```c if (removed &
BIT(i)) iwl_mld_remove_link(mld, old[i]); ``` **After:** ```c if
(removed & BIT(i) && !WARN_ON(!old[i])) iwl_mld_remove_link(mld,
old[i]); ``` ## Why This Should Be Backported ### 1. **Prevents Kernel
Crashes** The change prevents a potential NULL pointer dereference that
could cause kernel crashes. Without this check, if `old[i]` is NULL,
passing it to `iwl_mld_remove_link()` would result in a kernel panic
when the function tries to dereference the pointer. ### 2. **Consistent
with Similar Backported Commits** Looking at the historical examples: -
**Similar Commit #3** (Status: YES): Fixed NULL pointer dereference in
iwlwifi with `for_each_vif_active_link` that also checks for valid
pointers before dereferencing - **Similar Commit #5** (Status: YES):
Fixed null-ptr deref on failed assoc by keeping a local copy before
clearing This commit follows the same pattern of adding NULL checks to
prevent crashes in error conditions. ### 3. **Small, Contained Fix** The
change is minimal and surgical: - Only adds a single NULL check with
WARN_ON - Doesn't change the function's core logic or introduce new
features - No architectural changes or side effects - Follows defensive
programming practices ### 4. **Error Handling Improvement** The commit
message explicitly states "Errors can happen, and it is better not to
risk with a NULL pointer dereference." This indicates it's addressing a
real error condition that can occur during normal operation,
particularly in WiFi 7 Multi-Link Operation scenarios. ### 5. **Critical
Subsystem** This touches the WiFi driver subsystem, which is user-facing
and where crashes would significantly impact system stability. Users
could potentially trigger this condition through normal WiFi operations.
### 6. **MLO Context Risk** The Multi-Link Operation (MLO) functionality
is relatively new in WiFi 7, and link management operations like those
in `iwl_mld_change_vif_links()` happen during: - Interface
reconfiguration - Link addition/removal in MLO setups - Error recovery
scenarios These are common operations where the `old[]` array might
contain NULL entries due to race conditions or error states. ### 7.
**Defensive Programming Pattern** The fix uses `WARN_ON(!old[i])` which:
- Alerts developers to the unexpected condition - Prevents the crash by
skipping the problematic operation - Maintains system stability -
Provides debugging information ## Risk Assessment **Minimal Risk:** -
The change is purely defensive - If `old[i]` is NULL, the original code
would crash anyway - The new code gracefully handles the error condition
- No functional changes to normal operation paths This commit clearly
fits the stable tree criteria: it fixes a potential crash with minimal
risk, is a small contained change, and addresses an error condition that
could affect users in the field. The pattern matches previously
backported NULL pointer fixes in similar network driver contexts.

 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 68d97d3b8f026..2d5233dc3e242 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -2460,7 +2460,7 @@ iwl_mld_change_vif_links(struct ieee80211_hw *hw,
 		added |= BIT(0);
 
 	for (int i = 0; i < IEEE80211_MLD_MAX_NUM_LINKS; i++) {
-		if (removed & BIT(i))
+		if (removed & BIT(i) && !WARN_ON(!old[i]))
 			iwl_mld_remove_link(mld, old[i]);
 	}
 
-- 
2.39.5

