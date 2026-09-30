Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C25B51A148;
	Wed, 30 Sep 2026 17:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788409; cv=none; b=MtfNoBwuxNpiTODtH18ugd4OEutMwPgJsWJ8ykybrLiW4VuZOSh5vclcCqvdCo+ciAjxU5oswSLlDUY2nb74htxfOsJCdolLM32okVJouHEboUoeQndqjT0sbqWM1a1PhCySiVR8+hvHR0po2elSpaT4Ycx3gudprTcKsSGWqdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788409; c=relaxed/simple;
	bh=JIPF6OO/fH5Rmjqp/yw1W/lo0u2AJ4O03uNEAnixl8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwsCxlKATwY12sB7rWs9oIsUKAGgIg0rntQx1CENX3+ogcfZytgdGEfLPrV4Kkk0Qkf6Ic8m18jLazcGV8g6Y2U44ajibRjd0fraCtbSCDP/foU+cmph70ZECg+ulpD9PMNBrX9Zl8OEwB+CZyVBzQeGSViqbluCy/c47HNUeFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pI72BsEw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pI72BsEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4EC1F000FF;
	Wed, 30 Sep 2026 17:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788408;
	bh=Cf7Rvev/BGhQQOw2k19FuZGw3wb2aDgjeYsGZ/esE4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pI72BsEwL0qCjVQ/Jjt+gHvEZCWElexUv1BgMVv/Sbz3UxFAx6I3ZWz2EhaOFuiJw
	 /GSvHRac0fEOxfp2JNlKnd0bH3MkPQinrhA5YrDn8rxtBawVs66hJ/x91s5nvELl2P
	 qDgLbGKZnwhpME+gMS8bHEa4BmR+ZzMX7veNKCyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+435fdb053cf98bfa5778@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/877] wifi: mac80211: dont allow injecting frames wider than the chanctx
Date: Wed, 30 Sep 2026 17:16:20 +0200
Message-ID: <20260930152416.228476288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d71a4149cdf9..41ae682015fc0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7228,11 +7228,14 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
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
index ac0a7374d721a..3726dded1959a 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -929,7 +929,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 	/* reset flags and info before parsing radiotap header */
 	memset(info, 0, sizeof(*info));
 
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, NULL))
 		return 0; /* doesn't matter, frame will be dropped */
 
 	len_rthdr = ieee80211_get_radiotap_len(skb->data);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9bc1a80e80570..e78e71cb92f7f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2084,8 +2084,29 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
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
@@ -2259,6 +2280,9 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 		struct ieee80211_supported_band *sband =
 			local->hw.wiphy->bands[info->band];
 
+		if (!ieee80211_rate_bw_usable(rate_flags, chandef))
+			return false;
+
 		info->control.flags |= IEEE80211_TX_CTRL_RATE_INJECT;
 
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -2448,7 +2472,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * selected chandef above to accurately set injection rates and
 	 * retransmissions.
 	 */
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, chandef))
 		goto fail_rcu;
 
 	/* remove the injection radiotap header */
-- 
2.53.0



