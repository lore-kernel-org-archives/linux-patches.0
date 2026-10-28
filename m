Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211735;
	b=HwEsLUXhF0SMSxr38O8MHmy+tBRA/v5AXYLuhwXHH4gtyib2J8jrNlmo3/5xcgPJfAv9
	 gf5F+RXPDR0r52wsI03bYfDI5IaSTFveH3UbQShzRdn/0TDfhGOH7rOtuHdamZA5l32nM
	 xHZAyLGXwPV3ib5oZ73cTsWokcTDao/D76ymJh2/iFE7Qzs0WQKeNUS82njIMkqPvo9hv
	 dRAR1JYwuR2msDTP608wQMQjUXF9zCnGguFjZbZzkD5VAkU4Pd9EG9sI0N3wnEF408RH8
	 RxypZ0hBrLqGAqqANRXZFakn95jw/QJEKG26+zxsUppjkmSNlbTJLRgNJOdvmfYZwVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ufEidXq+P0tHgqdAVdJXpwbWVknD6Mk0Pl5Tv/urcXQ=;
	b=ey/QX/aEd6U5pb7BLgyGA5COJBOqWXnmJoNb49uqGHmux+Pu28jIt2lHSxGhUL2VKZqq
	 LpLmZXM4whT+SxVTmgZ7+wuQRauZgTxiDdvBvP+zMg9nUuoAl3WJ2bdaivb/8wTyHCg8/
	 76Ycz4IchFVwM27s0aEnCuPS4QQcNe0vPSML3l5rQR4Mv289kBgC7yU8RS8TUiqezCq0G
	 6DVZBCyuXVlP6Yd6yK370FgUAmXyaumX74U7wJvpIPPHrDOO59ISTusM2cq0/esaEgX3D
	 yYVZiaWNU6mCC+YkKCgG0Y2iFiGwmcpS3lJbxw67ZTwGJt5a/JGnR9su9UkJ0xCRvmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaYbAAij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EDF606A31C;
	Wed, 28 Oct 2026 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zaYbAAij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED381F01825;
	Wed, 28 Oct 2026 18:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211735;
	bh=ufEidXq+P0tHgqdAVdJXpwbWVknD6Mk0Pl5Tv/urcXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zaYbAAij49/jDxohWsiefpOizOviZbHGJbIMkSoHscunupGM30Fhb5p4z0pcGzrm6
	 3hwAcFAGsiv0IDf1nWvVaI/PbMCINyaFQQu3YWLkxRW5FTQAlQ/JDdt02tE783kc9O
	 WW65OY0Cp8Ov6HHDOHH2fXGUMAOpSwDYZ4nUWJ54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 482/571] netlink: reset skb headers before unicast and multicast filtering
Date: Wed, 28 Oct 2026 18:00:29 +0100
Message-ID: <20261028170019.461166889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ec133e744af0..63065d2449509 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1339,6 +1339,8 @@ int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
 	if (netlink_is_kernel(sk))
 		return netlink_unicast_kernel(sk, skb, ssk);
 
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 	if (sk_filter(sk, skb)) {
 		err = skb->len;
 		kfree_skb(skb);
@@ -1475,6 +1477,8 @@ static void do_one_broadcast(struct sock *sk,
 		goto out;
 	}
 
+	skb_reset_network_header(p->skb2);
+	skb_reset_mac_header(p->skb2);
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
-- 
2.53.0



