Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869E82F6931;
	Tue, 21 Jul 2026 20:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664118; cv=none; b=N5+kz0nK5Axpyu0RXVfr0igL2y3voxCrZg5XEIRC6nM2CsJB1Poa78Y3shsPsXSIGF79vYy0Ek5S6bXahwbXj4NLorwuPt+k3651Mbbn3dkE37Vl85wBgLt+L6TY6nbHCN2hw07C+hbm9Ll5OHEyoj2qjfYXysmJgkEUo79clyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664118; c=relaxed/simple;
	bh=nEEZkvO48qKzk5YB3MY9HVTQddPMQ+CQEoAF1yeeKqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InxweMSzY3x5XNk64Ytp4DbI1o6uK52FDDNnzjeSBOcvtna+rA7t1jddn07O6ZB6Q6Si8Zfk6yv+Aypej8BzmedgHVIfsM1+Yi0C7JBIR1T1vPerGHiymL9TyKj+Hiep9SLlk329uS8PkYIbCMWxHLszVbyzhmHvkr4fAgxMr+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsmLLFjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsmLLFjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C71F000E9;
	Tue, 21 Jul 2026 20:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664117;
	bh=wzrzS7EU8/MSw/YZO8aWHEFaw+aEFlDyRzDzApGVEms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsmLLFjluiuxh00WvRUGfqivGSdqsr6Hj65LC1bLTeZN6TfjUx8HPIE1jW5XuapOc
	 MjkTZzl6AsPLVY4pKIhm0A9/SrXmbGO+JpcVNCNdepaHjFdzqrsMQ9CUfwCH3g4yF9
	 FvijRfSqPPzeKpO3pw3Vsj73lyqE03Dm+O3XKx2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1062/1276] batman-adv: retrieve ethhdr after potential skb realloc on RX
Date: Tue, 21 Jul 2026 17:25:05 +0200
Message-ID: <20260721152509.752824517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index f46064333f3343..42ad04d356904f 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -445,6 +445,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 		if (!pskb_may_pull(skb, VLAN_ETH_HLEN))
 			goto dropped;
 
+		ethhdr = eth_hdr(skb);
 		vhdr = skb_vlan_eth_hdr(skb);
 
 		/* drop batman-in-batman packets to prevent loops */
-- 
2.53.0



