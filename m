Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A4B57CA1;
	Tue, 14 May 2024 10:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682561; cv=none; b=BNQZUtZkxHHbK+NIZDmnwdwdxu45rLa2O8pHZ/85dlkSrnIdxBOsUF6CejWLuc9ErdD+hYwN+MUuoygUDVdeO17nbicJ7EfsyzPgUOamGUwRoRUQHAJgHTP2rnImbnPUn4lNPFNow3hs6MH+Tt80qZinuIN4HpsOJuQX/M9k3iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682561; c=relaxed/simple;
	bh=UBjPvuXE+3KB+5mAfWks9RdTztWH6bkblqFKMZ03sPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSOgqh6nGvuv4z3+FboQnxK5Qr8AoVl68uF9/FUZ0JnaCYUmzTe/OnDyuIHfMAYaJKXW6BhAlDyyiLlXU4E4hQTE9uTwsEZ4UC6/yytTa4GEgAD49gQ6taVOSMjkRjM0LyxSeUX5WkTExc68Kz375HsAGCvFhEnTqpaVi11u7MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4iUqbHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4iUqbHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E04C32781;
	Tue, 14 May 2024 10:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682561;
	bh=UBjPvuXE+3KB+5mAfWks9RdTztWH6bkblqFKMZ03sPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4iUqbHDBQvwCKJcTgrMwABKg36zemqjmiuq6X/n9P8Qt4+TIoyjQtlySVE7xPSqa
	 xuL2FrsSJ9fBZktgqhCiKRdJtFaDF7SnO8NWzUj1ldivXcfX2dhD9SroLnBfefMbFr
	 S4R3E1J+f6zE0K+HZh5l67fwHqdHm2JZq8w+YaTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 074/336] net: bridge: fix multicast-to-unicast with fraglist GSO
Date: Tue, 14 May 2024 12:14:38 +0200
Message-ID: <20240514101041.399984535@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 59c878cbcdd80ed39315573b3511d0acfd3501b5 ]

Calling skb_copy on a SKB_GSO_FRAGLIST skb is not valid, since it returns
an invalid linearized skb. This code only needs to change the ethernet
header, so pskb_copy is the right function to call here.

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 7431f89e897b9..d7c35f55bd69f 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -266,7 +266,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 	if (skb->dev == p->dev && ether_addr_equal(src, addr))
 		return;
 
-	skb = skb_copy(skb, GFP_ATOMIC);
+	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (!skb) {
 		DEV_STATS_INC(dev, tx_dropped);
 		return;
-- 
2.43.0



