Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ABA5326C2;
	Thu, 17 Sep 2026 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666231; cv=none; b=VTD3vNFfNFAXxfz2oHkdYzUo4lW6CX0ZDhaMYZaFui+akGUKFJYfbe2YR843XUjOnkOqi1FdqqqsTSeDnIVs7TwdYDRykvpQJG8Hvpa8XVtBF5kaeeVVdkQvElHnh426MahGVk/xyzitgJMh4kjIk9RsHqjxJWrtraQ2u5wy/tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666231; c=relaxed/simple;
	bh=35Etwq4IciRtMbNIokHQ+1N3tCvcEfIpRWOlkPROhyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGp++RpSmUdv8cKS3ibb5ZGhnDzrZgaC46kOK5MB6qKVONgLjDrNY97r5KnJKfHmf4bpIYcuspbkc6i+JK0gQRaI/IGERXyxwER0PEI0nkbXvQtOvRVe3aTlFvXAs4ZRS2pGVDQMTBh9AtTGJNK6D+Zb8MNbbMkcD+X3eC92R+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mb5ZZmN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mb5ZZmN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9AD1F00893;
	Thu, 17 Sep 2026 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666230;
	bh=tJ3kvjvbTgQiYsfioSFkOghasWkRmHCSoZNnv0KuHw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mb5ZZmN+a4xuezkf43IGrg1NUZk6rupSGSuHfA5ICPytMWsjzptdigk5SqumuM5Am
	 f7WryRXRu7C+OLgvJbF2JfqBAp53eSIQaSTv4nLKN6MjDMHmzZyrtbDcdmFceFwjy/
	 mPu0UoByBTi7MBR4r23VHkjYuRlfc1HTXl9zJRZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0941/1250] net: stmmac: add stmmac_tso_header_size()
Date: Thu, 17 Sep 2026 16:12:16 +0100
Message-ID: <20260917151617.525362995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit f799b5dab9c98a4b52a93d1c357916e0f0b7e663 ]

We will need to compute the size of the protocol headers in two places,
so move this into a separate function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1w7ptJ-0000000Eat5-2ZlA@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5e38d732ec67 ("net: stmmac: fix TX descriptor availability check for TSO traffic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 007eee6798a5f..609f056d4a70f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4164,6 +4164,18 @@ static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue)
 	stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr, queue);
 }
 
+static size_t stmmac_tso_header_size(struct sk_buff *skb)
+{
+	size_t size;
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		size = skb_transport_offset(skb) + sizeof(struct udphdr);
+	else
+		size = skb_tcp_all_headers(skb);
+
+	return size;
+}
+
 /**
  *  stmmac_tso_xmit - Tx entry point of the driver for oversized frames (TSO)
  *  @skb : the socket buffer
@@ -4235,13 +4247,11 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	first_tx = tx_q->cur_tx;
 
 	/* Compute header lengths */
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
-		proto_hdr_len = skb_transport_offset(skb) + sizeof(struct udphdr);
+	proto_hdr_len = stmmac_tso_header_size(skb);
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 		hdr = sizeof(struct udphdr);
-	} else {
-		proto_hdr_len = skb_tcp_all_headers(skb);
+	else
 		hdr = tcp_hdrlen(skb);
-	}
 
 	/* Desc availability based on threshold should be enough safe */
 	if (unlikely(stmmac_tx_avail(priv, queue) <
-- 
2.53.0



