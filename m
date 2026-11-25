Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624186;
	b=tSv/w6AO1Bzr/8t8VetVvScTO3+qm/NGnqAMtqbABrtxmm5f5K1PcWaexRDpUI83a8yS
	 u+4wz6y6j51u69pYVVrY8Fym5E1YOiItHt0kUBoekoELItOA5EfWJcroEgV0lcZGSbcDt
	 zySmL8pwfNViK+fp/MVzZeCAy3k6ocfmiBI/9p23sKqoSC5yj2DbwojnjOJLeIn5hOYsp
	 4614Qv67viIeThWvTEuPDo+x8Nr/Ga6FAyedyNFl8oYuLRwhApE8c3b/7JA8nh386JRpN
	 ejKE/PeNZtCnt0ItghqK5l05T3FnnqTQppm7YOx8Rk43nKpdHdbLKq1WCu9zgk4LNAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3lI7rur9PHXGZIZcLwzu0+mtf6S3ODuplvSEUItfI4=;
	b=bRjox/j2zg1GEKQDZ0/bayRQzTiuHvNzj5Y1jYo7AeDIBaL0qy1tqyUrh41WI3GQiF9H
	 4u+fGJUStU0Wvy1g+p4dm/JneAB9dAblJ1qVYlKm+VIWJpK+UUXVs0P7213sNx2WjFubr
	 MSTO5dL9yoDUeBAgnWy74oTiV1zZKIyVrd00fVQ/gAif5R0mDIcuEUCmnSM1x8DtX/XSb
	 rsp1G+hRhcGy/PzX7HSMOm5ZLhwdiDmewudmYw6x9hQn3LB79HH7hZOaO5MBi5ImYNLWe
	 EE893lrxorEmE1e2LmViAUiOFZtKyEvRUQ/9M3eEBQElHwtPsTF2CrIDjKQTR2NkzNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZI59Q5v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5F8606A688;
	Wed, 25 Nov 2026 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tZI59Q5v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B381F000D1;
	Wed, 25 Nov 2026 16:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624185;
	bh=W3lI7rur9PHXGZIZcLwzu0+mtf6S3ODuplvSEUItfI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZI59Q5voacfgiRRMfMGoZcrp5TWG9xIQT18MzNcC6iQWZzPSsZPRZvfPPkhUXu0V
	 8cZ9rqwuvMK8vHQabs0c9qRaDPo4mL97iLpJKqLn9vyj3C4A00N36a3SM/+pMcG3ox
	 FeWF2nt8NgMEaTVps5WSfEeKWPI7mUa6DBNGywr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/816] bpf: Check the offset in bpf_skb_generic_{push,pop}()
Date: Wed, 25 Nov 2026 15:27:39 +0100
Message-ID: <20261125143851.781442514@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit ee36c9aa44ef300cd651074bd97552b229337f85 ]

To make room for len bytes at offset off, bpf_skb_generic_push() moves the
first off bytes and clears len bytes after them. It assumes that the first
off bytes are in the linear part. But in bpf_skb_adjust_room() off can be
the end of the IP header, and this header can be in a frag. Then the
function reads and writes after skb->tail, and can damage skb_shared_info.

bpf_skb_generic_pop() checks off + len, but this u32 sum can wrap to a
small value. bpf_skb_adjust_room() and bpf_skb_change_proto() calculate off
from skb_mac_header_len(). This length is a very large u32 when
network_header < mac_header. Then the check can pass, and memmove() reads
and writes far outside the skb.

Return -ENOMEM from both functions, like the present check, when
off > skb->len. Thus the sum cannot wrap. In bpf_skb_generic_push() also
pull the first off bytes into the linear part. Now bpf_skb_adjust_room()
fails when a prog grows an skb that ends before off. network_header stays
wrong.

Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-28-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 359180c91d034..044595be4217a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3320,6 +3320,10 @@ static void bpf_skb_change_protocol(struct sk_buff *skb, u16 proto)
 
 static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
+	/* The bytes in front of @off are moved with skb->data. */
+	if (unlikely(off > skb->len || !pskb_may_pull(skb, off)))
+		return -ENOMEM;
+
 	/* Caller already did skb_cow() with meta_len+len as headroom,
 	 * so no need to do it here.
 	 */
@@ -3340,9 +3344,10 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	void *old_data;
 
 	/* skb_ensure_writable() is not needed here, as we're
-	 * already working on an uncloned skb.
+	 * already working on an uncloned skb. The first test
+	 * keeps off + len from wrapping.
 	 */
-	if (unlikely(!pskb_may_pull(skb, off + len)))
+	if (unlikely(off > skb->len || !pskb_may_pull(skb, off + len)))
 		return -ENOMEM;
 
 	old_data = skb->data;
-- 
2.53.0



