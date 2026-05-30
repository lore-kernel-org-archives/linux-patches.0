Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FB314A62B;
	Sat, 30 May 2026 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161807; cv=none; b=N8n9Z7X2SY66BREprIMBga+/wKrXBDOzDcHDT+d0cyqDg9yr1MKpr/xlIpeU2wy5uZh0Mw+cA2PaeMQahcLBzmJA4eS0NToMh4kuYPss50tVfYtF69EqVLfNsCm9W8S4UoeyilsX0XOBzj5TMbgmcTtUo4raNRUL1/XzrNIkBSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161807; c=relaxed/simple;
	bh=+snHpONMoM9Uf9EtVxWVbQrdizS254xNr2Xq5IGQZ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btXYsO+OlzKnA04xKBaL0cifC1ziJMfiXDecWFE0Ns6XyBphopbBkV0C3aLG5zXrXUmrvYkQFHPRfTLF2qQLEUo77ZLApA6eqy/AB47H3d7NhCyRbJcA2pDX4gESBgcYsuv2uVtVpI7lNXNKmhEaWcwtIETinVZuueOuKl7IsKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/juPFN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/juPFN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5639F1F00893;
	Sat, 30 May 2026 17:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161806;
	bh=Jyw2tUks6L13D5SHK098JqLEbH1EeiYW+9iUBggv6To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/juPFN+ULfcrbSg7iAMqsk0M0wjYB3ukoz2bvI8zv8xsXF/oehzBnJGORACtdTvS
	 Q+1E204fJCcjX/Hs8uM7vXKFd4S7twyV2mma7SIH41CPtqza5sBzV/BKQ1WgNedECP
	 3Tywn0nh3kjXwq10q1aksmHnpdPflOww1tUHSx3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 702/969] netfilter: conntrack: remove sprintf usage
Date: Sat, 30 May 2026 18:03:46 +0200
Message-ID: <20260530160319.904106272@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6e7066bdb481a87fe88c4fa563e348c03b2d373d ]

Replace it with scnprintf, the buffer sizes are expected to be large enough
to hold the result, no need for snprintf+overflow check.

Increase buffer size in mangle_content_len() while at it.

BUG: KASAN: stack-out-of-bounds in vsnprintf+0xea5/0x1270
Write of size 1 at addr [..]
 vsnprintf+0xea5/0x1270
 sprintf+0xb1/0xe0
 mangle_content_len+0x1ac/0x280
 nf_nat_sdp_session+0x1cc/0x240
 process_sdp+0x8f8/0xb80
 process_invite_request+0x108/0x2b0
 process_sip_msg+0x5da/0xf50
 sip_help_tcp+0x45e/0x780
 nf_confirm+0x34d/0x990
 [..]

Fixes: 9fafcd7b2032 ("[NETFILTER]: nf_conntrack/nf_nat: add SIP helper port")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_amanda.c |  2 +-
 net/netfilter/nf_nat_sip.c    | 33 ++++++++++++++++++---------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 98deef6cde694..8f1054920a857 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -50,7 +50,7 @@ static unsigned int help(struct sk_buff *skb,
 		return NF_DROP;
 	}
 
-	sprintf(buffer, "%u", port);
+	snprintf(buffer, sizeof(buffer), "%u", port);
 	if (!nf_nat_mangle_udp_packet(skb, exp->master, ctinfo,
 				      protoff, matchoff, matchlen,
 				      buffer, strlen(buffer))) {
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index cf4aeb299bdef..c845b6d1a2bdf 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -68,25 +68,27 @@ static unsigned int mangle_packet(struct sk_buff *skb, unsigned int protoff,
 }
 
 static int sip_sprintf_addr(const struct nf_conn *ct, char *buffer,
+			    size_t size,
 			    const union nf_inet_addr *addr, bool delim)
 {
 	if (nf_ct_l3num(ct) == NFPROTO_IPV4)
-		return sprintf(buffer, "%pI4", &addr->ip);
+		return scnprintf(buffer, size, "%pI4", &addr->ip);
 	else {
 		if (delim)
-			return sprintf(buffer, "[%pI6c]", &addr->ip6);
+			return scnprintf(buffer, size, "[%pI6c]", &addr->ip6);
 		else
-			return sprintf(buffer, "%pI6c", &addr->ip6);
+			return scnprintf(buffer, size, "%pI6c", &addr->ip6);
 	}
 }
 
 static int sip_sprintf_addr_port(const struct nf_conn *ct, char *buffer,
+				 size_t size,
 				 const union nf_inet_addr *addr, u16 port)
 {
 	if (nf_ct_l3num(ct) == NFPROTO_IPV4)
-		return sprintf(buffer, "%pI4:%u", &addr->ip, port);
+		return scnprintf(buffer, size, "%pI4:%u", &addr->ip, port);
 	else
-		return sprintf(buffer, "[%pI6c]:%u", &addr->ip6, port);
+		return scnprintf(buffer, size, "[%pI6c]:%u", &addr->ip6, port);
 }
 
 static int map_addr(struct sk_buff *skb, unsigned int protoff,
@@ -119,7 +121,7 @@ static int map_addr(struct sk_buff *skb, unsigned int protoff,
 	if (nf_inet_addr_cmp(&newaddr, addr) && newport == port)
 		return 1;
 
-	buflen = sip_sprintf_addr_port(ct, buffer, &newaddr, ntohs(newport));
+	buflen = sip_sprintf_addr_port(ct, buffer, sizeof(buffer), &newaddr, ntohs(newport));
 	return mangle_packet(skb, protoff, dataoff, dptr, datalen,
 			     matchoff, matchlen, buffer, buflen);
 }
@@ -212,7 +214,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 					       &addr, true) > 0 &&
 		    nf_inet_addr_cmp(&addr, &ct->tuplehash[dir].tuple.src.u3) &&
 		    !nf_inet_addr_cmp(&addr, &ct->tuplehash[!dir].tuple.dst.u3)) {
-			buflen = sip_sprintf_addr(ct, buffer,
+			buflen = sip_sprintf_addr(ct, buffer, sizeof(buffer),
 					&ct->tuplehash[!dir].tuple.dst.u3,
 					true);
 			if (!mangle_packet(skb, protoff, dataoff, dptr, datalen,
@@ -229,7 +231,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 					       &addr, false) > 0 &&
 		    nf_inet_addr_cmp(&addr, &ct->tuplehash[dir].tuple.dst.u3) &&
 		    !nf_inet_addr_cmp(&addr, &ct->tuplehash[!dir].tuple.src.u3)) {
-			buflen = sip_sprintf_addr(ct, buffer,
+			buflen = sip_sprintf_addr(ct, buffer, sizeof(buffer),
 					&ct->tuplehash[!dir].tuple.src.u3,
 					false);
 			if (!mangle_packet(skb, protoff, dataoff, dptr, datalen,
@@ -247,7 +249,7 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 		    htons(n) == ct->tuplehash[dir].tuple.dst.u.udp.port &&
 		    htons(n) != ct->tuplehash[!dir].tuple.src.u.udp.port) {
 			__be16 p = ct->tuplehash[!dir].tuple.src.u.udp.port;
-			buflen = sprintf(buffer, "%u", ntohs(p));
+			buflen = scnprintf(buffer, sizeof(buffer), "%u", ntohs(p));
 			if (!mangle_packet(skb, protoff, dataoff, dptr, datalen,
 					   poff, plen, buffer, buflen)) {
 				nf_ct_helper_log(skb, ct, "cannot mangle rport");
@@ -418,7 +420,8 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 
 	if (!nf_inet_addr_cmp(&exp->tuple.dst.u3, &exp->saved_addr) ||
 	    exp->tuple.dst.u.udp.port != exp->saved_proto.udp.port) {
-		buflen = sip_sprintf_addr_port(ct, buffer, &newaddr, port);
+		buflen = sip_sprintf_addr_port(ct, buffer, sizeof(buffer),
+					       &newaddr, port);
 		if (!mangle_packet(skb, protoff, dataoff, dptr, datalen,
 				   matchoff, matchlen, buffer, buflen)) {
 			nf_ct_helper_log(skb, ct, "cannot mangle packet");
@@ -438,8 +441,8 @@ static int mangle_content_len(struct sk_buff *skb, unsigned int protoff,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	char buffer[sizeof("4294967295")];
 	unsigned int matchoff, matchlen;
-	char buffer[sizeof("65536")];
 	int buflen, c_len;
 
 	/* Get actual SDP length */
@@ -454,7 +457,7 @@ static int mangle_content_len(struct sk_buff *skb, unsigned int protoff,
 			      &matchoff, &matchlen) <= 0)
 		return 0;
 
-	buflen = sprintf(buffer, "%u", c_len);
+	buflen = scnprintf(buffer, sizeof(buffer), "%u", c_len);
 	return mangle_packet(skb, protoff, dataoff, dptr, datalen,
 			     matchoff, matchlen, buffer, buflen);
 }
@@ -491,7 +494,7 @@ static unsigned int nf_nat_sdp_addr(struct sk_buff *skb, unsigned int protoff,
 	char buffer[INET6_ADDRSTRLEN];
 	unsigned int buflen;
 
-	buflen = sip_sprintf_addr(ct, buffer, addr, false);
+	buflen = sip_sprintf_addr(ct, buffer, sizeof(buffer), addr, false);
 	if (mangle_sdp_packet(skb, protoff, dataoff, dptr, datalen,
 			      sdpoff, type, term, buffer, buflen))
 		return 0;
@@ -509,7 +512,7 @@ static unsigned int nf_nat_sdp_port(struct sk_buff *skb, unsigned int protoff,
 	char buffer[sizeof("nnnnn")];
 	unsigned int buflen;
 
-	buflen = sprintf(buffer, "%u", port);
+	buflen = scnprintf(buffer, sizeof(buffer), "%u", port);
 	if (!mangle_packet(skb, protoff, dataoff, dptr, datalen,
 			   matchoff, matchlen, buffer, buflen))
 		return 0;
@@ -529,7 +532,7 @@ static unsigned int nf_nat_sdp_session(struct sk_buff *skb, unsigned int protoff
 	unsigned int buflen;
 
 	/* Mangle session description owner and contact addresses */
-	buflen = sip_sprintf_addr(ct, buffer, addr, false);
+	buflen = sip_sprintf_addr(ct, buffer, sizeof(buffer), addr, false);
 	if (mangle_sdp_packet(skb, protoff, dataoff, dptr, datalen, sdpoff,
 			      SDP_HDR_OWNER, SDP_HDR_MEDIA, buffer, buflen))
 		return 0;
-- 
2.53.0



