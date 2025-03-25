Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EEE268C6D;
	Tue, 25 Mar 2025 12:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905942; cv=none; b=UfZbjUfNjNAs0chljeajFewW6XRe0edM9wCJMdh2bRdLcKZpXwI1kb5gTT0ug15bQZXH7eyuCkcSr9/9alZzgYMVdpNoxbNh5pt0qXFLAb9M6PZnnRLEL2zSTS4Pr7TJkSVHxTeE8KDMd2blekZpfXPKGIJaAEhYYKbhN1tlw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905942; c=relaxed/simple;
	bh=oi0uZcDAKzc9tqqoiCfsjBHIaQrhzSes1p04ueMoGN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pi1tkqZK650dphhVHxdo9+NtApF7MR7a8jkSRZFLuSizTppLWkJPJE++sKLehVqTmAOiNbCvpHZ9XTEFL5T3TDKTZYMkPYCjtUQ9SVr7LtL2lqKTnkEv152ascj+oSyDJjU7z03YqqnF3iHlMHaGm2XZnyfl/bL1zYstjsQJp88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+cxI0NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+cxI0NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B778C4CEE4;
	Tue, 25 Mar 2025 12:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905942;
	bh=oi0uZcDAKzc9tqqoiCfsjBHIaQrhzSes1p04ueMoGN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w+cxI0NX7M0IIHLjDbNS9VLNgflrLk+HQjQqq+rGqGlQ26+GlVm2z1Wzx2k/3vT/K
	 AnMGw6NGSCF8mKAkdPDIgUDsOsEZS+QgPuT5NXnorcTlpvemdKi9b+J8PW9Euru+g8
	 gFkqmwDuQq9EuovTkBVD5BG/UqzHRDAVcO2rfur0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 048/119] net: ipv6: ioam6: fix lwtunnel_output() loop
Date: Tue, 25 Mar 2025 08:21:46 -0400
Message-ID: <20250325122150.280264206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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
index 2c383c12a4315..09065187378e6 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -337,7 +337,6 @@ static int ioam6_do_encap(struct net *net, struct sk_buff *skb,
 static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb), *cache_dst = NULL;
-	struct in6_addr orig_daddr;
 	struct ioam6_lwt *ilwt;
 	int err = -EINVAL;
 	u32 pkt_cnt;
@@ -352,8 +351,6 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (pkt_cnt % ilwt->freq.n >= ilwt->freq.k)
 		goto out;
 
-	orig_daddr = ipv6_hdr(skb)->daddr;
-
 	local_bh_disable();
 	cache_dst = dst_cache_get(&ilwt->cache);
 	local_bh_enable();
@@ -422,7 +419,10 @@ static int ioam6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
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



