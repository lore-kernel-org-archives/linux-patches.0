Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45B115198D;
	Wed,  5 Feb 2025 14:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764802; cv=none; b=CrgDiOOi/JOF9ApiP9QmsAGLy4J5hImLiHf5SviMW41HEUllCmbbU3pA+f44C5vEmAvOcmShgdxbLC+FNaFaSfVnP3G6IHnSUcuYi30ifxn/J28bbfqLH8MVfHnjiAapB3g694Ge9yfOwD5zN6BFZhJXbDxHUT9kXWwWGOxkce0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764802; c=relaxed/simple;
	bh=9h9kCzG/IOjkMd45xfETh2TXUlgoXCQjwwHlR6LgR+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpltipPcI+UE9ZSSlaBYmcZ/R5EvfDIYcjQtYyjASKHXjOXY1kIfzomO9P7LhcL6az5AQpuVFzKOfuqu3F32cEjEzYIxJ1V4bTjxdIe4TrYeMN7uFS2ENl7d8QcV/qZGn5oOTfu/O4MSpKOPaQK6txEUpdo3X28GUzul4sYFjck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cN/lfXHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cN/lfXHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71A8C4CED1;
	Wed,  5 Feb 2025 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764802;
	bh=9h9kCzG/IOjkMd45xfETh2TXUlgoXCQjwwHlR6LgR+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cN/lfXHbw8UrpFB3wIak9c7XX95ajuUlVYsXXOxsp1j39u3E1cGVDkRCz4TEz6QPo
	 qs/vy7GNkWCd93NQ2cOresIGt2TqHrg+WaMsnxgqimYR6RnmARabxg7N31FRNS0T5r
	 bKBHXc8HQhow1i3Bryc9F8e7JY/9DQHU07qNMp8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/590] wifi: iwlwifi: mvm: avoid NULL pointer dereference
Date: Wed,  5 Feb 2025 14:38:34 +0100
Message-ID: <20250205134501.368055903@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b607961970e97..9b8624304fa30 100644
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



