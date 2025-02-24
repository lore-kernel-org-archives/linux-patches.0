Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10D138DD8;
	Mon, 24 Feb 2025 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408919; cv=none; b=uTjsHilRn4/i7nWixhlFbewYH0YyddvX2/gAq9AGR8GpDD2D+GZhOv5FC61A7c4f/y+CbHDDcSn4ThD5VdAdgHy/CyOBztA2mSdG8Wb1vgA5DJGOL+Cw729JFrM+XDuIFMRTg8gHXCsHewM/eUYmAV772Rwd6wmVGFTm2jaTs5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408919; c=relaxed/simple;
	bh=1u/tAxgP4nhwwGdRXFQwwwmTGTO6q/3fan/9MlfXR28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuCJ2VZoNu3e9NzLQGQfRSquxbmKtQLTlUkl13PSSdLQVzXJvCKlX9u/xX0+53zUjhr1EISMcwIhrkHRQ9hXiq2rDxYcxGtKfmVWGI8jKIVASemQ8fAD3E0SX4soYzcUsZJy8nTzM4Fsb/bXlNs61wMCADwX8RqMHz1T0RKoZB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4JQP0Zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4JQP0Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C9AC4CEE6;
	Mon, 24 Feb 2025 14:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408918;
	bh=1u/tAxgP4nhwwGdRXFQwwwmTGTO6q/3fan/9MlfXR28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4JQP0ZwF4HMeQXG98hGi/lY7I1iwpL/OYN8p0rfzdza31nI96a5aI37v2JCT3ynk
	 gbRRCgRJNQ6dUYoCyWTFaBY/3qyLCx47VIi/8j8C1if4FgfzDNPH/ZgmGq32ASGap5
	 uR0r31BBY2gLcE4nfW3Uwjkn+yhm26Jlyjxs4l+E=
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
Subject: [PATCH 6.13 043/138] flow_dissector: Fix port range key handling in BPF conversion
Date: Mon, 24 Feb 2025 15:34:33 +0100
Message-ID: <20250224142606.163478333@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c33af3ef0b790..9cd8de6bebb54 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -931,6 +931,7 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 				     struct flow_dissector *flow_dissector,
 				     void *target_container)
 {
+	struct flow_dissector_key_ports_range *key_ports_range = NULL;
 	struct flow_dissector_key_ports *key_ports = NULL;
 	struct flow_dissector_key_control *key_control;
 	struct flow_dissector_key_basic *key_basic;
@@ -975,20 +976,21 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
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



