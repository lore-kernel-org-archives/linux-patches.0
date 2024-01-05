Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB6F1E4A9;
	Fri,  5 Jan 2024 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dhi07Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F1FC433C7;
	Fri,  5 Jan 2024 14:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465762;
	bh=5m2z9CglCo7917h+9Gy6+MVvqf9oU2i4sYc+F7fRjLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dhi07Fh5Ysli4IH4IV9IM7jE1+4jeNG6cLXJN8q+hikK+B4m/hygevd9ybDBKHVe
	 /pV/TQbucnKEmJwBTS41A0Lh5aK7bSrhewMIFMnkdJiGNaAmrMfxp40eolDEaAJXZ4
	 BtiveSRBljX7ofZ/rpUlvGQt9S8wwKlZFpFWGcAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/47] net: check dev->gso_max_size in gso_features_check()
Date: Fri,  5 Jan 2024 15:39:05 +0100
Message-ID: <20240105143816.215833968@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9845dcf0a3ded..5e043e6f09476 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3140,6 +3140,9 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
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



