Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E24A1990C7;
	Tue, 13 Oct 2026 11:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892732; cv=none; b=gSidwDE4M1Srjbv4l6bHk/eY1EZ6DEM/sKOxM2Wmhil1cF8yhkAYeQOFnnLyDAC31ZKm64p3GS93qwG4fOGuKgH+H68IW9aToH4Z47Iiw81sgAW+ndaz7ciEfZQfdtit7UZfd39U0yVIcoHWdw+xK8Sgx9sJeX3Atqs4Z7VbuRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892732; c=relaxed/simple;
	bh=Rl2OSeLruhwgp6eGfdadXYSGq7mH7gHiUa7JayoGHfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alzSB8mHRg9+i2RfZwzQLPOAqEKixOEo0Bn5Pb9nqFxdca0mkJIOWvw/sXuXZeJArTBK6dMYqTuP1zkUDUBvPf6bacde3Clkc908uRWPakM93J3SdNths4fWi/v/vJFGnI6GmbOycTwFq0MqjgCwIi9A69r2t4O1kOdTYEEsziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBvNXUI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBvNXUI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865A01F00893;
	Tue, 13 Oct 2026 11:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892731;
	bh=aT65lpGi7v172J0uazbmbeLBVjE9Yo6AnAaD2WABtjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBvNXUI3qdj2F72Oed98b1qJJbwbXAjZj3dvdignk+P2dRrn8NEj9+QVHrk5luF0Z
	 esaHj9koEkKGlNwl//Xm06Gk2TQcdTEWK21p0W8Yga9Kbuu+dzOSg3P3CE1F6CTtXW
	 mOPvjMKIjCnobOZac9fYYxSJ6+hLqQnvLoutAVIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 264/281] bareudp: set the inner protocol to the protocol of the packet
Date: Tue, 13 Oct 2026 13:39:40 +0200
Message-ID: <20261013112901.546421774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit c57b2e60d4bf29707c51b39ed3bacbcce2f3ba2e ]

bareudp_xmit_skb() sets the inner protocol of the skb to the configured
ethertype, and bareudp6_xmit_skb() does not set it at all. The inner
protocol is used by skb_udp_tunnel_segment() to segment the inner packet
when GSO has to be done in software, for instance when the lower device
does not offload the checksum.

With multiproto, an IPv4 device also carries IPv6, so the IPv6 header
is parsed as an IPv4 one. With IPv6 underlay, the inner protocol is
whatever the skb had before. In both cases segmentation fails and the
packets are dropped. With veth tx checksum offload disabled, iperf3 TCP
over bareudp gets about 10 Mbit/s with thousands of retransmits instead
of about 700 Mbit/s for IPv6 over IPv4 and for both families over IPv6,
while IPv4 over IPv4 works.

At this point skb->protocol is the protocol of the inner packet, which
bareudp_xmit() has already checked against the configuration, so use it
on both paths.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261002153039.462663-1-yanhaishuang@cmss.chinamobile.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 5ef841c855269..2bfad8653be6a 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -355,7 +355,7 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (err)
 		goto free_dst;
 
-	skb_set_inner_protocol(skb, bareudp->ethertype);
+	skb_set_inner_protocol(skb, skb->protocol);
 	udp_tunnel_xmit_skb(rt, sk, skb, saddr, info->key.u.ipv4.dst,
 			    tos, ttl, df, sport, bareudp->port,
 			    !net_eq(bareudp->net, dev_net(bareudp->dev)),
@@ -423,6 +423,7 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (err)
 		goto free_dst;
 
+	skb_set_inner_protocol(skb, skb->protocol);
 	daddr = info->key.u.ipv6.dst;
 	udp_tunnel6_xmit_skb(dst, sk, skb, dev,
 			     &saddr, &daddr, prio, ttl,
-- 
2.53.0



