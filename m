Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA43341AC7;
	Sat, 30 May 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163938; cv=none; b=GBxib79YuHiAUCWVN4FsSSbGVcJ8Y1h3XmqiaTYo9v7jvk9UO6c+7iZYxXhpJlnCc7TVnrVPsXXHmBwyVBQsDdRh8UmHlt2M5jjZxTDVx+RpY80iwWI+KIdl5VVcNlsFzcfPyghaCCtBlBudesQX/TFkJLlEbb9Yxo+LcV7QLpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163938; c=relaxed/simple;
	bh=+n4Ob/u0hLK7+1wKeEP0tcrZf+nI3FYo4yfS6yNqywo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0GsZtBhPeKfMD/osVlfgbEizmcpPWyc2qctn1OYN2vHYlKOHiJrCcJgJTtI3Vrq3RGfZtQGFzZ0av5uWV8ab6B9ln+qlWB1iksOqWzqYVpqK5g9Mc2X16dHntktOonRBg1beaHuj0tN7G/3qdx5E7jF6xTdCbQ/emRE6bNW0Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qvj6O05H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qvj6O05H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4DD1F00898;
	Sat, 30 May 2026 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163937;
	bh=jki4l4EqJcUYabBDZh6lQYs22T8WNsvlBZGiOEXFqoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qvj6O05HRFQeCFcp4+4sSp10hrXOGo0BSRMSnvubKmxBk8ZktFXxriH882FQezfZG
	 n0yVPAVI6CjfCL8HNy+Rk8Q/8ElpcgaMtP8JUSr/NJ8U/6bPxuyqehgJ9Pi7T9Vq+K
	 tPd7QrsrbRgRDkUBVQAZnhxqsPX0hWv3CcL7MsB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 407/776] macvlan: annotate data-races around port->bc_queue_len_used
Date: Sat, 30 May 2026 18:02:01 +0200
Message-ID: <20260530160251.014603883@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index f2fb958c1f232..86a531ffe9fc0 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -344,6 +344,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 				      const struct macvlan_dev *src,
 				      struct sk_buff *skb)
 {
+	u32 bc_queue_len_used = READ_ONCE(port->bc_queue_len_used);
 	struct sk_buff *nskb;
 	int err = -ENOMEM;
 
@@ -354,7 +355,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 	MACVLAN_SKB_CB(nskb)->src = src;
 
 	spin_lock(&port->bc_queue.lock);
-	if (skb_queue_len(&port->bc_queue) < port->bc_queue_len_used) {
+	if (skb_queue_len(&port->bc_queue) < bc_queue_len_used) {
 		if (src)
 			dev_hold(src->dev);
 		__skb_queue_tail(&port->bc_queue, nskb);
@@ -1683,7 +1684,8 @@ static int macvlan_fill_info(struct sk_buff *skb,
 	}
 	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN, vlan->bc_queue_len_req))
 		goto nla_put_failure;
-	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN_USED, port->bc_queue_len_used))
+	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN_USED,
+			READ_ONCE(port->bc_queue_len_used)))
 		goto nla_put_failure;
 	return 0;
 
@@ -1739,7 +1741,7 @@ static void update_port_bc_queue_len(struct macvlan_port *port)
 		if (vlan->bc_queue_len_req > max_bc_queue_len_req)
 			max_bc_queue_len_req = vlan->bc_queue_len_req;
 	}
-	port->bc_queue_len_used = max_bc_queue_len_req;
+	WRITE_ONCE(port->bc_queue_len_used, max_bc_queue_len_req);
 }
 
 static int macvlan_device_event(struct notifier_block *unused,
-- 
2.53.0



