Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D62E2665;
	Mon, 20 Apr 2026 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700893; cv=none; b=WcN4oPJ4Nx9yAoc70d7YNffE6opj8ZYybaalVpNskLDLp1NPOTKQOowxNMpGOI70xOEhLcf6hGpAU2WrfcGz0ImlFcett20P98T+CDZyGyt433YmLcFbSA6xC5fhC+9C3bAxm5clYaQjK8xg+JPiW7Qk+vVYFoApESCJUUIDcHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700893; c=relaxed/simple;
	bh=NziIoVr6CJT6SiabbZdsyWZCZ2Y6Y/3+505Vf4IJ0D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCPSZ2+w3ii119xRwdJLjPAfy3ZZu7edzTQs+jq7e8ux9MQ6qgNHZP/43HH5soPMWzR7gCYjaILsP/VGDXrYANAYLDFDj+YZihup1dfHwydNR3d42f6DYNUe073RLvG+TMhg8/P+F6C8xLfkpFQESpLhziK2aQo+YEk045Cal7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQjwu/u4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQjwu/u4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6542C19425;
	Mon, 20 Apr 2026 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700893;
	bh=NziIoVr6CJT6SiabbZdsyWZCZ2Y6Y/3+505Vf4IJ0D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQjwu/u4hSP7D8iVDoLmQQlHUCPXPlNqiURLpsOdTjRkch8UQEb/5n1DJ32pQGYOa
	 euhZ8YrqgFTJmqTSpTrD/3n1ikwCFfSpo1rHkqKSwqIXMFQrDRnKMOyC2sPtsCozIN
	 +OJOz4tsTTwKVg4ErGF/uxLkJhCrQdHuqLVWTr68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/198] ipv6: ioam: fix potential NULL dereferences in __ioam6_fill_trace_data()
Date: Mon, 20 Apr 2026 17:40:52 +0200
Message-ID: <20260420153938.238420878@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv6/ioam6.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 8db7f965696aa..12350e1e18bde 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -710,7 +710,9 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_schema *sc,
 				    unsigned int sclen, bool is_input)
 {
-	struct net_device *dev = skb_dst_dev(skb);
+	/* Note: skb_dst_dev_rcu() can't be NULL at this point. */
+	struct net_device *dev = skb_dst_dev_rcu(skb);
+	struct inet6_dev *i_skb_dev, *idev;
 	struct timespec64 ts;
 	ktime_t tstamp;
 	u64 raw64;
@@ -721,13 +723,16 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
 	data = trace->data + trace->remlen * 4 - trace->nodelen * 4 - sclen * 4;
 
+	i_skb_dev = skb->dev ? __in6_dev_get(skb->dev) : NULL;
+	idev = __in6_dev_get(dev);
+
 	/* hop_lim and node_id */
 	if (trace->type.bit0) {
 		byte = ipv6_hdr(skb)->hop_limit;
 		if (is_input)
 			byte--;
 
-		raw32 = dev_net(dev)->ipv6.sysctl.ioam6_id;
+		raw32 = READ_ONCE(dev_net(dev)->ipv6.sysctl.ioam6_id);
 
 		*(__be32 *)data = cpu_to_be32((byte << 24) | raw32);
 		data += sizeof(__be32);
@@ -735,18 +740,18 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
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
 
-		if (dev->flags & IFF_LOOPBACK)
+		if ((dev->flags & IFF_LOOPBACK) || !idev)
 			raw16 = IOAM6_U16_UNAVAILABLE;
 		else
-			raw16 = (__force u16)READ_ONCE(__in6_dev_get(dev)->cnf.ioam6_id);
+			raw16 = (__force u16)READ_ONCE(idev->cnf.ioam6_id);
 
 		*(__be16 *)data = cpu_to_be16(raw16);
 		data += sizeof(__be16);
@@ -822,7 +827,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 		if (is_input)
 			byte--;
 
-		raw64 = dev_net(dev)->ipv6.sysctl.ioam6_id_wide;
+		raw64 = READ_ONCE(dev_net(dev)->ipv6.sysctl.ioam6_id_wide);
 
 		*(__be64 *)data = cpu_to_be64(((u64)byte << 56) | raw64);
 		data += sizeof(__be64);
@@ -830,18 +835,18 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 
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
 
-		if (dev->flags & IFF_LOOPBACK)
+		if ((dev->flags & IFF_LOOPBACK) || !idev)
 			raw32 = IOAM6_U32_UNAVAILABLE;
 		else
-			raw32 = READ_ONCE(__in6_dev_get(dev)->cnf.ioam6_id_wide);
+			raw32 = READ_ONCE(idev->cnf.ioam6_id_wide);
 
 		*(__be32 *)data = cpu_to_be32(raw32);
 		data += sizeof(__be32);
-- 
2.53.0



