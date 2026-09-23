Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2253A6F1C;
	Wed, 23 Sep 2026 14:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172957; cv=none; b=rwHqBXg1Wzo6Xr9d0pmo1dVXvv1pMBUCMZRKguwNRxXKsoSeiMND5FPsE2g51KCNfVHQ9zcitZmJCEcp/HuY0bxuh37cIuxbBNT2thiTYCxfiatq3Wtviw+fgifM4vafUJfVpcimSUWfL83T7+gGad7p59MmC6wsQAeXA7x8Vm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172957; c=relaxed/simple;
	bh=1JHe7B1Bs4VlAj39xIOsVLKi+l+imX3NUHklxmJodkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nexqJQHsaXgR5qtdFpIk20WagxiQuGc2RDFYQu68VzDc+jBHjbFCKBgUIh//7K/lymuoYYA1RHMSfkNTAYzlZk8G0IhejzuswVf/fQ+Hl0lwh9OYJrmyR4xXMH85LOrpD3KeGXfnUBoBvESf7j0Ew14o0KfBu2kJwcCz35rQpw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9VmIK1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9VmIK1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB96C1F000FF;
	Wed, 23 Sep 2026 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172956;
	bh=VDJ4uwFP26vIbI5z+D4+Z1rqhOFDECan1POs5l4Kn2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9VmIK1fEeE6w+ROlJfxjJ5txVXr3IA/yWRqX/aBZQ+oD2KSRD1cp20GT0stmR/vw
	 xSRJWgth1FWGCCF7YiJRbgnb31ag1+qdfyUppdMUYSsCsF5HASoOHP7N0teDqyLTsJ
	 tMwzV/ylEihBJ9wFLT4l8dtP/I81G4NLYjCZ7q/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+435fdb053cf98bfa5778@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 082/438] wifi: mac80211: dont allow injecting frames wider than the chanctx
Date: Wed, 23 Sep 2026 16:01:43 +0200
Message-ID: <20260923140646.908870269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e14bf37bb2b3853012ff160131d1c6233f7a9cc9 ]

Frames injected on a monitor interface can carry a radiotap
field requesting a bandwidth, which mac80211 passes down to
the driver regardless of the the actual operational bandwidth.

If the bandwidth requested is too wide, that triggers a warning
in hwsim:

  WARN_ON(hwsim_get_chanwidth(bw) > hwsim_get_chanwidth(confbw))

Drop such frames entirely instead since they cannot be sent.

Assisted-by: LLM
Fixes: 646e76bb5daf ("mac80211: parse VHT info in injected frames")
Reported-by: syzbot+435fdb053cf98bfa5778@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=435fdb053cf98bfa5778
Link: https://patch.msgid.link/20260908122838.201719-13-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h |  5 ++++-
 net/mac80211/iface.c   |  2 +-
 net/mac80211/tx.c      | 28 ++++++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4f95da023746f..36055d40172a1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7615,11 +7615,14 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
  *
  * @skb: packet injected by userspace
  * @dev: the &struct device of this 802.11 device
+ * @chandef: the channel definition the frame will be transmitted on, or
+ *	%NULL to skip the bandwidth checks
  *
  * Return: %true if the radiotap header was parsed, %false otherwise
  */
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
-				 struct net_device *dev);
+				 struct net_device *dev,
+				 const struct cfg80211_chan_def *chandef);
 
 /**
  * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 842bfb4a7cb68..ca66eb493ac7d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -991,7 +991,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 	/* reset flags and info before parsing radiotap header */
 	memset(info, 0, sizeof(*info));
 
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, NULL))
 		return 0; /* doesn't matter, frame will be dropped */
 
 	len_rthdr = ieee80211_get_radiotap_len(skb->data);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7cb9dd1b27314..a726a697c32d7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2096,8 +2096,29 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
 	return true;
 }
 
+static bool ieee80211_rate_bw_usable(u16 rate_flags,
+				     const struct cfg80211_chan_def *chandef)
+{
+	int width;
+
+	if (!chandef)
+		return true;
+
+	if (rate_flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+		width = 160;
+	else if (rate_flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		width = 80;
+	else if (rate_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		width = 40;
+	else
+		return true;
+
+	return width <= cfg80211_chandef_get_width(chandef);
+}
+
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
-				 struct net_device *dev)
+				 struct net_device *dev,
+				 const struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_radiotap_iterator iterator;
@@ -2271,6 +2292,9 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 		struct ieee80211_supported_band *sband =
 			local->hw.wiphy->bands[info->band];
 
+		if (!ieee80211_rate_bw_usable(rate_flags, chandef))
+			return false;
+
 		info->control.flags |= IEEE80211_TX_CTRL_RATE_INJECT;
 
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -2470,7 +2494,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * selected chandef above to accurately set injection rates and
 	 * retransmissions.
 	 */
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, chandef))
 		goto fail_rcu;
 
 	/* remove the injection radiotap header */
-- 
2.53.0



