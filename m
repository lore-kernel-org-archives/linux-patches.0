Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903B551AEEE;
	Wed, 30 Sep 2026 18:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792461; cv=none; b=O6VwqWt8zQG0JSYerkF8prOzjKUhUtSfRyf226szAL1cRMse32aTsAna1+FvgVJopm0xtkwz4gP2j87YNHPejrXueWeRYXG/Rjx1vzVjm+DPG/y+MOoZwjACi0GW1JBZpsX3rUlzAIm02jFelGCtN6f6rzDb8LcUNKXhIZpkYu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792461; c=relaxed/simple;
	bh=Lc6SvIWG0WTTdV7cK/FGeLwYmdAkiZeuP920szhyMwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OChRlith9qetaQkbEI3wwwYpwZkIQrJls88Cfzy6W8lW49iiTAuWI/rSJlZv5Sgb1SnLqLxkDExxS1qMNGmmiO04EUGGpE1OxHnCh4qHh5chKtjw3/Tb2zMJhbbWWzWKHvtA+tXpA9E6EezFZgEpS9xeWJwcqeLIPrrDVNkcv7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQF+SMsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQF+SMsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA31B1F000FF;
	Wed, 30 Sep 2026 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792460;
	bh=IgsldSFwb6xbD9WyGkA2kHunRJwaIO1nNxuXYMSAIz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQF+SMsVWKQaHCrz28kiGfEpmAbLCcjuSmWzcnX4i/Jq4lIJVJaFe99h1dqpvo1bX
	 WVXE3SblKS3FQQTdgLtDreurTmRyxvmaA94NVxmdyUo3cO7uG8rHzUpnxUnix78h8M
	 R5lo5+e4EDNI12ZfCz+aA52a3xdgjBLlJQIX5QTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Shihuang Liu <shlomojune6@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 664/752] net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()
Date: Wed, 30 Sep 2026 17:28:54 +0200
Message-ID: <20260930152412.626363135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 312fe0372829b..f35d32561c36a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5261,7 +5261,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ipv6_opt_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ipv6_opt_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5276,7 +5277,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ip_auth_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ip_auth_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5291,7 +5293,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
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



