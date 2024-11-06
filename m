Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4ED1DFE1E;
	Wed,  6 Nov 2024 13:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898423; cv=none; b=JBnauJPbX/Ctsvh1136mZjxeOKToKF+i37KncKcuZkApvt30orAvVHDHSHSjbhkRh5mwrbgmlTQ5ujsSKbhyFVRxHrqeftDJt1pmn9eck2PvLqSfUGYOWmFQLC9OlAF0VFe0c5sDDzof+pV6Slf03AzPv27pC0p5NwQkrIt/K50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898423; c=relaxed/simple;
	bh=OEC/1xf/50cr+WXvtVpX6TdZKrulgGxe4+TGaepuj5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az5Lj/xUmQy9pXtsBMyxAXkyR2fpNettCWF3ZqWJwLTREANAhdll+c3cdV0KhJOwBztdv+US2rCgJg9AGapQpZrESQzM29wRXvq26cX+f+UuzCvS8fMzMHjCHxj0liZoc6tcj/zM/qNPaZWhk0RUKb78E3eV9ivcZanoVw5w4ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtomloAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtomloAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16251C4CECD;
	Wed,  6 Nov 2024 13:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898423;
	bh=OEC/1xf/50cr+WXvtVpX6TdZKrulgGxe4+TGaepuj5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtomloAPCf+oVZ47L52m7cBXNaxZyYBi3dXqLfnhNJ/TT1JVjb5oHGOHhXa9nIVFp
	 lzr157i2jmvLknEeyEVjZpYYxixmtihWXBp6CnQFmxElggMB4rW/LBUdjBbICZqhk0
	 O5GmkW+Q2O5xTdXedhl6lhPGs/yvf5pkx+BR8WCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/462] net: add more sanity checks to qdisc_pkt_len_init()
Date: Wed,  6 Nov 2024 13:01:20 +0100
Message-ID: <20241106120336.133793273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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
index 5e75359acd0c5..8f2f14df3610b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3383,10 +3383,14 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
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



