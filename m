Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F1D401A21;
	Tue, 21 Jul 2026 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654265; cv=none; b=QLRoBtCRKQPrrBlETBF8iL/xF4vaauURioQtkMtM/ws4pNMBQ8oy3ExmPHdcbhp3+xFyjLP5HxLMpUW2nyf16ojKk05VyQOSCIwJbBUbXSbRqGg1MuYGxq+CPY+hwST67bYpPNOWa7/DtFoO14L82aWzPkEwyImJbLZ2kepSoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654265; c=relaxed/simple;
	bh=JZTUqcNSZ9S5jacLzmiQaDkIlS76b4Y4cLQlnKp5zXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5Z23M6hIW7c5L5xBEpb2me2Iwepk2g0NEdiYZwLXxePZuGIRX9YfYNIzzP4lEovEfo0OUAoFfA/ldVitW+VTNXmp27MbkjBMtaMFyzt1mV9WEU1Z15vYn2d0mwOYd9garuADaZVXWw0Mkfun5jdIigSQ/mTZX0wGPkZtmhK9x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjTRWhkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjTRWhkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E808C1F000E9;
	Tue, 21 Jul 2026 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654264;
	bh=7cUi0X8nJp24nkJ9VGfvURYSwgDxmB4lYbxY6woNp4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjTRWhkZoChLHtQGlyafPgtND94d74lBlFwyQOYOPjOobVNjLAbcG+WxxxBQW5EhU
	 SxDxLemT6+gkGfQCiO+66wJ2kPE5DFjp98V80lxtWFAMCcO8WjtPVGQNZFw6WBjKSv
	 Km6Cl6p4O0cfOlLcXGx2wTfC1J2QfLRnZVa4v8GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1639/2077] batman-adv: retrieve ethhdr after potential skb realloc on RX
Date: Tue, 21 Jul 2026 17:21:52 +0200
Message-ID: <20260721152631.408818705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


