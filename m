Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660CF1DFFB;
	Thu, 15 Aug 2024 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732491; cv=none; b=hVYVpFvCJgen8sNCmK/ujr/rM7wGH13HCZlrsS8Td7z5XXFHbXb/iQSo2g+nW10PNljzE1R5H0g9PZlX1IefrC+nI7XDAwhmYmvqBTmS3gsaQDQ6viJWh/d8Ma0XMR+nLbCc16G6/l/RjGMBJdL1pQOc/tHp1ZANXphDrI0iXiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732491; c=relaxed/simple;
	bh=leA0ExVy0qN8VkZyvN8CbqN3f6TBH4BECu1ArKBVSSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MseJD+8X10zcNunIjUsuqWnfE4Dt8GME8lO3Lt0Hwy8m1TXz7yLvc6SIUM5n8XblGaRo/dqFeA0lPDlBm5CxWc1UEOp0rTBX+OgyihkAB2IWrHHCQkrTbvShBDPURyUUHgFWwmLed6UD0rA9CIy47Hoq8oXpMim3K53OFigIYP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFCK+u+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFCK+u+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E55CC32786;
	Thu, 15 Aug 2024 14:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732490;
	bh=leA0ExVy0qN8VkZyvN8CbqN3f6TBH4BECu1ArKBVSSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFCK+u+jLsg+fRXrNSHRN+V9YL2Rp+nY98Kin6P9Heo+rBA3B1M/ePjY8UkA+ys/x
	 JaXQM/840yg6KqMDHmg04KSxcVV7AsU1SqHJCrQQC+XDmxIK9uIIwHYOHqo0yiM14w
	 YFzBG42uR2XvBHcs3XA3ATX/lD1Sl3VYMUixU3xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 196/352] ipv4: Fix incorrect source address in Record Route option
Date: Thu, 15 Aug 2024 15:24:22 +0200
Message-ID: <20240815131926.853945362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit cc73bbab4b1fb8a4f53a24645871dafa5f81266a ]

The Record Route IP option records the addresses of the routers that
routed the packet. In the case of forwarded packets, the kernel performs
a route lookup via fib_lookup() and fills in the preferred source
address of the matched route.

The lookup is performed with the DS field of the forwarded packet, but
using the RT_TOS() macro which only masks one of the two ECN bits. If
the packet is ECT(0) or CE, the matched route might be different than
the route via which the packet was forwarded as the input path masks
both of the ECN bits, resulting in the wrong address being filled in the
Record Route option.

Fix by masking both of the ECN bits.

Fixes: 8e36360ae876 ("ipv4: Remove route key identity dependencies in ip_rt_get_source().")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20240718123407.434778-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index b3b49d8b386d8..1eb1e4316ed6d 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1302,7 +1302,7 @@ void ip_rt_get_source(u8 *addr, struct sk_buff *skb, struct rtable *rt)
 		struct flowi4 fl4 = {
 			.daddr = iph->daddr,
 			.saddr = iph->saddr,
-			.flowi4_tos = RT_TOS(iph->tos),
+			.flowi4_tos = iph->tos & IPTOS_RT_MASK,
 			.flowi4_oif = rt->dst.dev->ifindex,
 			.flowi4_iif = skb->dev->ifindex,
 			.flowi4_mark = skb->mark,
-- 
2.43.0



