Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5B414BF89;
	Tue, 11 Mar 2025 15:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706114; cv=none; b=FHIPPHi8oO/xSi7H37fdiBySNrFGiFEgBxc+zhwyMnc40YH+GAMvD0Xc00PBGRvDWRDaThj/xUygFNudv6Y0Hsou9jDrQVviKvHe2sotaR/SriLQWBaOHTDGWtx5tq2F71kqwBF38nhMJhvgPMwqdYBfOpotJ8W0gxdFBtN0bXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706114; c=relaxed/simple;
	bh=OrT6x6EYLT7dQWd5f084i2XHWqJ/JASYfJhHMXenU6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3vajHwkN97FpY5D/wuCXq9l+TsZ+Gj5Xm5ogPgJNhouWuJtTeh0iT0rZAZN7XouT//973SzBlkO/JzJ6XmIJegOlmabqY/mykb5cpF8N7PfDMqbgGyykCWP5QRCBOTHLnfpjYW9AWGz28cgQKYS+U6PaRGX0i2r+4yj8t/otK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3r7qCzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3r7qCzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A97C4CEE9;
	Tue, 11 Mar 2025 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706113;
	bh=OrT6x6EYLT7dQWd5f084i2XHWqJ/JASYfJhHMXenU6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3r7qCzMYdr29WHsiNVJqPZsLgubn1A8nEnmpaCX0Kq/PhDesPZto+HbGsKEZH4h4
	 2jZ0ml41nO8Rvdqi2p1fFTGM6WWX2Yv6QMWh/S2gxUf8+GS55R2dHuZuEKvcs1VdOo
	 NmUFGZcXvt1eUzE/rW0IoYFfa+eX8Leq9Aq5kIY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
	Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 248/328] net: extract port range fields from fl_flow_key
Date: Tue, 11 Mar 2025 16:00:18 +0100
Message-ID: <20250311145724.767027530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 02171416c68eb..efd7987982a8c 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -158,6 +158,22 @@ struct flow_dissector_key_ports {
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
  *	@ports: type and code of ICMP header
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index c6f7bd22db609..dc4274dcdec7f 100644
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
@@ -90,6 +94,8 @@ void flow_rule_match_ip(const struct flow_rule *rule,
 			struct flow_match_ip *out);
 void flow_rule_match_ports(const struct flow_rule *rule,
 			   struct flow_match_ports *out);
+void flow_rule_match_ports_range(const struct flow_rule *rule,
+				 struct flow_match_ports_range *out);
 void flow_rule_match_tcp(const struct flow_rule *rule,
 			 struct flow_match_tcp *out);
 void flow_rule_match_icmp(const struct flow_rule *rule,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 45b6a59ac1243..3d54eca5960dc 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -97,6 +97,13 @@ void flow_rule_match_ports(const struct flow_rule *rule,
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
index c92318f68f92d..803107b30814e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -54,13 +54,7 @@ struct fl_flow_key {
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
 } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
 
-- 
2.39.5



