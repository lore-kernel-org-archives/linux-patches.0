Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6AD3BCD38;
	Fri,  7 Aug 2026 14:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114222; cv=none; b=c1cGqxtHRAEppEF7t7Jz4nx9Lxg/zedLNQtw9x74qtwF1w9AkbrCCkxBB4GRY740t+CqzW9HLQjX4GqE8uBivFTJJCAutxCvymiez34oQK04djFbs/dvVf9E0iFVxecV5LSMTw1aKNQD1SzQFOzwkPBKN7qhk2Vwr43Rk+B6jOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114222; c=relaxed/simple;
	bh=Axt1L1gwpgBXHa/0k5uLm+g8KZ0k1zc170STF71Wj+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FppEHAHNQVrQN9kpgrPef8eNGuTyHbA/53xSIeu0q7eAXrUJlksN1JtpcRnR51vb/RHrY2jXp8noKyUqSLoMej8XZx4oAallOMYHmADtQXtT/CLYFFSkjR/lr/NyIvJjBGpiSZdEzRp8uhzsG0gl8mulMktIb2/gEU4hPswoYRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqxcRtXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqxcRtXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A9C1F00A3D;
	Fri,  7 Aug 2026 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114218;
	bh=IOpBmd7f4dsUvoOerfc1CpjnPXPrCAGZmfOzJTqVVJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqxcRtXhGKMSDDztIaAR1ZZZwzzUpB12wDBg26PLy8kEGisrZAi3eDozcWCPfJcL5
	 R4LBvmlAq5+NeFhOUcSkWaKr150HA69pr7tfo0b6pBoOBCVSosDlqiQmo8clayJzpB
	 szTtWrUPiOhIFaW6eK2rQbmeVtVjgSZrT9sMDFEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 187/337] vxlan: re-fetch eth header after route_shortcircuit()
Date: Fri,  7 Aug 2026 16:36:30 +0200
Message-ID: <20260807143422.611149905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2790,6 +2790,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 	    (ntohs(eth->h_proto) == ETH_P_IP ||
 	     ntohs(eth->h_proto) == ETH_P_IPV6)) {
 		did_rsc = route_shortcircuit(dev, skb);
+		eth = eth_hdr(skb);
 		if (did_rsc)
 			f = vxlan_find_mac_tx(vxlan, eth->h_dest, vni);
 	}


