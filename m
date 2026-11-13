Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585440;
	b=F0Mk+mnddtIxRZxoSdm2Z8/meKqNlCbfqIBwBfdvQFkJFykrKmL1YiBb+cP4z7YFTR8I
	 uI6mhpDzlvLN3f2XaUh9lXxpp550Jtbq5Lm+Cc67rHy9Gz9f8hVq/oBSQGaAOwyHOT1gS
	 Z4JuhloTqS9mDtRMUIqiC639xh/WO3upUrpodkb/VMI/aagGOdL/vHK6r7AWpuxP7xzGr
	 c0Y9+SnFWD77Ip3cDtiN92sMcGKIYmcTqKeW6SIMJ3vD9Rmivz+XZ+6c4Og1vX9AfqYa7
	 b5IYw4bCvE9CVLlbrajv1TyK/QDvGNBPD6n5sQdxABj9eVPTp3+4mZIr7YVN3B/h9VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9KEeycpz/oETN2uImZNkubW9NDf4nM7WPa1l7c5UfqA=;
	b=M7GRVLVh7FK8Mepks4FCir0HtHDbMs6/y9qPwAw+r20ASahiVbhlARVSJQyC7rVyKfee
	 h3AzTN+Ost/RqJ6aOdIHk7l3OCjYetDPBxrzN7PEMMBIXxVBneKvkgF0UKxZKgYeVZxaW
	 vWNXtJgM0pSclqMtecLxS3ABsFDkcDJM0CWhhIzBkwTpa+sZEArSg17ZJ8YjdpR6jAKIp
	 7FwQ9UI/6KB9P5t2xeIvMwFLb2eA0hrSchtn7qVz4iB9VN7wXyrbM9jaHVmZvQ42kUQiF
	 uccepkWSR+KmzvOGc/y0SDzLvzCT0yfg/Sce/LMCr/RZ/8dPXBiTF1Fv7beISxn33+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8ygHxXu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC9660A5BD5;
	Fri, 13 Nov 2026 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p8ygHxXu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B22F1F000C4;
	Fri, 13 Nov 2026 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585440;
	bh=9KEeycpz/oETN2uImZNkubW9NDf4nM7WPa1l7c5UfqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p8ygHxXuZvp8gF1FbBGSi8gSWbBqZQX15aQBeb8HAe64/TaQRJBhcoHlDDEH80C7L
	 D5RQjm1dl762dE1cdvJt5IJSjPaR1ia5WErH5lLwifysOD6ns9HJzoY6k0ilhzgo1d
	 OxuBzP2b5SYQBK0Eky4uyvDEqIQA8c6hkWaDJOuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 058/507] xfrm: interface: validate the IP header on xmit
Date: Fri, 13 Nov 2026 10:46:02 -0500
Message-ID: <20261113153755.532295401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit 86de3a1118a16dbbbe5fabe9aa20ffb93c072ed5 ]

Packets injected into an xfrm interface (e.g. AF_PACKET on an xfrmi
device) reach the xfrm output path without IP header validation, but
xfrm4_transport_output() uses iph->ihl for __skb_pull() and memmove()
and expects the header to be valid.

vti_tunnel_xmit() already calls pskb_inet_may_pull() before handing
packets to the xfrm output path.  Do the same in xfrmi_xmit() and
perform the header checks ip_rcv_core()/ip6_rcv_core() do on entry
to the IP stack: reject wrong IP versions and malformed IPv4 header
lengths.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_interface_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
index 688306bf62c5a..9835fbe63ccb8 100644
--- a/net/xfrm/xfrm_interface_core.c
+++ b/net/xfrm/xfrm_interface_core.c
@@ -531,8 +531,13 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	memset(&fl, 0, sizeof(fl));
 
+	if (!pskb_inet_may_pull(skb))
+		goto tx_err;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IPV6):
+		if (ipv6_hdr(skb)->version != 6)
+			goto tx_err;
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 		xfrm_decode_session(dev_net(dev), skb, &fl, AF_INET6);
 		if (!dst) {
@@ -548,6 +553,9 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 		break;
 	case htons(ETH_P_IP):
+		if (ip_hdr(skb)->version != 4 || ip_hdr(skb)->ihl < 5 ||
+		    !pskb_network_may_pull(skb, ip_hdr(skb)->ihl * 4))
+			goto tx_err;
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		xfrm_decode_session(dev_net(dev), skb, &fl, AF_INET);
 		if (!dst) {
-- 
2.53.0



