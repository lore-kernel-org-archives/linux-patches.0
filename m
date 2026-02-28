Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2641333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301809; cv=none; b=P0jsWNFjXZtVos8yH7DejpRGlv9jchFeRyRM6S28l1po8txvxiCsnwlxJY4POP9Hc8/JAf3kNiaI7Io30kIBDzNVW19fspt/mHNmC+JzarsfmNL/q3Qswv0FNzqGi34ybS3LBr87UMsCQQHTW0I+MJQjyJKotUN091P5kJiadHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301809; c=relaxed/simple;
	bh=C+R3tzi8fhGfdCQc9bMBib77qloTeNXBmgOATl7vvRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xb9vbvqy8t8Vm2qvxMqzQamjk559MxSO9jIwyq5dVeVeQgVxvfTqaoUpXXjxLYMCaFXX6ZhKYzMnyixV7t46cyHBqpjrYIsqcxITijVu5/IHnaJzbBd5D65ZAgbVAirQ+ATumw5y7EgthAo+b7Zr31LU8IVunU49P+upow2dkyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q1wBzIF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q1wBzIF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DECC116D0;
	Sat, 28 Feb 2026 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301809;
	bh=C+R3tzi8fhGfdCQc9bMBib77qloTeNXBmgOATl7vvRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1wBzIF0gNZT0PclHfqxPPV/p6PdjmSGR0/cJd+KpLm9ePEbQQr2y1yxejmvDYgOf
	 e0qJVZmsmeCLyCoXJ+alN1vD3mfiODUGLyGj+pmcsT+ddJFmXv0+7mGYeyOsiSs/o8
	 fKcveJnJLkuH77KVL8XRFqGuICqrMHCMstl/OwdmGjeYH5SHjR7hcfKtQFEp1hP/i4
	 ImO/nLQVWWL1fWzGfpWr6GpcBreXz02X7s6KwoeMxLlzMeDYOUmctWwHs/MBA+4rIn
	 +QvYPGVruxofPAlJQNV+7lPy06RIB5htajaRtuUF3u0gMsIxJkGPeQx5xG/YauJyGL
	 wm1kY9u4a749g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Dumazet <edumazet@google.com>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/385] inet: RAW sockets using IPPROTO_RAW MUST drop incoming ICMP
Date: Sat, 28 Feb 2026 12:57:24 -0500
Message-ID: <20260228180011.1568201-222-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c89477ad79446867394360b29bb801010fc3ff22 ]

Yizhou Zhao reported that simply having one RAW socket on protocol
IPPROTO_RAW (255) was dangerous.

  socket(AF_INET, SOCK_RAW, 255);

A malicious incoming ICMP packet can set the protocol field to 255
and match this socket, leading to FNHE cache changes.

inner = IP(src="192.168.2.1", dst="8.8.8.8", proto=255)/Raw("TEST")
pkt = IP(src="192.168.1.1", dst="192.168.2.1")/ICMP(type=3, code=4, nexthopmtu=576)/inner

"man 7 raw" states:

  A protocol of IPPROTO_RAW implies enabled IP_HDRINCL and is able
  to send any IP protocol that is specified in the passed header.
  Receiving of all IP protocols via IPPROTO_RAW is not possible
  using raw sockets.

Make sure we drop these malicious packets.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/netdev/20251109134600.292125-1-zhaoyz24@mails.tsinghua.edu.cn/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260203192509.682208-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 14 ++++++++++----
 net/ipv6/icmp.c |  6 ++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 508b23204edc5..c0373d1172d73 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -840,16 +840,22 @@ static void icmp_socket_deliver(struct sk_buff *skb, u32 info)
 	/* Checkin full IP header plus 8 bytes of protocol to
 	 * avoid additional coding at protocol handlers.
 	 */
-	if (!pskb_may_pull(skb, iph->ihl * 4 + 8)) {
-		__ICMP_INC_STATS(dev_net_rcu(skb->dev), ICMP_MIB_INERRORS);
-		return;
-	}
+	if (!pskb_may_pull(skb, iph->ihl * 4 + 8))
+		goto out;
+
+	/* IPPROTO_RAW sockets are not supposed to receive anything. */
+	if (protocol == IPPROTO_RAW)
+		goto out;
 
 	raw_icmp_error(skb, protocol, info);
 
 	ipprot = rcu_dereference(inet_protos[protocol]);
 	if (ipprot && ipprot->err_handler)
 		ipprot->err_handler(skb, info);
+	return;
+
+out:
+	__ICMP_INC_STATS(dev_net_rcu(skb->dev), ICMP_MIB_INERRORS);
 }
 
 static bool icmp_tag_validation(int proto)
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 13a796bfc2f93..c8609147fce89 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -871,6 +871,12 @@ enum skb_drop_reason icmpv6_notify(struct sk_buff *skb, u8 type,
 	if (reason != SKB_NOT_DROPPED_YET)
 		goto out;
 
+	if (nexthdr == IPPROTO_RAW) {
+		/* Add a more specific reason later ? */
+		reason = SKB_DROP_REASON_NOT_SPECIFIED;
+		goto out;
+	}
+
 	/* BUGGG_FUTURE: we should try to parse exthdrs in this packet.
 	   Without this we will not able f.e. to make source routed
 	   pmtu discovery.
-- 
2.51.0

