Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159BC4437B;
	Mon, 11 Dec 2023 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXgPvvus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BA9C433C7;
	Mon, 11 Dec 2023 18:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320389;
	bh=CQ++Ivd3TpuO4SdvnkAJpNuAD1ArSRje/2K8NsnEVuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXgPvvuskmK2XbIqTGI4TumzsBTz97ZSerjgZFRqFyc+JmNUCq9rXCg4WClEn9Qxa
	 DXy/chv9N5KcOg4fUYs84aYdGmNFxBWGZ+GrUG5QVGHE6R8CtrRKq9s9R4qvGanMd+
	 HP/GNcZrVbh/yuzY53JkK+EI10wmAyKkC7VVIJ3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Suman Ghosh <sumang@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/194] ipv4: ip_gre: Avoid skb_pull() failure in ipgre_xmit()
Date: Mon, 11 Dec 2023 19:20:33 +0100
Message-ID: <20231211182038.491842817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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
index 5b8242265617d..d67d026d7f975 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -634,15 +634,18 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
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



