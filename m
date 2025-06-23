Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96190218580;
	Mon, 23 Jun 2025 22:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716473; cv=none; b=HXQ+sjZOAlTF4qLUDLrlxE9WD3Iau9Ww2w+GiQ99bp6Lhm9pS6ByVkvw7aWK8pcxiXnNIjWcUpsWSq4+B3/ymw1eN4RRM8CULTepS1RNvAKmw6h+P7OCJLkLgvSP8mcUG4BbiAZmbEh8ulC5CnmeIDXcIvPU7KtriWnDtARE/2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716473; c=relaxed/simple;
	bh=kl55pLFmAbHK5F4tWdhEZ/aQfrC7Dky2BfD3e1yLaUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ana4n+eEdaaDl0o0TlCyEN8R2ZeCsinNP/XQrfG/oLQB1jSPfHkMDSXc8Kffk12vumwS/V83Ej4zCgfg7HP1W+9GjG52X83G4+FXcP6emdTBRnlHfFJbWD5fzf/jKfN3s7W2mVQJE1RYdaW2dq5Ka8Drx3jGubCRKvngS5KPO6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCt1SFRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCt1SFRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E575C4CEEA;
	Mon, 23 Jun 2025 22:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716473;
	bh=kl55pLFmAbHK5F4tWdhEZ/aQfrC7Dky2BfD3e1yLaUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCt1SFRpU2qwejroc7yoH8xMJ/aHqXXCE3rfC+tBcSyHO23IHsp7gW66p7WwGlvlj
	 LPQVDE2XTvt3TrIJjqXz7t5rezVh5labOjGF2fIIgB+WPhvB8BNlb97swr4C5OuaZO
	 7+RWFTD5wegcq0+L/YXQznfDMha0Q4c+BHFGJ7x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/414] wifi: mac80211: VLAN traffic in multicast path
Date: Mon, 23 Jun 2025 15:06:30 +0200
Message-ID: <20250623130648.371291478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
index 0ff8b56f58070..ef16ff149730a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4523,8 +4523,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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



