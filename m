Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9A03229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7594AC4339B;
	Mon, 30 Jan 2023 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088246;
	bh=mpFuFh6JFmkTAooGvPqZ0lyTgxxdn+1xfdLelFQpU1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuyAR3hwBehilefVrxsBJoaOujMKlS/46huxWeEKnUMXPJ+60U3fbj3c0/fbqkYiR
	 tqJx3GmayAwgo2Wrt5ocGTUZr5GznQoj0oP50jLoD4KnFAodlbw17hedvZRydCHwKv
	 DU9Nyf4MJQxlt6nvOi5dTMET/CRB+DDuSxNprs9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergely Risko <gergely.risko@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 163/204] ipv6: fix reachability confirmation with proxy_ndp
Date: Mon, 30 Jan 2023 14:52:08 +0100
Message-Id: <20230130134323.723987888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gergely Risko <gergely.risko@gmail.com>

commit 9f535c870e493841ac7be390610ff2edec755762 upstream.

When proxying IPv6 NDP requests, the adverts to the initial multicast
solicits are correct and working.  On the other hand, when later a
reachability confirmation is requested (on unicast), no reply is sent.

This causes the neighbor entry expiring on the sending node, which is
mostly a non-issue, as a new multicast request is sent.  There are
routers, where the multicast requests are intentionally delayed, and in
these environments the current implementation causes periodic packet
loss for the proxied endpoints.

The root cause is the erroneous decrease of the hop limit, as this
is checked in ndisc.c and no answer is generated when it's 254 instead
of the correct 255.

Cc: stable@vger.kernel.org
Fixes: 46c7655f0b56 ("ipv6: decrease hop limit counter in ip6_forward()")
Signed-off-by: Gergely Risko <gergely.risko@gmail.com>
Tested-by: Gergely Risko <gergely.risko@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -527,7 +527,20 @@ int ip6_forward(struct sk_buff *skb)
 	    pneigh_lookup(&nd_tbl, net, &hdr->daddr, skb->dev, 0)) {
 		int proxied = ip6_forward_proxy_check(skb);
 		if (proxied > 0) {
-			hdr->hop_limit--;
+			/* It's tempting to decrease the hop limit
+			 * here by 1, as we do at the end of the
+			 * function too.
+			 *
+			 * But that would be incorrect, as proxying is
+			 * not forwarding.  The ip6_input function
+			 * will handle this packet locally, and it
+			 * depends on the hop limit being unchanged.
+			 *
+			 * One example is the NDP hop limit, that
+			 * always has to stay 255, but other would be
+			 * similar checks around RA packets, where the
+			 * user can even change the desired limit.
+			 */
 			return ip6_input(skb);
 		} else if (proxied < 0) {
 			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);


