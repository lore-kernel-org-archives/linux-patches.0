Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215893;
	b=NF89EBou3C+W304RoyHDtggNS/OAanhwoIkDen2gvYfpSu3DKeMV9cQlJxbVzjbUjSRp
	 YezZ6UcGSXsPhWSYEa2HFJYlkYGE0jf+V83CcT8YU99qH0uNaODncfb/Xr4gMDj/zjhvB
	 kXYkowpTfM2uYpFmpnPuLXxHWUeMkWAxOg6XJxxAPzqqKfElYfJPVIaBPl1pTYz0xNgVc
	 hzp5jokCNEonMT97LsSDwTaOJAO9G9BJ1o6SYnLIhMPXBoQW0sjsx6zJ5fRROwDJuLXid
	 ZRb7B1H3eGj0Zmrmmb6H7eIsnHUsteZE1wh+lJcP0jSsfHZnatB1dUF5rywlS0l16Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s2DLZFqMtJj6RPD9C+ipaGox3hY8Mt8+6pxSBPeiD8o=;
	b=cEgdPfQjO7/NbQkkWWgCN+sfmXivdaK2R/yOh+YNrzkAyBiCelJpYINrmRmpbHgqSywR
	 wLGHYTvF22/+LgOYrseFhL86V0FhKDemwqip74gA3uZ/URJ8sSBOBnU2DO6XoKU84JDzz
	 wfcs1C2ZT0TNpsCgNacWaijREaVracCmUh0VLJC8ktjK7UdHAqtLPBOp74/3iKkQkJzWa
	 dfDpIFlm5KKNMdtewDUDfEUcuN8g4EHoYJFfnF84O/2igpRygM+AKQF8conp7A3Nr3r4m
	 x4vXn4FbICDRP93ZFb00MKN/wkWQ4Pu2Eg9Oh/UsaXSfMWVdqos0C3OPXF1KqO9AfAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6CclT7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F1E606A31E;
	Wed, 28 Oct 2026 19:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X6CclT7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E931F01825;
	Wed, 28 Oct 2026 19:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215893;
	bh=s2DLZFqMtJj6RPD9C+ipaGox3hY8Mt8+6pxSBPeiD8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X6CclT7HTu+JbaoHHFTotA13nasTC5oSwiPIX8ldyZ6CBcavZhbpFCevuo0G9l0He
	 h4YD8bQ/GD3EzdwFGrAaxiav4/SeqCgGCLcxCNz5pbQfhWlR8seXfs4ycD5CDou12K
	 IqbplWZxCt6dyR8D6C/c3S7eK4khVI0QAtlkis9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1325/1887] netfilter: synproxy: drop packets if timestamp adjustment fails
Date: Wed, 28 Oct 2026 17:57:01 +0100
Message-ID: <20261028170529.580581651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 63d29ee95c4ab5976d660182d2e4733bb4a091d8 ]

If a packet was malformed or if skb_ensure_writable() failed, the
synproxy_tstamp_adjust() function returned 0 indicating an error but it
was ignored on the callers.

Make the function return a boolean instead to clarify the result and
drop the packet if synproxy_tstamp_adjust() failed due to ENOMEM from
skb_ensure_writable(). In addition, if there are malformed options, skip
the tstamp update but do not drop the packet as that should be done by
the policy directly.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 992c20bc8a4a ("netfilter: synproxy: fix unaligned memory access in timestamp adjustment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 500a90311ed50..fb071401d5c33 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -183,7 +183,7 @@ synproxy_check_timestamp_cookie(struct synproxy_options *opts)
 	opts->options |= opts->tsecr & (1 << 5) ? NF_SYNPROXY_OPT_ECN : 0;
 }
 
-static unsigned int
+static bool
 synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       struct tcphdr *th, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
@@ -193,13 +193,13 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 	__be32 *ptr, old;
 
 	if (synproxy->tsoff == 0)
-		return 1;
+		return true;
 
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + th->doff * 4;
 
 	if (skb_ensure_writable(skb, optend))
-		return 0;
+		return false;
 
 	th = (struct tcphdr *)(skb->data + protoff);
 
@@ -208,7 +208,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 
 		switch (op[0]) {
 		case TCPOPT_EOL:
-			return 1;
+			return true;
 		case TCPOPT_NOP:
 			optoff++;
 			continue;
@@ -216,7 +216,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 			if (optoff + 1 == optend ||
 			    optoff + op[1] > optend ||
 			    op[1] < 2)
-				return 0;
+				return true;
 			if (op[0] == TCPOPT_TIMESTAMP &&
 			    op[1] == TCPOLEN_TIMESTAMP) {
 				if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
@@ -232,12 +232,12 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return 1;
+				return true;
 			}
 			optoff += op[1];
 		}
 	}
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -748,7 +748,9 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	if (!synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy))
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, ENOMEM);
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv4_synproxy_hook);
@@ -1176,7 +1178,9 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	if (!synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy))
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, ENOMEM);
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv6_synproxy_hook);
-- 
2.53.0



