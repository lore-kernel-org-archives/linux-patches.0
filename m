Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033359;
	b=YeYYHrvkG4snN/2kCX2uL1/wPgUE5ax/Fl1mk29nHrDz9+Pj46g9Z2z67W4pB9+xXvXa
	 nB+AuwgrJa0YX2o4ybj1XLRIPSwZQsZOgq7yp65/79GHf8jGSh5t/mwVgskAChtqDZwKv
	 QZ9PogJaqzp0BLNn0XN7aOqEhildG0vYCwNBaT1VftjmAMPe+e3Ez1sFlud3tH3xugBSs
	 1A9loMLxfC7eZOvj4beVxnHOPsqWJpAuoGxnd3WuHVqayDeRFU6igl/PTIHKm1dftHLsa
	 gshurqu4Hw0+jMc8dqiQ3w5mcMmcoQ7EvPxFVymPEE185rFZtXvT98kMJofHzKwtqRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3lLX90ip/LKTQMaKOiK/FtrXp1vtfW5f5hV28XaN8fo=;
	b=j7uOmQNhQtu4TOWl32b0rQ83uaVCcduQu50IKn5QQlub7CweXJtcJniprAr5yNnrnHHf
	 esdGmmCO//wI9m5zTrD9PYTP9BV8uzQDKcKzzxgOcVpqe/X69+d8zZJznzZqHga2r0BZp
	 Deb7wxQoIHthKncYhLfnC4JF9LMrbZmfnYYtMI2KHuktcBU6KxoAIFTLUJJzgXE4IBxjm
	 ToCLjcBrEGHfR6za7kup3qaD78C9UrrvHADtGGkNBVa/vdipMKD7hHkJPwYEeTDW4zTwK
	 XYW8RededF3otp5CsWgx1B2AuYU51GKhyaan4tyaJBlpaacv5P/Lp4gdSWIxiqADqmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZVhkSfX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698E606A31C;
	Wed, 18 Nov 2026 20:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pZVhkSfX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F151F000C4;
	Wed, 18 Nov 2026 20:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033359;
	bh=3lLX90ip/LKTQMaKOiK/FtrXp1vtfW5f5hV28XaN8fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZVhkSfXiTRU/REKI14ITy85scOz0SdxEY1cQbVqO9KEnpO7M0cynwZaFCA3CDkKE
	 pjfdxaXG/250hhqqPWgeIZx2I/tmGX2QZhkhmscdo/IgrUgSzbVG32MRZ3g0QQUzX3
	 MMrl16Z4zp5VpfpUapFAh0ebW9s+cveHdssGApI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1698/1756] gro: do not GRO GSO packets with inconsistent payload
Date: Wed, 18 Nov 2026 16:03:45 +0100
Message-ID: <20261118150117.254991177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit de788d8a7032475f900c16e9cc0c1417f4f719eb ]

tcp_gro_receive() excludes empty non-GSO packets with the unsigned
len - 1 check, but its GSO branch only checks that gso_size matches
the held packet's MSS. A trusted TCP GSO skb can reach GRO again with
no payload after TC pedit increases its TCP data offset.

If the skb is fully linear, skb_gro_receive() then enters its fragment
transfer path with nr_frags == 0. The do-while loop copies skb_frag_t
entries backwards beyond both fragment arrays. An unprivileged process
using its own user and network namespaces can trigger a KASAN
slab-out-of-bounds write and panic through veth, pedit and GRE.

More generally, the payload of such a packet can be shrunk to any
value, making it inconsistent with its gso_segs, and a GSO packet
with gso_segs == 0 contributes no segment to the GRO packet.

Do not aggregate GSO packets with gso_segs == 0, and require the
payload of GSO packets to be consistent with gso_segs and gso_size,
the last segment being allowed to be short. This rejects the empty
skb before either TCP merge helper, and covers both IPv4 and IPv6.

Fixes: 5eddb24901ee ("gro: add support of (hw)gro packets to gro stack")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: check payload against gso_segs, refuse gso_segs == 0]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261028171350.2205175-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c         |  5 +++--
 net/ipv4/tcp_offload.c | 12 +++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index 74b1ed66693f4..6a730b4593e1c 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -516,9 +516,10 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	NAPI_GRO_CB(skb)->count = 1;
 	if (unlikely(skb_is_gso(skb))) {
 		NAPI_GRO_CB(skb)->count = skb_shinfo(skb)->gso_segs;
-		/* Only support TCP and non DODGY users. */
+		/* Only support TCP and non DODGY users, with a sane gso_segs. */
 		if (!skb_is_gso_tcp(skb) ||
-		    (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY))
+		    (skb_shinfo(skb)->gso_type & SKB_GSO_DODGY) ||
+		    !NAPI_GRO_CB(skb)->count)
 			NAPI_GRO_CB(skb)->flush = 1;
 	}
 
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 17f28f0ba9300..fbdeca5a0822a 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -339,14 +339,20 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb,
 
 	mss = skb_shinfo(p)->gso_size;
 
-	/* If skb is a GRO packet, make sure its gso_size matches prior packet mss.
+	/* If skb is a GRO packet, make sure its gso_size matches prior packet
+	 * mss, and that its payload is consistent with its gso_segs
+	 * (the last segment can be short).
 	 * If it is a single frame, do not aggregate it if its length
 	 * is bigger than our mss.
 	 */
-	if (unlikely(skb_is_gso(skb)))
+	if (unlikely(skb_is_gso(skb))) {
+		unsigned int segs = NAPI_GRO_CB(skb)->count;
+
 		flush |= (mss != skb_shinfo(skb)->gso_size);
-	else
+		flush |= len <= (segs - 1) * mss || len > segs * mss;
+	} else {
 		flush |= (len - 1) >= mss;
+	}
 
 	flush |= (ntohl(th2->seq) + skb_gro_len(p)) ^ ntohl(th->seq);
 	flush |= skb_cmp_decrypted(p, skb);
-- 
2.53.0



