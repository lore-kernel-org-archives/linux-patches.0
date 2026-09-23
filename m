Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331075383CD;
	Wed, 23 Sep 2026 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174972; cv=none; b=KG4REv3R9FzWXkz5Xzr8/nfNTp3TBtqVlocI52f6dV1k5DKD1ml1dCgmQF79DRhTNJ4lXsbYVJDK1hKHLqdulanhYfztNy7CweNdX5S0u0Ohmf/LNZuSoMJ2RcRuOw23swjRc/4x71zrLo6fOHCbhntfIgKmRnZEYCINsY8N1w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174972; c=relaxed/simple;
	bh=eYsrQImJ23ELwXAspdSZ2pU/CkRs9wsb287oCJdpWro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/tQ7QJwY8QdQXff5D2Ns4asLvjJvWGbqWC21Ft07lg+MLK96rc/Bo+JmNgIWblmVV8PtzWCZqMJf6uaM4Jdx4NPBv24fZaJl7B9trW8rMxYV5GviN32CvXXSPf9k89uxhPr4vIJfqLhREZWc1K1ImOgLXPtM4S/I8ni4dmSy9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XislW902; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XislW902"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E401F000FF;
	Wed, 23 Sep 2026 14:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174970;
	bh=Nk6gMQRBd8YTg7hNlYlsaLxkuMauIEYAxhm3a0X0TYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XislW902DepLc7V0ss1XV6vLZi3jwOgUNwPLN+/IO9mJaElMBbdPfaO9VISlSmVoy
	 VjJIhy/rIYDxCpClAAFpm7EjCGM9PvC1DLJqlUDoXAhwYZQwTF6osuDeSj0t58kCHZ
	 moOWn7RcYutfQyQqPNfuuW/eQyVjcYhHhokU9QOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 246/398] net: wwan: t7xx: validate the netif index in t7xx_ccmni_recv_skb()
Date: Wed, 23 Sep 2026 16:05:20 +0200
Message-ID: <20260923140649.785675681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


