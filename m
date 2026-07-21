Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AFC443A81;
	Tue, 21 Jul 2026 22:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672607; cv=none; b=emO16ubpH9hmRFyqQ1QLDRj5/sanrLs1ILXaLxluI/GY6R9jNkBL8gAbw3EvDCcQz3CQYxvoma2+LBg7HjdJJs57oSfP4hPwSkTVxnCLhA6gdoXBYRWNSlFvdurSOPbmmtEOEC9vPC3zOUPMjLGHg/b6aygpGlf31yIhJ/17ilA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672607; c=relaxed/simple;
	bh=rMdaH4vQL5/OiQtt9XyFfpYTCDu2pY6GSDqip92B8YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJcvnwl3on2H3l5TWGctbtms4EAZSL8OlitwBPIPouoO46UYTNeizDxywJRBcSwAeWmgAju/FgVOuJDm3PQ7oYPyCk9xPalY2FaansHe8tEg9WffRea7asMD+Waak3Z5WelxPL7KLWpt5dbs9AWH2X3Ko9++bQldcBvCYTNtQKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLWTybgi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLWTybgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8C11F000E9;
	Tue, 21 Jul 2026 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672605;
	bh=6s4n7LKaOpNhDgI6SfvlU9f0gnJFLUvtYZo6Fdk0GAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLWTybgiZvNMOzleFIWukpf0/wkGcXk+l5fSOZ6hr0TdAzeuMvcNwziUc8By7w7mF
	 XZGbyOtGgSKLDUJxJAcVluycjOZrzScUrZCzSqhihEf4oszxyyiqADI2pJrZc3NRGZ
	 3jKo1X7pa1d3R+p6ajMSFVW84ZEqpv+1AWm0lfLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 689/843] batman-adv: retrieve ethhdr after potential skb realloc on RX
Date: Tue, 21 Jul 2026 17:25:24 +0200
Message-ID: <20260721152421.554189335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b46480ec7bd1d0..21297af54e4ea7 100644
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



