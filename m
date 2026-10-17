Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4C538F233;
	Sat, 17 Oct 2026 17:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258518; cv=none; b=KJauoYpcIXACpwMGYCYxRr+UHG92CMHichUgGNBwJ7IlxLGOAmRoaqe2kUuiV/fXRMxrSgzBNv1ZYU0V3nX1KjZ487RA1jMB3GwZVJb80++hlYvka1TuW5/nv6uxhw+xN7icXJJBL4f20nagFFmy/TGiOLq33oKh3XVIcwdBSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258518; c=relaxed/simple;
	bh=YNxLGhyrAx/K5pKZ61tIe9qF53+bHG06nGOgQKadlqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=az3+aTuw4WTovCEnZZptNee3mar1+S2VThtUBkhALGdZisU06i72nFC6BuihVWPy4rDP1Gh5L2sj4ArbviP5icwD7FmNL8ZcOkiyCAh45GzXPovr1+FdX+uOiRlkDC4SYz5MFgJmupImnQBx7qRDqGCQtat++Vr1bQCsA219mTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsjJn2pu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsjJn2pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418B51F000C5;
	Sat, 17 Oct 2026 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258517;
	bh=0MbZgBaRMu1Z4/Vfy0YtzJslEQJb/tl/PKaGmnyAEmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsjJn2pu+2cRwwBuqBTO+UOrlqZLgdFCMt+BiotqwZhZ5ejUuwfs6REkm1MT40SZA
	 JnGJK8cfbQdVtPG4qI8XeIwGiqJqHAezdI6zs7dO9rPfFU6Q73x1JaedqJ3lg8RYsg
	 Cy9wPKwQNmzU2dvgXeWuQeaXZwbbp5k0bpyrZfaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0911/1674] ipv6: ioam: fix potential NULL dereferences in __ioam6_fill_trace_data()
Date: Sat, 17 Oct 2026 17:53:03 +0200
Message-ID: <20261017160454.517495983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4e65a8b8daa18d63255ec58964dd192c7fdd9f8b ]

We need to check __in6_dev_get() for possible NULL value, as
suggested by Yiming Qian.

Also add skb_dst_dev_rcu() instead of skb_dst_dev(),
and two missing READ_ONCE().

Note that @dev can't be NULL.

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260402101732.1188059-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 9bf3be3a26c5b..05d8d9a5b3537 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -650,6 +650,9 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_schema *sc,
 				    unsigned int sclen, bool is_input)
 {
+	/* Note: skb_dst_dev_rcu() can't be NULL at this point. */
+	struct net_device *dev = skb_dst_dev_rcu(skb);
+	struct inet6_dev *i_skb_dev, *idev;
 	struct timespec64 ts;
 	ktime_t tstamp;
 	u64 raw64;
@@ -660,13 +663,16 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	data = trace->data + trace->remlen * 4 - trace->nodelen * 4 - sclen * 4;
 
+	i_skb_dev = skb->dev ? __in6_dev_get(skb->dev) : NULL;
+	idev = __in6_dev_get(dev);
+
 	/* hop_lim and node_id */
 	if (trace->type.bit0) {
 		byte = ipv6_hdr(skb)->hop_limit;
 		if (is_input)
 			byte--;
 
-		raw32 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id;
+		raw32 = READ_ONCE(dev_net(dev)->ipv6.sysctl.ioam6_id);
 
 		*(__be32 *)data = cpu_to_be32((byte << 24) | raw32);
 		data += sizeof(__be32);
@@ -674,18 +680,18 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	/* ingress_if_id and egress_if_id */
 	if (trace->type.bit1) {
-		if (!skb->dev)
+		if (!i_skb_dev)
 			raw16 = IOAM6_U16_UNAVAILABLE;
 		else
-			raw16 = (__force u16)READ_ONCE(__in6_dev_get(skb->dev)->cnf.ioam6_id);
+			raw16 = (__force u16)READ_ONCE(i_skb_dev->cnf.ioam6_id);
 
 		*(__be16 *)data = cpu_to_be16(raw16);
 		data += sizeof(__be16);
 
-		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK)
+		if ((dev->flags & IFF_LOOPBACK) || !idev)
 			raw16 = IOAM6_U16_UNAVAILABLE;
 		else
-			raw16 = (__force u16)READ_ONCE(__in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id);
+			raw16 = (__force u16)READ_ONCE(idev->cnf.ioam6_id);
 
 		*(__be16 *)data = cpu_to_be16(raw16);
 		data += sizeof(__be16);
@@ -765,7 +771,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		if (is_input)
 			byte--;
 
-		raw64 = dev_net(skb_dst(skb)->dev)->ipv6.sysctl.ioam6_id_wide;
+		raw64 = READ_ONCE(dev_net(dev)->ipv6.sysctl.ioam6_id_wide);
 
 		*(__be64 *)data = cpu_to_be64(((u64)byte << 56) | raw64);
 		data += sizeof(__be64);
@@ -773,18 +779,18 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	/* ingress_if_id and egress_if_id (wide) */
 	if (trace->type.bit9) {
-		if (!skb->dev)
+		if (!i_skb_dev)
 			raw32 = IOAM6_U32_UNAVAILABLE;
 		else
-			raw32 = READ_ONCE(__in6_dev_get(skb->dev)->cnf.ioam6_id_wide);
+			raw32 = READ_ONCE(i_skb_dev->cnf.ioam6_id_wide);
 
 		*(__be32 *)data = cpu_to_be32(raw32);
 		data += sizeof(__be32);
 
-		if (skb_dst(skb)->dev->flags & IFF_LOOPBACK)
+		if ((dev->flags & IFF_LOOPBACK) || !idev)
 			raw32 = IOAM6_U32_UNAVAILABLE;
 		else
-			raw32 = READ_ONCE(__in6_dev_get(skb_dst(skb)->dev)->cnf.ioam6_id_wide);
+			raw32 = READ_ONCE(idev->cnf.ioam6_id_wide);
 
 		*(__be32 *)data = cpu_to_be32(raw32);
 		data += sizeof(__be32);
-- 
2.53.0



