Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4084D2B9A6;
	Thu,  3 Jul 2025 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554986; cv=none; b=VpoTvrsT2vZHEbZDcshFVgcsRDRZbdWOxvkib/ARRfH4mYdBCiY/ZDaC6A9jNQa9FKQXCaV4eTrJ644iR0TQPke/qsiEwGKxcU7xaQ3/qjx4eX5Os/shS7SFOiAupOkImBc6haFu+0HNoHMwKew4/01mcnGgBfKBfWX798llanw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554986; c=relaxed/simple;
	bh=N8+t25Sej0cKqkdDCF6iBnGlJRfLAanbQbP6lj4e95I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xg/kwVwBB9qi8bXj7dcvaj1BsZCNi5eM8mj9u5wIN6+rjMS1/mxt1ixJF+v0Bc1d5ijieVjsJ6XSVDDP4kT3JwyPZunKfgE6vTTamDw7lYh/4pjB5eAVjbxa+bBlTNVph6G9j4+Rs/uMNYFoLBdtEuFvzaf0I1Ap6uIbMdNBXbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=My4zS5+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="My4zS5+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DCAC4CEE3;
	Thu,  3 Jul 2025 15:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554986;
	bh=N8+t25Sej0cKqkdDCF6iBnGlJRfLAanbQbP6lj4e95I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=My4zS5+vimAg3IhxGRBQHP/gtWArBicC3uR/sNRlZcjVwHVkZB5xAifUv8YNsExre
	 mmwN0yoArTYO7wGwFzyzs9c2XLfvkYRjYp04CesENYy4jtNEov6kftgF6OVUjUe51n
	 K5Rp/VmPcggzva3L+QPuQeKxDXMFYwnwam5qvlHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 141/263] net: netpoll: Initialize UDP checksum field before checksumming
Date: Thu,  3 Jul 2025 16:41:01 +0200
Message-ID: <20250703144010.012174046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f5990207026987a353d5a95204c4d9cb725637fd ]

commit f1fce08e63fe ("netpoll: Eliminate redundant assignment") removed
the initialization of the UDP checksum, which was wrong and broke
netpoll IPv6 transmission due to bad checksumming.

udph->check needs to be set before calling csum_ipv6_magic().

Fixes: f1fce08e63fe ("netpoll: Eliminate redundant assignment")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250620-netpoll_fix-v1-1-f9f0b82bc059@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 4ddb7490df4b8..6ad84d4a2b464 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -432,6 +432,7 @@ int netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 	udph->dest = htons(np->remote_port);
 	udph->len = htons(udp_len);
 
+	udph->check = 0;
 	if (np->ipv6) {
 		udph->check = csum_ipv6_magic(&np->local_ip.in6,
 					      &np->remote_ip.in6,
@@ -460,7 +461,6 @@ int netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 		skb_reset_mac_header(skb);
 		skb->protocol = eth->h_proto = htons(ETH_P_IPV6);
 	} else {
-		udph->check = 0;
 		udph->check = csum_tcpudp_magic(np->local_ip.ip,
 						np->remote_ip.ip,
 						udp_len, IPPROTO_UDP,
-- 
2.39.5



