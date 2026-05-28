Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936F433F5B4;
	Thu, 28 May 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998150; cv=none; b=hHSRIlw71tZKTkYnsz8Dvto14+zd3YPOzzCurj5izvwcaaXVzTN+FqP5bkfs8OnnDDsj/7f1DeQZp5Vj1tqvI03axoRdyl7sNO5HmH5IB1mVKA2zwSZFMB6HI8KpBVvvB0tuNe5/St2x3NBnA+Oz6lmBMgc8vSlotomPx7FGYOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998150; c=relaxed/simple;
	bh=Cbm3I8KvxEN7BCkN4x1HeGVBdLC9uXaE2yl6vz4L/II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9y4zX6aJX7s2HcWyKtcxYfYqoHjSiU3Yw9lr4gVl85meDH3gplbAFi+ozYThZMoHRQWy2BxJvQkEwzNm1lsdhCWIpZVR/yyu6Klaz4DoOo4Zd+heA9PMNdVYCFhd1J+mYOcgINftHfU/fX+MrQ3I3naS6IxWPFw2/a1q/f6pYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou0atcL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou0atcL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F281D1F000E9;
	Thu, 28 May 2026 19:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998149;
	bh=3lAy0neJGuWxMiknJX3L5O/dZ3xcHpqlXa8jrj/scEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ou0atcL4mkRiFphPSFCwZ1UTjfb+5bBoHrZu4VClg+Rx4S0I/NJ3lIbZZzC0YgTOF
	 bwoNmdFvyZEtfAfcuyPzx+rQyNbyPqu2HwHAetknSzGWTujGY9rOFhxcWJ0ypJeC7L
	 KkKOAawbk38bezFb+3ZGjf9Q2qN64/nxa9H8B4hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 070/461] wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb
Date: Thu, 28 May 2026 21:43:19 +0200
Message-ID: <20260528194648.950451495@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit d71c841be5d9e586ee7f36c0dc8ed4db0d9a1349 upstream.

ieee80211_invoke_fast_rx() reads RX status through
IEEE80211_SKB_RXCB(skb), which aliases the same skb->cb storage
that ieee80211_rx_mesh_data() reuses as IEEE80211_TX_INFO.  In the
unicast forward path, mesh_data does:

	info = IEEE80211_SKB_CB(fwd_skb);
	memset(info, 0, sizeof(*info));

on the same skb the caller still names via rx->skb, then either
queues the skb for TX (success) or kfree_skb()'s it (no-route)
before returning RX_QUEUED.  The caller's RX_QUEUED arm then
calls sta_stats_encode_rate(status) on memory that is either
zeroed (success path) or freed (no-route path).  The latter is
KASAN slab-use-after-free in ieee80211_prepare_and_rx_handle.

Fix by encoding the rate from status before invoking
ieee80211_rx_mesh_data(), so the RX_QUEUED arm consumes a value
captured while status was still backed by valid memory.

Fixes: 3468e1e0c639 ("wifi: mac80211: add mesh fast-rx support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260509043427.60322-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4941,6 +4941,7 @@ static bool ieee80211_invoke_fast_rx(str
 		u8 sa[ETH_ALEN];
 	} addrs __aligned(2);
 	struct ieee80211_sta_rx_stats *stats;
+	u32 encoded_rate;
 
 	/* for parallel-rx, we need to have DUP_VALIDATED, otherwise we write
 	 * to a common data structure; drivers can implement that per queue
@@ -5048,11 +5049,14 @@ static bool ieee80211_invoke_fast_rx(str
 	/* push the addresses in front */
 	memcpy(skb_push(skb, sizeof(addrs)), &addrs, sizeof(addrs));
 
+	/* capture before mesh forward may memset or free skb->cb */
+	encoded_rate = sta_stats_encode_rate(status);
+
 	res = ieee80211_rx_mesh_data(rx->sdata, rx->sta, rx->skb);
 	switch (res) {
 	case RX_QUEUED:
 		stats->last_rx = jiffies;
-		stats->last_rate = sta_stats_encode_rate(status);
+		stats->last_rate = encoded_rate;
 		return true;
 	case RX_CONTINUE:
 		break;


