Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B1E44B69C;
	Tue, 16 Jun 2026 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625260; cv=none; b=GujMkEgiVeGzI9kJ+YPgUf2fo5WaZuoFna6MKsyvpE2pOP2PIc+Q9PQrLC6WJLOo1zjeP3mdYsMStzp+8HKkpDEvRN9X+lWna96SlIbXTbIc4cB4rvNJycYb9SSQrRSIIw4Rp8nDfzFw1oKK1awiI5KEMBlPLTbLBwGymdgUo00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625260; c=relaxed/simple;
	bh=WbEPC6EilZVNVUB3cB81ouG5d1nmWX7BvsB5uP+Y/MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGOKHqcEdGGu8l7euy4BqOH01jG0JSudRlYsIwY4BWkxsdVGgaa+pPcQg1J4lI4QDDC9pZtY3hsBKA2xl8J8GbehyK6QysB3VwcUgqDACPmCjRUtBtG1kPSHYFd5Ze50KKwoojjG1Cdx8y61Z2YxtVf+bUL2X/u4PuvCwKzMkWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9Hi+/jH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9Hi+/jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B35F1F000E9;
	Tue, 16 Jun 2026 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625257;
	bh=S7Ux1RQrjRbQan2jkk6OQbiB22TL5VKWQl0xZoSqVsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9Hi+/jH6uKeFeOM0JqfCo0fI519z2HnHDDvYDBGBEDTjoCh+6z7BIw/hdV4t0ku2
	 72/5fNAjgqtRSGLQ4q3Jy23DnRJ62KlhcQjEjwLIY8phrp8zKlC7tl0xhN3pCoemNu
	 L30Z7v8O1u8R04mG2t7PQFY+pldds0IgPACygMy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@google.com>,
	syzbot+6eb9ca986d80f6f88cf9@syzkaller.appspotmail.com,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/325] ipv6: sit: reload inner IPv6 header after GSO offloads
Date: Tue, 16 Jun 2026 20:28:23 +0530
Message-ID: <20260616145103.020327291@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit f0e42f0c4337b1f220de1ddd63f47197c7dee4de ]

ipip6_tunnel_xmit() caches the inner IPv6 header pointer at function
entry and continues using it after iptunnel_handle_offloads().

For GSO skbs, iptunnel_handle_offloads() calls skb_header_unclone().
When the skb header is cloned, skb_header_unclone() can call
pskb_expand_head(), which may move the skb head. The pskb_expand_head()
contract requires pointers into the skb header to be reloaded after the
call.

If the later skb_realloc_headroom() branch is not taken, SIT uses the
stale iph6 pointer to read the inner hop limit and DS field. That can
read from a freed skb head after the old head's remaining clone is
released.

Reload iph6 after the offload helper succeeds and before subsequent
reads from the inner IPv6 header. Keep the existing reload after
skb_realloc_headroom(), since that branch can also replace the skb.

Fixes: 14909664e4e1 ("sit: Setup and TX path for sit/UDP foo-over-udp encapsulation")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+6eb9ca986d80f6f88cf9@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20260605073448.6524-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index cf37ad9686e698..6a833ee665e9b4 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -960,6 +960,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		ip_rt_put(rt);
 		goto tx_error;
 	}
+	iph6 = ipv6_hdr(skb);
 
 	if (df) {
 		mtu = dst_mtu(&rt->dst) - t_hlen;
-- 
2.53.0



