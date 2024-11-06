Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89181200CB8;
	Wed,  6 Nov 2024 12:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896797; cv=none; b=GHx1Elz7hDbYt9HwrK8Qxv0obLUru1T+D7oPRwlAQD0e61Xng0DuI04HJbZtSh+xtSLlCX6Mi1TQAsZc97I7CPNyg4ks7jgsDN7XAIUOB59mk2OvBUdVFNZ5cIex5tCizJ0EUvlYePFdGQKm52NkPz7LEKfCbRZqWiLKWv6NTo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896797; c=relaxed/simple;
	bh=Q999o+9bwJ0/8HVdXCh2TIW7bZOsGj2e71NrgL2fZR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVgh9e/Cew4jqpk/i3VdYcV7lRgHpbWy3pLE1WlunxzKV84isCmknULFb8aQynckS4c9dYbQMQsHfRKLdIryC8cNKB+EVPlZPQaUqx+BR5dMdMtCqqWmLQDroAKJsk7eQw+JcUMdRRqKc7JCc55ChLKBNhtnk9hUOYF1nG5yJaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rl6czS58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rl6czS58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2E3C4CED3;
	Wed,  6 Nov 2024 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896797;
	bh=Q999o+9bwJ0/8HVdXCh2TIW7bZOsGj2e71NrgL2fZR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rl6czS5857Mb2yelvLjcm/WchuiUqK99bobCekXnnrzOBXSEX19QQ20AThWuk97g6
	 p45u48guNEOGvxPpHfQHHILZkNRXZ6+qNl2MT+TALWxadENeJIPGz0qzomEvnZWKMZ
	 WwSg3zz3qZOowTBwadnr6ANaI64sXAmVORFf9VpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@gmx.fr>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/110] net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension
Date: Wed,  6 Nov 2024 13:04:42 +0100
Message-ID: <20241106120305.286236592@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f04bb2ac4932..2c11247509b4c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3651,6 +3651,9 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 		return 0;
 
 	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+		if (vlan_get_protocol(skb) == htons(ETH_P_IPV6) &&
+		    skb_network_header_len(skb) != sizeof(struct ipv6hdr))
+			goto sw_checksum;
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -3658,6 +3661,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 		}
 	}
 
+sw_checksum:
 	return skb_checksum_help(skb);
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
-- 
2.43.0



