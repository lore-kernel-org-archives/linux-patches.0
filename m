Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A2397958;
	Fri,  7 Aug 2026 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116633; cv=none; b=t2kzFWlAUtgdN+dx2svxieSSqzAkoI+ltWTsNN7oakFeg+JsQLAyohpJ80fy4eByOYmOMldddslgHZVJ/+xJwQT5qszkiq2kEId1uOGcDJAE7TkToBjQ5//xb3tY8wxQ1yIbOLrhWt/nM3EiM+fHVBX3CKxvNV9J1WzV3dCmJCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116633; c=relaxed/simple;
	bh=xdC0/c6U2eZb9ilWV9zPI832xvzmnR+5xX6PT2hxGCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EC/dZDMv4FbgrG6J/0Y1W9HFk5A4cO/tBAyMPzGI7djbQDicxvlhwpFBSr4EOVSzsCdbAzIgL0ROyHlOH1kW4yFSQN4vM8iVvj7hNmlJLsttlQcnb1l73c0IeeAVaSzWAbKylfcliScVJmwbTtzgyH9vEyuXmo/Qq5lUfSSRnEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgC9RfEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgC9RfEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D381F000E9;
	Fri,  7 Aug 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116631;
	bh=zt6lVAqsXk5LluWq7y+5EWnD7CDpNI7qmOtIz5LBSxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgC9RfEW3vNP6UKaZ3NATRyMpvogPyiEzzH/YXEWWR3Tb1dyU23erzq5L2LTzWZZm
	 t6CZLlo3Y97Xzp9BrSG58ecfM5cDqwXKdvWOOY8jRpblohbsA+ssGEcvMTJeIFuGIZ
	 Qyw9e0eWB25+bUZSYtYktvm9bkO6f8iLgLc8q60w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 037/438] netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()
Date: Fri,  7 Aug 2026 16:33:53 +0200
Message-ID: <20260807143428.796609477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit db3d0e0e5d4bc5ab4fe445b9f413d1b486508ca5 ]

sip_help_tcp() stores the size change of each NAT-rewritten SIP message
in s16 diff and accumulates it in s16 tdiff, but a single message can
grow by more than S16_MAX while the packet stays under the 65535
enlarge_skb() limit: nf_nat_sip() rewrites every matching URI, and a long
Contact list expands the message by tens of kilobytes. diff then wraps,
and "datalen = datalen + diff - msglen" yields a huge unsigned datalen,
so the next iteration's ct_sip_get_header() reads past the linearized skb
tail.

Widen diff, tdiff and the seq_adjust hook to s32. Both are bounded by the
65535 byte packet limit, and the seqadj core is already s32
(nf_ct_seqadj_set() takes s32), so no previously accepted input is
rejected.

  BUG: KASAN: use-after-free in ct_sip_get_header (net/netfilter/nf_conntrack_sip.c:464)
  Read of size 1 at addr ffff888010800000 by task ksoftirqd/1/25
   ct_sip_get_header (net/netfilter/nf_conntrack_sip.c:464)
   sip_help_tcp (net/netfilter/nf_conntrack_sip.c:1694)
   nf_confirm (net/netfilter/nf_conntrack_proto.c:183)
   nf_hook_slow (net/netfilter/core.c:619)
   ip6_output (net/ipv6/ip6_output.c:246)
   ip6_forward (net/ipv6/ip6_output.c:690)
   ipv6_rcv (net/ipv6/ip6_input.c:351)
   __netif_receive_skb_one_core (net/core/dev.c:6212)
   process_backlog (net/core/dev.c:6676)
   __napi_poll (net/core/dev.c:7735)
   net_rx_action (net/core/dev.c:7955)
   handle_softirqs (kernel/softirq.c:622)
   run_ksoftirqd (kernel/softirq.c:1076)
   ...

Fixes: f5b321bd37fb ("netfilter: nf_conntrack_sip: add TCP support")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/netfilter-devel/20260712234201.3213635-1-xmei5@asu.edu
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/nf_conntrack_sip.h | 2 +-
 net/netfilter/nf_conntrack_sip.c           | 2 +-
 net/netfilter/nf_nat_sip.c                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index dbc614dfe0d56..aafa0c04f917e 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -115,7 +115,7 @@ struct nf_nat_sip_hooks {
 			    unsigned int *datalen);
 
 	void (*seq_adjust)(struct sk_buff *skb,
-			   unsigned int protoff, s16 off);
+			   unsigned int protoff, s32 off);
 
 	unsigned int (*expect)(struct sk_buff *skb,
 			       unsigned int protoff,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f3f90a8663389..e4a70d1d77b0b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1663,7 +1663,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 	unsigned int matchoff, matchlen;
 	unsigned int msglen, origlen;
 	const char *dptr, *end;
-	s16 diff, tdiff = 0;
+	s32 diff, tdiff = 0;
 	int ret = NF_ACCEPT;
 	unsigned long clen;
 	bool term;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aea02f6aff092..a93eaf0f7d305 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -321,7 +321,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 }
 
 static void nf_nat_sip_seq_adjust(struct sk_buff *skb, unsigned int protoff,
-				  s16 off)
+				  s32 off)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-- 
2.53.0



