Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B1B2512E9;
	Wed,  5 Mar 2025 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197146; cv=none; b=ZRVZkqfPidD9BMVWD/88ZsDXUX4352SEY33uzRp5Uh2TPEyRhPpwm03swSNPhm8+3UEJPOKN6RS2GaDM81g1NXcxhYHbTWXVYhtysc2RWFYX7TjdUoH6ur+6Mf220pUhz7mKD+GUflqTjfGU9HBmXRfo3OIoJAQZPFCQUAS1RSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197146; c=relaxed/simple;
	bh=Y7LCavz28HqblkhlFLW91l5AWcvUFlwf+KxlY1RXpKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4N00HP9FsRc/xI0vuGKg1xzS45A5bWT3C/qUSe3AK2VgG0nrI52tXo0OFxDa1KtvEy83SIfqTkF65xUTr48GmzHPlcLpSu9Lln/ekmnUlkfNSTwHPLXhxDPwHIxny39n4vIm4jxtm6X27zX/MJI2rDn/9hT+fUf4Fa7LWIqD4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuNu258q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuNu258q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2856EC4CED1;
	Wed,  5 Mar 2025 17:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197146;
	bh=Y7LCavz28HqblkhlFLW91l5AWcvUFlwf+KxlY1RXpKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AuNu258q6LNZ7blD4PFhwJ5ZcPfpm2WO0Qa20LVMpnZpwkh3/N6VHq8JtzQbdI+dt
	 GT6Xh05odu/pmWkf0+jB7MyzRm/4j9Y5TzBpWzihovoStaKArIAQLpepiT3hFSxJpw
	 9xBxDuzsAXE/UDqKDhzy2ZHGOjJsjjrSmch7B48w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Zhang <dtzq01@gmail.com>,
	Yoshiki Komachi <komachi.yoshiki@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/176] flow_dissector: Fix handling of mixed port and port-range keys
Date: Wed,  5 Mar 2025 18:47:04 +0100
Message-ID: <20250305174507.667866321@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 3e5796862c692ea608d96f0a1437f9290f44953a ]

This patch fixes a bug in TC flower filter where rules combining a
specific destination port with a source port range weren't working
correctly.

The specific case was when users tried to configure rules like:

tc filter add dev ens38 ingress protocol ip flower ip_proto udp \
dst_port 5000 src_port 2000-3000 action drop

The root cause was in the flow dissector code. While both
FLOW_DISSECTOR_KEY_PORTS and FLOW_DISSECTOR_KEY_PORTS_RANGE flags
were being set correctly in the classifier, the __skb_flow_dissect_ports()
function was only populating one of them: whichever came first in
the enum check. This meant that when the code needed both a specific
port and a port range, one of them would be left as 0, causing the
filter to not match packets as expected.

Fix it by removing the either/or logic and instead checking and
populating both key types independently when they're in use.

Fixes: 8ffb055beae5 ("cls_flower: Fix the behavior using port ranges with hw-offload")
Reported-by: Qiang Zhang <dtzq01@gmail.com>
Closes: https://lore.kernel.org/netdev/CAPx+-5uvFxkhkz4=j_Xuwkezjn9U6kzKTD5jz4tZ9msSJ0fOJA@mail.gmail.com/
Cc: Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250218043210.732959-2-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index de17f13232381..41ad5c1cccf64 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -751,23 +751,30 @@ __skb_flow_dissect_ports(const struct sk_buff *skb,
 			 void *target_container, const void *data,
 			 int nhoff, u8 ip_proto, int hlen)
 {
-	enum flow_dissector_key_id dissector_ports = FLOW_DISSECTOR_KEY_MAX;
-	struct flow_dissector_key_ports *key_ports;
+	struct flow_dissector_key_ports_range *key_ports_range = NULL;
+	struct flow_dissector_key_ports *key_ports = NULL;
+	__be32 ports;
 
 	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS))
-		dissector_ports = FLOW_DISSECTOR_KEY_PORTS;
-	else if (dissector_uses_key(flow_dissector,
-				    FLOW_DISSECTOR_KEY_PORTS_RANGE))
-		dissector_ports = FLOW_DISSECTOR_KEY_PORTS_RANGE;
+		key_ports = skb_flow_dissector_target(flow_dissector,
+						      FLOW_DISSECTOR_KEY_PORTS,
+						      target_container);
 
-	if (dissector_ports == FLOW_DISSECTOR_KEY_MAX)
+	if (dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_PORTS_RANGE))
+		key_ports_range = skb_flow_dissector_target(flow_dissector,
+							    FLOW_DISSECTOR_KEY_PORTS_RANGE,
+							    target_container);
+
+	if (!key_ports && !key_ports_range)
 		return;
 
-	key_ports = skb_flow_dissector_target(flow_dissector,
-					      dissector_ports,
-					      target_container);
-	key_ports->ports = __skb_flow_get_ports(skb, nhoff, ip_proto,
-						data, hlen);
+	ports = __skb_flow_get_ports(skb, nhoff, ip_proto, data, hlen);
+
+	if (key_ports)
+		key_ports->ports = ports;
+
+	if (key_ports_range)
+		key_ports_range->tp.ports = ports;
 }
 
 static void
-- 
2.39.5



