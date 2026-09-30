Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE8865192;
	Wed, 30 Sep 2026 18:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791983; cv=none; b=S4kPgWWlsPVcsYexYLyfjHTPkQTmfGUIdFZMTEFnLZDXO2khRLSujJSBtMoVI5a2DZgnGPWolsyRcgvDqdFzWzFcT6jhORh5uYPCtPAoQxJxloa6x1ki/e09C7AWnN81Cjun49v8kzC+lWFAhvI4uIUVC2OQ0mD7KSR4iKbBuqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791983; c=relaxed/simple;
	bh=MkLTZSdzQb1GHDCeiPzJcbRXUfeQ0s8eaTtGWXrir8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhmiVjdNEAg/dUWpBOAww3der0I3IDeKkjvjivTCkaSVcU9J7Mcvu9YmAaVX9YEjC38blQybqP76v830VWY6qpYJ5EWp2WuiOSfv+OXilsy7oTaVGtn6XT8sUo+R4VOf+eL0kBIOxpuNw0pOHRB4crOGnPJjOkRfNxWjX8FfFOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOU5VLN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOU5VLN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779EB1F000FF;
	Wed, 30 Sep 2026 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791982;
	bh=rR66F3aVGRKpjtgaduyRwoLO3EvdR0Wni4fxOWqYJMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MOU5VLN8C1qOnjJGUb2rBQ28folgrJUCWXpO8cgiU2lVk2/8XzQTi8M9amOLnrt7I
	 afi85/14KSj2ykbNEykmrAB6MQh9VcX7UIMFD42aRUdwNQ3JJtXzkRWN28PG3jQC4Y
	 fhDRZDUOWIZLvnapL5jNRSvPKprhN8ryB8lgi3e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 493/752] seg6: set IPSKB_L3SLAVE from IP6SKB_L3SLAVE on IPIP decapsulation
Date: Wed, 30 Sep 2026 17:26:03 +0200
Message-ID: <20260930152408.934521511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3b74e3413e369..de26ab96b43d0 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -194,10 +194,13 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
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



