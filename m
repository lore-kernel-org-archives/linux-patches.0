Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C314315A;
	Sun,  7 Sep 2025 20:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277675; cv=none; b=bq0USklmdx4lXvz26jNkxfJx0hgtM+7FXekxT42XyQFSItybUd4/X2fLzw6mj+dmYbmOE/PLrqqxNNjC01tLw9tvL4fKuOgDBMaXZvjJX+Xci0T1+hR7JTFUkUGS/VUlnGxe9QFKe5jkO6Pf9iFWNC8vS1WLbwDWbA+XCEx5MMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277675; c=relaxed/simple;
	bh=QfCnTh7GRYFdjMpDQMY9F3wmqy4h893ZDosBU52Sw6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alaTZCVUw8uix/OWGMzzklsBveu0j3CqL0lInCqgeLz6pB+HflKGRuGPG+DBxCcElwDfySZ0zhnOgfv7fTsw0+ELBRWsHQ8+saouVOGcadeUquugYZo+kV3N3JctuYFxnSAySZv4RZajDRWESzymb8Gea+1CF6NwEMfSU5uRYUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTA2NyR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTA2NyR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FF5C4CEF0;
	Sun,  7 Sep 2025 20:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277674;
	bh=QfCnTh7GRYFdjMpDQMY9F3wmqy4h893ZDosBU52Sw6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTA2NyR2BMFPSoE5uUDP+LXC5I7E9T8imqAm0wX0byuBfr5LTRaUt5tAWJaZ0wUHC
	 Id4kZ2iJaadh30DV/Cj3LPUGRNe6hC9akGfcKg+f+Jc27+KcCCwjHxu+TUJlxHajoy
	 CcMOvvPxdfm/P+8jVyvzgvoaiil+181ca3SxEg+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <f6bvp@free.fr>,
	Eric Dumazet <edumazet@google.com>,
	Joerg Reuter <jreuter@yaina.de>,
	David Ranch <dranch@trinnet.net>,
	Folkert van Heusden <folkert@vanheusden.com>,
	Dan Cross <crossd@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 088/183] ax25: properly unshare skbs in ax25_kiss_rcv()
Date: Sun,  7 Sep 2025 21:58:35 +0200
Message-ID: <20250907195617.881586031@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8156210d36a43e76372312c87eb5ea3dbb405a85 ]

Bernard Pidoux reported a regression apparently caused by commit
c353e8983e0d ("net: introduce per netns packet chains").

skb->dev becomes NULL and we crash in __netif_receive_skb_core().

Before above commit, different kind of bugs or corruptions could happen
without a major crash.

But the root cause is that ax25_kiss_rcv() can queue/mangle input skb
without checking if this skb is shared or not.

Many thanks to Bernard Pidoux for his help, diagnosis and tests.

We had a similar issue years ago fixed with commit 7aaed57c5c28
("phonet: properly unshare skbs in phonet_rcv()").

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Bernard Pidoux <f6bvp@free.fr>
Closes: https://lore.kernel.org/netdev/1713f383-c538-4918-bc64-13b3288cd542@free.fr/
Tested-by: Bernard Pidoux <f6bvp@free.fr>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Joerg Reuter <jreuter@yaina.de>
Cc: David Ranch <dranch@trinnet.net>
Cc: Folkert van Heusden <folkert@vanheusden.com>
Reviewed-by: Dan Cross <crossd@gmail.com>
Link: https://patch.msgid.link/20250902124642.212705-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 1cac25aca6378..f2d66af863595 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -433,6 +433,10 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 int ax25_kiss_rcv(struct sk_buff *skb, struct net_device *dev,
 		  struct packet_type *ptype, struct net_device *orig_dev)
 {
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		return NET_RX_DROP;
+
 	skb_orphan(skb);
 
 	if (!net_eq(dev_net(dev), &init_net)) {
-- 
2.50.1



