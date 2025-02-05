Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889051519BE;
	Wed,  5 Feb 2025 14:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765302; cv=none; b=uWlipZClzrNijtLJMHQl2y7WGYjcNS/0rGs1FpZdGD79UYx/TJzPnyV0Ogl0Pfnt3u/KnL1BuLZumg6Swwrg9cNwrkeoaZRYjQ60JaynWZrYPdQROa3+WH+H/Qhz0R+t1WWFFgxq/NAoq+1wmCnmWs5aWKlNGSs4GQP2I7W/lj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765302; c=relaxed/simple;
	bh=UXb83zwmOUkNt5hVI+n8cZsDWMNNd9jNS9Rd1NROzqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWS0m+LY40JAYmVZWR6qrCvrJpPsZtJ7RuLoU/TFdz2qP+b+DF2lxp2qp9CgYXvSuCG+/N/GB8OwIpllNDOE2zEisZvt4oGk4BP0/pVUi43LrmFBf1g9NRV5O2yUYou1TX3oHHhWTs4KL9m+wSvJC8Rut2SVaUBhSMOv2sN2Hy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtnfCuUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtnfCuUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD96C4CED1;
	Wed,  5 Feb 2025 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765302;
	bh=UXb83zwmOUkNt5hVI+n8cZsDWMNNd9jNS9Rd1NROzqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtnfCuUYqcpRt74Zbs+nVq+hDwQ/dRufLxASn+80hxXYmiItFCHx6oVYjOLrdSvE/
	 krXABbVUvsfBg/nLFFaQw/0F75SOQULDYW1tr0xkdKzYTPs4eL/8L2I0l0GyQBp5Gn
	 3efuTGrmtSJ6pH64dKS6prPZI6ojBpiVH91hNccs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 164/623] wifi: iwlwifi: mvm: avoid NULL pointer dereference
Date: Wed,  5 Feb 2025 14:38:26 +0100
Message-ID: <20250205134502.509895741@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit cf704a7624f99eb2ffca1a16c69183e85544a613 ]

When iterating over the links of a vif, we need to make sure that the
pointer is valid (in other words - that the link exists) before
dereferncing it.
Use for_each_vif_active_link that also does the check.

Fixes: 2b7ee1a10a72 ("wifi: iwlwiif: mvm: handle the new BT notif")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20241229164246.31d41f7d3eab.I7fb7036a0b187c1636b01970207259cb2327952c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
index 36726ea4b822a..21641d41a958c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/coex.c
@@ -530,18 +530,15 @@ static void iwl_mvm_bt_coex_notif_iterator(void *_data, u8 *mac,
 					   struct ieee80211_vif *vif)
 {
 	struct iwl_mvm *mvm = _data;
+	struct ieee80211_bss_conf *link_conf;
+	unsigned int link_id;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	if (vif->type != NL80211_IFTYPE_STATION)
 		return;
 
-	for (int link_id = 0;
-	     link_id < IEEE80211_MLD_MAX_NUM_LINKS;
-	     link_id++) {
-		struct ieee80211_bss_conf *link_conf =
-			rcu_dereference_check(vif->link_conf[link_id],
-					      lockdep_is_held(&mvm->mutex));
+	for_each_vif_active_link(vif, link_conf, link_id) {
 		struct ieee80211_chanctx_conf *chanctx_conf =
 			rcu_dereference_check(link_conf->chanctx_conf,
 					      lockdep_is_held(&mvm->mutex));
-- 
2.39.5



