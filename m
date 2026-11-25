Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624825;
	b=zGw3HIAeqLVV8So/m7UX8+tYcI59RoNMKDAG8b/+gDp1UAwgIFrA6yC7GQ7RlMJkYsDw
	 jPxSy0wB2gapERYUAK3nTtEXYU0wLOytyKOCHY+b2ZRjRwik/qDylerIyB93G0AsU5gx9
	 nDQB/p5pqqWWQ/8GVU++ghWyoarSMqLe+u66STD1rp0Q7UOveej+2FKfc76v/SUTg+/33
	 JeN/RHUdeKvnnOZ6yhf2nXdAinP0RAOy0zvPjiUdVGDpSf4YL0iUVEzXRHdK831lMRDKq
	 Wf1JQ+FfSB/GjCB6eU+8lDfEUAAOC1LbU84se/eUdvzK6SkAaGASJ8lhZnM9SFKrkAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l858Z1xkn9OAE5WQ7xECdfCap+Fe5gsWLhRzJSbaeWQ=;
	b=ME2D+2tBhFUAi+iX7smIts83gsdzloM6hTRSadNJA4Ew/vG87FIXyLcbBVd4kqz7bU0F
	 /lyB7QNtPxJvaeXfqWKdFyYmyjxGWQ6HVzBD64yHgAUu3D/bgsdeN+y1xQpoKF/oX65n2
	 J+XRIfO5r6STEQEJhq09JQr282MiQVYoWCeUiyUw3fvPbV6k0gvAtT73Bf116eRPTNq+/
	 DzcOtFewkoC+AKKdQS3jDKrkAm+RN2pbN6oVK2DQzYTWQfbEKFDY8GFJoeMMqqIMfWOCD
	 inKtNQKdfJWkPyuS6Ui/WJkPcttxcrtqCqXWMZYICXWlTl6i/KSOve66dVlGqiz80yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2EjVScgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F3D606A696;
	Wed, 25 Nov 2026 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2EjVScgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B451F000F2;
	Wed, 25 Nov 2026 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624825;
	bh=l858Z1xkn9OAE5WQ7xECdfCap+Fe5gsWLhRzJSbaeWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2EjVScgmvXOj67LInt+tmfYY6bfJG8AXhzmfq7t3I6qxywkgi0GwbnnNZ6sGWSvdr
	 BAAVs7bAmlPMKwHbtXs1OkUeAKV66giU08wNoTFCJt/+D2ejOstUU5ttlwL5rB3kas
	 PztlZpzPWwjluab+i+S0cjPmhLZey/jAfCSE860c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/816] wifi: mac80211: mesh: dont linearize SKBs unnecessarily
Date: Wed, 25 Nov 2026 15:31:05 +0100
Message-ID: <20261125143856.537393519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1af24cd4d88f4..415d16ed08084 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2795,9 +2795,6 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return false;
 
-	if (skb_linearize(skb))
-		return false;
-
 	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
 	if (tid_tx) {
@@ -2808,6 +2805,10 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
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



