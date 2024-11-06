Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB3E1F4FCF;
	Wed,  6 Nov 2024 12:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897788; cv=none; b=RyWROqPpF6xdpnVvh8X1ylPgrnxFr05gFzCJVc2Ve4P+kiPYN0WY8W9Akq/1YQ4tmiGj8MmBp5Wfhw0SbNWx6XO1l5iDKa+p9Ujm3a5MQzq5XWOsFjoahyAXfwB+/lCg+yowV9mVFRUDjki3mV7hWKjnBh6xr7xd0iUF1J3XHhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897788; c=relaxed/simple;
	bh=yJ5mPHVwwm3Jn7I5X7Dr1P2YtLqHTaeRgUDcKY0a73c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO5VL3yD6eX4WOjg3iw9jNkDp3r+vuqZBGTlU/BE67bkYWUHkUSCiyyAoAIuXMEsqLfhn0e9mi2wYzSJ0AzqOZwaG1S3kj5R0bMxVJc2mtgSidQbE7aAci+jukUpg5zIrjy214JJT+8hYKJ5rJQ+9u7GbNSN+r+Qs5oHRLeSel8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZklcOGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZklcOGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE563C4CED3;
	Wed,  6 Nov 2024 12:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897788;
	bh=yJ5mPHVwwm3Jn7I5X7Dr1P2YtLqHTaeRgUDcKY0a73c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZklcOGO5znaB5sadUhar5C2oQtWND2U+1CtYFO5juTPa4nMV6b776A6nX4pICOoJ
	 MULx7yBZ6cLHWhYuKa7nJpRcnzi5CT6VpaMYyv2pkKzKyXWsxcB+VKMxBWMMJAy9KG
	 ggIL/D/7ogP48OIS4HfXUDOUAnXYU/yi9R1URT6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moon Yeounsu <yyyynoom@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/462] net: ethernet: use ip_hdrlen() instead of bit shift
Date: Wed,  6 Nov 2024 12:58:15 +0100
Message-ID: <20241106120331.565118655@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Moon Yeounsu <yyyynoom@gmail.com>

[ Upstream commit 9a039eeb71a42c8b13408a1976e300f3898e1be0 ]

`ip_hdr(skb)->ihl << 2` is the same as `ip_hdrlen(skb)`
Therefore, we should use a well-defined function not a bit shift
to find the header length.

It also compresses two lines to a single line.

Signed-off-by: Moon Yeounsu <yyyynoom@gmail.com>
Reviewed-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/jme.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 25aa400e2e3c..773ec50d515b 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -947,15 +947,13 @@ jme_udpsum(struct sk_buff *skb)
 	if (skb->protocol != htons(ETH_P_IP))
 		return csum;
 	skb_set_network_header(skb, ETH_HLEN);
-	if ((ip_hdr(skb)->protocol != IPPROTO_UDP) ||
-	    (skb->len < (ETH_HLEN +
-			(ip_hdr(skb)->ihl << 2) +
-			sizeof(struct udphdr)))) {
+
+	if (ip_hdr(skb)->protocol != IPPROTO_UDP ||
+	    skb->len < (ETH_HLEN + ip_hdrlen(skb) + sizeof(struct udphdr))) {
 		skb_reset_network_header(skb);
 		return csum;
 	}
-	skb_set_transport_header(skb,
-			ETH_HLEN + (ip_hdr(skb)->ihl << 2));
+	skb_set_transport_header(skb, ETH_HLEN + ip_hdrlen(skb));
 	csum = udp_hdr(skb)->check;
 	skb_reset_transport_header(skb);
 	skb_reset_network_header(skb);
-- 
2.43.0



