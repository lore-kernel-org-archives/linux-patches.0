Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209945;
	b=Id5WaupDyF+rLCX5bEKupKRL1uXDIO4JjGKnkv3l9tfbq9WzCkvkImYwjfjv0Kb822C6
	 AovBNKrP3wvJfqTw1HtzVe2M7KcjcQ0F/+7dDrEAxB6oM98iLdTAht9LDQfLSYBnU3kos
	 WRLUkp6kxT7zDK+/bi8N9bTwBBvfZE+htyGUslmmAB9CK3xySQDetxycPKXC4ss5n1hVV
	 tIKOHGgUkfbhOR+CKlWLdnAUY3kmKvkMbvhgOHCrlF1OUq48OsK+cacpJf+uiWqyP/Xyb
	 1OZw/QOBRHy/LOm5G7W+1ap8ph0b7SvMTIPqBt0fcCZ7x9AzPGENFa+IZac29oNO66w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OWfmyFY3OZkTjzyzmGA7vjlHFKZsdNn2/I49eNZ7JhA=;
	b=Mi9K8MSrOG19Pjewmnn/WFkzc/NWw/k4z6fyZiJ86aIxTHLUkwty4ulBS17ppQFa5pSA
	 wph8CoTiW0KvRWaMgml1du4FPNM7HThD/Mky73inoxuPfBCy6ntm6zjJ9RNn8hjfa1MZ1
	 jHOINax/HVf7Ix4hMWOABoJXJLA1NNP2oHocE47SnsJUCm0+WcDP0EZbJ/oO+N7EkBwNb
	 GcS+eLuLPVfgLOzsgU/Erg9MNgmDe+OfZw20OmdceHf+AZ/mKkJexXjDQ2OCqfJGg6+xE
	 21wOTgfIdI1h9s5qcL/8EdCdeiKaMAi31kge/rzI4Pk5xhNHpa4oPGyX0EeC0oecwSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=icQ1pTlN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F83606A31C;
	Wed, 28 Oct 2026 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=icQ1pTlN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17E41F01825;
	Wed, 28 Oct 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209945;
	bh=OWfmyFY3OZkTjzyzmGA7vjlHFKZsdNn2/I49eNZ7JhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icQ1pTlN/Mj21TlAKl6ACjw+HJuJ3H+WWXKDigaDesESJHEAEA0BcKSggHWkAZmn8
	 sQoEKFoWtkkXZXhabs9soI1G/NmnAZ+29i+HdI/knygmYF/rJcsz5wlzcf1IsjDu+g
	 0kU2a+U81GhbIwbEi6nWWfjA9lAxK3ywKD7vaECo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/168] netlink: reset skb headers before unicast and multicast filtering
Date: Wed, 28 Oct 2026 17:59:18 +0100
Message-ID: <20261028165943.623422858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f3a8c8338d203..e539b0a632fad 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1345,6 +1345,8 @@ int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
 	if (netlink_is_kernel(sk))
 		return netlink_unicast_kernel(sk, skb, ssk);
 
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 	if (sk_filter(sk, skb)) {
 		err = skb->len;
 		kfree_skb(skb);
@@ -1479,6 +1481,8 @@ static void do_one_broadcast(struct sock *sk,
 		goto out;
 	}
 
+	skb_reset_network_header(p->skb2);
+	skb_reset_mac_header(p->skb2);
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
-- 
2.53.0



