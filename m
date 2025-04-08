Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1278D26A1C8;
	Tue,  8 Apr 2025 12:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115196; cv=none; b=dJWVMm9IUVVv2xrSz2syismQY8WQkoazBCKnBbgNejRnfiDQs0kpc4HqgBs+9mumuM6O+8V6MSYegYaeHyuVvq3V1UqOsjEzYiWR1emgQ9M6f0myyA1Y0Hdm+vup1UlDBzuPl1ASeLHRB1qoVUZp6tPM+/oap/YBHvPxdyEFbSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115196; c=relaxed/simple;
	bh=BVsVUO7D8oE3o9PWZIuu0Sw+xCvoQJvBjragxL00gkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4kcrujYwknyIy+CKnxtldigfDjyH4Jzdg+wC5ZI9CZxJkIxO02rkCxfkU533Rs3am8HQ95K1vGqEpo6OQfR/O/fQxzt0sNFY5g0ir4Icq7gc/TNwuoFVrM9tUEU+iZK6faMy2nfHt4dNNMdL13j7S2Kpq8DsTnvwxCfEZhLf8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuWfR1nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuWfR1nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958AAC4CEE5;
	Tue,  8 Apr 2025 12:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115195;
	bh=BVsVUO7D8oE3o9PWZIuu0Sw+xCvoQJvBjragxL00gkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuWfR1nH8XahTLWNe9IpI9TMdZPD8ZQSvnMGSOmd8L7/C6v1E/fWIBQUcYRHq3MO/
	 X8cIf/E2jgvT6QAADfn6aYtv89Is3WU0Norl/EltLwBy3ho04Klh3YbW/RaXnH2lA6
	 iG8MlLKxrSazL5lq7wceC/wW6Mk3MCGAKHlzknhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 336/499] wifi: mac80211: fix SA Query processing in MLO
Date: Tue,  8 Apr 2025 12:49:08 +0200
Message-ID: <20250408104859.602596091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9a267ce4a3fca93a34a8881046f97bcf472228c8 ]

When MLO is used and SA Query processing isn't done by
userspace (e.g. wpa_supplicant w/o CONFIG_OCV), then
the mac80211 code kicks in but uses the wrong addresses.
Fix them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250306123626.bab48bb49061.I9391b22f1360d20ac8c4e92604de23f27696ba8f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c4a28ccbd0647..a42959b39bd01 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -6,7 +6,7 @@
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2024 Intel Corporation
+ * Copyright (C) 2018-2025 Intel Corporation
  */
 
 #include <linux/jiffies.h>
@@ -3330,8 +3330,8 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
-	if (!ether_addr_equal(mgmt->sa, sdata->deflink.u.mgd.bssid) ||
-	    !ether_addr_equal(mgmt->bssid, sdata->deflink.u.mgd.bssid)) {
+	if (!ether_addr_equal(mgmt->sa, sdata->vif.cfg.ap_addr) ||
+	    !ether_addr_equal(mgmt->bssid, sdata->vif.cfg.ap_addr)) {
 		/* Not from the current AP or not associated yet. */
 		return;
 	}
@@ -3347,9 +3347,9 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	resp = skb_put_zero(skb, 24);
-	memcpy(resp->da, mgmt->sa, ETH_ALEN);
+	memcpy(resp->da, sdata->vif.cfg.ap_addr, ETH_ALEN);
 	memcpy(resp->sa, sdata->vif.addr, ETH_ALEN);
-	memcpy(resp->bssid, sdata->deflink.u.mgd.bssid, ETH_ALEN);
+	memcpy(resp->bssid, sdata->vif.cfg.ap_addr, ETH_ALEN);
 	resp->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 	skb_put(skb, 1 + sizeof(resp->u.action.u.sa_query));
-- 
2.39.5



