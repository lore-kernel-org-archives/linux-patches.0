Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805AF1DDC24;
	Tue,  8 Oct 2024 12:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389598; cv=none; b=SLYSNLXLiZWe18l8qPOpR0pqn1WE2vklQP1rGoKki00Nj7Z9Ej9Tqd1q6ucwqB+N4ITfzlClgXw9P/6xOf12HcVaVtzd0fvR8x7bsG1VsoYa5XAYO5LeKPyk2zGQ/NVeQz9fj3dgPOG2y6ZudU3umJZ1iNrQet7LKH3GIkdQ8Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389598; c=relaxed/simple;
	bh=q+FKGaJpwQYNEbOzJXha4VcsqNUWEMLaOwtiG1oK0Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuEQtsYJaz2kSkZB8aF9fY1nWDxtaJVn40cpYnxhltXsgAllvpfZIrSTqjG3uWyM/1IzE/p5zadUkM46AOcjMYpzDc1CAUEhoNtSal9Ou+M+OjIDg/7IO51EHkmH5Zb4AUo662pWLZ6aTBjvsxVzgLybPdoEWNCwv9ZoTsu0S4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkNWNLZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkNWNLZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC768C4CECC;
	Tue,  8 Oct 2024 12:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389598;
	bh=q+FKGaJpwQYNEbOzJXha4VcsqNUWEMLaOwtiG1oK0Wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkNWNLZQLl4KzCaI1ouIA6/rS2dFkK1wAojI/mt9ktQ5GxA1Vk+7Sxn8xPMHcqr9y
	 xROHSqb0MFTj7qENvn1ooteT8a0CvNJXygbEUhLIGMnfRyH2o/inN169J1Ab38iFOa
	 1iid617aSwoWslnbQuuQgo2BO7UsDnZy9t7+Q0L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 040/482] net: add more sanity checks to qdisc_pkt_len_init()
Date: Tue,  8 Oct 2024 14:01:43 +0200
Message-ID: <20241008115649.881695157@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ab9a9a9e9647392a19e7a885b08000e89c86b535 ]

One path takes care of SKB_GSO_DODGY, assuming
skb->len is bigger than hdr_len.

virtio_net_hdr_to_skb() does not fully dissect TCP headers,
it only make sure it is at least 20 bytes.

It is possible for an user to provide a malicious 'GSO' packet,
total length of 80 bytes.

- 20 bytes of IPv4 header
- 60 bytes TCP header
- a small gso_size like 8

virtio_net_hdr_to_skb() would declare this packet as a normal
GSO packet, because it would see 40 bytes of payload,
bigger than gso_size.

We need to make detect this case to not underflow
qdisc_skb_cb(skb)->pkt_len.

Fixes: 1def9238d4aa ("net_sched: more precise pkt_len computation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 62ec4bf8bcd88..d716a046eaf97 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3756,10 +3756,14 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
 				hdr_len += sizeof(struct udphdr);
 		}
 
-		if (shinfo->gso_type & SKB_GSO_DODGY)
-			gso_segs = DIV_ROUND_UP(skb->len - hdr_len,
-						shinfo->gso_size);
+		if (unlikely(shinfo->gso_type & SKB_GSO_DODGY)) {
+			int payload = skb->len - hdr_len;
 
+			/* Malicious packet. */
+			if (payload <= 0)
+				return;
+			gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
+		}
 		qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
 	}
 }
-- 
2.43.0



