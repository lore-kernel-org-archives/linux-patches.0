Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D46415F2C;
	Tue, 21 Jul 2026 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656316; cv=none; b=O/Q/wsXDgAs8Hxgsx9yyiNbkvv0FrUQ3fCCVZPW9Y3ZfL4uai29iIH7nRxNWq1BUyBRm2Q6YWFFRba3zVnkgg4OCoGSOFz9ne8lgcesUGn6akhIQlPPb39m6/eQMk5EfNAc/Imo+dwoP82OX456pBeP8F6WKCwM+uFsLY2o1HaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656316; c=relaxed/simple;
	bh=UOH9YHsxoFX9ASjBIInLHuFrUvbSIlkThIXwQ6C+qE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3XOdhGviYrfEGEUw9/nkY9gPd8Chq0fhd2F2fgOE8nmWuRcclR8l8hdKIx4lfWPXRjnr1iOr23RXnqx4sXWi4uI6FNo6asS2nc2Ma4J6teGCbKaDnK639ER9U3VL+OqxbGJExnbqsZ4nDOamaZd0xffct1EklywB8tt2jbECRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSpnmJGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSpnmJGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77B21F000E9;
	Tue, 21 Jul 2026 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656315;
	bh=/NZaZJA/Q2vKLjQXuLnboHRktX3k9zQkiVlAWjl4Pik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSpnmJGQHNt/ZQ6FlW+7urOlOIS7JRVJyA0sLUuka1SCG58m4lqr+lWf5u7BJFnAL
	 kA4Vl+V1GVxkstlEwoUUADRYECn4Gm3HD5GTY+x70OxXsfG0K59ZE527epiHeuA6a6
	 BG4PPjEsIUPr/r4/jOaA4Hj2O67vU+RsM3sf1sCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0342/1611] netfilter: synproxy: drop packets if timestamp adjustment fails
Date: Tue, 21 Jul 2026 17:07:38 +0200
Message-ID: <20260721152522.814102932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index a277b2bd3275dc..a90511238ec378 100644
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



