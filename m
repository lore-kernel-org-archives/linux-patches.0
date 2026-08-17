Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE02442B30;
	Mon, 17 Aug 2026 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979993; cv=none; b=T866KW+idrMNgvwo3colJDmo0bjFTZfaQrFUg+veO6S7lRw7g9yaId8sTqfawiElAlJNoni3sRY5Phsllg5ilhOaXN2S52I3h92spwnecu8VLfCoej99v1Gz22KkzKLE4FjU/olvQQB7acRviNAIy6OW+N8LCsUCPiW4Ix4IAUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979993; c=relaxed/simple;
	bh=4d5L3ZUaVjnKKjFlY8uwUxXRspUqVOwxcwwXqgD3ORc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzOrCBGYY0BMVOtjD+HL6cnj+pUVFLJya3bT9y4DxAdtD1bmxmtwtbwF0oIXa9GfBxDYCMlPbp5Equl/0/9crQ6FP/VPeGao444DTnwwWbak8tbATsz34VH1cQFSxLjl9C9ZVHomi7HgRdkokbJcpUH1sPGc9fcwCgUR/b5Nq5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLwsTyWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLwsTyWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFE21F000E9;
	Mon, 17 Aug 2026 15:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979991;
	bh=J7brbS6qvfYiqH+0lHaEz/u2TuSKAmRUtsJZKgin1ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLwsTyWGxl/fVThmpa1ovsNdTzoJUTn6AUz0K/nlQx8K2KFjebvql6euGIc9fd94F
	 NTwXIp9Kjs3RKwp8hZtAymTWGgIFKR8bQNOE19P+BMAwOvuPC8zuHKqSoU8obCXNID
	 KqCOER+fFqih2oyQFojq7+NHQPIPdiMMMF+D+5R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 419/609] vxlan: re-fetch eth header after route_shortcircuit()
Date: Mon, 17 Aug 2026 15:31:55 +0200
Message-ID: <20260817132558.142418599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -2879,6 +2879,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 	    (ntohs(eth->h_proto) == ETH_P_IP ||
 	     ntohs(eth->h_proto) == ETH_P_IPV6)) {
 		did_rsc = route_shortcircuit(dev, skb);
+		eth = eth_hdr(skb);
 		if (did_rsc)
 			f = vxlan_find_mac(vxlan, eth->h_dest, vni);
 	}


