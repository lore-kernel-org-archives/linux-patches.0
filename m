Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050211;
	b=Bd4NCaHUGHK+dYtoh0rYvBfaw7FW098wIAkPloCqgZD8wfHkIXUbEsWfaSnXh/SfeFTv
	 IE6tEHfhKjy2AQqpOPRvb6OyXBwELpEMgGx9RFEwz0J8lSroiaj3bDhLdQTcieADlnHLr
	 /nbX/MDaCEp/nIsNqRAlE/K8oTzj3gmdJcharxfJ2oUFUm5S2DQSVuYsln/AHH7iLObKI
	 D8FKTPstP9Rc7iJfPuSGEOlbJp8mWVhFOEK6JQr3DDqXOdAVpT4LYMQYdwID6MzJP0kXO
	 FOiSHGx3pqAMxV65SVBssghL6I7C6vOKEdxd9Eof7h+LfLH3CSeXYSQPYBD19/q/+EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WqOnOY6Aym8bzCii57f5EiUx3LpFxcfIR9ex0Oya0fc=;
	b=LI7TS3AunydR4wMfbI5I1niKfbZ+0XMh7ALYnpmAlRVIltwEKs5yLNnEAfQEXiAmzhh6
	 hIt3XxKcogSw021M63oYP+1vCfJzIJmIBTmXjdTgGaORJFaXR0APNIvdN8Nkx2HtI0xd0
	 tv64NR0dfXtIQixoWxqunHfcDgzUAeqFNib6m6d5E0o/ORiWOGctbX6Zdkvy8AyYeTzvG
	 8K+o18gQA/ths0HIxuv/BA6e74SOkToFSHl+Q2By4O9SU2f7UQQV+n2nlVI+NP+tBVpkt
	 fIoMp3Jo34xvD6y+O6FUSNyvLLrZB6zZJ7td7L81ssJNLZ+xepzUCa442J+3Krk/Oww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CoYO2QK0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E76606A325;
	Thu, 19 Nov 2026 01:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CoYO2QK0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400021F000C5;
	Thu, 19 Nov 2026 01:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050210;
	bh=WqOnOY6Aym8bzCii57f5EiUx3LpFxcfIR9ex0Oya0fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CoYO2QK0JrxVMmT1pOtOqP8tI7uLsH8SUx3gj1PRsMLCpxPtl8tq0bL+j3AOQySyi
	 2PUQgyu4WYA9BOOf4PBb+4RORqlkwS7TiyAKfxsDY1sefEK3LF2U9Q83JEDd+npMqS
	 ny2Ejku11JtzhuU42nG4vIQBpr52wkPX5gd7w8JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2586/2857] bpf: Make bpf_skb_adjust_room metadata-safe
Date: Wed, 18 Nov 2026 16:00:20 +0100
Message-ID: <20261118150334.623528077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit be83105d38ab99737ac0488600efd59ddd57b74c ]

bpf_skb_adjust_room() may push or pull bytes from skb->data. In both cases,
skb metadata must be moved accordingly to stay accessible.

Replace existing memmove() calls, which only move payload, with a helper
that also handles metadata. Reserve enough space for metadata to fit after
skb_push.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251105-skb-meta-rx-path-v4-7-5ceb08a9b37b@cloudflare.com
Stable-dep-of: 12d07c38e1b0 ("bpf: Don't let bpf_skb_adjust_room() use up the MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index cce48847d931d..6c87f72d15b4d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3287,11 +3287,11 @@ static void bpf_skb_change_protocol(struct sk_buff *skb, u16 proto)
 
 static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
-	/* Caller already did skb_cow() with len as headroom,
+	/* Caller already did skb_cow() with meta_len+len as headroom,
 	 * so no need to do it here.
 	 */
 	skb_push(skb, len);
-	memmove(skb->data, skb->data + len, off);
+	skb_postpush_data_move(skb, len, off);
 	memset(skb->data + off, 0, len);
 
 	/* No skb_postpush_rcsum(skb, skb->data + off, len)
@@ -3315,7 +3315,7 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	old_data = skb->data;
 	__skb_pull(skb, len);
 	skb_postpull_rcsum(skb, old_data + off, len);
-	memmove(skb->data, old_data, off);
+	skb_postpull_data_move(skb, len, off);
 
 	return 0;
 }
@@ -3521,6 +3521,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 	u8 inner_mac_len = flags >> BPF_ADJ_ROOM_ENCAP_L2_SHIFT;
 	bool encap = flags & BPF_F_ADJ_ROOM_ENCAP_L3_MASK;
 	u16 mac_len = 0, inner_net = 0, inner_trans = 0;
+	const u8 meta_len = skb_metadata_len(skb);
 	unsigned int gso_type = SKB_GSO_DODGY;
 	int ret;
 
@@ -3531,7 +3532,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
-	ret = skb_cow_head(skb, len_diff);
+	ret = skb_cow_head(skb, meta_len + len_diff);
 	if (unlikely(ret < 0))
 		return ret;
 
-- 
2.53.0



