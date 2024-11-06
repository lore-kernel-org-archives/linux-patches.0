Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B76A1DFE12;
	Wed,  6 Nov 2024 12:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895780; cv=none; b=EUvG4uaPslks8nUxecD6lRyCkJgC4WAVhYMH/xQjySZ0B7gZSnQEtlX/DFD1wJcvM+7nZFSQBJV5fHSm1iZ4IrU5T/CyeeLYIpI5eIqxePookuc2DugL+PNCR6wazFmyfzj1facS+FmM6cl0fm7cKrunuYWCJzlnc+lgUjfqP5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895780; c=relaxed/simple;
	bh=9kdsLVZe32eICVQf5B1XXHXqkMFcfP1HuYKCE7egkS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AM4kjvaFfwJ36QtO/MceO5p+8ikGFL/KoThpJqO9Nio36P0gCNKwRl86w5rUlFqOJgQThiAnUwWYiv7C/x64BLkXITEstlFiHYMoqIBDrkx2r/mr4pNtOskKLcyaqSRblI0VLV14VH37LlkWoQ/hbeHrseOpGyK40ftC0OBjNNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Tu8SY+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Tu8SY+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60ACC4CED5;
	Wed,  6 Nov 2024 12:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895780;
	bh=9kdsLVZe32eICVQf5B1XXHXqkMFcfP1HuYKCE7egkS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Tu8SY+MCmVivvxbuSzciB6atQDWAn+Q3nFERX6MJznlTuFoY6i+gaH6XXYKGvVUv
	 z66LNKqDtrPycTcixjXQeBhKUz8s3PhPi+TE4h40YLLIrQLi7p7iu1adXBIgEOAGk4
	 uD8KqICzL/jGNFHdJxoHicPI6FiqmCnDovqL4NBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@gmx.fr>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 334/350] net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension
Date: Wed,  6 Nov 2024 13:04:22 +0100
Message-ID: <20241106120328.965567545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Monin <benoit.monin@gmx.fr>

[ Upstream commit 04c20a9356f283da623903e81e7c6d5df7e4dc3c ]

As documented in skbuff.h, devices with NETIF_F_IPV6_CSUM capability
can only checksum TCP and UDP over IPv6 if the IP header does not
contains extension.

This is enforced for UDP packets emitted from user-space to an IPv6
address as they go through ip6_make_skb(), which calls
__ip6_append_data() where a check is done on the header size before
setting CHECKSUM_PARTIAL.

But the introduction of UDP encapsulation with fou6 added a code-path
where it is possible to get an skb with a partial UDP checksum and an
IPv6 header with extension:
* fou6 adds a UDP header with a partial checksum if the inner packet
does not contains a valid checksum.
* ip6_tunnel adds an IPv6 header with a destination option extension
header if encap_limit is non-zero (the default value is 4).

The thread linked below describes in more details how to reproduce the
problem with GRE-in-UDP tunnel.

Add a check on the network header size in skb_csum_hwoffload_help() to
make sure no IPv6 packet with extension header is handed to a network
device with NETIF_F_IPV6_CSUM capability.

Link: https://lore.kernel.org/netdev/26548921.1r3eYUQgxm@benoit.monin/T/#u
Fixes: aa3463d65e7b ("fou: Add encap ops for IPv6 tunnels")
Signed-off-by: Benoît Monin <benoit.monin@gmx.fr>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/5fbeecfc311ea182aa1d1c771725ab8b4cac515e.1729778144.git.benoit.monin@gmx.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index fb48a6b1301fb..c5b5dac093d6a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3327,6 +3327,9 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 		return 0;
 
 	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+		if (vlan_get_protocol(skb) == htons(ETH_P_IPV6) &&
+		    skb_network_header_len(skb) != sizeof(struct ipv6hdr))
+			goto sw_checksum;
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -3334,6 +3337,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 		}
 	}
 
+sw_checksum:
 	return skb_checksum_help(skb);
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
-- 
2.43.0



