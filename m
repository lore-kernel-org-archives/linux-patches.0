Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4538A314A95;
	Fri,  7 Aug 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115347; cv=none; b=YqDBaem6Ke8OPfs+aCk9ORyUynp114/EkdVxG4N4ElKM7uVi7giaDiZtuUU97uCpCPGwrXSsI1rVBsz8w2RyrBEtvVHxjYnd975beBg7ykQ3dJaUnJH1RDUmu0ndLS2J+y7nCoLarIjRTIBtjrWe43gRFKw/cbVD9rIZgZ3TraM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115347; c=relaxed/simple;
	bh=/cgX680UDzPt+KPGmLcfP3OZClOK0OIv5nuj9YrnZl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExSd9UoE4vJy6aAPlSwYGa5pvlW0kKPk16JlGE/dDqrW3vBDQORw0drwAnfaaQ54EOwmVbkrib+WxgNmxtzvfce2PmJhYoDQyp1w8mTdn1LTCRfXRDyGORrn/agqUL4G4QLm9wLDhj62o6AunUpvi0zvv9Mcy5mrhE9eNVXh8ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBBOfwbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBBOfwbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9BC1F000E9;
	Fri,  7 Aug 2026 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115346;
	bh=eZ91G8sZo6vBEG8by9OtCOGgl/3aZGWJcfRTmu7yZkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBBOfwbKYRJHNLn/6Mnd/4+ZWPOlZoM0sP8SHqt5gVY9tBPfZQ9XjZ7ChJXr1NUtj
	 87+Rn5Tg0QABIprhzl9zyoTJbrDLm9EMy0qgxWjJDbn/bhH4oC7jHt/7vWZKmm5yKY
	 9VVS8ZBXaQvXo7LR9S5cmioV2yzRy4XAUXnk9wQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 245/396] vxlan: re-fetch eth header after route_shortcircuit()
Date: Fri,  7 Aug 2026 16:36:45 +0200
Message-ID: <20260807143429.537613444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 1395a676ec15a0a02a2a6d86602324f2d5fd41d5 upstream.

Before route_shortcircuit(), the eth header pointer is cached from eth_hdr(skb).

Inside route_shortcircuit(), pskb_may_pull() can be called, which may
reallocate skb->head.

In this case, returning to vxlan_xmit() leaves the cached eth pointer pointing to
freed memory, leading to a use-after-free when dereferencing eth->h_dest.

Fix this by updating eth = eth_hdr(skb) after calling route_shortcircuit().

Fixes: ae8840825605 ("VXLAN: Allow L2 redirection with L3 switching")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260723144249.759100-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2798,6 +2798,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 	    (ntohs(eth->h_proto) == ETH_P_IP ||
 	     ntohs(eth->h_proto) == ETH_P_IPV6)) {
 		did_rsc = route_shortcircuit(dev, skb);
+		eth = eth_hdr(skb);
 		if (did_rsc)
 			f = vxlan_find_mac_tx(vxlan, eth->h_dest, vni);
 	}


