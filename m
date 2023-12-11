Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668E8FC06;
	Mon, 11 Dec 2023 18:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9LXLGoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE73C433C8;
	Mon, 11 Dec 2023 18:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320149;
	bh=/YZO7tnckoiBiL8c1wsSLMYYp7a6XI+9rtcxRJqSs7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9LXLGojiWdzQepj+aq6+jsvo0VUpmyQkG4WeaoEAeHcxaThQIUo/feDPim0FXW0Q
	 cjavpHuzx1a3Tzf4fB9yEdXHAPYcF9d9C3hn8NZYUxER/jtVih2+H69Z/GAdd5C/w4
	 INQdq7gPKtoDD8w7HV7f1UjeQctcZFMD2YK1+B/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Suman Ghosh <sumang@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/67] ipv4: ip_gre: Avoid skb_pull() failure in ipgre_xmit()
Date: Mon, 11 Dec 2023 19:22:06 +0100
Message-ID: <20231211182016.037283080@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 80d875cfc9d3711a029f234ef7d680db79e8fa4b ]

In ipgre_xmit(), skb_pull() may fail even if pskb_inet_may_pull() returns
true. For example, applications can use PF_PACKET to create a malformed
packet with no IP header. This type of packet causes a problem such as
uninit-value access.

This patch ensures that skb_pull() can pull the required size by checking
the skb with pskb_network_may_pull() before skb_pull().

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Suman Ghosh <sumang@marvell.com>
Link: https://lore.kernel.org/r/20231202161441.221135-1-syoshida@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f8f008344273e..db48dec61f305 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -607,15 +607,18 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
+		int pull_len = tunnel->hlen + sizeof(struct iphdr);
+
 		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
 
-		/* Pull skb since ip_tunnel_xmit() needs skb->data pointing
-		 * to gre header.
-		 */
-		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
+		if (!pskb_network_may_pull(skb, pull_len))
+			goto free_skb;
+
+		/* ip_tunnel_xmit() needs skb->data pointing to gre header. */
+		skb_pull(skb, pull_len);
 		skb_reset_mac_header(skb);
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
-- 
2.42.0



