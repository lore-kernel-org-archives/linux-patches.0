Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6451DE2AD;
	Tue,  8 Oct 2024 12:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391312; cv=none; b=DVjyyZ6ZP0N1oIzh/6EYKYx2vzmgvMfFIilaAwRbSOz/2qtG5n9Gcbh1wMlL9Iv3e4HpJUnAElLHryAm6mSYyalfhR4Jt7Df1Vs7ORJSP+TmWfxMruUdj3e2QL6Edf0a7HMCMJ2pOVxEpHvJf62k8mFo6YhYe5CaN9UcwCSYV+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391312; c=relaxed/simple;
	bh=tLbLdLlQs3mxeLWV5vx9ulzMIeebtqQcn1ZLegHVMIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr1mDIPsPmxypQL3N9qIbXK4PGaxYTR8LGVK1K2C3dcRwYVP9BVX28nj1AcwBjvK0whGSgKgtK8H5eNX/YHtAUNzoWXqWG4a9LkR+6Egv5M+Hq2AWbxeWRr6DRd6EajnnBynf70Q4CNCWStrMCrhhcPTQWSNMLBpSCC4nIf7eMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACSBGyyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACSBGyyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46A5C4CEC7;
	Tue,  8 Oct 2024 12:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391312;
	bh=tLbLdLlQs3mxeLWV5vx9ulzMIeebtqQcn1ZLegHVMIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACSBGyyL8hpCd6yTiGWChWsz92hLbvueoEWBG10XfZS4xMbQoT7gQihZU4xyJWGNC
	 W4T65wvVmB4NtM+3yBlYuRG+44oHrpbD8bRZp6/zRWN4zXggYEOa8She5n0p3Y07wh
	 mYIRpwpY6Fu3R/8gP1Kb1l07mmCgrThpQFbMEze8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 043/558] net: add more sanity checks to qdisc_pkt_len_init()
Date: Tue,  8 Oct 2024 14:01:13 +0200
Message-ID: <20241008115703.920734555@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 7f2355574ceca..dd87f5fb2f3a7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3758,10 +3758,14 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
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



