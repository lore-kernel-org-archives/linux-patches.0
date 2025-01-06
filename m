Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C42BDF71;
	Mon,  6 Jan 2025 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177543; cv=none; b=SvYM5Ogl+1q1019zkZGjdmOQbv6p67xns3GF1mY/SbBVbrdQ/j23OxPaHzXthwjxFX0HCB9qg6MiMGp33v9Jw3i717IfXvMU+T/lsD3PCFbP4/5UOXY7bt0PAi8HW5d14wku1MmqaVJLg9sgMb+OKEZ1inixUneJPW3jPcopDA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177543; c=relaxed/simple;
	bh=DvJkZJMOCcx26FUUT2+5SRaceXcr9RHj/05YXmapA/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdRfPXjq/SaKCylvnjeiW8sM9+WSeaGkhXstYkUUWdNQ6ApREzPthB2wlelSJyaBNO2GLN4HiKbXo4L5AalMpp++X2pzVSnutxQuo3rzev8b06jEjVBCQn/pfPHkOkUwiPFtpwWsbOZp8vpU4OnBbr2lN93tJhWp4jg0XdZZbvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHhakaU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHhakaU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD77C4CED2;
	Mon,  6 Jan 2025 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177542;
	bh=DvJkZJMOCcx26FUUT2+5SRaceXcr9RHj/05YXmapA/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHhakaU/noAVn3G8PZNM0Deuh4Xckhcn3Lj5wSezkqPWtXQOGXpk9KStoUkLrrw/p
	 inKZA0zuK987CCjBBw56Tjhlt1His4mmB3NC/C36OqEpVCRyD2d40EpBd3GK4SHP+h
	 XBr0Z7DAGp6KRK+HAtNA2JwDwMOlPmrS+pSR+zIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/222] ipv4: ip_tunnel: Unmask upper DSCP bits in ip_tunnel_xmit()
Date: Mon,  6 Jan 2025 16:16:00 +0100
Message-ID: <20250106151156.669252883@linuxfoundation.org>
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
index b5437755365c..fd8923561b18 100644
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



