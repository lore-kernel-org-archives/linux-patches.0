Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A0051AFF5;
	Wed, 30 Sep 2026 18:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793171; cv=none; b=BRdMgZcGh3vuZ1cvfLTWIi5yZUiv3q9RNoq8U02c/jBF1PodYiTmwhoOkRJ18nkl8Hm83odn6StVDXtR/YIxJUdXdrMZrHyDfdbsX5a/sMY1cFllBgT2Wx+Nua1VmVIMegRE4NxoY+8/1mKmB1IRUjsfLJmx5sS4azzml29gesw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793171; c=relaxed/simple;
	bh=9oxFT40XOUD6mPTLUl1RH6f2J92sGhiaDul4W/Xb4Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI8A0IfcXLR9kTBd+UJJSfktCxwl2Beq4bKhITf7LP6+Z3Eu9whmNOjkC18z6t/cV+1gpGSYXLCHLdOf7k54xjiCCHzBd15kbF50A+H+zfahe2WK7rACASYyhtO4rkTbV7bNJ9S9i2WgXiM+USQjDzMux1BwRpv4iZGYIik6QcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRjoCpcc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRjoCpcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6001F000FF;
	Wed, 30 Sep 2026 18:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793169;
	bh=OCnfFKKskIT6BbZtNJuXbS16Y/WLyfDy9zQKTbYMTGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRjoCpccKeWpI9xlxqu16VUGAdEiuI6igaFUEn/jxo7HEd9yTj9Ag0N+cns5XlsAs
	 2QzGBOZ8xAYBfUd1pH33M/DoZEPBiVxZYRmfwhW3zylekOVj8ptIhjpFTqU6BQ1Kn9
	 4umGRNhGwb++iuDnJX8OJpQNdNm9S/+fiA3FBHUI=
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
Subject: [PATCH 6.18 159/395] vrf: Stop corrupting skb->csum when capturing CHECKSUM_COMPLETE packets
Date: Wed, 30 Sep 2026 17:27:01 +0200
Message-ID: <20260930152344.094799661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index 4b62b167650ea..7ac320da3ba20 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1225,8 +1225,6 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	skb->protocol = eth->h_proto;
 	skb->pkt_type = PACKET_HOST;
 
-	skb_postpush_rcsum(skb, skb->data, ETH_HLEN);
-
 	skb_pull_inline(skb, ETH_HLEN);
 
 	return 0;
-- 
2.53.0



