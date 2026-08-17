Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C9A4322E5;
	Mon, 17 Aug 2026 14:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978750; cv=none; b=oxm6rFq4ioJFPPUMu7+0YbDLD9csVrQ84ZEghOrZBI5wAiP5EQZZfKAMciMB0IZMxVznqcbbFpyVm8u1+jQ38qTMAOjNhE1KMz+YUYCLibH9omlPH4FkBaTHkFqtJaNfx7DMWuejSaRNMInkL/ZlC59mowZEfSoj5bv4a67swJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978750; c=relaxed/simple;
	bh=DJyxQkITpL/t/1+uIUbQtMPGTox25D2SuDoaKz71OlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+eQqYVfFj5Y6Ae1Y2/39RstqpS0BiaxjaAlrK4g7wMXSO4HoYZgf/9uebWNt1HjSs23vMqIYvySUitua1h8RnZnBOzMEXyh4U1e0cj3Q0etkyH39N+6IMl4U5JWTv6UC3li4GNFj0Qls9ownLwEieFvGM2boWBQw2CVe1+f9Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTOlNYvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTOlNYvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E8A1F000E9;
	Mon, 17 Aug 2026 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978748;
	bh=h/CSV+KCkZPpAA+W62GwzWFjGZ3zdzwNOkmEC5hZ4wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTOlNYvHnQ4H2q8kGi8p2uN+sZKxXWhcsYeFKEH9tLq7g3i77hBctenzP2A/bRc5r
	 /wTtaUe/bef2FnBiB/N+kWX8dc2i1IAjpu1JMySdJkg9OSyk1I1Q694yd7nDDFS84y
	 NP9zhOiJpja6HKIcvXZXcREkR/kdn49JC3doCPs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 144/156] ip6_tunnel: clear skb2->cb[] in ip6ip6_err()
Date: Mon, 17 Aug 2026 15:34:38 +0200
Message-ID: <20260817132540.357419583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit f803c086399da277b5d0ff36a107d0f162751800 upstream.

ip6ip6_err() clones an outer IPv6 ICMP error skb, pulls it to the
quoted inner IPv6 packet, and then passes the clone to icmpv6_send().
The clone still carries the outer packet's inet6_skb_parm in skb->cb.

If the outer packet had a Home Address Option, IP6CB(skb2)->dsthao
remains non-zero after skb_pull(). icmpv6_send() later calls
mip6_addr_swap(), which uses that stale dsthao offset against the quoted
inner packet. A malformed inner destination-options header can then make
the HAO lookup and address swap run past the end of the quoted packet
and corrupt skb_shared_info.

Clear skb2->cb[] before pulling the quoted inner IPv6 packet so the
reply path does not reuse metadata left by the outer IPv6 stack.

Fixes: e490d1d85cf5 ("[IPV6] IP6TUNNEL: Split out generic routine in ip6ip6_err().")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/fe1a5e765fbca88d69391887f0ed26a19e3e4d39.1785736562.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -675,6 +675,9 @@ ip6ip6_err(struct sk_buff *skb, struct i
 		if (!skb2)
 			return 0;
 
+		/* Remove debris left by outer IPv6 stack. */
+		memset(IP6CB(skb2), 0, sizeof(*IP6CB(skb2)));
+
 		skb_dst_drop(skb2);
 		skb_pull(skb2, offset);
 		skb_reset_network_header(skb2);


