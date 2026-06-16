Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4465043E4BA;
	Tue, 16 Jun 2026 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626729; cv=none; b=a8DDmh2ldrjmAWtmvAq9jbm8qvvsu5IXrdX/d1vzvrPVN2kYuZhoH/jPYorjkYP5lWLgLXcfZzwMG/t02zvZslrPndknrDXqog2kmb25izhyFML1MWeFcGY2sFNcOwWyng9fNa2nA2IXsVZZrbY8NsOqGI/2o7DxD30PxoVn8LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626729; c=relaxed/simple;
	bh=whHCH0sO8r5zMQcDVCJM+IK8IP2r7yXiLo41A18/Nx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okj/A4sd9GR/hkVvzvIaGfi/iyfMRYxjEaCMKvDSq1tnPxC+TMTQ3eV37wqbT2aHpyTdYMHj80AoTiU1zWej/LVSGTENXicdulXf3wvXtCWmK9iTGDTD/BquXsX/+YiXYeIqiMxC3ltvX9KFJ2P/6ncWHIvxA9xruEYjNW9+dNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaItuaZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaItuaZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470231F000E9;
	Tue, 16 Jun 2026 16:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626728;
	bh=ZQS41QXP8InLel0W8jGMFBoluVtu83Pbc79E/8wgy+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaItuaZCcRhW4Gd6mg0ZzFVbdjDe4F/pRvOlVsRyjuQnjM4LJVOqOuEcXuv7d6cTC
	 TkNGinZg112vqgXYZD/nG9t7nT3ILhMyIAxjyEBChkxEW1C7xQTXpmPhdqlWTpVmAY
	 00AsK1gnUeNTaBOQ91XNKXBd1kdNzPwg+Tg2dZ/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f13c19f75e1097abd116@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/261] ieee802154: 6lowpan: only accept IPv6 packets in lowpan_xmit()
Date: Tue, 16 Jun 2026 20:28:15 +0530
Message-ID: <20260616145047.799926376@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3a5f3f7aff18bcc36a57839cf50cf0cc8de707f3 ]

The aoe driver (or similar) generates a non-IPv6 packet
(e.g., ETH_P_AOE) and queues it for transmission via dev_queue_xmit()
on a 6LoWPAN interface (configured by the user or test case).

Since the packet is not IPv6, the 6LoWPAN header_ops->create function
(lowpan_header_create or header_create) returns early without initializing
the lowpan_addr_info structure in the skb headroom.

In the transmit function (lowpan_xmit), the driver calls lowpan_header
(or setup_header) which unconditionally copies and uses the lowpan_addr_info
from the headroom, which contains uninitialized data.

Fix this by dropping non IPv6 packets.

A similar fix is needed in net/bluetooth/6lowpan.c bt_xmit().

Fixes: 4dc315e267fe ("ieee802154: 6lowpan: move transmit functionality")
Reported-by: syzbot+f13c19f75e1097abd116@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a1fd763.278b5b03.2bcf39.0049.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260603072955.4032221-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/6lowpan/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/6lowpan/tx.c b/net/ieee802154/6lowpan/tx.c
index 0c07662b44c0ca..4df76ff50699ed 100644
--- a/net/ieee802154/6lowpan/tx.c
+++ b/net/ieee802154/6lowpan/tx.c
@@ -255,6 +255,11 @@ netdev_tx_t lowpan_xmit(struct sk_buff *skb, struct net_device *ldev)
 
 	pr_debug("package xmit\n");
 
+	if (skb->protocol != htons(ETH_P_IPV6)) {
+		kfree_skb(skb);
+		return NET_XMIT_DROP;
+	}
+
 	WARN_ON_ONCE(skb->len > IPV6_MIN_MTU);
 
 	/* We must take a copy of the skb before we modify/replace the ipv6
-- 
2.53.0



