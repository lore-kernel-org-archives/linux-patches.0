Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81861D0E05;
	Wed,  2 Oct 2024 13:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877485; cv=none; b=HS00uzggRxX1xUCgdevnzGblh3GYMw3LrXNLQyZpPsdnbBw4GwcmEtCHa29kmRSLkMrYhonXFHCRMZ5lrkMxvnX257gccAnH9NKEt/fxOkg78t84wVU+TAEWmss5u8I+N6E3oCVE7Zegaa1rs0Fh+z3Te5Vckk8KOU0RYWfs4L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877485; c=relaxed/simple;
	bh=DRoFljR7657MIbpdtjoaVIrJ/43i//PcEi4vr33Sgr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgm5EfyGp3JkRMCO9DDo49FqdR0wE39paZPkyYcpAY3DwmhGF7qk7fde9zcCHGTtukv2Y4nZfp8qnG0C4Lsr9dRd6e8mtQUMPHwY9Po6O7dRXrBUUdzFk1/SYVIRqq0vZKrMbFDOhY04+nsZZYCHt3HFUn1gXrabqCoNvf3HaVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGbyLq3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGbyLq3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A2FC4CEC5;
	Wed,  2 Oct 2024 13:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877485;
	bh=DRoFljR7657MIbpdtjoaVIrJ/43i//PcEi4vr33Sgr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGbyLq3E3c40m5gfV7qVR2+uOuczxPGhoowuPuzM+JTMGkQuAfAPJN/JXK2vErMqN
	 suU6E2APcK5oTd4chYXhX7rpozuHGwXBWDjuAuy3pNp8VN23XaUP/aRPLEG7J+VyJb
	 F22J5f6HM0zVFgZTX8hjltrPETXlCGKzo0P1qSYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 093/634] bareudp: Pull inner IP header in bareudp_udp_encap_recv().
Date: Wed,  2 Oct 2024 14:53:13 +0200
Message-ID: <20241002125814.781463624@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 45fa29c85117170b0508790f878b13ec6593c888 ]

Bareudp reads the inner IP header to get the ECN value. Therefore, it
needs to ensure that it's part of the skb's linear data.

This is similar to the vxlan and geneve fixes for that same problem:
  * commit f7789419137b ("vxlan: Pull inner IP header in vxlan_rcv().")
  * commit 1ca1ba465e55 ("geneve: make sure to pull inner header in
    geneve_rx()")

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/5205940067c40218a70fbb888080466b2fc288db.1726046181.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 7aca0544fb29c..b4e820a123caf 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -68,6 +68,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	__be16 proto;
 	void *oiph;
 	int err;
+	int nh;
 
 	bareudp = rcu_dereference_sk_user_data(sk);
 	if (!bareudp)
@@ -148,10 +149,25 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	}
 	skb_dst_set(skb, &tun_dst->dst);
 	skb->dev = bareudp->dev;
-	oiph = skb_network_header(skb);
-	skb_reset_network_header(skb);
 	skb_reset_mac_header(skb);
 
+	/* Save offset of outer header relative to skb->head,
+	 * because we are going to reset the network header to the inner header
+	 * and might change skb->head.
+	 */
+	nh = skb_network_header(skb) - skb->head;
+
+	skb_reset_network_header(skb);
+
+	if (!pskb_inet_may_pull(skb)) {
+		DEV_STATS_INC(bareudp->dev, rx_length_errors);
+		DEV_STATS_INC(bareudp->dev, rx_errors);
+		goto drop;
+	}
+
+	/* Get the outer header. */
+	oiph = skb->head + nh;
+
 	if (!ipv6_mod_enabled() || family == AF_INET)
 		err = IP_ECN_decapsulate(oiph, skb);
 	else
-- 
2.43.0



