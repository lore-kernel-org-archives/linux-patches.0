Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0A534B1A6;
	Tue, 21 Jul 2026 21:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670443; cv=none; b=B6BFFkUZGXMz2Z3dwKabn3IJXuMjEZxfd+yIn8EttxfXdHWzTDxH7c+q9zzBHt0HUifc8ywLf02hVTIbEYocTz/dg7QZ/WarzUsRGp2dw0Xm2WDFdfQ69hnWiKoXrbI9fEaBOB+BJXoloyZ3qO7E7Oj8nqt6zBSIiSUpt1r5eNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670443; c=relaxed/simple;
	bh=EykOsIuU/lIWGlsaaZe0xY/y3jW6puFUjTkRGK7wxeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGqLfBnBt78ASaEoeqPt7hTw/bfqH0aMSgBiBQxZJz4VwyV6kKDvQSjT43nQKg4si5uLbdflOMtGLLejaekR5OH7uTJEr50NP5B/EO8nXSimxXKuyx9I6QEEWF/XRaiXoehLP4ClBd9JIsz2ih+nNxF6O1wVLaCFSXUeeKomyaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeJH2mAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeJH2mAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608CF1F000E9;
	Tue, 21 Jul 2026 21:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670441;
	bh=NXwz6angUI044Dt+vR1B6VBLJHQCPVL6yFN8m8twWnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JeJH2mAKxnroN8jth7Pi4r9Ufum8fe1zJFaVsd4c1h0fxwXIyf53FCMV/da16lGnx
	 YCAtJbyI59ZsdoHXjlRIshIaVaHCzbbli3/l2/BGpH/K+bdZQanDs1CE+6Yzh8XpuQ
	 32QYbUYNMHyq+kg7mghu300k1FGtl9eBdogUu6D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0890/1067] batman-adv: retrieve ethhdr after potential skb realloc on RX
Date: Tue, 21 Jul 2026 17:24:51 +0200
Message-ID: <20260721152444.441989160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 035e1fed892d3d06002a73ff73668f618a514644 upstream.

pskb_may_pull() in batadv_interface_rx() could reallocate the buffer behind
the skb. Variables which were pointing to the old buffer need to be
reassigned to avoid an use-after-free.

This was done correctly for the VLAN header but missed for the ethernet
header which is later used for the TT and AP isolation handling.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Fixes: c78296665c3d ("batman-adv: Check skb size before using encapsulated ETH+VLAN header")
[ move from mesh- to soft-interface.c ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/soft-interface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index c0549abcae7a64..40354da5c5b555 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -444,6 +444,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 		if (!pskb_may_pull(skb, VLAN_ETH_HLEN))
 			goto dropped;
 
+		ethhdr = eth_hdr(skb);
 		vhdr = skb_vlan_eth_hdr(skb);
 
 		/* drop batman-in-batman packets to prevent loops */
-- 
2.53.0



