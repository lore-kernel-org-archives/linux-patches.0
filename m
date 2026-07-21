Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBB946C4D0;
	Tue, 21 Jul 2026 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658578; cv=none; b=nHQ0PO1dLSVNQxHTSirQyZEJlaFLMVd7JxF0JfeKR/9aJkk6Sl6QmmfESyEx+vRDOtdVSznacMZnbh4yp1l8F1qgMMwHA65oamMVo8MCbbUMaLdHNWhYK9oNSM4RaXd7RM+zcX/xcWXBqoLFNxFxfsN6M0BbYKs5E072/fmrDh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658578; c=relaxed/simple;
	bh=5DEjzQCkumLJVCaspkiFZj5vBqOn0xtLgTwsGUk4qQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPqQq9/FpMcQwPAg7cK6uqe6JVVDEa1q+MRsuwRQPf6sWISmH1EqOlGIN3C0Wr3LGHsYmG9FtLR0WW+ktyil7jbVQajvoR/u9kmJjPYSJjcjf3ux38UXuwd2vwLslyo9dvNY5d3MNWYb4Ndji7gHBGnS5tbvPQ5OC39gB+dDHU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXWJF/Z3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXWJF/Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7521C1F000E9;
	Tue, 21 Jul 2026 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658577;
	bh=pp9b1SUYfpqM00wyT8BZE0gtgAJ8dCMrwV2C9gjaTJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXWJF/Z3CZAAjw3ybxcu3LKDZE6AOeAiXqpvLh+OUkeB0WnswQLp+4xCqDrmPLcc8
	 KwNnCR83iuRY3I372pPZ44ml88+MD46B6tlBaag5l92CFSTUw9Qd0v2Nq3BYRVe/h3
	 k9EcRxgq0qH0nooKUmJl8uTZ3YpLJXDOkoLaUmmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1195/1611] batman-adv: retrieve ethhdr after potential skb realloc on RX
Date: Tue, 21 Jul 2026 17:21:51 +0200
Message-ID: <20260721152542.310351377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/mesh-interface.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/mesh-interface.c
+++ b/net/batman-adv/mesh-interface.c
@@ -432,6 +432,7 @@ void batadv_interface_rx(struct net_devi
 		if (!pskb_may_pull(skb, VLAN_ETH_HLEN))
 			goto dropped;
 
+		ethhdr = eth_hdr(skb);
 		vhdr = skb_vlan_eth_hdr(skb);
 
 		/* drop batman-in-batman packets to prevent loops */


