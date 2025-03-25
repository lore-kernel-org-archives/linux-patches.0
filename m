Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA4F26B972;
	Tue, 25 Mar 2025 12:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906305; cv=none; b=Rf9p1MbmimkNze3UFqHyxGQd7T/vndwmnCIUexLnwpPTtzrWuySor8x7UAdbe1LYmKV/f0iFEVfDNJGDjQb0ZxEASqb8adCF15Oz0X+IaLJ8U2KDOQUVtfQvT3zDUcAE3ZeknSJ5jrZYpPKuTyQgxzZRgqJRDq86ouIthkD+2Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906305; c=relaxed/simple;
	bh=MqeoZE67U3K542aY/IEa6nkJOIaacvPfvdvQFjwWIig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQPrd3X4WgjVGB/qu2SG5aVssKdyOVdYi4EXltsur9rsmXRRWBfcPniyoSIxo1d1xyRXUyuTrQ0JKCfgHctqCu2lWUeEGedQ6I8BAwaNq3KtyTUC2a9iEUmBACrjtbd4A6Ay3DH8tkxYnebIC8V8Qc9eZiFMy0j0LDnY0UXPx4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKFIiF3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKFIiF3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2EDC4CEE4;
	Tue, 25 Mar 2025 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906304;
	bh=MqeoZE67U3K542aY/IEa6nkJOIaacvPfvdvQFjwWIig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKFIiF3w+n36Pv7q7pK7jYKdXYOV4r/to3458rqHujmr49MNB70sCtLi0Nh9/Is1p
	 V5tn+/lITYybnB1LNjTVeyOj83Bi8fT/z9cZ2J1mYcedZkCysBYybP95JQIX3R8AcY
	 bG+Oumcn+vNLqe+B7Mcki6KJOZEUIcxEL5zqkhJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/116] net: ipv6: ioam6: fix lwtunnel_output() loop
Date: Tue, 25 Mar 2025 08:22:14 -0400
Message-ID: <20250325122150.408501598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 3e7a60b368eadf6c30a4a79dea1eb8f88b6d620d ]

Fix the lwtunnel_output() reentry loop in ioam6_iptunnel when the
destination is the same after transformation. Note that a check on the
destination address was already performed, but it was not enough. This
is the example of a lwtunnel user taking care of loops without relying
only on the last resort detection offered by lwtunnel.

Fixes: 8cb3bf8bff3c ("ipv6: ioam: Add support for the ip6ip6 encapsulation")
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250314120048.12569-3-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6_iptunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index 4215cebe7d85a..647dd8417c6cf 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -339,7 +339,6 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb), *cache_dst = NULL;
-	struct in6_addr orig_daddr;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
 	u32 pkt_cnt;
@@ -354,8 +353,6 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (pkt_cnt % ilwt->freq.n >= ilwt->freq.k)
 		goto out;
 
-	orig_daddr = ipv6_hdr(skb)->daddr;
-
 	local_bh_disable();
 	cache_dst = dst_cache_get(&ilwt->cache);
 	local_bh_enable();
@@ -424,7 +421,10 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 	}
 
-	if (!ipv6_addr_equal(&orig_daddr, &ipv6_hdr(skb)->daddr)) {
+	/* avoid lwtunnel_output() reentry loop when destination is the same
+	 * after transformation (e.g., with the inline mode)
+	 */
+	if (dst->lwtstate != cache_dst->lwtstate) {
 		skb_dst_drop(skb);
 		skb_dst_set(skb, cache_dst);
 		return dst_output(net, sk, skb);
-- 
2.39.5



