Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D5D466B5E;
	Wed, 23 Sep 2026 14:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173753; cv=none; b=QlYxoR4zEpA/ZUJxZNoR1O3hrDPLX2V9vGQo9b7NXULU/Mjcp9kqjrRmeQ3wj/6HIw+IcRwtsapfD+h4eL5RZCK4exvjT1LqydTpff3mdziC4g+gBSOOpO6iBjeDC3g7SMOIvJumqC+6Z4XUtaxZfMcQSBCVRuSJRQDJrtB7ylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173753; c=relaxed/simple;
	bh=7zwD8CncL0kCsS7bRq/YoE4hSDTCbRlbwv0BP3M7DrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZjr0rC+F8bIIy7FstF7GbrcOVvA4q7usyEu6WhwjowKmkQBEEJNTh+HobLhtI9Fm/lS6FUSt3w9nueVRJDMQ4AIw0mlltoaBsStPq0TE/SSdYSGfq6sWdnmUeWZsHOWur3gra6DXx5FLDAgwapKGZEIcLpgvfqIRtUOq/lvXKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5AsGp47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5AsGp47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0263B1F000FF;
	Wed, 23 Sep 2026 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173752;
	bh=6KGpUq/DOBSVzl2MVusEhSJJPZfM/hl6W9RLd0yBlRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5AsGp47xiZXfEwBNmf7pJCWR//rHH1nDKDOQa+qubCzlPjcYPdRe+dFc6NwQXvRX
	 mlsKRXZ0Aimq7hDp1U09r1JtCjIaMgpmwcjNoLK/tpq1dFMmiF6G1qpqINX6IjFZGD
	 uZwpZlS5rv6ersc4J60siaH1wOY2RDt67+X6gle4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 298/438] net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()
Date: Wed, 23 Sep 2026 16:05:19 +0200
Message-ID: <20260923140652.502753969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanglei Zhu <zhugl3@xiaopeng.com>

commit c7ead9704249d57d4693a04697e3bbd285138fa9 upstream.

The netif index carried in the DPMAIF PIT header is five bits wide,
but ccmni_inst[] only has room for NIC_DEV_MAX (21) entries.
t7xx_ccmni_recv_skb() indexes the array without a bounds check, so
indexes 21 to 31 read past it.  The out-of-bounds value lands in the
callback table that follows the array, which is never NULL, so the
existing !ccmni check does not catch it and the driver dereferences
whatever sits there as a struct t7xx_ccmni.

Drop the skb when the index is out of range.

Fixes: 05d19bf500f8 ("net: wwan: t7xx: Add WWAN network interface")
Cc: stable@vger.kernel.org
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Verified in a QEMU guest with a fault injector setting the netif
index to 25: the unpatched driver reads a value past ccmni_inst[],
which lands in the callback table, and dereferences it far enough to
queue the skb.  With this check the packet is dropped.  Well-formed
traffic on index 0 is unaffected.

Changes in v2: none.

Link: https://patch.msgid.link/20260911021734.1396599-3-zhugl3@xiaopeng.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_netdev.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -420,6 +420,10 @@ static void t7xx_ccmni_recv_skb(struct t
 
 	skb_cb = T7XX_SKB_CB(skb);
 	netif_id = skb_cb->netif_idx;
+	if (netif_id >= NIC_DEV_MAX) {
+		dev_kfree_skb(skb);
+		return;
+	}
 	ccmni = READ_ONCE(ccmni_ctlb->ccmni_inst[netif_id]);
 	if (!ccmni) {
 		dev_kfree_skb(skb);


