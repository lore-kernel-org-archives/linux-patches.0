Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81246386441;
	Wed, 23 Sep 2026 14:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174405; cv=none; b=Wt5BCpKOHLu0aoJ6lOlWANuFzym7h/WhDSVLfBPhqnJzunKKehmoK47KS6yfy5q/Ig6kuY+Pp0LCfo/2p/OO1kQlmtHL0kKYozMp3qqCe2iDIVoEgzvco/5DY+9zo6K1Bl+k55Dd9k2RWGoKYcINM2us5gNyi0XO8/+lxuM7JaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174405; c=relaxed/simple;
	bh=WSdGJ1/B9JdEEzQzMCDEgkor2yNZgv4bcCa5IXqDpsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoFcOrD9G2OI+t5ghpW6YA1ULfscYdSEjPQC1L2jsyLg1RVLJB28b3yFvH2axvMNnJeU01SJ2M2GmFASVXxAGx3OKbVLzBBH4IWjMhM0Fh7uwD5RGne+LFmFKilDZ80du9vIFTgMWse8sIdSkBHhNMHZfvUCytWCwT/Y5GAy6rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8cG74js; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8cG74js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86521F000FF;
	Wed, 23 Sep 2026 14:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174404;
	bh=FsTGroNFEBWSPNG0spG/z/odmZsveZDvMqFa3LXqRKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8cG74js4fj5rxqta/8QSq+Qg5iw9iKxD1qiQfMPE29zE/Y+s8PFs7XZNyMZ4V7G7
	 4JbfyZXWWc4Rf1tmDTbekHhAjbwXO+OCruAKYUYTR6ZHGlwyKJj0/bXcDKtu3XUzwX
	 C69v2rq6a5iaoAM2aEBg+2j8YfgoakyESOM3hJj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/398] wifi: mac80211_hwsim: dont hand frames to mac80211 while stopping
Date: Wed, 23 Sep 2026 16:02:26 +0200
Message-ID: <20260923140645.299513775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 87840d4a3a21b1c19b867a80e16ba69dff284de2 ]

The code checks ->started for frames coming from wmediumd, but the
radio can be stopped after the check and before frame delivery,
causing mac80211 to hit the WARN_ON(!local->started).

Expand the mutex for this case and synchronise against it when the
radio is stopped to avoid being able to hit the warning with hwsim.

Drop the error print that would've complicated the error path, it
only triggers for allocation failures (already noisy) and malformed
frames anyway.

Assisted-by: LLM
Fixes: 7882513bacb1 ("mac80211_hwsim driver support userspace frame tx/rx")
Reported-by: syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b4aa2b672b18f1d4dc5f
Link: https://patch.msgid.link/20260904170140.5f69a10d606b.I4a7921d00643f69e439c7a3b221d104f66a3dcdc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 39 ++++++++++++-------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 90caa4290dc45..484198766efda 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -2162,7 +2162,12 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
 	struct sk_buff *skb;
 	int i;
 
-	data->started = false;
+	/*
+	 * Serialise against wmediumd userspace, so no more frames
+	 * can be handed to mac80211 after this returns.
+	 */
+	scoped_guard(mutex, &data->mutex)
+		data->started = false;
 
 	for (i = 0; i < ARRAY_SIZE(data->link_data); i++)
 		hrtimer_cancel(&data->link_data[i].beacon_timer);
@@ -6136,12 +6141,12 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
 	    frame_data_len > IEEE80211_MAX_DATA_LEN)
-		goto err;
+		goto out;
 
 	/* Allocate new skb here */
 	skb = alloc_skb(frame_data_len, GFP_KERNEL);
 	if (skb == NULL)
-		goto err;
+		goto out;
 
 	/* Copy the data */
 	skb_put_data(skb, frame_data, frame_data_len);
@@ -6166,10 +6171,17 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 			goto out;
 	}
 
+	/*
+	 * Serialise against mac80211_hwsim_stop() - mac80211 doesn't allow
+	 * frames reported while the HW is down, hence the ->started check
+	 * must be under mutex.
+	 */
+	mutex_lock(&data2->mutex);
+
 	/* check if radio is configured properly */
 
 	if ((data2->idle && !data2->tmp_chan) || !data2->started)
-		goto out;
+		goto out_unlock;
 
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
@@ -6185,22 +6197,18 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		iter_data.channel = ieee80211_get_channel(data2->hw->wiphy,
 							  rx_status.freq);
 		if (!iter_data.channel)
-			goto out;
+			goto out_unlock;
 		rx_status.band = iter_data.channel->band;
 
-		mutex_lock(&data2->mutex);
 		if (!hwsim_chans_compat(iter_data.channel, channel)) {
 			ieee80211_iterate_active_interfaces_atomic(
 				data2->hw, IEEE80211_IFACE_ITER_NORMAL,
 				mac80211_hwsim_tx_iter, &iter_data);
-			if (!iter_data.receive) {
-				mutex_unlock(&data2->mutex);
-				goto out;
-			}
+			if (!iter_data.receive)
+				goto out_unlock;
 		}
-		mutex_unlock(&data2->mutex);
 	} else if (!channel) {
-		goto out;
+		goto out_unlock;
 	} else {
 		rx_status.freq = channel->center_freq;
 		rx_status.band = channel->band;
@@ -6208,7 +6216,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
-		goto out;
+		goto out_unlock;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (void *)skb->data;
@@ -6218,10 +6226,11 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		rx_status.boottime_ns = ktime_get_boottime_ns();
 
 	mac80211_hwsim_rx(data2, &rx_status, skb);
+	mutex_unlock(&data2->mutex);
 
 	return 0;
-err:
-	pr_debug("mac80211_hwsim: error occurred in %s\n", __func__);
+out_unlock:
+	mutex_unlock(&data2->mutex);
 out:
 	dev_kfree_skb(skb);
 	return -EINVAL;
-- 
2.53.0



