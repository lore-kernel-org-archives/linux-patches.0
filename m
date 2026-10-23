Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774440;
	b=A9AnHJ51AMOLv2NxOyFHO2SayzjW2SQz5sUxhDW4LRvFN90YOJ/JZjUUMxKxgHDelkZM
	 yfXrtyp+/373/h/YN1Lb3iINOPzEZ+abRN81ovoU6gqmihdyIW35iGKV47LGLIYWK4oBK
	 fldmWL00OqgqnCwgTM/XXS7v2NCMclvxo3QIf5FRr0gzn8VWwfSQKA2vOHKEErwwkaBKA
	 MAlC2cOMIaNLJlPAlu8eJjLkvPV8AhmG41TgatISCul0Tu9vv3wa+lrN+dAo0cNaazSah
	 uKq8IEPyxocFoka2Aht9moDcsWbYdBaFIeHA8WglMm1wDDi3KVcJ50FyKSG14yVS63A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y0K5JnBd71RZsTVV1vFSrV5NiojZaBes79u+VOw7sY0=;
	b=eq4KEgN6h1CbHNQMpgM4RcYihL9xu8L/IGtQkbpMvPKEkmWfve33Sl2Xf+iB0q6Mubrf
	 cJ9mrWyf0ftASM7aX/qoZpJ5gZu7oDeE1yTnOxOaE8aIGgWWD0/4NoOYngamfYHfT+RHu
	 D1zhboCgK1rUyzDOthsP3R+N8k7Xo0+m2tLO6Ubrhk4KkUtvjQ2+Fw7OEPblAW3VIf9gg
	 j3T96WbIwdao0d5Qgx8dVGqI/+eMFQMtFa8zarlkHinIDHLzp8s49iApeDkvhN4epMUcV
	 QYX6ztpDqH09imKZTlbgS8d1N4zD1gzYii1V08Eayp0QA0PrGA8iX/P66nQofTH2M9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xqv6HGvE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C61606A31F;
	Fri, 23 Oct 2026 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xqv6HGvE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975481F01828;
	Fri, 23 Oct 2026 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774440;
	bh=Y0K5JnBd71RZsTVV1vFSrV5NiojZaBes79u+VOw7sY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xqv6HGvEpjKmu0wIpvdbgMtb9qTYrekttKCasyc1p8e8nnxuqHfYmMeaOUcESl7xx
	 uiCR7rsWoNAD5xb574aiSwsufPFe2vvXlwM5Ig9R5qXMPkl5mryif0zyJx+jmSnhjR
	 S/Kfg4EuNqbEZ1xdJX988IFXfn5+s2ssqJoHAyrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 040/242] netlink: reset skb headers before unicast and multicast filtering
Date: Fri, 23 Oct 2026 18:38:02 +0200
Message-ID: <20261023163714.726151415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7288de715341a..5324edb13760a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1363,6 +1363,8 @@ int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
 	if (netlink_is_kernel(sk))
 		return netlink_unicast_kernel(sk, skb, ssk);
 
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 	if (sk_filter(sk, skb)) {
 		err = skb->len;
 		kfree_skb(skb);
@@ -1497,6 +1499,8 @@ static void do_one_broadcast(struct sock *sk,
 		goto out;
 	}
 
+	skb_reset_network_header(p->skb2);
+	skb_reset_mac_header(p->skb2);
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
-- 
2.53.0



