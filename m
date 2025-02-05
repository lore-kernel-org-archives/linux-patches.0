Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C701553AB;
	Wed,  5 Feb 2025 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765323; cv=none; b=sxdYo7fzvXHk66H2Ziht44s/pUjZhBHO75avhkzG34VUW+iI9IGQKV9rJhKZLc3ryjyPGWsjH8hJvnLDhJOCP/zU1sM/gzVfQnf3lwq+t35u3lq5Bai0+5x0BUa7nOF2BboCC0IYLJBVMgRjeDkVI3NkFkahrChfExFbcAAXkYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765323; c=relaxed/simple;
	bh=tB2Y71mNDMhlw606gRW0LD/dHYro95GOchVmF6t4/aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQIYw6v28rrI5dEsqZE5FOLHdZ9ddBu11aTq3QtcH3zxqFbs+mhcfK7PNcWCCyCz7w6AyYtqVNN4kbLYl+hjYva2MeYTxjG1nhqi5wNxo8XWK/BaTnctpuhkRmsYEcafx3dqwK3ajzrWRSd7Ief6LS+3dEn3IGyaluAyeFWONrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIf+iE9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIf+iE9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702FCC4CED1;
	Wed,  5 Feb 2025 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765322;
	bh=tB2Y71mNDMhlw606gRW0LD/dHYro95GOchVmF6t4/aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIf+iE9+Np44Ogc9JdwouZhEC1hcuTmZZqPEfkZrqw+d9qZ77i4xlDb77ZeVNnO5q
	 YnvJ/0ileJcQF3S3x0hRnIMCV5kjs5bCZQqxZeMgN3IupiwmxE5OOnwqiC3+d42kSn
	 h/re6N8+gvwM5Xlt+/zaXCImqx0k8ZqlgMjk7SaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 166/623] wifi: iwlwifi: mvm: remove unneeded NULL pointer checks
Date: Wed,  5 Feb 2025 14:38:28 +0100
Message-ID: <20250205134502.585932490@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 79f4b6934dbd7dd6741726ba004a15e25380b8cc ]

Smatch reported that we dereference the data pointer to calculate the
expected length before we check it's not NULL. While this is true (and
hence needs to be fixed), this will never happen because the data
pointer comes from struct iwl_rx_packet object which has the following
layout:

struct iwl_rx_packet {
        __le32 len_n_flags;
        struct iwl_cmd_header hdr;
        u8 data[];
} __packed;

So, if the pointer to iwl_rx_packet is valid, data will be valid as
well.

Remove the NULL pointer check on 'data' to avoid confusing smatch.
Also remove the check from similar functions in the same flow that were
cargo cult copy-pasted.

Fixes: 4635e6eaa0fe ("wifi: iwlwifi: mvm: support new versions of the wowlan APIs")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202411210812.0eLaonw3-lkp@intel.com/
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241229164246.c8ce6e041e4b.I4dc19289e3f3807386768c846e08be3ea322cd15@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 7d973546c9fb8..4d1daff1e070d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2498,12 +2498,6 @@ static void iwl_mvm_parse_wowlan_info_notif(struct iwl_mvm *mvm,
 	u32 expected_len = sizeof(*data) +
 		data->num_mlo_link_keys * sizeof(status->mlo_keys[0]);
 
-	if (!data) {
-		IWL_ERR(mvm, "iwl_wowlan_info_notif data is NULL\n");
-		status = NULL;
-		return;
-	}
-
 	if (len < expected_len) {
 		IWL_ERR(mvm, "Invalid WoWLAN info notification!\n");
 		status = NULL;
@@ -2555,12 +2549,6 @@ iwl_mvm_parse_wowlan_info_notif_v4(struct iwl_mvm *mvm,
 	u32 i;
 	u32 expected_len = sizeof(*data);
 
-	if (!data) {
-		IWL_ERR(mvm, "iwl_wowlan_info_notif data is NULL\n");
-		status = NULL;
-		return;
-	}
-
 	if (has_mlo_keys)
 		expected_len += (data->num_mlo_link_keys *
 				 sizeof(status->mlo_keys[0]));
@@ -2609,12 +2597,6 @@ iwl_mvm_parse_wowlan_info_notif_v2(struct iwl_mvm *mvm,
 {
 	u32 i;
 
-	if (!data) {
-		IWL_ERR(mvm, "iwl_wowlan_info_notif data is NULL\n");
-		status = NULL;
-		return;
-	}
-
 	if (len < sizeof(*data)) {
 		IWL_ERR(mvm, "Invalid WoWLAN info notification!\n");
 		status = NULL;
-- 
2.39.5



