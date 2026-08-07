Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6140B31327A;
	Fri,  7 Aug 2026 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116162; cv=none; b=BR7xrIiZL1vYdwZCFNFT1NdH8+SRconNgwAjdNbfBpC1cVA1VoDGJ8q8vMcmuMCjxR3555AD1cAwirDFSJkgmsTP4pDLQe9c2w37FyBBJsFcZMf4wAzcTcRoNV7UpDr/SvjYZDWFcOnwkVREMLogPHpxVsytsqZvIxa3Q2L0qt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116162; c=relaxed/simple;
	bh=35iY/jVB7fFCEQgtnIoDRUUlwZR6QhXRjtG2JnJj9pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUJf0kMln0PohFiwGwebqTzPd48Dd4gUTtioPxZOS4EcsEwtns+DuuCGMTLshYG1JDAE0UI8Rdjqk+FwP7WXWFfhCwkaj3mNE+ibUV6Hc8+GPz4A8iHasj+6q23LGRPvOu7VmxyPUiTErtq9O6IlbaVxNiWlkS7IFm0hvkkp0Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ft17CZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ft17CZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC89A1F000E9;
	Fri,  7 Aug 2026 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116161;
	bh=QbrTYomTszofV6so3qTxAO/E9MLxFnSG+yZGobWsL/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ft17CZEqiU7wkTN4pcQiWr2kdub02TyQM9yO1RfTsE6fLvMy/vZEnKywiMsf6abV
	 LoRjwTc1e3TMkyvBPiQzHD0W36DuPLB2LWjr9LcQ4MD6uy+d9rC3isLyBu8+6zTDSS
	 WBiAv8fL/OP85liyuHT3n9yeaWwMjDI12nzsQTE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 134/261] vxlan: re-fetch eth header after route_shortcircuit()
Date: Fri,  7 Aug 2026 16:38:11 +0200
Message-ID: <20260807143418.258277868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2863,6 +2863,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 	    (ntohs(eth->h_proto) == ETH_P_IP ||
 	     ntohs(eth->h_proto) == ETH_P_IPV6)) {
 		did_rsc = route_shortcircuit(dev, skb);
+		eth = eth_hdr(skb);
 		if (did_rsc)
 			f = vxlan_find_mac(vxlan, eth->h_dest, vni);
 	}


