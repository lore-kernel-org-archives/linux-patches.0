Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E05361DDC;
	Sat, 12 Sep 2026 09:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205128; cv=none; b=POP9jnNaDUXwV8OsYXwX5cQOrWHqBAmGoMBr6vMSYr5Y5XEctRKK4QO6LCB+zUrEqwQcUrpQ1fiEuVDdophnSO1wKj5QpJPngmwGqk3T76A4wFcTnCN3EFxv0iJrw0WHOA3vQBKGJfmnk0FexZweK9CF2fb4l62niJFtTBd8ae4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205128; c=relaxed/simple;
	bh=G7mu2MX88DKxYu5HGiPwe/ATGtlIkGCaiRcxDUK10MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1WXpm3TEjxEoyufVTlU2rYkcyk8n6WOGmVcUcSwsRh9AA4VmypjS6BgjfXF0EbERyn+9iBIR+WReFlYFlNg9bTZ0z9dn9Tl/cN/iMrZhK4xD+7+F8fJatSH91bCxR7yFmprZKs1cYFJZt7qCeEXg6WW5zsb79Ws5enmqNk2Dao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUW4Yhoj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUW4Yhoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC601F000FF;
	Sat, 12 Sep 2026 09:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205126;
	bh=9lAalTjG0NmC0vM1be6GH7S7fTKNqyCW0F9veCdX5VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUW4Yhojs7Mf6LrZQ7Ma4VCxMC/0MnWgWz+frCirBeLbM4CZLZhwqwgeM9waxJpMA
	 9db15bsYeqwqNVmJ4RZOtK/LHadYUCclrXnnCJb3cTIQ0rQ6VcFIfyDsSotLc2h1YP
	 oipOKZ8r+EM/1kMPL0e17i2HZyAb0GpMi4JlSbeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d56f14f95c0480cfdc9@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1755/1815] net/sched: act_skbmod: fix length calculations and avoid invalid header warnings
Date: Sat, 12 Sep 2026 08:58:25 +0200
Message-ID: <20260912065730.189536643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 81d0d1e64f30d9989c829c0953cd6e6c68d9c5fb ]

syzbot reported a warning in skb_network_header_len() triggered
by tcf_skbmod_act():

  !skb_transport_header_was_set(skb)
  WARNING: CPU: 0 PID: 14949 at include/linux/skbuff.h:3243 skb_network_header_len include/linux/skbuff.h:3243 [inline]
  WARNING: CPU: 0 PID: 14949 at net/sched/act_skbmod.c:55 tcf_skbmod_act+0xfe8/0x1810 net/sched/act_skbmod.c:55

There are a few issues in tcf_skbmod_act():

1. Calling skb_network_header_len() assumes skb->transport_header is set,
   which is not guaranteed when tcf_skbmod_act() runs at TC ingress.
2. Unconditionally calling skb_mac_header_len() at the beginning of
   tcf_skbmod_act() triggers a warning on L3 devices (e.g. TUN) where the
   MAC header is unset, evaluating to an underflowed garbage length.
3. On TC ingress, skb->data points to the network header. Adding the MAC
   header length to the IP header length causes skb_ensure_writable() to
   request more bytes than the actual IP packet length, dropping valid
   short packets (e.g. 28-byte UDP/IPv4 packets).

Fix these by:
- Using skb_network_offset(skb) + sizeof(struct iphdr/ipv6hdr) for
  SKBMOD_F_ECN so that the required length is correctly calculated on
  both ingress (offset == 0) and egress (offset == mac_len).
- Setting max_edit_len to ETH_HLEN for Ethernet header modifications
  after validating ARPHRD_ETHER.

Fixes: 56af5e749f20 ("net/sched: act_skbmod: Add SKBMOD_F_ECN option support")
Reported-by: syzbot+1d56f14f95c0480cfdc9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a8b39c0.dbb3a75c.13dd47.0051.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260823182241.1958695-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_skbmod.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index a464b0a3c1b81..7579cf1e0ff37 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -38,7 +38,6 @@ TC_INDIRECT_SCOPE int tcf_skbmod_act(struct sk_buff *skb,
 	if (unlikely(p->action == TC_ACT_SHOT))
 		goto drop;
 
-	max_edit_len = skb_mac_header_len(skb);
 	flags = p->flags;
 
 	/* tcf_skbmod_init() guarantees "flags" to be one of the following:
@@ -51,14 +50,19 @@ TC_INDIRECT_SCOPE int tcf_skbmod_act(struct sk_buff *skb,
 	if (flags == SKBMOD_F_ECN) {
 		switch (skb_protocol(skb, true)) {
 		case cpu_to_be16(ETH_P_IP):
+			max_edit_len = sizeof(struct iphdr);
+			break;
 		case cpu_to_be16(ETH_P_IPV6):
-			max_edit_len += skb_network_header_len(skb);
+			max_edit_len = sizeof(struct ipv6hdr);
 			break;
 		default:
 			goto out;
 		}
-	} else if (!skb->dev || skb->dev->type != ARPHRD_ETHER) {
-		goto out;
+		max_edit_len += skb_network_offset(skb);
+	} else {
+		if (!skb->dev || skb->dev->type != ARPHRD_ETHER)
+			goto out;
+		max_edit_len = ETH_HLEN;
 	}
 
 	err = skb_ensure_writable(skb, max_edit_len);
-- 
2.53.0



