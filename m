Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1C14F3924;
	Wed, 30 Sep 2026 17:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788550; cv=none; b=FEi9JNyMPfjKvEb18US4g8QZAXA2wQhdzXPxYQ6YtCfPUxvGYGeImIo2fY899iOeQFzNYBkmxB8VtPCFBmlrehxR8Kr/LuUb64uaVeg4MShk/XXtsRzsMnyyE2wmGoI1zTyDNPfJpjGe7ILIEWpda5kaOqutewXFTVwV5Tkz2oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788550; c=relaxed/simple;
	bh=7V+QB2iiXkZ2NJUm9MKGC2YFfxy1wlrGPtc2X1phGaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBQop0KsbR5csYMTmEcpCwmYUbNNdONCnmmrYD5BeLqVdgi7JO9o5Uw+roBX1N459Rl/yVnTA07NKaeFL1OGdmHgtM0KsL4tW09wt9zwv9YwQ8/egxW85iU36YFtiCRXfc36gq/Ve6+UVUJVKQ5Wwb3gBQw5cjtOws7AiSLWbyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfn119gn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfn119gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C683F1F000FF;
	Wed, 30 Sep 2026 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788549;
	bh=z7GBC8rHLDHmCcxeOhS3Tvou0OCTHPpPXQdK0V3YE8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mfn119gn/Qt2MEgHIsoQY4PP4uCn81dKyUzv57eAkc/3PbZtHRxtcWvnSMdqL85wS
	 tR6IvpUmVomX+NPRFusw6a/0dMt0/OYnY5d6Em/eGc38j465TPBSaYwdlrdi03Wevm
	 oeMA6s1Rk0z35gO3PQuV3Hf6JmDbnBYvhPDrTmCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/877] seg6: set IPSKB_L3SLAVE from IP6SKB_L3SLAVE on IPIP decapsulation
Date: Wed, 30 Sep 2026 17:17:10 +0200
Message-ID: <20260930152417.305355704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit 7616242a2b37883f7322aaa1d2bd6cd0fed28315 ]

When an SRv6 packet arrives on an interface enslaved to a VRF,
vrf_ip6_rcv() sets IP6SKB_L3SLAVE in IP6CB, but decap_and_validate()
has never set IPSKB_L3SLAVE in IPCB. The bit stayed clear in the
common case, and with CONFIG_IPV6_MIP6 the leftover frag_max_size of
a reassembled outer packet could even set it, with no VRF involved.
Commit 44930446dde4 ("ipv6: seg6: clear IPv4 control block on IPIP
decapsulation") then made the unreliable bit reliably clear.

The effect of the missing flag is visible with End.DX4 when a
delivery to a local address of the node reaches the socket lookup.
For example, a UDP socket bound to the enslaved ingress interface
does not receive any of the decapsulated packets, while an unbound
socket outside the VRF does.
This contradicts Documentation/networking/vrf.rst: by default the
scope of an unbound UDP or TCP socket is limited to the default VRF.

Set IPSKB_L3SLAVE for IPv4 in decap_and_validate(), which already does
the same for IPv6. The socket lookup then matches the decapsulated
packet like any other packet received on that enslaved interface. Such
a packet matches an unbound UDP or TCP socket only when
udp_l3mdev_accept or tcp_l3mdev_accept is set.

Fixes: 891ef8dd2a8d ("ipv6: sr: implement additional seg6local actions")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260913194421.31-1-andrea.mayer@uniroma2.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_local.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 10f29bb8e608f..191b99b073b06 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -257,10 +257,13 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 		return false;
 
 	if (proto == IPPROTO_IPIP) {
+		bool l3slave = ipv6_l3mdev_skb(IP6CB(skb)->flags);
 		int iif = IP6CB(skb)->iif;
 
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		IPCB(skb)->iif = iif;
+		if (l3slave)
+			IPCB(skb)->flags |= IPSKB_L3SLAVE;
 	} else if (proto == IPPROTO_IPV6) {
 		bool l3slave = ipv6_l3mdev_skb(IP6CB(skb)->flags);
 		int iif = IP6CB(skb)->iif;
-- 
2.53.0



