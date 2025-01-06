Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2786E146D6B;
	Mon,  6 Jan 2025 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176794; cv=none; b=OiqgFSMCC5YiOj3CCJFL2vTfI5B73wOuCoYkhRqDDJMUrmkH/HNy70xVVoZEaRUbSDE3cljBibSc6WnATAuqBZcA3OTeOhPSfesxO1Sql2WLaSf+VMQsUrXMjuD0EOUP31NgswLcE3YHoI1kJZIIW8/iKalptr2WVC+Rm4Q4nGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176794; c=relaxed/simple;
	bh=aVwDzl51Glcf+yyl2i69L9SRVx1PX0E/VcFcSCIqvQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6vQRauY5Q8N6VpuNYpnTkaomHB66bxB8OuGWb7WPEVkwETJHi/1Y1G0WcC582Lai9q/m2Al0pW0XVAi3b9lhUPRX/BouThpmyIFuLu3c5KfgCMqUc61KagAV67zHi1ZleG1bcVu3HYHpqUymOPGhhxWs/pfcmqyW6mHZnenFMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3r8q5Af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3r8q5Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45C3C4CED2;
	Mon,  6 Jan 2025 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176794;
	bh=aVwDzl51Glcf+yyl2i69L9SRVx1PX0E/VcFcSCIqvQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3r8q5AfK4RHBC/TCn+Ys/4P+cBmRkwvJdy+IbAVAIkif4ABIxVabkkbrxOy/ewTt
	 lzznoBelO3JPIx0M5SS0fpMWfYK8mQk1zs8zNg3CEmSDLnWav/fQnCP53qwEwOb5wm
	 XQPm7/VAbCBMNyNLygLc7XhVh+anlu8bU1BJw4W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/81] ipv4: ip_tunnel: Unmask upper DSCP bits in ip_tunnel_xmit()
Date: Mon,  6 Jan 2025 16:16:06 +0100
Message-ID: <20250106151130.726886373@linuxfoundation.org>
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

[ Upstream commit c2b639f9f3b7a058ca9c7349b096f355773f2cd8 ]

Unmask the upper DSCP bits when initializing an IPv4 flow key via
ip_tunnel_init_flow() before passing it to ip_route_output_key() so that
in the future we could perform the FIB lookup according to the full DSCP
value.

Note that the 'tos' variable includes the full DS field. Either the one
specified as part of the tunnel parameters or the one inherited from the
inner packet.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b5a7b661a073 ("net: Fix netns for ip_tunnel_init_flow()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index eb74e33ffb64..4f30ccf2d321 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -773,7 +773,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
-			    tunnel->parms.o_key, RT_TOS(tos),
+			    tunnel->parms.o_key, tos & INET_DSCP_MASK,
 			    dev_net(dev), READ_ONCE(tunnel->parms.link),
 			    tunnel->fwmark, skb_get_hash(skb), 0);
 
-- 
2.39.5



