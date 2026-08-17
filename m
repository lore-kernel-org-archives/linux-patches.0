Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0150282F29;
	Mon, 17 Aug 2026 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979336; cv=none; b=SYjB5Y6Ep1/vKhuo1lUACQKfp3vxnRiwplu9OqaGHE/Ol9vpt2psemOzTkn9TKJEbq3jKJk3mW+i3UFYi6LgQ92P+UtBaZYWi2BR4VdNJMaLGd7TaGKJDG8Qa9wkDfk+7i8QOXYHEceXDSWVB8tNvq43h+LNMfYAg3ZkJpNAI2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979336; c=relaxed/simple;
	bh=ZG3NGlpNgtXhqX6HvTeZ1su8iIy5XsosaHx4TLZj2qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMUskXZYhrp40KMRkyxo5w3nX1NpdXRdvhKZYjcH/KnqiRdyQXg9q/t19Ffb2LAbxg1NzYHvQspuIC/XIxtZOySdnLnjhuQDg4kGVxfpVmXaim88KbETD2a6Y2kKFmW343aA57I6Xuo1p45e8pyzT3C/rbCvidvisS39ArhWL+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM7Iu7BQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM7Iu7BQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBF11F000E9;
	Mon, 17 Aug 2026 15:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979334;
	bh=vTqzc59zBJknQEpQQYCIA1qRKTGbhxsILVQIS1UIqnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM7Iu7BQYnvTg1RrEBAzjmiZe0WGHoeLTb+iHOlsJV86eri73RDo6s2jhL8l+9OWi
	 ryI1ye2u66nak+vHycc2XLK2ms6D1Ign9ZOMSNKnGMOuyQnsehWYcWckI9VmdOa1Uu
	 XfVu/KK0g48eBjkXrmfVaTfC2BZzPLOfNc6wnFG8=
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
Subject: [PATCH 6.1 153/609] net: stmmac: fix l3l4 filter rejecting unsupported offload requests
Date: Mon, 17 Aug 2026 15:27:29 +0200
Message-ID: <20260817132549.131492878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 27187f5286206a..6bf198b3f12369 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -456,6 +456,7 @@ static int tc_parse_flow_actions(struct stmmac_priv *priv,
 }
 
 #define ETHER_TYPE_FULL_MASK	cpu_to_be16(~0)
+#define IP_PROTO_FULL_MASK	0xFF
 
 static int tc_add_basic_flow(struct stmmac_priv *priv,
 			     struct flow_cls_offload *cls,
@@ -471,6 +472,37 @@ static int tc_add_basic_flow(struct stmmac_priv *priv,
 
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
@@ -608,6 +640,8 @@ static int tc_add_flow(struct stmmac_priv *priv,
 		ret = tc_flow_parsers[i].fn(priv, cls, entry);
 		if (!ret)
 			entry->in_use = true;
+		else if (ret == -EOPNOTSUPP)
+			return ret;
 	}
 
 	if (!entry->in_use)
-- 
2.53.0



