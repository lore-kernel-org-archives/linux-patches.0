Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDD51C07FF;
	Tue, 15 Oct 2024 13:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997758; cv=none; b=bHrjR8dbG9wzbW2RSlEBXc5l1AabEuHoHPeksH1cWIwGaJym3hrC5+twBL7nN7sixpr+j0N0UFrXeBNkCg3FJZBGA8F8OiUfjEKPD+ds0d2V+3NA1Hd45VVpnguCG+3RM8cG0SonWEh4Al4Rt1+BIoEZx4UV45UQ24W1x2ZgRtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997758; c=relaxed/simple;
	bh=Z0IESDpHrXpYPyFuh9ZvlHNv8maYG8quZInSdqAHiYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZQytekv4iKHPvzu48wTkcLdepGGB/4si51d4l2ATRlxccwelrwVMeJBPVNIAPDPTJP59zkDMLoDZL86MQyBOS0mRlIKYUVnv1hiopjA4LdrVWAmT4OEYQpwsv9E+x1DSD6DnnKMKrkn7OQehDfFXk/D27QUwoU7iIZ1KBjcjgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO8WgKBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO8WgKBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71524C4CEC6;
	Tue, 15 Oct 2024 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997757;
	bh=Z0IESDpHrXpYPyFuh9ZvlHNv8maYG8quZInSdqAHiYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO8WgKBsrbkCokj/WXqC7lD4AfhQPHVaf5aUnCCyWUiodhcyHwj3/P/uUisoDwnnn
	 1449GmxZUn6nRou3UmeM2cRp/bMtDe7bOW1dsJIjKqDq95jkTmdjc/VA9Tc/K8xP6W
	 Bm6oyT+5lLP5hIdNXGKjCYP/SEJRG8IepNjmGaPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/518] net: add more sanity checks to qdisc_pkt_len_init()
Date: Tue, 15 Oct 2024 14:43:02 +0200
Message-ID: <20241015123927.722407031@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0da9ca0a42305..5edab9328d5e0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3767,10 +3767,14 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
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



