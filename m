Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC32AD3C;
	Sat, 12 Sep 2026 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232040; cv=none; b=R83qs9aPbNQQsduaQWsziOBKXDVRhxmVDJu2vBfkxcwCvIXbM/+LJi6ST8fsQef9QuhXpgSLMrRVbcaJ+H2l8Xwjnlsvy6u5ODj5AB43g/ER1hc0f5ghT363P8UxJfTduBTiy5ro2ylCuW4aSiZXJIh0TskpIUzoOmgY5beJd2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232040; c=relaxed/simple;
	bh=p6MyDHeved2HA/eSNo78bRHHLVweE8z+xlkJy2jcnzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJUcxZ0SDXjq6hfDXn+BzbnRqIQER886zYkxXSHnQMpnS3NnsTlKm4lNr8aIo72+uG7ECGX4z0QqFCwPboQWqoGTIuq65wMPf/J1nVRFsbwFMWg7RqhJXKdtNT+zFKgt339hAlUpMAt1eCihzHCVLQXKFiu2Ll0VT4CnRLx8vG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIZy44yR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIZy44yR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B681F000FF;
	Sat, 12 Sep 2026 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232039;
	bh=7Nq+OfV/8pi03zbNQ9DwMN8CxCfDlSUgUJ3xw7vfTWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SIZy44yRjtgnFvqYXUQJpWKTuItkclQp3s5m87AkA6aEykONVfupv8VHdoAmx9AME
	 l0tjpL1bY/9FfHDfY1Olx1MRd4Ba5v678UQYauscsQ3EabiyL4KzEU4KjQGeaa/wdt
	 5mFJjnVlSMFfTIM7Fg7hCGbzI/2kIL6m7+UPGqcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d56f14f95c0480cfdc9@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1104/1191] net/sched: act_skbmod: fix length calculations and avoid invalid header warnings
Date: Sat, 12 Sep 2026 09:03:52 +0200
Message-ID: <20260912065612.949547796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 94a18d029b28a..83994eee0b6ae 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -36,7 +36,6 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 	if (unlikely(p->action == TC_ACT_SHOT))
 		goto drop;
 
-	max_edit_len = skb_mac_header_len(skb);
 	flags = p->flags;
 
 	/* tcf_skbmod_init() guarantees "flags" to be one of the following:
@@ -49,14 +48,19 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
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



