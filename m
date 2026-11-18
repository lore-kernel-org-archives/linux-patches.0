Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056658;
	b=3FiarEQku24Pv4k30WA3VWnL7Xu61o292qgngtqJQ9vqg9psoy4XzPUgRU6vGqU0pLa3
	 EHmInfsmscd83/3C/mIT4d84ebf6YndRS9G+CByee8exsGFb2Gup3lzAYExgQ87Zqvg7j
	 gvIK3ZSbPQeIPxvdRxAqIrQtAb+RwOyFbC9jih2bwWoiSkTkkkzbvw0p+fAhhcYBDYQhI
	 lpX+3iygBvl6ntVqMwsTm+B3mzXEin0M4cN1H77238QMd18VHTgp53wOXJg1I/Upu0hmA
	 iC585Sl1913JjFir8daVNvFXiDRQcZpQwygkUfdTFv3tczexll+YMJ8UPOtlimkuAOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pYE1e7Hbflcpw2EP8JLwNvukDagrQ3wY8m4omh3LRYU=;
	b=vVvc1TP9dkkCu1XD/1pyo8/D6DdUTwYltAyjP9sRdpW8CIJ71G/dEStm/7uy2k9+6QAa
	 fAM9DsbBp2eb8YBFgPoXQYwxvXjvtso6xusSpMnYVoaRNXn/rNzbf330gZBlpKndJ7ZD8
	 KjZNZxABCkc8EO6Wycmd9AStWeQiioB4IBcriKWMv6rJb3GN3eY9MX6HPzY8a6aSMEXVB
	 h5o+PTSxz8xFqVmOG6YhPvGmxNvYNZK1216K96F9jTNfp/aPZgCSUJf9KOQyk5+eJMkXO
	 no/qoUN8aFCrBVwWfOxKOlLx43yZJW2PKMX4jIr+vJr2cgaHpBK6Bo/dmwGnkXJoAHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz2IvM82;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3776D606A320;
	Thu, 19 Nov 2026 02:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gz2IvM82
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0381F000C5;
	Thu, 19 Nov 2026 02:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056658;
	bh=pYE1e7Hbflcpw2EP8JLwNvukDagrQ3wY8m4omh3LRYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gz2IvM821C9T3deVV1/evzCFSfvO7/gjY5gJOw7uAxMV1zRFy5tbJRjGy6SDvwix4
	 CuVGPj/b8VG8gFFfy7TkM4K+z3IAFo+lxn1nrr43b6yG+YlPj/MuL70tl2q+UPLmet
	 U3VIAm9SWegPzVwh+DTbQ+Z3Ls/zQPjaGeHWQlWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2065/2214] net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
Date: Wed, 18 Nov 2026 16:02:21 +0100
Message-ID: <20261118150133.258042082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14c0350142ab0a10ebeefed03b779df23749e16a ]

An IPv4 later fragment carries no L4 header, but key extraction leaves
ip.proto set to the real protocol and the flow may wildcard the frag
field, so validate_set() accepts such packets. set_tcp() and set_udp()
then treat the first bytes of the fragment payload as an L4 header,
rewrite them as ports and patch the bytes at the checksum offset,
corrupting the packet.

Skip these actions for OVS_FRAG_TYPE_LATER. IPv6 later fragments are not
affected, since their ip.proto is NEXTHDR_FRAGMENT and validate_set()
rejects L4 set actions for them.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index aea8a4eb9cded..b7f2120cc45b6 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -617,6 +617,9 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct udphdr));
 	if (unlikely(err))
@@ -660,6 +663,9 @@ static int set_tcp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct tcphdr));
 	if (unlikely(err))
-- 
2.53.0



