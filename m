Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42841184556;
	Tue, 30 Jul 2024 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357004; cv=none; b=iYk8+En70jHdJnqBrvZNRjevhQKf4Xsf4TQfPvJ2ML1852nxnt+/np9u2ephoKGaFXvzp3fEI3hccOPh7EZHiR8eW1xiavYt2CD25AAcJBnNwbEHawG8PCFY6ETHU0p/keU/ouQGsO9vzvuJIf5kmL/+9VaPjAGRb0B5IF/reyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357004; c=relaxed/simple;
	bh=Zr+c7zaL9G0H3BT/kJEK1Wq890LxCMK9nLLzaBWbmd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB92hBxydCCU2hChWKo14WkBaQNBh3DOzkIFn3f67C4fIg/i0ZuM8glo3sppwMw09/lgUteSdz5bmxNWke0p0I9n5v/aN+L/efFRAbIKY78jK4LZssXX8SX1CvQnlqr6FUfnCMpgggWD78ET7IqSSMPxLP/gvBpM/kNAlGLFnfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfiaFyU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfiaFyU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC00CC4AF0A;
	Tue, 30 Jul 2024 16:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357004;
	bh=Zr+c7zaL9G0H3BT/kJEK1Wq890LxCMK9nLLzaBWbmd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfiaFyU2yRFemFxhFA6nzqv6cmn/WCbkYiuc+73y6c2BUhX+lGR/tapT2Rwbba7ET
	 EZaLhm9GETdonPF6YhN6sILuCbnOc8tFGvS1cwIhJV+/I9jx+A+YBsFrcU95ysNPuc
	 6CzM0AlDvBxkGayqfiCoeELlprXBRzDwPwLgM9IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 209/809] wifi: mac80211: add ieee80211_tdls_sta_link_id()
Date: Tue, 30 Jul 2024 17:41:25 +0200
Message-ID: <20240730151732.861315823@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d42fcaece03654a4b21d2da88d68ed913e0b6c46 ]

We've open-coded this twice and will need it again,
add ieee80211_tdls_sta_link_id() to get the one link
ID for a TDLS STA.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240612143707.9f8141ae1725.I343822bbba0ae08dedb2f54a0ce87f2ae5ebeb2b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 0b2d9d9aec2b ("wifi: mac80211: correcty limit wider BW TDLS STAs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.h | 6 ++++++
 net/mac80211/tx.c       | 6 ++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index bd5e2f7146f67..9195d5a2de0a8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -727,6 +727,12 @@ struct sta_info {
 	struct ieee80211_sta sta;
 };
 
+static inline int ieee80211_tdls_sta_link_id(struct sta_info *sta)
+{
+	/* TDLS STA can only have a single link */
+	return sta->sta.valid_links ? __ffs(sta->sta.valid_links) : 0;
+}
+
 static inline enum nl80211_plink_state sta_plink_state(struct sta_info *sta)
 {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f861d99e5f055..72a9ba8bc5fd9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2774,8 +2774,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 		if (tdls_peer) {
 			/* For TDLS only one link can be valid with peer STA */
-			int tdls_link_id = sta->sta.valid_links ?
-					   __ffs(sta->sta.valid_links) : 0;
+			int tdls_link_id = ieee80211_tdls_sta_link_id(sta);
 			struct ieee80211_link_data *link;
 
 			/* DA SA BSSID */
@@ -3101,8 +3100,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	case NL80211_IFTYPE_STATION:
 		if (test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
 			/* For TDLS only one link can be valid with peer STA */
-			int tdls_link_id = sta->sta.valid_links ?
-					   __ffs(sta->sta.valid_links) : 0;
+			int tdls_link_id = ieee80211_tdls_sta_link_id(sta);
 			struct ieee80211_link_data *link;
 
 			/* DA SA BSSID */
-- 
2.43.0



