Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AFA46AEE1;
	Tue, 16 Jun 2026 18:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635956; cv=none; b=qk+twE8cl3lkCNQSjOsrS6r0YZfYT//wEeON5rM1J9ogy/yuNFBD1q77I6ZTQ9paONYwlJjkLCXEpFQ/sSAH22VlTjA5gUNguWtizw0T4jbNLkE4NxMjkWnC0s0Po/Ey87GqZlldmrm7WqPXXerrDIkMVPYyLqwPMH1fIsau1kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635956; c=relaxed/simple;
	bh=Lx1ckfmRVlp9yC5mYKJQAw//o3N6yo4szOwMPUiASN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9F6EsTvac54drol9NSFMovDdiUfw3vGpOzMpyxRT+Wa49VEjIfemo7C+GUn7GFmtBW1ms8Y6bxT3NaZFK8tdQVWjI9mznE0woBtJ6Xj+w9VucmRRjE1LOjcikqXsSsmbSvwDgsgFARDTm7sw7OmJboIJacpdfr7VcCWROSTy+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7wm/XEf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7wm/XEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010531F000E9;
	Tue, 16 Jun 2026 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635955;
	bh=oWTTk0ud1skWDh+GBz8LXKuHXIo0mbdM6DQofqARkFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7wm/XEfzVLod6W/3RdZp7Di0hhaVZNlPh6i8jUSumfrWf7BL5fzHZ4H4S6iKSqt4
	 nM2yV37BkQGmKUxSMHBjo8Ng4GtxARVirRkVQXC4/z1m4dOe1zzCtR4qTDIJUG8Kna
	 9rp9OLpbqk6H4z5JKnwmg8cwK5bxSuFEi6GC0hiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f13c19f75e1097abd116@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/342] ieee802154: 6lowpan: only accept IPv6 packets in lowpan_xmit()
Date: Tue, 16 Jun 2026 20:27:23 +0530
Message-ID: <20260616145055.020874708@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



