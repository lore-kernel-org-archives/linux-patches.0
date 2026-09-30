Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1B13C3F56;
	Wed, 30 Sep 2026 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795380; cv=none; b=llRKBt5Ak57XtfocSkyjlmOf8ytkS9p/PyxtoxWsACnoHBjWhKMwv9cmVl5Wp3AyLNqDRXc+kV8Yj+odM0+SRIE/Df9NefWkuxM2tZTjZICo/no0fBaRZhiXbgXMGkmoqe9AxFjpzT9gs6Ny7z8ecZ8GUbvBvQum3iRnL6OgV0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795380; c=relaxed/simple;
	bh=I9l/pkHdgUGyI0v6IFud5ukcGMrB0f8Y2Rgjz6YonqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbEJcVro0d5hq0aK2QWbUYKAqIcYK3iej/zUMNYG03Jry/JmDioE11GAz7NWzS5myoTzvVVTWLEWbcT18wfRqfcgd987igwuI0iSZ3jxlvTKaxgxHNRBR1mZZmplUWTJQke0KoOweiUuDEo2LFgf+oQ+LAH2Cuf3GnsUA2cz3J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt6hiyD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt6hiyD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0FF1F000FF;
	Wed, 30 Sep 2026 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795379;
	bh=cGNR4t/qDu5zmmOTVfRQ1jKG1TOin070Vnw0dBSW4AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dt6hiyD8F+vcWSQLARNJ6Ny8jwjpwwuPxnlPK82Vr9PUwCNmubgAgpiSsCOu65Jw6
	 hcNff9COaZc5V5zO86MCJgZATgxWiAK5V+PFlzXc+25d0bnom0Sg9ONg+LsVu+bjRe
	 7Z5b5P0KtzuUJ0hyIC1FoA/F4/q1M2ZRyyUrN3G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ce13c07d96d04716eaa2@syzkaller.appspotmail.com,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0541/1193] net: ipv6: Fix UDP length overflow with PMTU discover and big MTU
Date: Wed, 30 Sep 2026 17:20:25 +0200
Message-ID: <20260930152446.245277638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 0ae10b6be49b425827659b23bcce498f80eb7182 ]

This commit bounds cork->base.fragsize to IP6_MAX_MTU for UDP sockets to
avoid a possible overflow of UDP length that triggers a WARN in
udp_set_len_short when setsockopt IPV6_MTU_DISCOVER is set to
IPV6_PMTUDISC_DO or IPV6_PMTUDISC_PROBE, and a large packet is sent over
a netdev with an unusually large MTU.

Steps to reproduce (included in the new selftest):

1. Set device MTU bigger than IP6_MAX_MTU. cork->base.fragsize will be
   set to that MTU in ip6_setup_cork.
2. Set IPV6_MTU_DISCOVER to IPV6_PMTUDISC_PROBE or IPV6_PMTUDISC_DO. It
   lets maxnonfragsize be set to device MTU (cork->fragsize) in
   __ip6_append_data, rather than to IP6_MAX_MTU.
3. Send 65528 bytes of payload (+8 bytes of UDP header, +40 bytes of
   IPv6 header). Device MTU allows it (it's only one byte bigger than
   IP6_MAX_MTU, and the device MTU is bigger than that).
4. The UDP length in the built packet is 65536, which overflows the
   16-bit length field and triggers the WARN in udp_set_len_short.

To avoid breaking sending UDP jumbograms over raw IPv6 sockets, limit
the change to UDP sockets only.

The original overflow bug with IPv6 and IPV6_PMTUDISC_DO seems to
predate git history (verified reproduction on 2.6.21), was fixed later,
and then reappeared in commit 427faee167bc ("net: ipv6: introduce
ip6_dst_mtu_maybe_forward"), which is chosen as the Fixes tag here. The
overflow with IPV6_PMTUDISC_PROBE reproduces since its introduction in
commit 628a5c561890 ("[INET]: Add IP(V6)_PMTUDISC_RPOBE").

Fixes: 427faee167bc ("net: ipv6: introduce ip6_dst_mtu_maybe_forward")
Reported-by: syzbot+ce13c07d96d04716eaa2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a6a966c.86abc875.e5c3d.0054.GAE@google.com/
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260901195714.673548-3-alice.kernel@fastmail.im
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 320c964ce0fd4..056c95f8f6d3f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1406,6 +1406,8 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	if (frag_size && frag_size < mtu)
 		mtu = frag_size;
 
+	if (sk_is_udp(sk))
+		mtu = min(mtu, IP6_MAX_MTU);
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
-- 
2.53.0



