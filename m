Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517062E415;
	Fri,  5 Jan 2024 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBS1OaOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66629C433C7;
	Fri,  5 Jan 2024 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465648;
	bh=ZT4WoTSgzAc85oJj4o+mbbEXAuUNzRfx7UpYsVOfquI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBS1OaOWftinSbw58FKrZc9zahvTz6oeIE7+UQgyB4Z4gGxSchKGq9fdOwlLkDTXr
	 vUH52JvtLJpWP1TfAW0kAv8dzgXk5tmOgd3KDjTZ6Q9fcR3PQTYab7KDACvkS2CKGI
	 0e5mm8izRghHa4bS2V6MadfmqIpVkZYcldLsThxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/41] net: check dev->gso_max_size in gso_features_check()
Date: Fri,  5 Jan 2024 15:38:58 +0100
Message-ID: <20240105143814.757494921@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143813.957669139@linuxfoundation.org>
References: <20240105143813.957669139@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 24ab059d2ebd62fdccc43794796f6ffbabe49ebc ]

Some drivers might misbehave if TSO packets get too big.

GVE for instance uses a 16bit field in its TX descriptor,
and will do bad things if a packet is bigger than 2^16 bytes.

Linux TCP stack honors dev->gso_max_size, but there are
other ways for too big packets to reach an ndo_start_xmit()
handler : virtio_net, af_packet, GRO...

Add a generic check in gso_features_check() and fallback
to GSO when needed.

gso_max_size was added in the blamed commit.

Fixes: 82cc1a7a5687 ("[NET]: Add per-connection option to set max TSO frame size")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20231219125331.4127498-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index ea05db68aa95a..b5c9648c2192f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3200,6 +3200,9 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	if (gso_segs > dev->gso_max_segs)
 		return features & ~NETIF_F_GSO_MASK;
 
+	if (unlikely(skb->len >= READ_ONCE(dev->gso_max_size)))
+		return features & ~NETIF_F_GSO_MASK;
+
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
 		return features & ~NETIF_F_GSO_MASK;
-- 
2.43.0



