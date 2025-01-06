Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984C3126C05;
	Mon,  6 Jan 2025 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176788; cv=none; b=BZxdzCzSIlw73hgFbunxfeCe9/wOoNndtq7rA13CUj1bgBVBz0dtf3E9xWEchz1wjf1hE9nve0stlBVsSVyaeejLruJc0NMAkFdekKSQsdj0J687obt09ao0O0kIR2ALG5X0EuuKpeEFvq8/cwIwFh0B0wo216MmuRP2/EmwvAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176788; c=relaxed/simple;
	bh=2rflKhY3pAr3YrnGWQ+Q5F4Ta3BNWHygMnm0nsIlvns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyfqHZyjqZkzPGRYbMc5Knb6JgszF+76xZvfVIZvSD9d3mEkSKQb47jtzZCWNyC+RSLBz0JiW2hPgZt62KDj8YxxKi5HfTNDFUdBq8H5irrU1p1mKmnc1r/29BbkBcbfIiJ6SPI7d+W8jodKMwEPNSP0VvFQ2G+FKkUGLQHnnMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPaRatqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPaRatqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E29C4CED2;
	Mon,  6 Jan 2025 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176788;
	bh=2rflKhY3pAr3YrnGWQ+Q5F4Ta3BNWHygMnm0nsIlvns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPaRatqoLb6wE2lvMhKrA+LLG7eJfbq7vqMACp4M1pEwi0nVybBVRTjRzWHdB2tZp
	 QQpZg2rncCb0s7a61c8//yrlXurL0dXlaM7yQ+Q+SEgKZ2ec2R4HEWUGTaOgmCnikO
	 NXjCW4IfGsLSls3kwPQyNxeUm8X04h332uD4wR94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/81] ipv4: ip_tunnel: Unmask upper DSCP bits in ip_tunnel_bind_dev()
Date: Mon,  6 Jan 2025 16:16:04 +0100
Message-ID: <20250106151130.651758878@linuxfoundation.org>
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

[ Upstream commit e7191e517a03d025405c7df730b400ad4118474e ]

Unmask the upper DSCP bits when initializing an IPv4 flow key via
ip_tunnel_init_flow() before passing it to ip_route_output_key() so that
in the future we could perform the FIB lookup according to the full DSCP
value.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b5a7b661a073 ("net: Fix netns for ip_tunnel_init_flow()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 196fe734ad38..d3ad2c424fe9 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -293,7 +293,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 
 		ip_tunnel_init_flow(&fl4, iph->protocol, iph->daddr,
 				    iph->saddr, tunnel->parms.o_key,
-				    RT_TOS(iph->tos), dev_net(dev),
+				    iph->tos & INET_DSCP_MASK, dev_net(dev),
 				    tunnel->parms.link, tunnel->fwmark, 0, 0);
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
-- 
2.39.5



