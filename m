Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207844;
	b=FuKHSGEh49USOM6QuC+lYk/P63zpUdf9XdQJBE6Tl7jR9osDRAs27SytiUcVWhGZLPhq
	 bZvnb7AH/jU8Ot34mKKtMa6BGkqu1EKMA/cf9WYQJ03MGp0XtQRdCR2AV2ec+SDN0kmiI
	 4o5QZxdfInrnWK5XvMrfaxTsJrlMc4y7yxIc33UrjesGnVspijMYPBKTYl3FDR/fl54cM
	 ssG9Hg9dBCwX05RLFQVk/CPksPIYWxBE9a90lm6vlgdCPpg814VrXqwAblThLVx8GzVjM
	 n7ev9kE6mOXmaHXYRPiNp8qQpq4kI0Kjw5z3UKjnXY1qj8Fy88JBwRE60xCSF0+KTJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7+xx2aVAzffyM3Jy7FfKWBNKjLK59XyZBOuKHFSMswQ=;
	b=bGKQU9SUKvv2Om6M2IZCaKO7ieAAbgJkbMD5CgTdf6Pt4wndDskKr49znMzywNOmH/Rz
	 /dLeDWn/Q3Pw6eYU8vT7HA1gBlxyfcagG+AygIvhlvFPPcwt1yxIrCuh3vGTEtpRn84Ao
	 kgYUSz3aNzolYgTMgYljN5CTDvEC8yO3pts6+kmRRA8vjm0YSvJ3qZBPXnqCjenv5q2xJ
	 6oa2iRD0TEf2KjviOoN4m7r9l98/5KrikhbUK2YarbRTA04CsuRzBfhTT48a96ym1fJPj
	 BxyHcPjSX+7kx6sBHaTFinhtIuNFIrmgglj+CPWh4RIh932E5okU0/FL4MUfW4RbcAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Izr9saVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D2606A31C;
	Wed, 28 Oct 2026 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Izr9saVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A61C1F01825;
	Wed, 28 Oct 2026 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207843;
	bh=7+xx2aVAzffyM3Jy7FfKWBNKjLK59XyZBOuKHFSMswQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Izr9saVGn+CBjfEefzE/zlcB5DS4zuqH5DHE3ainHrSiVpyKKW2TRdascu1ykUNnT
	 LVpuwDLa2NxMoYEYY2b4mO+hElQzjYwd8BKrlwRZCWo/fRiJFoStXTcPZ5zSF1QERw
	 RFJW6XpAeRChOa7+B3MHOKhWTwRziEgOxoQnKP9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/247] netrom: require full NET/ROM headers in nr_route_frame()
Date: Wed, 28 Oct 2026 17:59:21 +0100
Message-ID: <20261028165951.155061960@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

nr_route_frame() only checked that an incoming frame was long enough
for the two network layer addresses and the time-to-live byte, and did
so against skb->len without making sure the bytes were in the linear
part of the skb.

A valid NET/ROM network frame always carries the 5-byte transport
header as well, so anything shorter than NR_NETWORK_LEN +
NR_TRANSPORT_LEN (20 bytes) is malformed, whether it is for this node
or in transit. Use pskb_may_pull() for that length, as suggested in
review, so the header fields are also guaranteed to be linear before
they are read here or later in nr_rx_frame().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[F6BVP: taken from the nr_route.c part of Greg's "netrom: do some
basic forms of validation on incoming frames"; the nr_rx_frame() part
is handled separately. Switched from a skb->len test to
pskb_may_pull() following Simon Horman's review.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit dc06212ff6bb781fad2b5082e3ecb7cc93336da0)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 9cc29ae85b06f..7f55030e4b166 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -755,10 +755,11 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	struct sk_buff *nskb, *oskb;
 
 	/*
-	 * Reject malformed packets early. Check that it contains at least 2
-	 * addresses and 1 byte more for Time-To-Live
+	 * Reject malformed packets early. Check that it contains at least
+	 * the network and transport headers (20 bytes), and that they are
+	 * in the linear part of the skb.
 	 */
-	if (skb->len < 2 * sizeof(ax25_address) + 1)
+	if (!pskb_may_pull(skb, NR_NETWORK_LEN + NR_TRANSPORT_LEN))
 		return 0;
 
 	nr_src  = (ax25_address *)(skb->data + 0);
-- 
2.53.0



