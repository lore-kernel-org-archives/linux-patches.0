Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D953C0601;
	Sat, 17 Oct 2026 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258952; cv=none; b=Cr14Mt/1Gtx/UppINMfWjfG2MnDcuBvQVOwDG2wA4DNClyLoJnCj8JJvC18cc1rbfjvg5JQ5B2nXpe7pNcmUAmR5JgqZsFacYAWlwpmD/MhiLSMvTBbmJkD4swmAlllbiVXN2nZyD2PxbICxspJT/Qi/kK4qjwZGFhBrJK0hIbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258952; c=relaxed/simple;
	bh=13FQUt9Nh2Yc1oFLfGtWa/W0XLYU1aEKVgJ02vB7CoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjMVT1fpmkVq+OHhN9dSqv/NaD+xKom3do2OqRjBzT7METfYS8wMIuzGBSwjDghXFkohK4lEh2Ke1nA4TniaUeN/YK8oc52Ls0e7xAcWaVvdJZyC+LEyjwlTXvp0de2dVzMEiDm6QwGqaC+ikSbFCQNvQ6ARybeV0GmRkjZVSbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXpj4Uti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXpj4Uti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351341F000C4;
	Sat, 17 Oct 2026 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258951;
	bh=v/Xz+Wx0KRMOI+xQ6j3v+I1PGYQ+AmEuWzJTlqvzOcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXpj4UtiAH47gW1vCURUB1mabLlCHDDzwDYLgJHFXuDZrXOQagA6Cr/e6mWpFTngP
	 C2VDcGG2yLh0W13nd2NoL0Nxtk/MrF4n4voVJ5Zkvi0VZakDv70YwNDhxQzgMCv+Gj
	 R7XVGvs9AMhGLpjPNnSzd2IJI7t+z4dv06O0m9O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1052/1674] wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb
Date: Sat, 17 Oct 2026 17:55:24 +0200
Message-ID: <20261017160458.132282694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit d71c841be5d9e586ee7f36c0dc8ed4db0d9a1349 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 52b2b2b097d56..378d58395532e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4835,6 +4835,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 		u8 sa[ETH_ALEN];
 	} addrs __aligned(2);
 	struct ieee80211_sta_rx_stats *stats;
+	u32 encoded_rate;
 
 	/* for parallel-rx, we need to have DUP_VALIDATED, otherwise we write
 	 * to a common data structure; drivers can implement that per queue
@@ -4942,11 +4943,14 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
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
-- 
2.53.0



