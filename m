Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66EE373BE1;
	Sat, 28 Feb 2026 17:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301535; cv=none; b=s45a2axr+GgNMupHWX6EblEEj6wg09l1QYUW9wkx4cKAI409kYg+gqI0EhX8HMKm3RUkoGWGWma8wvrI/3RVXysnCuJYDO0icFfIYOBLx3nlkqLNfM7de70gVcm4xg7e4e1eX/r/r3CFu8fb0x7kQMIovyF1x2P8txSdc5f1cvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301535; c=relaxed/simple;
	bh=ZMGr9zlLKvUGwFobXcT97WA+X/+/KbFE5hJxL/qb/Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIvzRbBGnrdJbTpF0WHJ1ySWgf1pYOrO/755JvTlwJqvRSpL23OiKRKUx03RGWsdHa4WjFMEPy+V37c87u//1+UlhxaokDARbyYEqfCjqQT/Ev/kptCUTl06Hr2Sot3Pis5VCDinPJ+bt2S/c4TR+m4YUFbI8Ul6faKKkKdogIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0GJ+33d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0GJ+33d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD642C19423;
	Sat, 28 Feb 2026 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301535;
	bh=ZMGr9zlLKvUGwFobXcT97WA+X/+/KbFE5hJxL/qb/Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0GJ+33dYjDAqHA9SOnSE/bdj2I1R44Hl5+CENilEP9I8yLHzJIC19hurmoqgIa1n
	 UoVXnwEf6zALmS+6+wAW5q+8cX9muHHS8k19S+s0FTlBHpNb/GMuMWzl9MqSm2VrIT
	 vNjuureovL2/0dyAe78BKFkO/EQbPOPkgZ7nLvOaff0KBjxECR9vg1sAEg2RYKTMcb
	 VH89t03mBLLexFrg0q8bZiPLZ56iHTjh5gQZNRra5aD8zpLp0b3+1JzgwVm2KzsE9T
	 vO4qQ8qFORcgWZDqxMpKv8CkOc57u0SDTmlsBFHUL9GfjxbeR9AwWFlbeXHUXPmpto
	 AAACOP0buy+2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qanux <qjx1298677004@gmail.com>,
	stable@vger.kernel.org,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 717/752] ipv6: ioam: fix heap buffer overflow in __ioam6_fill_trace_data()
Date: Sat, 28 Feb 2026 12:47:08 -0500
Message-ID: <20260228174750.1542406-717-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Qanux <qjx1298677004@gmail.com>

[ Upstream commit 6db8b56eed62baacaf37486e83378a72635c04cc ]

On the receive path, __ioam6_fill_trace_data() uses trace->nodelen
to decide how much data to write for each node. It trusts this field
as-is from the incoming packet, with no consistency check against
trace->type (the 24-bit field that tells which data items are
present). A crafted packet can set nodelen=0 while setting type bits
0-21, causing the function to write ~100 bytes past the allocated
region (into skb_shared_info), which corrupts adjacent heap memory
and leads to a kernel panic.

Add a shared helper ioam6_trace_compute_nodelen() in ioam6.c to
derive the expected nodelen from the type field, and use it:

  - in ioam6_iptunnel.c (send path, existing validation) to replace
    the open-coded computation;
  - in exthdrs.c (receive path, ipv6_hop_ioam) to drop packets whose
    nodelen is inconsistent with the type field, before any data is
    written.

Per RFC 9197, bits 12-21 are each short (4-octet) fields, so they
are included in IOAM6_MASK_SHORT_FIELDS (changed from 0xff100000 to
0xff1ffc00).

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Cc: stable@vger.kernel.org
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260211040412.86195-1-qjx1298677004@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ioam6.h       |  2 ++
 net/ipv6/exthdrs.c        |  5 +++++
 net/ipv6/ioam6.c          | 14 ++++++++++++++
 net/ipv6/ioam6_iptunnel.c | 10 +---------
 4 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/net/ioam6.h b/include/net/ioam6.h
index 2cbbee6e806aa..a75912fe247e6 100644
--- a/include/net/ioam6.h
+++ b/include/net/ioam6.h
@@ -60,6 +60,8 @@ void ioam6_fill_trace_data(struct sk_buff *skb,
 			   struct ioam6_trace_hdr *trace,
 			   bool is_input);
 
+u8 ioam6_trace_compute_nodelen(u32 trace_type);
+
 int ioam6_init(void);
 void ioam6_exit(void);
 
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 54088fa0c09d0..310836a0cf17b 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -931,6 +931,11 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 		if (hdr->opt_len < 2 + sizeof(*trace) + trace->remlen * 4)
 			goto drop;
 
+		/* Inconsistent Pre-allocated Trace header */
+		if (trace->nodelen !=
+		    ioam6_trace_compute_nodelen(be32_to_cpu(trace->type_be32)))
+			goto drop;
+
 		/* Ignore if the IOAM namespace is unknown */
 		ns = ioam6_namespace(dev_net(skb->dev), trace->namespace_id);
 		if (!ns)
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 9553a32000813..08b7ac8c99b7e 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -690,6 +690,20 @@ struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id)
 	return rhashtable_lookup_fast(&nsdata->namespaces, &id, rht_ns_params);
 }
 
+#define IOAM6_MASK_SHORT_FIELDS 0xff1ffc00
+#define IOAM6_MASK_WIDE_FIELDS  0x00e00000
+
+u8 ioam6_trace_compute_nodelen(u32 trace_type)
+{
+	u8 nodelen = hweight32(trace_type & IOAM6_MASK_SHORT_FIELDS)
+				* (sizeof(__be32) / 4);
+
+	nodelen += hweight32(trace_type & IOAM6_MASK_WIDE_FIELDS)
+				* (sizeof(__be64) / 4);
+
+	return nodelen;
+}
+
 static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_namespace *ns,
 				    struct ioam6_trace_hdr *trace,
diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index 1fe7894f14dd9..b9f6d892a566c 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -22,9 +22,6 @@
 #include <net/ip6_route.h>
 #include <net/addrconf.h>
 
-#define IOAM6_MASK_SHORT_FIELDS 0xff100000
-#define IOAM6_MASK_WIDE_FIELDS 0xe00000
-
 struct ioam6_lwt_encap {
 	struct ipv6_hopopt_hdr eh;
 	u8 pad[2];			/* 2-octet padding for 4n-alignment */
@@ -93,13 +90,8 @@ static bool ioam6_validate_trace_hdr(struct ioam6_trace_hdr *trace)
 	    trace->type.bit21 | trace->type.bit23)
 		return false;
 
-	trace->nodelen = 0;
 	fields = be32_to_cpu(trace->type_be32);
-
-	trace->nodelen += hweight32(fields & IOAM6_MASK_SHORT_FIELDS)
-				* (sizeof(__be32) / 4);
-	trace->nodelen += hweight32(fields & IOAM6_MASK_WIDE_FIELDS)
-				* (sizeof(__be64) / 4);
+	trace->nodelen = ioam6_trace_compute_nodelen(fields);
 
 	return true;
 }
-- 
2.51.0

