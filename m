Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620763;
	b=35+BDTj1DHJhgh50R1QhhZzTOIaXsWjQ4Ay9v9gaQse19dryoORJTNkHx7gJPTZ2vi4+
	 m7gDuFhhYwQxd9ZpTfsb1GSWunwtnXEKZc/pm8Qgi4on/2Ct0NeyBbyZlgDV+50DtrYW0
	 zwOIswM1nZnIdRLiUJ9+IOab9peXI3EEuwVKUzw118DZwdqq8nxzH3mc6gyxq3ObTnFoZ
	 NGuNfoAQCUCNamT1QeNxOkfXtvkKP/RPGOjaKCJIGRGC1FcXBsxKqDUJPOU4t9ka/uzGB
	 1lS6/95mawJjXPB6Y6Q87bNrL4MuUvfX2I8J/YQDlMTzyAqglfS4bG1qtMN8r5v6P6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K7f1ES2Q32YWoLItzoaNYHO6kz/Gn0TVqiyeh9i3/IE=;
	b=WwDZqpnBIR6ota8JCRaCVCun3kkgAB5fW0b5onCTVvR4lRAEO6C+i3Qxivg3yxwCTT1+
	 11YFJinz7KvwQdTqtZReapFxtgbziaSG7JFoF2Cm4HlIx+FmJBTcE0Su3IaNMAk3/m4/k
	 C0XAS7V2IyJ5zfADdNsxPUZ/txzaTMSqV1iBv6J1uOtmKShBr286DbAL+ef86zEGuEgq0
	 /rUVpnznM40+Eoj7lL+J/JbH4sSG3Rd4/9xxXOr452aiipKjQBGHILgUZYEmsneQL4ksX
	 El79QJ1oLe6GQnr1H73FCxxv/4latGl2vZSmwMB+fgu/UmSUuLMVTOjoCjby6sn9s+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJUlEEPr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82740606A327;
	Wed, 25 Nov 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HJUlEEPr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862AC1F000D1;
	Wed, 25 Nov 2026 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620763;
	bh=K7f1ES2Q32YWoLItzoaNYHO6kz/Gn0TVqiyeh9i3/IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJUlEEPrgL4WFPPQYb1mh4WuEqRAG7/rrO7DH4cOVdS4wD0FpQQ7f2LUq/ZesfHtB
	 Xb6sCsdoo6V+7W+qLPr1KSoQKDGhDo45M1vU/e7R38gukjSevLjJJec0Jx0bcMiIPA
	 BWBkY4/cZYAPBqWv1lyH/tJ/Bvxemht120dp7PvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/990] tun: clear stale skb->protocol of NAPI frags skbs
Date: Wed, 25 Nov 2026 15:22:54 +0100
Message-ID: <20261125143822.256490359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 3287cd714a853d9443c4a743eca010aedcfbbcdd ]

With IFF_NAPI_FRAGS, tun_napi_alloc_frags() gets its skb from
napi_get_frags(). If GRO merged the previous frame with
GRO_MERGED_FREE, that skb was recycled by napi_reuse_skb(), which does
not reset skb->protocol set by napi_frags_skb() for the previous frame.

tun_get_user() calls tun_vnet_hdr_tnl_to_skb() before eth_type_trans(),
so the virtio header checks see the protocol of the previous frame:
GSO packets without VIRTIO_NET_HDR_F_NEEDS_CSUM are dissected with the
wrong protocol. A following change checks the outer protocol of UDP
tunnel GSO packets, which would then reject a valid frame when the two
ethertypes differ.

This needs GRO to hold packets across writes, and IFF_NAPI_FRAGS needs
CAP_NET_ADMIN.

Clear skb->protocol in tun_napi_alloc_frags(), like skbs allocated
by tun_alloc_skb() or build_skb(). eth_type_trans() sets it later.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179386753589.488856.11455181721004759454@kernel.org/
Suggested-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261110213628.3476051-3-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7ddb91ede4dad..20fbd2d60191b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1419,6 +1419,12 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
+	/* An skb recycled by napi_reuse_skb() keeps the protocol of a
+	 * previous frame. eth_type_trans() sets it after the virtio
+	 * header checks, which must not see a stale one.
+	 */
+	skb->protocol = 0;
+
 	linear = iov_iter_single_seg_count(it);
 	err = __skb_grow(skb, linear);
 	if (err)
-- 
2.53.0



