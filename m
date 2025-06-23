Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D51EEA5D;
	Mon, 23 Jun 2025 21:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714416; cv=none; b=S4dnr5/bUc5zoK5HzwXM/dV+snWssyZgeOjJlU2VDYwD7OR3UGibXC4M35qcwNiZiQouzv8g5GyeXvazElCELRy6zx4wRAXQaQcq8Fp75/rShk4mR131JhqEJETbNPQ58QFFA6mg4QEKkZYD8GmGDdcME3MI9LGyg02XpSPmhLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714416; c=relaxed/simple;
	bh=lcuiz/aoXTGTUV8JqrlOedB9uk445hbnTv1Ly45Muik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+P+kcZrSVaAW/2mygnYM5XWzr2WHwrlHDVaA4smPJYSD21K2Cqj+j9BqG8faSXeZbFTtpj+NjdGnYErREO4IYN9HPcWCayq+pxEH6DBK9fVWmRL4ilSBzma034vFH/Eb0CtrpriHkHPN4cC5qJz2xU9LhfZ4PN80yoX3ctEaFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZm2iGiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZm2iGiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3672EC4CEEA;
	Mon, 23 Jun 2025 21:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714416;
	bh=lcuiz/aoXTGTUV8JqrlOedB9uk445hbnTv1Ly45Muik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZm2iGiZ3Dixe/AuDNxbjyFyTXST+6OetcgeVrHbA8uHa1yque4dJs7NgZhMP05js
	 pg5r8YtyUvI7TusrmTA0lM984ZDf5oRbWYacKhgrcyhsW9l5HiljH/9+rVwkPYQt5W
	 rh4LujKHMNHWiaYclpD3noHu9vj1iiitATExelEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 389/592] wifi: mac80211: VLAN traffic in multicast path
Date: Mon, 23 Jun 2025 15:05:47 +0200
Message-ID: <20250623130709.695815742@linuxfoundation.org>
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

From: Muna Sinada <muna.sinada@oss.qualcomm.com>

[ Upstream commit 1a4a6a22552ca9d723f28a1fe35eab1b9b3d8b33 ]

Currently for MLO, sending out multicast frames on each link is handled by
mac80211 only when IEEE80211_HW_MLO_MCAST_MULTI_LINK_TX flag is not set.

Dynamic VLAN multicast traffic utilizes software encryption.
Due to this, mac80211 should handle transmitting multicast frames on
all links for multicast VLAN traffic.

Signed-off-by: Muna Sinada <muna.sinada@oss.qualcomm.com>
Link: https://patch.msgid.link/20250325213125.1509362-4-muna.sinada@oss.qualcomm.com
[remove unnecessary parentheses]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 20179db88c4a6..d6af02a524af3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4526,8 +4526,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 						     IEEE80211_TX_CTRL_MLO_LINK_UNSPEC,
 						     NULL);
 	} else if (ieee80211_vif_is_mld(&sdata->vif) &&
-		   sdata->vif.type == NL80211_IFTYPE_AP &&
-		   !ieee80211_hw_check(&sdata->local->hw, MLO_MCAST_MULTI_LINK_TX)) {
+		   ((sdata->vif.type == NL80211_IFTYPE_AP &&
+		     !ieee80211_hw_check(&sdata->local->hw, MLO_MCAST_MULTI_LINK_TX)) ||
+		    (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		     !sdata->wdev.use_4addr))) {
 		ieee80211_mlo_multicast_tx(dev, skb);
 	} else {
 normal:
-- 
2.39.5



