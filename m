Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B6F215F49;
	Mon, 10 Mar 2025 18:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630598; cv=none; b=j+0StnjvAWuwVivpU4No36m9DArwGJPQOBryAl/qb+KxrHIf89kddmbTpQpJQoIGlZN5B9fAgY+6EVCAGrixbIcDzr/dCQ0QYp3ODn4VnsQzdDd6IK4+/ZDIDDrlXfQBExDPBihUTTf7P2CGZm0TB/KN3pwBo06V2IEQf9Pljj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630598; c=relaxed/simple;
	bh=DSqXEc0B4puV7ECrK1pI9BJyOyTj47mI4aawi4jlKe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q48a+gtbtrmIqEgUkKd9Jwo2dzOmgu+2h2/kcPuiTfh+4dcCRZJjS/tb1svS+SrV/fF0k3h9x8IwsX+n0/kbSgef5snvtt4pHFoWBoC8bIGQONQrXwF8rdUjw1Kp3a4c8RutHCG9VhNOJ5ZS92LMeuZXryihFLOVt9AIZLvaZQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jo8yRSVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jo8yRSVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8A4C4CEE5;
	Mon, 10 Mar 2025 18:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630597;
	bh=DSqXEc0B4puV7ECrK1pI9BJyOyTj47mI4aawi4jlKe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jo8yRSVtWL2oXPirzP71ExyjGQRF1bsAqmkhLFy8+XX23yK0JrrVhJQivaPfy2lWo
	 DnzAahIU+gkqkDeBZ/BrwFk983ah0GHWIQgRPw9/0uEColKP3t6ZhaOqo3PH0+l63C
	 VAZfM0nCryu9NBTvwaHnA9S2DvkBy3dbdOhEVLPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Zhang <dtzq01@gmail.com>,
	Yoshiki Komachi <komachi.yoshiki@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/620] flow_dissector: Fix port range key handling in BPF conversion
Date: Mon, 10 Mar 2025 18:05:16 +0100
Message-ID: <20250310170604.130542600@linuxfoundation.org>
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

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 69ab34f705fbfabcace64b5d53bb7a4450fac875 ]

Fix how port range keys are handled in __skb_flow_bpf_to_target() by:
- Separating PORTS and PORTS_RANGE key handling
- Using correct key_ports_range structure for range keys
- Properly initializing both key types independently

This ensures port range information is correctly stored in its dedicated
structure rather than incorrectly using the regular ports key structure.

Fixes: 59fb9b62fb6c ("flow_dissector: Fix to use new variables for port ranges in bpf hook")
Reported-by: Qiang Zhang <dtzq01@gmail.com>
Closes: https://lore.kernel.org/netdev/CAPx+-5uvFxkhkz4=j_Xuwkezjn9U6kzKTD5jz4tZ9msSJ0fOJA@mail.gmail.com/
Cc: Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://patch.msgid.link/20250218043210.732959-4-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 7dfc7ac0624d8..ba437cfcbe90f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -803,6 +803,7 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 				     struct flow_dissector *flow_dissector,
 				     void *target_container)
 {
+	struct flow_dissector_key_ports_range *key_ports_range = NULL;
 	struct flow_dissector_key_ports *key_ports = NULL;
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
@@ -847,20 +848,21 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 		key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 	}
 
-	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS))
+	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS)) {
 		key_ports = skb_flow_dissector_target(flow_dissector,
 						      FLOW_DISSECTOR_KEY_PORTS,
 						      target_container);
-	else if (dissector_uses_key(flow_dissector,
-				    FLOW_DISSECTOR_KEY_PORTS_RANGE))
-		key_ports = skb_flow_dissector_target(flow_dissector,
-						      FLOW_DISSECTOR_KEY_PORTS_RANGE,
-						      target_container);
-
-	if (key_ports) {
 		key_ports->src = flow_keys->sport;
 		key_ports->dst = flow_keys->dport;
 	}
+	if (dissector_uses_key(flow_dissector,
+			       FLOW_DISSECTOR_KEY_PORTS_RANGE)) {
+		key_ports_range = skb_flow_dissector_target(flow_dissector,
+							    FLOW_DISSECTOR_KEY_PORTS_RANGE,
+							    target_container);
+		key_ports_range->tp.src = flow_keys->sport;
+		key_ports_range->tp.dst = flow_keys->dport;
+	}
 
 	if (dissector_uses_key(flow_dissector,
 			       FLOW_DISSECTOR_KEY_FLOW_LABEL)) {
-- 
2.39.5



