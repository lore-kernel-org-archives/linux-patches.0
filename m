Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DED1547D8;
	Mon,  6 Jan 2025 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177412; cv=none; b=k8c2jp0qQepfMTt+nyzjUwBOLubhrE6Uu8JZUsiUO2Uf/RlmFqcqclTu/OV7wS6N38uB8+kPpOKoIQeNQJ+unyqZT9pM5CC1RL6fbjLhTf4eOOdVHGHBn5ZnhmKJ9ptnDAgmYWPIyDWn77jJM0monD5n4H7Mq35vwQkge5cSB9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177412; c=relaxed/simple;
	bh=kdhCXqJhZQ/uPSujsJDMpxN0p1zGxywuzVzP0Hwf7JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdK/5BVOOiRb2sZ+IpkKVt2aTkNReKAORP4L6Keyd03lpyynlMAM8cCPOXsrtTxxXK3P/vXrZDZJGkpWdDyaFTW+yZASEWIs6gswDUrvQicTJ1lGhThRZky2uQSGgIXEYau6xEXLxAO+GWW9SN81gwNEPfbPT+Ek5QSRfUh6NaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGqyjB/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGqyjB/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE19EC4CED2;
	Mon,  6 Jan 2025 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177412;
	bh=kdhCXqJhZQ/uPSujsJDMpxN0p1zGxywuzVzP0Hwf7JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGqyjB/MBAVe+cU8IwY8zBi7QMyfaU+z4/A+201IMLCz2JiugzLW7TbNGxWsf6op5
	 LC4M9rIdqVzVNfTO9BiLplibxBScNr5xMyRzGLVNIMiAtFgPKSQVILntyy7f6fUN8F
	 lo0ZFcsgXPc5KoE+GESfxGi1Og1xIz0Jpw6zAeMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/222] ipv4: ip_tunnel: Unmask upper DSCP bits in ip_tunnel_bind_dev()
Date: Mon,  6 Jan 2025 16:15:58 +0100
Message-ID: <20250106151156.593622101@linuxfoundation.org>
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
index 0f5cfe3caa2e..571cf7c2fa28 100644
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



