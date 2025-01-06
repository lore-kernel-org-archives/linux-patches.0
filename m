Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F39126C05;
	Mon,  6 Jan 2025 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176791; cv=none; b=LdV6SEw9T6Q7iOS1DQMPVRcbzpbO6a368whAcQm2mOkilhPnHOOJPlzXGN+NvqpDqP+vizfxOq5F9Krfb5Myb5cBjdWShpbpUDUhbCfa2W8fijBFB+6RG2rCplTJTOg/HxTu0hRb1Gp2wx17LOw00bBxS0DY9sHjP9EpHqThubo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176791; c=relaxed/simple;
	bh=OBBl4TNM4WGdJnjzKy54W4zPkieiBmiMQwG5g30pa50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlwrYAcsT7IAnEauv3iZ8d2uSMzRq4PE5tW6u/9JtemDe/P7RZGYfqzCCfxJJu0W4JEQkHZ9WA00ZjQSIQLYq4uSGzno7oC5dfOyBYLXgLoX/hZlD2k4LME4II898cYMxSvUShFoLts3C87V/Txh6P+6ADadXAwzjpVGsMJ7Yv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRGhZni3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRGhZni3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99B0C4CED2;
	Mon,  6 Jan 2025 15:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176791;
	bh=OBBl4TNM4WGdJnjzKy54W4zPkieiBmiMQwG5g30pa50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRGhZni3As4mK6iD9mQLYj/PfW5A9OAX70MIA9Lv9uJSFML3DkpNcDeeZT3nz6LzU
	 4IEVDgsgfNKOAG0+ucI9F/PCLX+6l/nrJdmDEx+yY1uRQq/ndT+rWwx5m4wy9Zufry
	 T01/QiQlW8UZI7+0L8upliuX2n10+835B+fJRD7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/81] ipv4: ip_tunnel: Unmask upper DSCP bits in ip_md_tunnel_xmit()
Date: Mon,  6 Jan 2025 16:16:05 +0100
Message-ID: <20250106151130.689270471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d3ad2c424fe9..eb74e33ffb64 100644
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



