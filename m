Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3554D4F4CE5;
	Tue, 13 Oct 2026 12:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893508; cv=none; b=VPBWprLtwq1isXsV9I7499z/Sti/xBh+pwHsOLQ0W/3oFFiFRTJO52Mw7RBWYUQa4KS6vdseMDLuK2xuGQ//JjaSgbS9Dg2EBuy2fAsGMPNEDq68dSIFjOeTT6DQB2EeeimotxMjCxRhOd2L1/Oh9uFgtIOh8OmqvOHQ4ETR4XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893508; c=relaxed/simple;
	bh=MBNfgG+hFruQnft26FbpQ/czBsL3IfJlYu9scSK0Bs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQFCb2bC5/BNvdGr3OZrqxd7U+j9f1GXvwaO1cxItQTtsyDIP6YzD0SQu3qD8KmH3/AmsKst8ztDeqWSOp1qt/OeKRCRIoNluTzvgtrYAuxtFBMrsywYur3pDGfHQOZYCLo+wvjVd0ZAo1xnyQABQsDgiKM47IfUJmauMOGyyUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pW4EhItg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pW4EhItg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAF41F000FF;
	Tue, 13 Oct 2026 12:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893507;
	bh=tWK6tzPmVwn7gCz4L7Rg5Tu0qb3Ud6Mj1VIklqOfr50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pW4EhItgntXiNYHsjP7z9u+9QzoswS7aevhFum+D+0rmF8GwITkaeuoB2wNjkucGA
	 +Dkzq4dSloPt5G3KzHlnnVxjgr/0DHptFXltZTj6vuFWVhO2FG9SquQpm7nJel62HQ
	 OwaUHT+go6zlpU9sf0VWETer/31oaQ0C/lhaN/XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 247/621] wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb
Date: Tue, 13 Oct 2026 13:34:02 +0200
Message-ID: <20261013112926.723939112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index dd47faeb6afad..f61ff900f863a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4847,6 +4847,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 		u8 sa[ETH_ALEN];
 	} addrs __aligned(2);
 	struct ieee80211_sta_rx_stats *stats;
+	u32 encoded_rate;
 
 	/* for parallel-rx, we need to have DUP_VALIDATED, otherwise we write
 	 * to a common data structure; drivers can implement that per queue
@@ -4954,11 +4955,14 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
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



