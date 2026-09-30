Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF63D51CF51;
	Wed, 30 Sep 2026 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788378; cv=none; b=AmZKG8/UeWcyDK6tW3cKVx3lLh7nHnZJwunhZ7Wjif1QOdFdGZkxqXBqDSIkp6b2XxSzF5ePdT7Oqm4rdB3Z8NXHzBT81OJR0gi7ufkRwsZbnRzi9Bd3BLAuNsxycfrF+kCremsGGtm7lnMJBilQ9CsYbKHFwd0+dUmfUWlIJ78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788378; c=relaxed/simple;
	bh=tP8V6gXisHvMpRANAbnS8qv0SrobiXTc5t1ejWt0J0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCoKkOZ7/w2k/gzyK9NHVDZtXaLOGJzHg2o/TtFwxPRaufhW/rs/GIumiC1WJ0UyfIXq5IO4Nt45aEnDM0/1ba/lh/KdrFyR2cffuzzqpfI51fCzAS04Wtap0QHbSVIC50urj6YYN/9myJ86fChb3P2hY6wJV0gS1qh+9K1V5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZbGxJsN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZbGxJsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253421F000FF;
	Wed, 30 Sep 2026 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788376;
	bh=bT5adhr1QFSi0VEVDwYSNsHpIjIOhy8MSq87b8W6J9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZbGxJsN6azCTzKAkvO+8t4eam9n5ldqoy1VP4kwa53bFEV8Os7Kb2hlh7ZJCjqk1
	 PmE1ZY/LHADjg4MtNkggitBeGILG/2NipdQiLSeXSGoj9NiJB2Mz88wyJd7EvFHA8t
	 ZIQNZM6mEyplQGw05qKg3ZYwkmLwh7ibH+j/p6RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/877] wifi: mac80211_hwsim: dont hand frames to mac80211 while stopping
Date: Wed, 30 Sep 2026 17:16:17 +0200
Message-ID: <20260930152416.164175011@linuxfoundation.org>
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
index 9410059e97f01..f1b96cd1198c5 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -2120,7 +2120,12 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw, bool suspend)
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
@@ -5851,12 +5856,12 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
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
@@ -5881,10 +5886,17 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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
@@ -5900,22 +5912,18 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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
@@ -5923,7 +5931,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
-		goto out;
+		goto out_unlock;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (void *)skb->data;
@@ -5933,10 +5941,11 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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



