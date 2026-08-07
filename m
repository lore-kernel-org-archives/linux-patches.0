Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1748442393;
	Fri,  7 Aug 2026 14:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114750; cv=none; b=rRhzKOY8zfSV13bGFjLWnu7R8W8U9r7/Aa4Ur3CHH7+zIx9Zeif2om1a4cYC8HSTf6EXTqwCGCrXWSVfDa3jOHM5rVE2d0GMa9TeMELJKNQSwwQwnOh86tiCz+9OyZT+3Re7VXNQShQ021kZB5NC4Hudl7SNDStbbtiBqm8Uqgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114750; c=relaxed/simple;
	bh=7seHCYEXGNXBJBRz4JqPmYACbqrZKzeeB4NmTLSBp2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVQEqgfnMvpAIgGkauCE041gIm7OvI+sl31rQ2alnNhU/olFsIDWd7NStWJv8jUfukJtA3AdaggxTPTvR9uFnx+eYojDrzECk+SsI6FID0UjdmboSmxkIKPyg5uNgKtK3v5FyplajoMGBVmuP2/KMNRV9IJnQxV1lhHE6lhrv2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI0/5qyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI0/5qyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2746F1F00A3A;
	Fri,  7 Aug 2026 14:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114749;
	bh=If98PnwYJmphFUfEHW/JYOW7zGCN59am6dJ8aHBkV4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qI0/5qylBMCqsO02goThvBK/omXJB9es1EQkGzP+GE4rh+QOaDyTOUB0N2bveT12V
	 aZgndF2b/YGVTwLW0Tih/vFxh04/LveWbKKKm3yWBbzC+8d13N/uP2XY1/RrPhmUEO
	 UA8n+YsuHrgcGg7G+o/KRMFFBVOFOUYbk5GxR8no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/396] netfilter: nf_conntrack_sip: widen NAT rewrite delta to s32 in sip_help_tcp()
Date: Fri,  7 Aug 2026 16:33:14 +0200
Message-ID: <20260807143425.009136604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
index 4bebf66410ea3..f5f9bd47d2889 100644
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



