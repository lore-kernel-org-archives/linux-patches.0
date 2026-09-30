Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A292D9484;
	Wed, 30 Sep 2026 16:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785785; cv=none; b=erv/AkJdTxZbDmbYIH39V2x695r8OFiajqk+MJNEg/10nz7FTLY3podxq+J0FcpVSrVVtGLPih9vcxa5SJTdpcp/4CcznRNGjjXzL2JH7v+5zQV5JXUa487M7EGz/TQAdl+vESkTwXmVWn+rGDMQ6ORahDX4HqPdNzSnVXk1l3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785785; c=relaxed/simple;
	bh=kfUIR4GUj8q/zCeBQTfgSbNxIoCg3a3kCl5mEjaEDpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTWu5wW6IGck9T5wECc39FFrMHEFUxiKQEAMoA6gL0xylsWVwag3Gi37w0GCU3OzRPu/75tPCAs+5FIyyZI7qKtaFmdfmnstg+o7HsDm8lH+yO/Uuwvn8oXTXxTjIBXJ4hneL+AZ+CWVo+h6xhUetbG3JgnfkGbxtRd0CYbCpDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgutJ0OS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgutJ0OS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F281F000FF;
	Wed, 30 Sep 2026 16:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785784;
	bh=1fSJjHZhLSMBVtwIFd9oozmSki1I0p4ocCZ+cOq0Wp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgutJ0OSvnVe7hn8hUb0a7H1W0ocoBkizPSL+ToJERGphEKIW21YS62CZbIfpV5rl
	 I5+OQoD/2mdR3xt4GbgnEGJddwa2so8iEfnrBVqhz07JOlH/DR+wGef6Nd96084Dvz
	 8TT5J+aXgp84yubWAljCIErIp3qIYin+R5IBOsRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b4aa2b672b18f1d4dc5f@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 629/982] wifi: mac80211_hwsim: dont hand frames to mac80211 while stopping
Date: Wed, 30 Sep 2026 17:22:45 +0200
Message-ID: <20260930152430.282317289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/mac80211_hwsim.c | 39 ++++++++++++++++-----------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e71e40376ba58..8ebc76cbb0d98 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1969,7 +1969,12 @@ static void mac80211_hwsim_stop(struct ieee80211_hw *hw)
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
@@ -4913,12 +4918,12 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
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
@@ -4943,10 +4948,17 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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
@@ -4962,22 +4974,18 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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
@@ -4985,7 +4993,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
-		goto out;
+		goto out_unlock;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (void *)skb->data;
@@ -4995,10 +5003,11 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
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



