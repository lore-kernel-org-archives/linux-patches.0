Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CB727147D;
	Fri, 21 Nov 2025 13:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731178; cv=none; b=iAqXroO1s5Ko13sQwjvmKsC5LAiQNbu6SUPLEHy8EkDjIt+s/XVP7+TmpFsm/YIunODhg6wCehtpFnfD9xKBs/Kb30eU8avDi3b6eZ69ErMuNU6fEmFa9buLBh32QqMLJP8ZXoOtMNx13o84+5oP2RWrTy3bSYpur6BdALAmzPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731178; c=relaxed/simple;
	bh=1eS2uH0dXZ2L2rji6Nz0AoCEIMHSCPmkqSE/NPFUwek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbIxvGvfYK3kzYKLVhWbI1J0EAPsFw6q6SaBWMuKt5xQk1kzli0cqu2alKLyiYRiqZDAlMvgVDrmWYGFncLWEXNhD7HEhhluF1gNWwbRwNz6Ypz2PUUnN6kI4C5hfTd3xG3BL9b0O7MeMittjA5wxqhQyGfCa1yF4qT8wvc+4dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COLTj78G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COLTj78G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5487BC4CEF1;
	Fri, 21 Nov 2025 13:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731178;
	bh=1eS2uH0dXZ2L2rji6Nz0AoCEIMHSCPmkqSE/NPFUwek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COLTj78G1qcmmKTlfdHf4TyYHkUdS7trQNw+G2Hnlb4SkbrywftJJf8Duvu+fOybn
	 zUdVw4dwLXUIstjwAGXPEjbLt/5BA5oF/UxkalqTrJQbhDgT6/54tleU9USCUtVtBx
	 EvI5/FgO12Bs2kec2loiPCu/oJxps2949lBbVJWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 083/247] wifi: iwlwifi: mvm: fix beacon template/fixed rate
Date: Fri, 21 Nov 2025 14:10:30 +0100
Message-ID: <20251121130157.576260433@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3592c0083fb29cca13cd9978b8844d58b4eff548 ]

During the development of the rate changes, I evidently made
some changes that shouldn't have been there; beacon templates
with rate_n_flags are only in old versions, so no changes to
them should have been necessary, and evidently broke on some
devices. This also would have broken fixed (injection) rates,
it would seem. Restore the old handling of this.

Fixes: dabc88cb3b78 ("wifi: iwlwifi: handle v3 rates")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220558
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20251008112044.3bb8ea849d8d.I90f4d2b2c1f62eaedaf304a61d2ab9e50c491c2d@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 13 +++----------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    | 12 +++++++++---
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 8805ab344895a..0065c2ead56b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -938,19 +938,12 @@ u8 iwl_mvm_mac_ctxt_get_lowest_rate(struct iwl_mvm *mvm,
 
 u16 iwl_mvm_mac_ctxt_get_beacon_flags(const struct iwl_fw *fw, u8 rate_idx)
 {
+	u16 flags = iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
 	bool is_new_rate = iwl_fw_lookup_cmd_ver(fw, BEACON_TEMPLATE_CMD, 0) > 10;
-	u16 flags, cck_flag;
-
-	if (is_new_rate) {
-		flags = iwl_mvm_mac80211_idx_to_hwrate(fw, rate_idx);
-		cck_flag = IWL_MAC_BEACON_CCK;
-	} else {
-		cck_flag = IWL_MAC_BEACON_CCK_V1;
-		flags = iwl_fw_rate_idx_to_plcp(rate_idx);
-	}
 
 	if (rate_idx <= IWL_LAST_CCK_RATE)
-		flags |= cck_flag;
+		flags |= is_new_rate ? IWL_MAC_BEACON_CCK
+			  : IWL_MAC_BEACON_CCK_V1;
 
 	return flags;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 62da0132f3838..a62f5288dfd06 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -169,9 +169,15 @@ int iwl_mvm_legacy_rate_to_mac80211_idx(u32 rate_n_flags,
 
 u8 iwl_mvm_mac80211_idx_to_hwrate(const struct iwl_fw *fw, int rate_idx)
 {
-	return (rate_idx >= IWL_FIRST_OFDM_RATE ?
-		rate_idx - IWL_FIRST_OFDM_RATE :
-		rate_idx);
+	if (iwl_fw_lookup_cmd_ver(fw, TX_CMD, 0) > 8)
+		/* In the new rate legacy rates are indexed:
+		 * 0 - 3 for CCK and 0 - 7 for OFDM.
+		 */
+		return (rate_idx >= IWL_FIRST_OFDM_RATE ?
+			rate_idx - IWL_FIRST_OFDM_RATE :
+			rate_idx);
+
+	return iwl_fw_rate_idx_to_plcp(rate_idx);
 }
 
 u8 iwl_mvm_mac80211_ac_to_ucode_ac(enum ieee80211_ac_numbers ac)
-- 
2.51.0



