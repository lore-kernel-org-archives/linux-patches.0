Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09681B424F;
	Sun,  7 Sep 2025 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275974; cv=none; b=B+W9hnPajiAp7KH2fqF7C0kkTkvayw9UsWnn48HzwkFpk8znYqIllefJ4wNjAnj3eX0V2UcdY24EkB/IUx6j69q+ScN+Nbp+5bxpzfV1q031UlXoharGX4kzeiY3zp5WNAiEIOz+WfiOAHle6LV2/Oidq2HcvM9jNimRdFiH8bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275974; c=relaxed/simple;
	bh=3MjvQOXKy4ibVPF29qoKLZuyn1Qolw5q3MfaRnUhgmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/WcyV6V/eQFuLK9A6N/1/ol2zI35XGkk8Nkr/k+v3I0B9+5WX/S2mDDVXcDNzm2dXf/RmTGO+3gx3STVittQ5SCQs45Nat9THCb1qnbvRCWp0RDoi3ELzoFZtImgvieuPC38e/MbH7jJdqcivgfASWpNsx+XfgQ3+dNjE2EUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQE52Yjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQE52Yjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277A3C4CEF0;
	Sun,  7 Sep 2025 20:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275974;
	bh=3MjvQOXKy4ibVPF29qoKLZuyn1Qolw5q3MfaRnUhgmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQE52YjnYRnK/4BNkwFB61eq1kHG6iryGbqowZxSaO7NklVyUbCpZz3l+60PlsxnM
	 5NO58znqk0E2K/R1sj/6Df+7f9PVJilmLDv7ePczRB7GoAkBKUhp3MzaBqQlP57idy
	 2zK2WxRGYJAyh+iEpyHgsunEz2x0ru3qeBBIWWgU=
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
Subject: [PATCH 5.15 23/64] ax25: properly unshare skbs in ax25_kiss_rcv()
Date: Sun,  7 Sep 2025 21:58:05 +0200
Message-ID: <20250907195604.031800087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cd6afe895db99..e43f92372cba5 100644
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



