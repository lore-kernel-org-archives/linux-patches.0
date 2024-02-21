Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9F97FBBA;
	Wed, 21 Feb 2024 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524570; cv=none; b=KD4t66620j93F+J23PobbUrJeqV9QYDDtbIyY7p3zFiWuFsTW93Al/XhCIc53F+LJCCg6D+vuY875peVAtOygWWPYWJ6U5/KVxgJ3fXwpwByQ7Y7KmgI+x/Ql1msQQysQeYwP1wTYVJRLu/xagVxcwmJjP3nXz9hopbWtrKiO2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524570; c=relaxed/simple;
	bh=wSNl075VGAsP3TOjNmxTk/xPEqoX8MJ1qhkbXV2w244=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXut8hE7lwGihgXMNBcPbG8wxpfc7rgDPwdbcEZbO3hDXJwGQA/r6nLVrZsDM4z6jm9nYok5tOXBqIpDLcPRuqv+79DcHUhFsWcRJgW2D4s/lQMXQ37QeNJSEsaWKf6bD7QmYVAkmLFYQWOmoTliYobdfS9k8nwjH7cXOlbzCq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5e27Ruw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5e27Ruw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F37C433C7;
	Wed, 21 Feb 2024 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524569;
	bh=wSNl075VGAsP3TOjNmxTk/xPEqoX8MJ1qhkbXV2w244=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5e27RuwjaOaOOraG31zvFCJ3DpDNTNqFOrnwuH1HPnQgSwZFg6sDw/wpHsMFdu3A
	 I7Fa507LXhmFvVzvEP7qzlYM7V6HL9QE7/jfusVzvFy1TNAxHly90trUiQFPSyeZHW
	 M0dusivwU5ogSZMp0I68StOar5Xoms7w6RILq90E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/379] tunnels: fix out of bounds access when building IPv6 PMTU error
Date: Wed, 21 Feb 2024 14:07:15 +0100
Message-ID: <20240221130002.489998227@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit d75abeec401f8c86b470e7028a13fcdc87e5dd06 ]

If the ICMPv6 error is built from a non-linear skb we get the following
splat,

  BUG: KASAN: slab-out-of-bounds in do_csum+0x220/0x240
  Read of size 4 at addr ffff88811d402c80 by task netperf/820
  CPU: 0 PID: 820 Comm: netperf Not tainted 6.8.0-rc1+ #543
  ...
   kasan_report+0xd8/0x110
   do_csum+0x220/0x240
   csum_partial+0xc/0x20
   skb_tunnel_check_pmtu+0xeb9/0x3280
   vxlan_xmit_one+0x14c2/0x4080
   vxlan_xmit+0xf61/0x5c00
   dev_hard_start_xmit+0xfb/0x510
   __dev_queue_xmit+0x7cd/0x32a0
   br_dev_queue_push_xmit+0x39d/0x6a0

Use skb_checksum instead of csum_partial who cannot deal with non-linear
SKBs.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index da9a55c68e11..ba1388ba6c6e 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -332,7 +332,7 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 	};
 	skb_reset_network_header(skb);
 
-	csum = csum_partial(icmp6h, len, 0);
+	csum = skb_checksum(skb, skb_transport_offset(skb), len, 0);
 	icmp6h->icmp6_cksum = csum_ipv6_magic(&nip6h->saddr, &nip6h->daddr, len,
 					      IPPROTO_ICMPV6, csum);
 
-- 
2.43.0



