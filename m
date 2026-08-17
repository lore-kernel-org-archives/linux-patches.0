Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED9542D763;
	Mon, 17 Aug 2026 14:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976145; cv=none; b=IPSBqVvjRwzt+oEylcB+b3KXDypNILS3fXPQbYrPdbjGMx8wTomEONd5rwzetD51lPQR3/hoH+m6poCyXh1VG6u+pJUE1Jg9f9i/042VX3R0vQjdDmEZnjvtXn90Brvvi7gaqEuWuuNnx+KHFbfri0/GX5/d/YIz24tkj6dhzdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976145; c=relaxed/simple;
	bh=ufFAzgcTp2vl/UQi8b6f9NbO4rDOMSOkfaMq00NURJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+eVHiH8UBbFpOhcXyPsxPr2+yoQFE3h82dizSgYecm9KthQoZzSd7oOKWb3Za2LT3Tzf0tGdRkDlLBY3amAQ+t5kkon9L2xEBYOapKR+73OBjniXECe38n1dMM5roJIZha4GTJwam5S+/Dh6TVN3qLbP3slt6QUIosjcPBvO28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAjtbo78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAjtbo78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004DB1F000E9;
	Mon, 17 Aug 2026 14:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976144;
	bh=Yv3DV6Wud2gFb+mobSgNvBI4lVceGtc2wjKaEtJ0dNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAjtbo78gU4u0YOK5gmeKwrV3x65bgdcoOTg7ZWZ6ByXzAWVd0eW5YIqSYAvFM3Tx
	 abFzNePkF1DCDlDn7xlACn8ubSLE2oNyo+BskM2L9vW8falQGGh+mO4YUDogunzg2u
	 FMY/Jf8u7/Bd5wCiERzLWv8YZjOS2dN+XHJdiWqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 271/389] vxlan: re-fetch eth header after route_shortcircuit()
Date: Mon, 17 Aug 2026 15:31:50 +0200
Message-ID: <20260817132549.752067893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2940,6 +2940,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 	    (ntohs(eth->h_proto) == ETH_P_IP ||
 	     ntohs(eth->h_proto) == ETH_P_IPV6)) {
 		did_rsc = route_shortcircuit(dev, skb);
+		eth = eth_hdr(skb);
 		if (did_rsc)
 			f = vxlan_find_mac(vxlan, eth->h_dest, vni);
 	}


