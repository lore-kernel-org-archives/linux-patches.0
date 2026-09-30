Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1116389104;
	Wed, 30 Sep 2026 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786519; cv=none; b=fIYywGqMt39azOILPWaxU/rK43Vc6R7Dj161RHk7Clhc5i8V7iHD0ILPOeo1OXQlCNizD92GjYs1/dsBlTXsyjnL2IfnjQSibJB5pnwiN3cAWHxedqFDiCEqf6YG9MXBOdfL/r6t9YAo0y9mHvHjG3+PopT6KxL/Nty5ToLeO1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786519; c=relaxed/simple;
	bh=hMbZnQGFxcjRyRjVrPAeq47jUF8SYax12RfOR3kAf3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDcXBx1r2lg71jSbakwQOgf9+3ovPrqg9lti1cHfd7jg8K9ZRgf+8WMIU3pROOKIOkSKR6w5CiwxapC2OubuoUbO7SOVwJnJjbG3jl3cycHXYOls0480jm4WrJK27dF85UqnV67k/U5kYs8SCi0hZpIqkZfvr8mH5W3YigXSjhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a67WvazC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a67WvazC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2960D1F00898;
	Wed, 30 Sep 2026 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786517;
	bh=LFi7fKt9oT9I+aIgHOaftaC/Dg4cgL5kTHyPfJBO+yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a67WvazCF6/AaZ4cIGHs5K9WEkKdjokqyGQd3Z5cqG9eGO878ZayDm6nGEFvizBHf
	 tyziSvek3te+04w/0rjJ0mUnV+CHgcuTPVOzqfu+KeMmSR1XJxtT9sTBEQijDnAeqL
	 HCBUQkUbHy7miZxaJGU4XYsU64J2bGtkkAyn7lac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Sasso <stesasso@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 891/982] vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets
Date: Wed, 30 Sep 2026 17:27:07 +0200
Message-ID: <20260930152435.885514488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit ab7aa05c06ae340e5c7530bb78fa8d23794e460b ]

The VRF device is an Ethernet device but it can have non-Ethernet ports
such as IP tunnels. Before the cited commit, capturing packets from such
ports on the VRF device resulted in these packets being detected as
malformed since they lack an Ethernet header.

The cited commit fixed it by pushing a dummy Ethernet header to such
packets before the capture and pulling it afterwards. In the case of
CHECKSUM_COMPLETE packets it also updated skb->csum with the checksum of
the dummy Ethernet header. This is wrong as skb->csum should not include
the checksum of the Ethernet header ("checksum of the _whole_ packet as
seen by netif_rx()").

This also means that L4 protocols receive a corrupted skb->csum and
potentially drop the packet, as is the case with UDP packets whose
checksum was completed by software.

Fix by removing the unnecessary call to skb_postpush_rcsum().

Fixes: 048939088220 ("vrf: add mac header for tunneled packets when sniffer is attached")
Reported-by: Stefano Sasso <stesasso@gmail.com>
Closes: https://lore.kernel.org/netdev/CALtE316UtL3x7LL6uxfXzx8rW6AbzYPeDOb478hqJCr_-dj=Wg@mail.gmail.com/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260922131239.2509494-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 65668113f715e..807b96925fe1e 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1278,8 +1278,6 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	skb->protocol = eth->h_proto;
 	skb->pkt_type = PACKET_HOST;
 
-	skb_postpush_rcsum(skb, skb->data, ETH_HLEN);
-
 	skb_pull_inline(skb, ETH_HLEN);
 
 	return 0;
-- 
2.53.0



