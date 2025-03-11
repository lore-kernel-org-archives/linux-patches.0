Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A468325BAA1;
	Tue, 11 Mar 2025 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706119; cv=none; b=qhnNPU+OJzQbMDzv71vriduwBHjppqS/ViYzP/pFxIULvflAVOODV8bSKaSJyjuD45xZl8dJvIGGCbkHXtduirulZgM3F301tRHwDtFdjxpXjwb9iYdneNyo2M/7lx9HrDPzchhIWTK10IowIpdq/uxWNaa2U0+cNZUTDlFpgt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706119; c=relaxed/simple;
	bh=RZk/e2qtZhBvN2GrV38ahQjNqhaQnqtsL/YYVvxMZ1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjNLQ/bn2E6AjIhiZquORXlgFOHSsoBTH5dGLXuPBtyFZJrv6J0KX7B39i2F/HrqCJZPhfvKeAvsblnU6hXWE0sauVVwL5INFRCgQg50j8M3ciMeqRsTQHeeKIgr3Mc9jVIhJsJ1RZXdAcmWcsfXaltsPtWKDRm9hFjWANy8gX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eELqtjjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eELqtjjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6D4C4CEE9;
	Tue, 11 Mar 2025 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706119;
	bh=RZk/e2qtZhBvN2GrV38ahQjNqhaQnqtsL/YYVvxMZ1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eELqtjjjTIscd42oVpsMk0FOE1IUoE8iyGqCW/BW6YIHKdj77SB8584CbPKCBS9D9
	 h2sFoOdt2NF/EhkiXG1vxaHWoWeucYM4W5ZiQo4erFUCejw+gP+MBHi/2wSrb5x02X
	 vL9hkPu3+S70mDavZCbAmbu+zTjO8YcD0CNyI3gA=
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
Subject: [PATCH 5.4 250/328] flow_dissector: Fix port range key handling in BPF conversion
Date: Tue, 11 Mar 2025 16:00:20 +0100
Message-ID: <20250311145724.846729640@linuxfoundation.org>
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
index f4cc3710be94a..96d2635aaae07 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -781,6 +781,7 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 				     struct flow_dissector *flow_dissector,
 				     void *target_container)
 {
+	struct flow_dissector_key_ports_range *key_ports_range = NULL;
 	struct flow_dissector_key_ports *key_ports = NULL;
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
@@ -825,20 +826,21 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
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



