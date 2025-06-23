Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08B71DDC04;
	Mon, 23 Jun 2025 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714977; cv=none; b=UpiJRKmeB0U7MCBvGU3SIkxlldkY6GbV4f/BPtAMSAVlixdS1BHGTzMc/AeOOlKPVduZUf3n+oI7qsASvDmYp5ld/yu0fAmtHxafA0iEBvFO6F/7MpkFvn5wD6N/u04HHYrVoo01aRK5Q2v3yiT7TDV5P65B5FP90H+gdlOSfrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714977; c=relaxed/simple;
	bh=uIlkwUSnU8ogfXbj9Wn6QNBCNRtcsK3lwNvw02PpxVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJD8gE9i1ww4W8YN3/K/WxG89+OmsoGxPTjlRF6gYG3wwMU5e5I4Nj2Wy0ZqO7Zt+AF1jJA8AP686fEUIOI6r49j2PgP3+OJ1ArALNqS7MEFz7IyNfm3wkqS8wKQO1heMmKvxUorpCdzG12/2ddFSzvoyVKgHnjrx7eXptjwcg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2jhk1Lv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2jhk1Lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69995C4CEEA;
	Mon, 23 Jun 2025 21:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714977;
	bh=uIlkwUSnU8ogfXbj9Wn6QNBCNRtcsK3lwNvw02PpxVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2jhk1Lvc3EiDZr5SjJO+RuFgdGSUJogwxQwssVjCtmqJ4HyA6DLgrcoX9ubo1FA0
	 8MkJwrUJtBvZDQncsq/9OrAYdMujMliNU7FENkjenbgDbWh3hGNmne4gIe1pNoyHdD
	 e7vzK1N4rK92rM6KnuxTNSY5qhrsDM8sStY1UYkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/290] wifi: mac80211: VLAN traffic in multicast path
Date: Mon, 23 Jun 2025 15:07:13 +0200
Message-ID: <20250623130632.062883843@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45a093d3f1fa7..ec5469add68a2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4507,8 +4507,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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



