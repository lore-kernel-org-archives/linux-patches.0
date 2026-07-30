Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C232F442119;
	Thu, 30 Jul 2026 14:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422230; cv=none; b=N2zN3PunWTeJys1qqk9cdNNJYo0setKwYLToUcn3yYaTcRChnIlMTRj2Yf0jpRcKyqBUesWmthD/fFWhxfDGEqz2LTxjsm80Phpz/OYblL87CACwwVMxnBqhr1/WvFU2QvDa1TSXklY0F+uhsaMHr5y96/BOEixjQJwTpjIXli0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422230; c=relaxed/simple;
	bh=ySiPW2VRJgOlnsbCm/elX1/s5B3WzbctJATev1OwOtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TN3ehwNLmFp12oePX1D7vmjmnXM75c27NjzXTfKZx1C6cerZrmvlOvrrSYUtF1nOv9nNKQ7nnex0yBzyRYXZdx07YpDK4YeA1KixGFjwDvbntO4Uet5fn3b9Qir9eE1wos4JX8XReO3KkcEbBryLbjYNHo/cAzkDJk64o6DOEVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUfWXpae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUfWXpae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288AC1F000E9;
	Thu, 30 Jul 2026 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422229;
	bh=iVFT18oxJQ2he/9/xpmWdx6U2ckkWFUqBOtSE2vc6gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUfWXpaezqZJd2jShU8tAtK/Yd830/tcCclaBhq1fMM+Pa7z4JdvDUts2WfMHT/Nv
	 mJB7fo9SDOGJTlDbd2hwHDDQi64s+FQzuqkNkBRRZ/otCy6JRhibPTCPCd3qcWa3Y3
	 Uqj7gYHJBDDer5Iz2kOb0GXYeYbeuH01LkfzVurI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 323/744] net: stmmac: fix l3l4 filter rejecting unsupported offload requests
Date: Thu, 30 Jul 2026 16:09:56 +0200
Message-ID: <20260730141451.150821556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>

[ Upstream commit 5536d7c843637e9430279b94935fcf7df98babb3 ]

The basic flow parser in tc_add_basic_flow() does not validate match
keys before proceeding. Unsupported offload configurations such as
partial protocol masks, non-IPv4 network proto, or non-TCP/UDP transport
proto are silently accepted instead of returning -EOPNOTSUPP.

Add validation to return -EOPNOTSUPP early for:
- No network or transport proto present in the key
- Partial protocol mask (only full mask supported)
- Network proto is not IPv4
- Transport proto is not TCP or UDP

Each rejection includes an extack message so the user knows which part
of the match is unsupported.

Also propagate -EOPNOTSUPP from tc_add_basic_flow() in tc_add_flow()
by returning it directly rather than using break. The break was silently
discarding the error for FLOW_CLS_REPLACE operations where entry->in_use
is already true, causing tc_add_flow() to return 0 (success) for
unsupported replace requests.

Fixes: 425eabddaf0f ("net: stmmac: Implement L3/L4 Filters using TC Flower")
Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Signed-off-by: Nazim Amirul <muhammad.nazim.amirul.nazle.asmade@altera.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260714023716.29865-4-muhammad.nazim.amirul.nazle.asmade@altera.com
Reviewed-by: Jakub Raczynski <j.raczynski@samsung.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index d786527185999d..1f8c9f47306b97 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -446,6 +446,7 @@ static int tc_parse_flow_actions(struct stmmac_priv *priv,
 }
 
 #define ETHER_TYPE_FULL_MASK	cpu_to_be16(~0)
+#define IP_PROTO_FULL_MASK	0xFF
 
 static int tc_add_basic_flow(struct stmmac_priv *priv,
 			     struct flow_cls_offload *cls,
@@ -461,6 +462,37 @@ static int tc_add_basic_flow(struct stmmac_priv *priv,
 
 	flow_rule_match_basic(rule, &match);
 
+	/* Both network proto and transport proto not present in the key */
+	if (!match.mask || !(match.mask->n_proto || match.mask->ip_proto)) {
+		NL_SET_ERR_MSG_MOD(cls->common.extack,
+				   "filter must specify network or transport protocol");
+		return -EOPNOTSUPP;
+	}
+
+	/* If the proto is present in the key and is not full mask */
+	if ((match.mask->n_proto && match.mask->n_proto != ETHER_TYPE_FULL_MASK) ||
+	    (match.mask->ip_proto && match.mask->ip_proto != IP_PROTO_FULL_MASK)) {
+		NL_SET_ERR_MSG_MOD(cls->common.extack,
+				   "only full protocol mask is supported");
+		return -EOPNOTSUPP;
+	}
+
+	/* Network proto is present in the key and is not IPv4 */
+	if (match.mask->n_proto && match.key->n_proto != cpu_to_be16(ETH_P_IP)) {
+		NL_SET_ERR_MSG_MOD(cls->common.extack,
+				   "only IPv4 network protocol is supported");
+		return -EOPNOTSUPP;
+	}
+
+	/* Transport proto is present in the key and is not TCP or UDP */
+	if (match.mask->ip_proto &&
+	    match.key->ip_proto != IPPROTO_TCP &&
+	    match.key->ip_proto != IPPROTO_UDP) {
+		NL_SET_ERR_MSG_MOD(cls->common.extack,
+				   "only TCP and UDP transport protocols are supported");
+		return -EOPNOTSUPP;
+	}
+
 	entry->ip_proto = match.key->ip_proto;
 	return 0;
 }
@@ -598,6 +630,8 @@ static int tc_add_flow(struct stmmac_priv *priv,
 		ret = tc_flow_parsers[i].fn(priv, cls, entry);
 		if (!ret)
 			entry->in_use = true;
+		else if (ret == -EOPNOTSUPP)
+			return ret;
 	}
 
 	if (!entry->in_use)
-- 
2.53.0



