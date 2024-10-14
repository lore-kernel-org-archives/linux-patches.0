Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866B6481B7;
	Mon, 14 Oct 2024 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917613; cv=none; b=QX+am1EyWMZHdFL+8fEXYEolAHh3nuMylpGd9SyVOQhA+BIo5f7XJsTz0bOf8R9T4oD2av1uvyUkGLwDr0A7CUEoNSCjMIgRExPX/YKLX242s5nsxMglBlFtcr50m70bk0lgshTXMk6BeSgMqwa5ujlkg7rOfb0hDpL8TTxvzOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917613; c=relaxed/simple;
	bh=b0dfcpT61TAfToDSHUrIdbHWKIw8GRF/I9L983A6dYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCnBfh2HMVm81wGRlTq2FPkfLJiZoAmtr5Pz+2QRyQqnpdFnhRmNpr+dlcWOI/9CHz8Npvdui7AqoBfkKETWsryCpwNwpOjKrEiah2qwzba0TFjm2nbRnjHwGS+mcdQTMbB/ddy1qqAOo1O/JTZzD3T86XvtDQrXxQfqnWB9GNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZ8A9Dvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZ8A9Dvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FB3C4CEC3;
	Mon, 14 Oct 2024 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917613;
	bh=b0dfcpT61TAfToDSHUrIdbHWKIw8GRF/I9L983A6dYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZ8A9Dvc/MRkp90YMwFoVpPAJpc2LsMr17+Eru483Stq//JrGAayY8eRbQdeHwDsZ
	 NlYiAcMDdXJJggRVUJ3wWRf6KoZ9mrilsP5SXJTbuxivR9ohDqhUQYVz/IdIKLSAW7
	 Vq+txk302YiShLICR9jd6jK/O+HXvEhFXn2TODtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/798] bareudp: Pull inner IP header in bareudp_udp_encap_recv().
Date: Mon, 14 Oct 2024 16:10:09 +0200
Message-ID: <20241014141220.105782388@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 277493e41b072..d0759d8bf7305 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -67,6 +67,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	__be16 proto;
 	void *oiph;
 	int err;
+	int nh;
 
 	bareudp = rcu_dereference_sk_user_data(sk);
 	if (!bareudp)
@@ -144,10 +145,25 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
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



