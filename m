Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622049;
	b=H7BSm1tJL6K4MgQYGimw4KIZPkPPngzS5aEUN6oDn6YT0X18ewiAbfpruVqf8TP8OQ5G
	 UGm638+83KUh5JJdzDBmZJYy8d/30VztaboOW+blmXIW3rL9Hn3a5KTHaGfU8JEc9ybEl
	 kNC6wwqa7Xwo0SdFB78i1s8/pz9wf/B8RgeO25P/cdccbXFTmjDQlFVHPlpU42Q8RCgRt
	 uLJgzg0BdgeKzXDDqORJO8wjfBy5fj+O4diDKV1NrRBrEo3VkYvyXPhEBdxOypis7HU4d
	 2f7K9Y9VzAVm4GVrojkkBuWuo0uL/T7xio9wGWUvg3tJ4HajkGSCH4o7nWNE6uDHZBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EDSqrPJxY3Drt3ckHmvHRvI40dAwnzADFMY/e3LpVkU=;
	b=xeha0W0DbV8qtZbzMXYEt1XSSyy36XVbcFW0OMejG3IcsyMA9lNAHJ0qhkMjvALdQlBy
	 YChTk2lpGelRdcTZjbh9XgTjpFNYZy853JhfKOsfOcqMqlVk2ZS2zE/XL1Ob02DECl5OC
	 F42z6qjeEwsll4wuOzTDlQFsHtngbSbpVRmB4CpUdqIpWJGzd2ItNTH3gYgI9WpQpqWfC
	 5I4Aj2DBu2PRran31BkGe6JTNMWTYrBGs79sf/yeq0Qym/YZ8PNVubAdTgSYMfQykNdCH
	 5K5CPW9e2mRNTYb2abWpyP7Fm/IW3wOGc5bskfSNn7WZKyL6A1uihfvck6yybTjg2CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ABNJf+W6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777A0606A321;
	Wed, 25 Nov 2026 15:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ABNJf+W6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560571F000C6;
	Wed, 25 Nov 2026 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622048;
	bh=EDSqrPJxY3Drt3ckHmvHRvI40dAwnzADFMY/e3LpVkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABNJf+W6kSo76+x/a5z2078HIzAlF88LZreJAzAmESlTTb3XiLqAqKqu7iwreQBDY
	 605ZMSm/dgpcxNU0JMxchW/M1JfVWg+0iYe+TpCxs/Sd5NWMUw0IZtIxIGgTrv60y3
	 qzJPHHqGbAH/andXO/DvPzFymIWTzLRqIDWpZPtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 415/990] wifi: mac80211: mesh: dont linearize SKBs unnecessarily
Date: Wed, 25 Nov 2026 15:29:42 +0100
Message-ID: <20261125143831.820853760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6a6db144d96352967623f38692dfc4b4fb814518 ]

If mesh fast-xmit cannot be used due to aggregation not
being fully set up yet, there's no need to linearize the
SKB. Avoid that, which addresses a stale pointer issue
in the caller.

Change-Id: I6b93e6c7587faf8749f8366ed574ee2b79fd47a5
Fixes: 8b0f5cb6bc7c ("wifi: mac80211: use mesh header cache to speed up mesh forwarding")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1f1b1e4f0df70..04dafe115d2c2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2818,9 +2818,6 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return false;
 
-	if (skb_linearize(skb))
-		return false;
-
 	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
 	if (tid_tx) {
@@ -2831,6 +2828,10 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 			tid_tx->last_tx = jiffies;
 	}
 
+	/* this function must not fail after this */
+	if (skb_linearize(skb))
+		return false;
+
 	ieee80211_aggr_check(sdata, sta, skb);
 
 	if (ieee80211_get_8023_tunnel_proto(skb->data + hdrlen,
-- 
2.53.0



