Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C1E52FE48;
	Wed, 23 Sep 2026 14:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173252; cv=none; b=s1j74n5brAZi4KTWDrn530LjZvJ0IRFlNKMAPuKNTltZ3uCSE4g8x4OItgUdAU6WAZ5DHrSVxyztuQgWCM9pafui4sSy4rDjZk/kV6y7jwquOk/spWUCRywgNU7LuYQD0o9mNjQD5e2/mJaWc1adzFPT+ozSwgiLvqlDv/3edXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173252; c=relaxed/simple;
	bh=us6Auv/6ts6IqJ5oeunK1/jj1sUuejQeoSCEwxQsMiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7yw2LsFc90dwwrdV7wCUwdG8nZkcyGbKD3KmxBD9EVGVbQ/xbmPpAh6iziW16G8nQARWOx9CJCbyImex+N5KeCwT7R0XEqdxrVw015EQE9/87ilZse8N9ZgsvFQIWsUCKML41IKZRoBTtv8aBN8psKrtvfH6InhixiNBtsuwAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTeejIc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTeejIc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494221F000FF;
	Wed, 23 Sep 2026 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173250;
	bh=lYxqyfO4ZHby8feiYFO5XjXsjVFWLP2DzpXLSTSJEMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTeejIc2SfwMRGrAsbbrFUuk+xZASb+WVx4u9ph42gMpZwWQnU3PAP8hWJ7MWyyi7
	 9Vyv+nZsIg+w56TJr7aaL3CB1YIkgRtUEfm/uPItVbtpF1N4417xvCaNG5XkdKNibY
	 6w0Ah9MKqmnxx7zjo89QfRvB5Rv3EfmqqBSjK5vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 154/438] seg6: set IPSKB_L3SLAVE from IP6SKB_L3SLAVE on IPIP decapsulation
Date: Wed, 23 Sep 2026 16:02:55 +0200
Message-ID: <20260923140648.761331883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 7b52122201858..d1070aec7b72b 100644
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



