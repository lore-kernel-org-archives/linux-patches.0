Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C943264D6;
	Fri,  7 Aug 2026 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115976; cv=none; b=ECXA7W1CYlXL73v3tLM26v6+5jOjja9PxF+Kun3IY+dA0rcZfKwx0fw2sx6vJlnsPGxQ8xnW1guft1W44hU8cMXeStR3JKqOZG5Tc7q28fSD3/oaUAk7DLrpP3thZUR0oM0y7dv3CeO7qySpmPfOSZgGCM+MOsWzgXxzOthZdLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115976; c=relaxed/simple;
	bh=kAhsMlIts/jjtQisi3rK+JzEEqDqrR/qMFsrL/0J4L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBKhTj6g45yVocjXgoToEyoy2PIj88SU1OjLtjCqI/DxzlkqNJz9tLyRl0OtEG0jq4K55rSO3VkfAL8LOD6KfhWIKGTMzcZl7FXFe3+bvEJ4ffGiecVAlJzt0pBOSr+WwueaOH4K2x2djjgiI5GhsYz1a56/i8suAccWCO72UQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOu1syaD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOu1syaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DA91F000E9;
	Fri,  7 Aug 2026 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115974;
	bh=efTBXsnm8z4B/8jOH8ZUXig2AFn8hO6AX0DlbgQSPJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOu1syaD1OPv7ecdaFlR8CJVT667ODNM7/9CaYOvBW8favhxEhDWbm+WUf4WD+WSs
	 Wr9SDqW8g5/z8ayDgaDGfYR+/I+gczFbVI5yMUUMpcouO1vCWQW6rglM+rpY/cdeUE
	 l0m7fc7y86rqOag57bEFTzUgK6Py5B6YpTG9mhUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/261] netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()
Date: Fri,  7 Aug 2026 16:36:20 +0200
Message-ID: <20260807143415.870432641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 852c0b74b8a77..4f975b83c84f6 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1629,7 +1629,7 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 	unsigned int matchoff, matchlen;
 	unsigned int msglen, origlen;
 	const char *dptr, *end;
-	s16 diff, tdiff = 0;
+	s32 diff, tdiff = 0;
 	int ret = NF_ACCEPT;
 	unsigned long clen;
 	bool term;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index f7be30c69b5c8..a1c41defaf22d 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -315,7 +315,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 }
 
 static void nf_nat_sip_seq_adjust(struct sk_buff *skb, unsigned int protoff,
-				  s16 off)
+				  s32 off)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
-- 
2.53.0



