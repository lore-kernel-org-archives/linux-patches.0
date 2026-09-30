Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFA83D8908;
	Wed, 30 Sep 2026 19:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796078; cv=none; b=bH2eFkU5K/0f91Jc+yDf3DM2aHBoHa3EOSbVFLEQJwKjX5qp/Np3q2CVdeHxrFy01iSKkgNDeAqoxnZfsuW8zICuI9+t3EJDWFmFdjsiC97XSobRHzi75Xom0jdSMEM7xacE3vRpGikORX1Vn3HW5Rmy2nTyEit5dNOvBNDs+00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796078; c=relaxed/simple;
	bh=Exjo8nA3lIsEQ0AxpzH3/Y2rhO3hMUBqDQWvwREvB80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMGriMe8IBBujahEqoFrQZwahjGtH5Sj0u42CQx1bn69TruPTDa4kezKpoCZGjQMFBuBykWQa0ee437A2UElxLcE9UTZMrWEd0eOYYVw1oo5IXgsm5dNTzPRZ1t+13Bhnv/ywxFUQzeOmBiIF5NWpUWve0K5jxKf28d4250PXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MoBmQTpJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MoBmQTpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC001F000FF;
	Wed, 30 Sep 2026 19:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796077;
	bh=m07jX7cuOiur6io9iPyrM5ljhY/CeznkK0VfSp02WrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoBmQTpJf4qSRsVMZj0E3aKJSYo4ZFirXU9xfHHXH7Itb+fSVYwtknMcJJsOfAGy3
	 E4FFdjkxRI0+EHVgZoHm+0Um4aQ28CTRs4ggNGfVuOy88n/BNZi0zm2fDNVFI433KY
	 D2NgB79qEZXO+8qRv8CZSedi1yJ5RsH1DzHMNZGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0759/1193] wifi: mac80211_hwsim: dont hand frames to mac80211 while stopping
Date: Wed, 30 Sep 2026 17:24:03 +0200
Message-ID: <20260930152451.117762872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dd9e7ef2186d5..4703406944353 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -2087,7 +2087,12 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
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
@@ -5632,12 +5637,12 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
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
@@ -5662,10 +5667,17 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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
@@ -5681,22 +5693,18 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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
@@ -5704,7 +5712,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
-		goto out;
+		goto out_unlock;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (void *)skb->data;
@@ -5714,10 +5722,11 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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



