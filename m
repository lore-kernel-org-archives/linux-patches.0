Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938761D7999;
	Mon,  6 Jan 2025 15:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177416; cv=none; b=oET2mKipPmphQX1CLTj/iUZVQMK1UxLuwhXiS1bcOLHGfDxoCAK4cWQBJpivsLFAPWRo6ZyGO4uyinWi4qcZKZkWk/PUDah8SZfnK0H9bPGBDR/GgVx2FTPGvC63+aajVbO+nZGwpSK0f/qraeeRUthX/QpvjKUMerNpYpTWjoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177416; c=relaxed/simple;
	bh=szinAZZOiE2PaMoHcWidOhmYIWOJx15C7Tsgd9lPFXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEp5Y+4CHP9lcAVF7ox0dBPaXuld9zTx2FEpYApcuufatqIIb+cNTlrHk+mT4Jner00ObaME2h61LqPt56SIpvEAc09PuTHrZ+9yllQJ/5t4ym0CHcUBNgf8pwMW5GbGUPKli+j6WoJBpkKIT1eoeBDpy446GFA5OaFbeL9rly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfQS2nx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfQS2nx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C814CC4CED2;
	Mon,  6 Jan 2025 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177415;
	bh=szinAZZOiE2PaMoHcWidOhmYIWOJx15C7Tsgd9lPFXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfQS2nx1rmStMPsE0CQSKxYhzYjpUvK7Vn87UaeKqDWvhiScW14nIblgjOPy0/31n
	 qmDXeIyIGjXpA59NC2qQOHxADiC+2EZXmPqIKiJHk8nqPxWxNo4lomYWkKEqmDYPtD
	 EsHF06WWbwl0zk8YbKtUI5b6GDMBu2RVsdpE9Vv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/222] ipv4: ip_tunnel: Unmask upper DSCP bits in ip_md_tunnel_xmit()
Date: Mon,  6 Jan 2025 16:15:59 +0100
Message-ID: <20250106151156.632104207@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit c34cfe72bb260fc49660d9e6a9ba95ba01669ae2 ]

Unmask the upper DSCP bits when initializing an IPv4 flow key via
ip_tunnel_init_flow() before passing it to ip_route_output_key() so that
in the future we could perform the FIB lookup according to the full DSCP
value.

Note that the 'tos' variable includes the full DS field. Either the one
specified via the tunnel key or the one inherited from the inner packet.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b5a7b661a073 ("net: Fix netns for ip_tunnel_init_flow()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 571cf7c2fa28..b5437755365c 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -43,6 +43,7 @@
 #include <net/rtnetlink.h>
 #include <net/udp.h>
 #include <net/dst_metadata.h>
+#include <net/inet_dscp.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6.h>
@@ -609,9 +610,9 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			tos = ipv6_get_dsfield((const struct ipv6hdr *)inner_iph);
 	}
 	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
-			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
-			    dev_net(dev), 0, skb->mark, skb_get_hash(skb),
-			    key->flow_flags);
+			    tunnel_id_to_key32(key->tun_id),
+			    tos & INET_DSCP_MASK, dev_net(dev), 0, skb->mark,
+			    skb_get_hash(skb), key->flow_flags);
 
 	if (!tunnel_hlen)
 		tunnel_hlen = ip_encap_hlen(&tun_info->encap);
-- 
2.39.5



