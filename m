Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3902356D3;
	Mon, 10 Mar 2025 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630591; cv=none; b=XcmXF5SKyio6xRTkSRZxOHZt81W5T6q6k2+uWMszGknphi0NIl4x10+nSbCSfanTvIshuCkwY6zyuxEhyCGzPO5il+tadYZayPVGPKOcORZqs3erAiMkI/xBSpLsYyT5RXICWTxnlIviu2c+FVL9S+a4/pbe78u52Wmeed1hkEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630591; c=relaxed/simple;
	bh=A2j9whO/U10vPRoaH0bwTSsdJwkEcLGxlCV12uO+Yqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G92Z1h9Spzf74xvb0NSXKbq/U3umnPuImjjAFcxoRuD1D24oY7uJFA4FVeCBavZV7sdKtBTQbL+xV6t3ABE/ONPgT1262IH5lUyc9gUs19GRyhYOKDKizOGq4Wrr++WD75WDKptE4R9xca2eBaPR/k17TDIQ5PaRYOcakAi7SWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YpzPUhhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YpzPUhhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EA0C4CEED;
	Mon, 10 Mar 2025 18:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630591;
	bh=A2j9whO/U10vPRoaH0bwTSsdJwkEcLGxlCV12uO+Yqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YpzPUhhwcE6wPo4W66/OOhas2k0WgbOUTuJaNXstGieuGVhig6DCldpGi+CWHWnV5
	 KGIldK5Qomug/o07K2DiGUVqa/eZYV3bDiyq+foasiypMuPr7dASjbYeMdm6sOyKL2
	 h1HfMgITQEHlmP1x3JAmPbRgMhFNSgI9jWunwE40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
	Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 468/620] net: extract port range fields from fl_flow_key
Date: Mon, 10 Mar 2025 18:05:14 +0100
Message-ID: <20250310170604.051811219@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maksym Glubokiy <maksym.glubokiy@plvision.eu>

[ Upstream commit 83d85bb069152b790caad905fa53e6d50cd3734d ]

So it can be used for port range filter offloading.

Co-developed-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 3e5796862c69 ("flow_dissector: Fix handling of mixed port and port-range keys")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_dissector.h | 16 ++++++++++++++++
 include/net/flow_offload.h   |  6 ++++++
 net/core/flow_offload.c      |  7 +++++++
 net/sched/cls_flower.c       |  8 +-------
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index c8d1c5e187e4b..8d0d0cf93a785 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -178,6 +178,22 @@ struct flow_dissector_key_ports {
 	};
 };
 
+/**
+ * struct flow_dissector_key_ports_range
+ * @tp: port number from packet
+ * @tp_min: min port number in range
+ * @tp_max: max port number in range
+ */
+struct flow_dissector_key_ports_range {
+	union {
+		struct flow_dissector_key_ports tp;
+		struct {
+			struct flow_dissector_key_ports tp_min;
+			struct flow_dissector_key_ports tp_max;
+		};
+	};
+};
+
 /**
  * flow_dissector_key_icmp:
  *		type: ICMP type
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 7a2b0223a02c7..41f8dcd3505c1 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -48,6 +48,10 @@ struct flow_match_ports {
 	struct flow_dissector_key_ports *key, *mask;
 };
 
+struct flow_match_ports_range {
+	struct flow_dissector_key_ports_range *key, *mask;
+};
+
 struct flow_match_icmp {
 	struct flow_dissector_key_icmp *key, *mask;
 };
@@ -94,6 +98,8 @@ void flow_rule_match_ip(const struct flow_rule *rule,
 			struct flow_match_ip *out);
 void flow_rule_match_ports(const struct flow_rule *rule,
 			   struct flow_match_ports *out);
+void flow_rule_match_ports_range(const struct flow_rule *rule,
+				 struct flow_match_ports_range *out);
 void flow_rule_match_tcp(const struct flow_rule *rule,
 			 struct flow_match_tcp *out);
 void flow_rule_match_icmp(const struct flow_rule *rule,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index fb11103fa8afc..d8f19f4080f4a 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -104,6 +104,13 @@ void flow_rule_match_ports(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_ports);
 
+void flow_rule_match_ports_range(const struct flow_rule *rule,
+				 struct flow_match_ports_range *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_PORTS_RANGE, out);
+}
+EXPORT_SYMBOL(flow_rule_match_ports_range);
+
 void flow_rule_match_tcp(const struct flow_rule *rule,
 			 struct flow_match_tcp *out)
 {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 057612c97a372..35842b51a24e2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -62,13 +62,7 @@ struct fl_flow_key {
 	struct flow_dissector_key_ip ip;
 	struct flow_dissector_key_ip enc_ip;
 	struct flow_dissector_key_enc_opts enc_opts;
-	union {
-		struct flow_dissector_key_ports tp;
-		struct {
-			struct flow_dissector_key_ports tp_min;
-			struct flow_dissector_key_ports tp_max;
-		};
-	} tp_range;
+	struct flow_dissector_key_ports_range tp_range;
 	struct flow_dissector_key_ct ct;
 	struct flow_dissector_key_hash hash;
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
-- 
2.39.5



