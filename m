Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31942D5A19;
	Mon, 13 Apr 2026 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098040; cv=none; b=NImD0NZ74N3OD/fLwBpQ9yvX2qOreNNEpfYjzuFDli3yu9SK8AEppGE1VlzGlI/QrfGQdEOe7tPSeZyV2Owvps2oC3C0hD4h80Cg8HAWC+oX9z2OsCsFHhqOJL//VExIoh9pQVLZtd8Bcd/NlR7btmD7bAOw+qqR4ljtQsgDMPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098040; c=relaxed/simple;
	bh=SSIzTnI7y3mh9onqT2Uni7janyT4a+wqQ0kfG896N/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMtEJTv5MkeM39Itd9C/tRLPenRbDuNvzoQL8KLM2DNeBs4rDrTPLezUFTvSwrCOzxbsodhSXAr4uPDnAzQ9yoT7bisdWO2VJ4x3ez0zctujOB99y1Wb68oWwwaUfnMHJ/IQx7v2ESEk4hccQdvN4Tn+c5t0gVYSS0WRgjmgK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWeby28h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWeby28h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BA1C2BCAF;
	Mon, 13 Apr 2026 16:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098040;
	bh=SSIzTnI7y3mh9onqT2Uni7janyT4a+wqQ0kfG896N/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWeby28hh+2l1aauIbqPpAyzH+JI3zRn5/ei/CUVqJrlYI0zY35EXItvRuTsGfy7T
	 c2KvCtDqiEKTp84QqBQil3v3tdL9eaOXYtubqpnUn8kYfVKughp0dSrfkwzPIfWQt1
	 3FUijX0LimhEAs8InHkWdUJ53K+GF7UTVs6iIunI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/570] netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp
Date: Mon, 13 Apr 2026 17:57:48 +0200
Message-ID: <20260413155843.117591449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 6a2b724460cb67caed500c508c2ae5cf012e4db4 ]

process_sdp() declares union nf_inet_addr rtp_addr on the stack and
passes it to the nf_nat_sip sdp_session hook after walking the SDP
media descriptions. However rtp_addr is only initialized inside the
media loop when a recognized media type with a non-zero port is found.

If the SDP body contains no m= lines, only inactive media sections
(m=audio 0 ...) or only unrecognized media types, rtp_addr is never
assigned. Despite that, the function still calls hooks->sdp_session()
with &rtp_addr, causing nf_nat_sdp_session() to format the stale stack
value as an IP address and rewrite the SDP session owner and connection
lines with it.

With CONFIG_INIT_STACK_ALL_ZERO (default on most distributions) this
results in the session-level o= and c= addresses being rewritten to
0.0.0.0 for inactive SDP sessions. Without stack auto-init the
rewritten address is whatever happened to be on the stack.

Fix this by pre-initializing rtp_addr from the session-level connection
address (caddr) when available, and tracking via a have_rtp_addr flag
whether any valid address was established. Skip the sdp_session hook
entirely when no valid address exists.

Fixes: 4ab9e64e5e3c ("[NETFILTER]: nf_nat_sip: split up SDP mangling")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5db17768ec2ad..dcb0a5e592775 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1040,6 +1040,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 	unsigned int port;
 	const struct sdp_media_type *t;
 	int ret = NF_ACCEPT;
+	bool have_rtp_addr = false;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
 
@@ -1056,8 +1057,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 	caddr_len = 0;
 	if (ct_sip_parse_sdp_addr(ct, *dptr, sdpoff, *datalen,
 				  SDP_HDR_CONNECTION, SDP_HDR_MEDIA,
-				  &matchoff, &matchlen, &caddr) > 0)
+				  &matchoff, &matchlen, &caddr) > 0) {
 		caddr_len = matchlen;
+		memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
+		have_rtp_addr = true;
+	}
 
 	mediaoff = sdpoff;
 	for (i = 0; i < ARRAY_SIZE(sdp_media_types); ) {
@@ -1091,9 +1095,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 					  &matchoff, &matchlen, &maddr) > 0) {
 			maddr_len = matchlen;
 			memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
-		} else if (caddr_len)
+			have_rtp_addr = true;
+		} else if (caddr_len) {
 			memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
-		else {
+			have_rtp_addr = true;
+		} else {
 			nf_ct_helper_log(skb, ct, "cannot parse SDP message");
 			return NF_DROP;
 		}
@@ -1125,7 +1131,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 
 	/* Update session connection and owner addresses */
 	hooks = rcu_dereference(nf_nat_sip_hooks);
-	if (hooks && ct->status & IPS_NAT_MASK)
+	if (hooks && ct->status & IPS_NAT_MASK && have_rtp_addr)
 		ret = hooks->sdp_session(skb, protoff, dataoff,
 					 dptr, datalen, sdpoff,
 					 &rtp_addr);
-- 
2.51.0



