Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C125EF93;
	Tue, 11 Mar 2025 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707289; cv=none; b=YrYIpZ7lVOiPPFIh42MsMUhxPxCCvftevyBFygtW1Auf5gBCHZTOs/6Alr8nE30D5DDNiyYV2r7kEYYp2krDo87pV+ZBda0foDHgHnp9c+s10Dapa9qGHeTYujexrO94y2gSfyHvoMtfuRl7W/6m2rlxDgRWGe4s/cEcsZGFk8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707289; c=relaxed/simple;
	bh=h2RfLOm71xx5kmdQA8R1tVdK3SxG86KVtVPf6T0DNF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJLeCjF1WaLFNKHUtUEIjLGJg2xXZ3DzWflIuQ0l9LZcAwRLzTgZkiwj4ISvNbPYGO1qbdxpUlQrcl4HtmorjjaXYcxv+dF7YcKrU0umZ+ni0qnzuaROB1DMXpluz6Q73of6iAG3HySnQVuOguO+jfI59u8MWxtYco4UFoJH350=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z86nqHk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z86nqHk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E39C4CEE9;
	Tue, 11 Mar 2025 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707289;
	bh=h2RfLOm71xx5kmdQA8R1tVdK3SxG86KVtVPf6T0DNF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z86nqHk+uPsjXVOIuifk9zcJXSNZ5hDt62UUnb+RmhmJjG8Vn34MXVoGRsEgc661p
	 3xOPAeeYq1xpXtxvLWLB/AXPNa6FVBjFun4IHyYVk/m6KvPe0Pl6DdpMcY8rBY98c/
	 fbeVeRuKGpshbOM2EiRASvbs/GFQ8JA6afbtqfcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
	Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/462] net: extract port range fields from fl_flow_key
Date: Tue, 11 Mar 2025 16:00:04 +0100
Message-ID: <20250311145811.719197859@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5eecf44369659..4036063d047c2 100644
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
index 9a58274e62173..1ecb19a7ab071 100644
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
index 8d958290b7d22..1e618398b9e81 100644
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
index 10d3dde238c6c..98f333aa0aac9 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -61,13 +61,7 @@ struct fl_flow_key {
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



