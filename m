Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207628;
	b=qzfuu9JuG05pGOgpqCbYOw3m1caF5vuHpSOJFqiIt5sbN5hD6CONsviAjb0fQJIE0pnQ
	 Wyjetsn1OBF0QgOppoFxh0Y38J/QykhmGe3pJKyDBeoZSqyfgeMA6i2KimB7j9VOr8kh3
	 Y3VpivYWpvJ7p4CqqLoZ6E6w6m1AEZJnLgpvMFtQQWdJBxij1ALKA+kLPEgF0AUYihDN5
	 Ezaln2DIWPYhdVuhz8fOoDBJ+gry9irf0fs5L5UUdh08+CTpTSQ1h3DDBwRCmJi2DYytn
	 Rmhu+1kU71kq3dK9OEB5M6P+YeOkcTl8//qp8o1NblS8j4c6hzBogN4lojZqXvPYUgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NAbRhoIXbxlfldWULqnnaPRlaaX+D9j3kKhNuHthMdo=;
	b=ouCOsqCiBz29hsnVKmgMGQKhZhmaAYHC0QTcZA72JbpA37vk/KTlM9UUPu0j9slzYoNJ
	 kGGr2Do6iVywe3plFyPlxEUvlnH2PKC/KNh3WNk3DHKtgQmfbD6airEMDttk+TrLNpZ6p
	 Fqn7rl0+E0CDbz32O0bH8v2t3orBSG2uUV87483ov0gFU4t1MkRdw1eProOIpvCa2duO7
	 c/E9B2Tw+7Om94KcWSoXYbsxYsYMrh63tHjdHIAQqp0VHz2LdQZqlUlsFXLSyuOO60FrX
	 zJP2nrIWG29shygY5h4JeMjnaFXA5R41UpyllvC6OtEHIivmVUTCthyfPNJW4So62Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKJTnQo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F022A606A31D;
	Wed, 28 Oct 2026 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKJTnQo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365DA1F01825;
	Wed, 28 Oct 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207627;
	bh=NAbRhoIXbxlfldWULqnnaPRlaaX+D9j3kKhNuHthMdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKJTnQo51rdKrS1UHnSGe8HAksoYbXeMSvxFmYgB8/x3J1OMc1B2d9IRaXIpCzLHk
	 bSssjD67cClnr1hyjrPIhX8IYFz1jaiMlIVJMKOZ8osmSXL39iAWGaKSMIejrvImIU
	 nAcZC/g/QhtIcRbh9LsRVDjF0nvsTXOyGE6YkOQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/247] netlink: reset skb headers before unicast and multicast filtering
Date: Wed, 28 Oct 2026 17:57:23 +0100
Message-ID: <20261028165948.319069352@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 8bf659bd54e1f00e34cf5244b1d289c506fa47c0 ]

Socket filters can use SKF_NET_OFF and SKF_LL_OFF to read relative to
an skb's network and MAC headers. Netlink producers may reserve
headroom without resetting those headers, allowing a receiving socket's
filter to read data before the initialized message.

For example, IWPM HELLO replies are allocated with dev_alloc_skb(),
which reserves NET_SKB_PAD bytes. An unprivileged NETLINK_RDMA user can
attach a classic socket filter and disclose this headroom through the
length of the delivered reply. The resets in netlink_dump() do not help
because IWPM sends a separately allocated skb through netlink_unicast().

Reset both headers before running the receiver's filter in unicast and
broadcast delivery, as is already done for dump skbs. This also covers
other netlink producers that reserve headroom without changing their
allocation or message-building code.

Fixes: b1153f29ee07 ("netlink: make socket filters work on netlink")
Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261006224232.50724-1-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e250d4a3d0309..a0a8f185ccdeb 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1338,6 +1338,8 @@ int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
 	if (netlink_is_kernel(sk))
 		return netlink_unicast_kernel(sk, skb, ssk);
 
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 	if (sk_filter(sk, skb)) {
 		err = skb->len;
 		kfree_skb(skb);
@@ -1472,6 +1474,8 @@ static void do_one_broadcast(struct sock *sk,
 		goto out;
 	}
 
+	skb_reset_network_header(p->skb2);
+	skb_reset_mac_header(p->skb2);
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
-- 
2.53.0



