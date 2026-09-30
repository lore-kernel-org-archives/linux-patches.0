Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A023F4F5E0E;
	Wed, 30 Sep 2026 16:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787309; cv=none; b=JXPSTRP/hgKuPlI4Wz10ZMzP5J9rtFwvcRXtJ0TZcGWPb9zPxIVjJeR2kSuMd4BJK8QO+N4kwJlOd4flKtRpzQUqxXRNFLATxIz2RYIIpOBqE+VYyYMgIOi3WfzILKhneWtCcDQHMc7lIKo4PkAdlZRKoYuWthVH62EWOO1LdcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787309; c=relaxed/simple;
	bh=GorUJDmiQVDOqlmO/VFkt5PkGU6Tw0Zc1z0/HuWESxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBgUQ/33UGPgo/nNqe9gIcdDqwthdaN+rbR437DSgbOxlK9dlgs9f2ihVty+S+0zKyZQ6/N0KRynpyzvPavXf41R8NX34aUy+DlAWwaOh8KqXaqN+wqh/Qutao+lhl6gIoyV3LChsH1aGdsWlrbmSnFeezOtmd9vv/uOOUJJ4cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWORCxr7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWORCxr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF73C1F000FF;
	Wed, 30 Sep 2026 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787308;
	bh=bPkadys9UtudwW5dNN+LJRdEJj7s9sHeq2dTFwjoNMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWORCxr7KYtdMPGpQXRUlzLWK4pffTEmt4TjsM4UxbP5uWGbvK5tLDP3et4cM8PJz
	 hvdvryR+2b7LnEZRwRDWwU8IwkQI+M0/srTsK11jG1sqXVvA/z/hj6hVfWqxPWiRxy
	 zrbfbu6lk3CG1cCSaw6mH9/8eQtmQnvfdbOdPp2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Shihuang Liu <shlomojune6@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 184/457] net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()
Date: Wed, 30 Sep 2026 17:24:49 +0200
Message-ID: <20260930152350.023044189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c485be081aeaa..89ee7907e4996 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5965,7 +5965,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ipv6_opt_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ipv6_opt_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5980,7 +5981,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ip_auth_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ip_auth_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5995,7 +5997,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
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



