Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A38E1D55C
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKz7vTlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E4AC433C9;
	Wed,  4 Oct 2023 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443690;
	bh=DzssuuLuMP67r1VLWOuJriOGEQVLcjpLHnelWy0wFhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKz7vTlGCs/txrQ1G6GWK84u86LuvQJdy8gfC8ZdLsPewm/w2cJVwEhWy9CssgGFg
	 W11DnLnrG1c0rr+6xPWMww6cSeGhZJ3kKswzqpuR/x3Urrg1ADp07iQFKwtoPE/W0S
	 QzAO39eso6acZRoiWQVkBL4teppd/22SeETzD/NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Balcanquall <alex@alexbal.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 245/259] net: thunderbolt: Fix TCPv6 GSO checksum calculation
Date: Wed,  4 Oct 2023 19:56:58 +0200
Message-ID: <20231004175228.624107879@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit e0b65f9b81fef180cf5f103adecbe5505c961153 upstream.

Alex reported that running ssh over IPv6 does not work with
Thunderbolt/USB4 networking driver. The reason for that is that driver
should call skb_is_gso() before calling skb_is_gso_v6(), and it should
not return false after calculates the checksum successfully. This probably
was a copy paste error from the original driver where it was done properly.

Reported-by: Alex Balcanquall <alex@alexbal.com>
Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/thunderbolt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1005,12 +1005,11 @@ static bool tbnet_xmit_csum_and_map(stru
 		*tucso = ~csum_tcpudp_magic(ip_hdr(skb)->saddr,
 					    ip_hdr(skb)->daddr, 0,
 					    ip_hdr(skb)->protocol, 0);
-	} else if (skb_is_gso_v6(skb)) {
+	} else if (skb_is_gso(skb) && skb_is_gso_v6(skb)) {
 		tucso = dest + ((void *)&(tcp_hdr(skb)->check) - data);
 		*tucso = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
 					  &ipv6_hdr(skb)->daddr, 0,
 					  IPPROTO_TCP, 0);
-		return false;
 	} else if (protocol == htons(ETH_P_IPV6)) {
 		tucso = dest + skb_checksum_start_offset(skb) + skb->csum_offset;
 		*tucso = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,


