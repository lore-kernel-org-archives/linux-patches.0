Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9F528134C;
	Sat, 14 Feb 2026 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104344; cv=none; b=XyxGWtp1H0eKYa7qunohFQTiaB+tjgpC7EdYeAQJORZV+fOB78V5p75egqDW1+XWRN/sS7KZ1CTjjAHuRNHXPOBI6zbhib+tl91hcc5Lzl/BMxaPFNDioOgZyNP20qlPS+jHXguHCcJngy5u5h8+b4TqxuIw9/nAhat0i6Wb6WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104344; c=relaxed/simple;
	bh=el7q+S3zLO8ASetRoqYi/Y+cAyRoQ4xecM7aCSAOMzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceEC/fu4YbK087SpAItOmuWjtbMlSj82R0U9o3/HmgFTVv+xBFACAwS9YIfAU4heZsCPyIC2jRLxWezCcy7+3vJI831grMcf2lZWFKZik5Lap9wMMiTn4Iu2Bs3NLxGgZtqzVCXSqGHuUcA7EGRxF3pWO82sqFA7I3nT9yi/F4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nu90zRww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nu90zRww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815E4C16AAE;
	Sat, 14 Feb 2026 21:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104344;
	bh=el7q+S3zLO8ASetRoqYi/Y+cAyRoQ4xecM7aCSAOMzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nu90zRww1B7VqP4lUsQ2OlpA1bZT0W/DvxMaQRSH15AUlUkPAE0eNrs0PG3WPXCMi
	 qRxMo9utLxCIhhIhjTXEHVVyl2nQpP50Qu44/95UjOLlxfaGlKWsP9/kkMNxBYQMPx
	 RkQ45i2v8IOh2DQT3+qdwMcK5eXBYJjwtIrpOjMtVMtOdMLpblPey/2yApeoPEi9oG
	 rm9t9DNogdMDQA4QUnsZRH5XQ9dj4jOVWy5cfZeA59z/w4MvH+gjSLhZX7+i30QU6C
	 e3e3G7NQuuWF1jzS+jMju0uonu2IGrZLSSkz6P9ePG6kwWcbBLxeaBlc8S+o1BeIfq
	 rZrDOvP3CltMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nidhish A N <nidhish.a.n@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes.berg@intel.com,
	emmanuel.grumbach@intel.com,
	ilan.peer@intel.com,
	benjamin.berg@intel.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] wifi: iwlwifi: mld: Fix primary link selection logic
Date: Sat, 14 Feb 2026 16:22:52 -0500
Message-ID: <20260214212452.782265-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Nidhish A N <nidhish.a.n@intel.com>

[ Upstream commit 7a749db26cab2334d5b356ac31e6f1147c7682da ]

When assigning emlsr.primary with emlsr.selected_primary
we are checking if BIT(mld_vif->emlsr.selected_links) are
a part of vif->active_links. This is incorrect as
emlsr.selected_links is a bitmap of possibly two selected links.
Therefore, performing the BIT() operation on it does not
yield any meaningful result and almost always leads to
incorrect primary link selection.

Additionally, we cannot rely on vif->active_links at this
stage of the link switch flow because it contains both the
removed links and also the newly added links.
For example, if we had selected links in the past (0x11)
and we now select links because of TTLM/debugfs (0x100),
vif->active_links will now be (0x111) and primary link
will be 0, while 0 is not even an active link. Thus,
we create our own bitmap of final active links.

Signed-off-by: Nidhish A N <nidhish.a.n@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260111193638.38b2e14e3a20.Ie81a88dfff0c5d2becedabab8398702808f6b1bf@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `iwlmld` driver was added in v6.15. Current stable trees that could
possibly have it are 6.15.y, 6.16.y, 6.17.y, and 6.18.y. The mainline is
6.19. The most actively maintained LTS kernels (6.12.y, 6.6.y, 6.1.y,
5.15.y) do **NOT** have the `mld/` directory at all.

## CRITICAL FINDING: Applicability to Stable Trees

The `iwlmld` sub-driver was introduced in v6.15. The current long-term
stable (LTS) kernel branches are:
- 6.12.y (LTS)
- 6.6.y (LTS)
- 6.1.y (LTS)
- 5.15.y (LTS)
- 5.10.y (LTS)
- 5.4.y (LTS)

**None of these LTS trees contain the `mld/` directory.** The code only
exists in 6.15+ (which was a regular release, not LTS). While 6.15.y,
6.16.y, 6.17.y, and 6.18.y are maintained as short-term stable, the fix
targets very new code that:

1. Only exists in recent non-LTS stable trees
2. Is part of the brand-new WiFi 7 EMLSR implementation
3. The `iwl_mld_assign_vif_chanctx` function itself was added in v6.15

## Summary

| Criteria | Assessment |
|----------|-----------|
| Fixes real bug? | YES - incorrect primary link selection |
| Obviously correct? | YES - the BIT() on bitmap bug is clear |
| Small and contained? | YES - single function in one file |
| Risk of regression? | LOW |
| Applicable to stable? | LIMITED - only 6.15+ short-term stable trees |
| User impact? | MODERATE - affects WiFi 7 EMLSR users with Intel
hardware |

## Verdict

While this is undeniably a real bug fix that is small, correct, and
well-scoped, **the affected code only exists in very recent kernel
versions (6.15+), none of which are LTS trees**. The `iwlmld` sub-driver
is brand new WiFi 7 code that doesn't exist in any of the long-term
stable kernels (6.12.y and below).

That said, short-term stable trees (6.15.y through 6.18.y) DO contain
this code, and users of those trees would benefit from the fix. The fix
is clearly correct, addresses a real bug that "almost always leads to
incorrect primary link selection," and is small/surgical. For the short-
term stable trees where this code exists, this is a good backport
candidate.

Given that stable backporting applies to ALL stable trees (including
short-term ones like 6.15.y, 6.18.y), and this fix is clearly correct,
small, and fixes an always-triggering bug in EMLSR mode:

**YES**

 .../net/wireless/intel/iwlwifi/mld/mac80211.c | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index cd0dce8de8569..3a1b5bfb9ed66 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -984,7 +984,9 @@ int iwl_mld_assign_vif_chanctx(struct ieee80211_hw *hw,
 {
 	struct iwl_mld *mld = IWL_MAC80211_GET_MLD(hw);
 	struct iwl_mld_link *mld_link = iwl_mld_link_from_mac80211(link);
-	unsigned int n_active = iwl_mld_count_active_links(mld, vif);
+	struct iwl_mld_link *temp_mld_link;
+	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
+	u16 final_active_links = 0;
 	int ret;
 
 	lockdep_assert_wiphy(mld->wiphy);
@@ -992,10 +994,7 @@ int iwl_mld_assign_vif_chanctx(struct ieee80211_hw *hw,
 	if (WARN_ON(!mld_link))
 		return -EINVAL;
 
-	/* if the assigned one was not counted yet, count it now */
 	if (!rcu_access_pointer(mld_link->chan_ctx)) {
-		n_active++;
-
 		/* Track addition of non-BSS link */
 		if (ieee80211_vif_type_p2p(vif) != NL80211_IFTYPE_STATION) {
 			ret = iwl_mld_emlsr_check_non_bss_block(mld, 1);
@@ -1016,17 +1015,25 @@ int iwl_mld_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 	rcu_assign_pointer(mld_link->chan_ctx, ctx);
 
-	if (n_active > 1) {
-		struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
+	/* We cannot rely on vif->active_links at this stage as it contains
+	 * both the removed links and the newly added links.
+	 * Therefore, we create our own bitmap of the final active links,
+	 * which does not include the removed links.
+	 */
+	for_each_mld_vif_valid_link(mld_vif, temp_mld_link) {
+		if (rcu_access_pointer(temp_mld_link->chan_ctx))
+			final_active_links |= BIT(link_id);
+	}
 
+	if (hweight16(final_active_links) > 1) {
 		/* Indicate to mac80211 that EML is enabled */
 		vif->driver_flags |= IEEE80211_VIF_EML_ACTIVE;
 		mld_vif->emlsr.last_entry_ts = jiffies;
 
-		if (vif->active_links & BIT(mld_vif->emlsr.selected_links))
+		if (final_active_links == mld_vif->emlsr.selected_links)
 			mld_vif->emlsr.primary = mld_vif->emlsr.selected_primary;
 		else
-			mld_vif->emlsr.primary = __ffs(vif->active_links);
+			mld_vif->emlsr.primary = __ffs(final_active_links);
 
 		iwl_dbg_tlv_time_point(&mld->fwrt, IWL_FW_INI_TIME_ESR_LINK_UP,
 				       NULL);
-- 
2.51.0

