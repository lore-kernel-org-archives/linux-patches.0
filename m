Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1709D1C07C2;
	Tue, 15 Oct 2024 12:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997082; cv=none; b=rXcHT7Xj71ElykQd9Lfb0ORHrxQZ0ypThh6KqL96y19Q+iDzjsCzTze61i0wHUsVShn13RjU7QSZF+HIkbvtI4/Ji7geNWtxbTaaYBztJwXzfh6CyNiNqAYgBRPwkY7k/n6AtfZxenEuNMTvrzarbzDIkSYjmfzemNm5qNDgRPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997082; c=relaxed/simple;
	bh=JJNf1ay+YUfAdkrV9YDZGAfPmcMi5Ts5XxFnzU77kGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAjyl4rCGAs5VjI6sxjcoJbnbf+PmIp/D8Kkx1CPWVvNDV/ZCLAif/+RW8L5WvlwTiTUGEY3FL421DmjmXCocUXKnqVjXgGqZe75Entmi52Rs9cPdFUZuIvclVqGIctFlrWvEvqsAWNVBXlWLRviZLUgI96dXBqitoZLaQlN6Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQHRpMbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQHRpMbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D202C4CEC6;
	Tue, 15 Oct 2024 12:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997082;
	bh=JJNf1ay+YUfAdkrV9YDZGAfPmcMi5Ts5XxFnzU77kGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQHRpMbvE9ce0SnPr/EHLmR8PiMRulZ7WIVjllzeRPqmso1ubKKUyuFGgEvZ0hJZl
	 G46HnLIXTVlhIGakbR/77izAHQbpwUdlm2HLVFDgt8Iqig0DU+6i/OyVyLl5hitiUU
	 IhshaZJxTo2Nq3N+625cGcfwA0b+tVom7GJ/jT3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/518] bareudp: Pull inner IP header in bareudp_udp_encap_recv().
Date: Tue, 15 Oct 2024 14:39:46 +0200
Message-ID: <20241015123920.166657708@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1b774232b0df0..8efd61bdee997 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -60,6 +60,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	__be16 proto;
 	void *oiph;
 	int err;
+	int nh;
 
 	bareudp = rcu_dereference_sk_user_data(sk);
 	if (!bareudp)
@@ -137,10 +138,25 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
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



