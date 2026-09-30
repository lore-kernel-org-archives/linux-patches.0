Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C58651AED4;
	Wed, 30 Sep 2026 18:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793168; cv=none; b=PHebQZC+GJxsiA5Ce3uWLhjxfj/2ytuSrT1puFOOcrkDbEujoA+PELz0gIzTv1vuHOkuAsCuOW7JoXbheFRA3UKUtpNkhSsfw2J5NJ49YvV+Q22Xk2+1qxE6dKa4bNJsIpxhi3AfdsY/HAI/byjp9yYjKXBzTlO7i+nLl6dYmYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793168; c=relaxed/simple;
	bh=eIuge6AckR5/OgOZZPEp7bG7Tal5QNLGF9OTaQWwrRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2AEfhyDHtb1g3DHXXKmt8vMZ5suPesu629dlxUG5p1W3nQA42fcR9hEGnfap1xZcKH4PoQqdH0Ee3tFX8K48bjyQpeBUVVVegXrQZQQtLnccKLGdgmx0Fh6it8mbHat7nojooiyPJZIPy1H30RnRXYUujp4eIG1IaQxdCrjq6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDNx2N+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDNx2N+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822F51F000FF;
	Wed, 30 Sep 2026 18:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793167;
	bh=omp3r3dK2itvzw+tHLyih3HB2xprQbVDzOmP/KOyc3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDNx2N+4UCSpfXig0DSLGaLHrsf2SFgxjY7YZSn+bmcjTf6eogi53kp/U+sG8xTo/
	 rmfh6546AJzDd7UtpMUHbygYjvkwTa8F6AdDPvDFpClKdj/pboE/mekSWF9v3pPHEI
	 HeqP9+iC8Qb4rTTPDrTK1HSCHrFCX00vByJ7/fag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Shihuang Liu <shlomojune6@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/395] net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()
Date: Wed, 30 Sep 2026 17:27:00 +0200
Message-ID: <20260930152344.073254292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Shihuang Liu <shlomojune6@gmail.com>

[ Upstream commit 3b4e0b0c008a8c1b474730248cd5b873026c74bd ]

skb_maybe_pull_tail() subtracts skb_headlen(skb) from the unsigned max
argument and passes the result to __pskb_pull_tail() as a signed int.  The
function does not ensure that max is at least skb_headlen(skb).

This can happen while parsing IPv6 extension headers when an skb already
has a linear area larger than MAX_IPV6_HDR_LEN.  Once the parser needs data
beyond the linear area, max - skb_headlen(skb) wraps and is converted to a
negative delta.  __pskb_pull_tail() then passes that negative length to
skb_copy_bits(), where it can become a very large copy length.

Pass the requested length itself as the pull bound at the three
extension-header call sites, so the delta can no longer go negative.

Fixes: 1431fb31ecba ("xen-netback: fix fragment detection in checksum setup")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Shihuang Liu <shlomojune6@gmail.com>
Link: https://patch.msgid.link/20260919133604.50948-1-shlomojune6@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 594764eab40dc..9ef8b31dbc870 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5911,7 +5911,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ipv6_opt_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ipv6_opt_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5926,7 +5927,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ip_auth_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ip_auth_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5941,7 +5943,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct frag_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct frag_hdr));
 			if (err < 0)
 				goto out;
 
-- 
2.53.0



