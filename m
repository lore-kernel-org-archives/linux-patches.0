Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875B93D75C7;
	Wed, 20 May 2026 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300146; cv=none; b=r/JrM3qnvlYWZdNQeMNvYPMoJaAF7s2wWrTwMVjVExWJLuyeKisbKXAt2fgauVsTDb+21+ym3t1VO4u2koUZtcamHp1fimlJAlCWVuoerbVxnyqZ9OOqObZuH3xYbQFlI2oNHrNnqA7FTOx5B06vN7o3GDdb1yEbJCd8L7qnpN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300146; c=relaxed/simple;
	bh=BvBtjcLMVjiM9tRjYCnKeijks5MqVLHvAA4OAfqMrqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YusbliVgSaS5Rq9R+lETS5X+xoijcsFdIUtEdMw01wb+LtXyHoO8bzXJCYukqtJhkAAefS/PmOn+zTL7Z7iT50iSk8EvfIQuWdjE4XYvl0/YlI/OlNo4eMu9pK17e6cTDNem81EDuWsolZqCP/1MDbjdQ6MqKbUbMgrrWVtHWCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyMznz3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyMznz3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1301F000E9;
	Wed, 20 May 2026 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300145;
	bh=7AIS/wgL0PVzgeC4zAwfmMifxZ+Nj6D4ggIGU9y22E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyMznz3De6LEj+BLS3jYNqIsKei+yVHP/KmDmHBueuxA5+u3meN4CiYTspBvXmrrY
	 UxfJtO/i1gciXwuzHePAKmMgWA+tCYvxzd8lVQmdmokLy5v92XTVE0b/ByWjkaL0YT
	 gj417jphDa0AHt0S1aMGtAROrr/Hyt3xiqRQEXiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/666] macvlan: annotate data-races around port->bc_queue_len_used
Date: Wed, 20 May 2026 18:14:34 +0200
Message-ID: <20260520162112.598187192@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

[ Upstream commit 1ef5789d9906df3771c99b7f413caaf2bf473ca5 ]

port->bc_queue_len_used is read and written locklessly,
add READ_ONCE()/WRITE_ONCE() annotations.

While WRITE_ONCE() in macvlan_fill_info() is not yet needed,
it is a prereq for future RTNL avoidance.

Fixes: d4bff72c8401 ("macvlan: Support for high multicast packet rate")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260401103809.3038139-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 3770bc84a9445..b43a1221a5908 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -351,6 +351,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 				      const struct macvlan_dev *src,
 				      struct sk_buff *skb)
 {
+	u32 bc_queue_len_used = READ_ONCE(port->bc_queue_len_used);
 	struct sk_buff *nskb;
 	int err = -ENOMEM;
 
@@ -361,7 +362,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 	MACVLAN_SKB_CB(nskb)->src = src;
 
 	spin_lock(&port->bc_queue.lock);
-	if (skb_queue_len(&port->bc_queue) < port->bc_queue_len_used) {
+	if (skb_queue_len(&port->bc_queue) < bc_queue_len_used) {
 		if (src)
 			dev_hold(src->dev);
 		__skb_queue_tail(&port->bc_queue, nskb);
@@ -1723,7 +1724,8 @@ static int macvlan_fill_info(struct sk_buff *skb,
 	}
 	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN, vlan->bc_queue_len_req))
 		goto nla_put_failure;
-	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN_USED, port->bc_queue_len_used))
+	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN_USED,
+			READ_ONCE(port->bc_queue_len_used)))
 		goto nla_put_failure;
 	if (port->bc_cutoff != 1 &&
 	    nla_put_s32(skb, IFLA_MACVLAN_BC_CUTOFF, port->bc_cutoff))
@@ -1783,7 +1785,7 @@ static void update_port_bc_queue_len(struct macvlan_port *port)
 		if (vlan->bc_queue_len_req > max_bc_queue_len_req)
 			max_bc_queue_len_req = vlan->bc_queue_len_req;
 	}
-	port->bc_queue_len_used = max_bc_queue_len_req;
+	WRITE_ONCE(port->bc_queue_len_used, max_bc_queue_len_req);
 }
 
 static int macvlan_device_event(struct notifier_block *unused,
-- 
2.53.0



