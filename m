Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39E94DE72B;
	Wed, 30 Sep 2026 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786516; cv=none; b=lnQ4LccfM8x1ab8Prw8D72W59wfDbQaUH5w+HrdwK71mDHLCKGZa1ofjfZo8q/wMym0yGyY58yXWUoGJd+yDi3rVab0GsXtess3U+5zcTuZzHJHGFQv+Nm/cQ7Pdho42WOC3QGGGhhVfdRgTo5uuDQDWq/8YlXjLtVWi85EqRRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786516; c=relaxed/simple;
	bh=dljDZt15f+BkQt6C3Wdqlx2IqypRxLyu03rvnTXHcjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6vHz8dNRiUA29lErTxyugWHBNMpldB0uual870liLVZ3gIWc7IaGBwtMveA7kme3czdoCV0nWQ2L4QtqQsr0LsKlbn7hPZ7l41S4DWsIwLdJYHSO08VhgOrOQgB+PWChv9JWqgaRqQgDOmvyOnDc7yiUB7QvcuOuqED4qikJ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QF0u2PtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QF0u2PtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F4D1F00898;
	Wed, 30 Sep 2026 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786514;
	bh=l9AuNhKWcUrG19BmcgeD4D63jCshJqp+PYMrED8hmw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QF0u2PtHNnRibbg8quZ51djlzXDEjPDfDTGK0Fc4Ksyf9LTfmBBUDNxCdpt6bzkEA
	 kTDl2zhqtv7yPf8JteaPMRLJiQ/fCvJMID3Saq9hYOEk698Gs9k5eoH+nzSAhdhpSQ
	 fWd291qrFaTy3PLvIc2uOt34o95PQBCtvETMrOCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Shihuang Liu <shlomojune6@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 890/982] net: skbuff: fix pull-bound underflow in skb_checksum_setup_ipv6()
Date: Wed, 30 Sep 2026 17:27:06 +0200
Message-ID: <20260930152435.864812504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 40b2fee82bf9f..a66066bc98610 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5256,7 +5256,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ipv6_opt_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ipv6_opt_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5271,7 +5272,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
 			err = skb_maybe_pull_tail(skb,
 						  off +
 						  sizeof(struct ip_auth_hdr),
-						  MAX_IPV6_HDR_LEN);
+						  off +
+						  sizeof(struct ip_auth_hdr));
 			if (err < 0)
 				goto out;
 
@@ -5286,7 +5288,8 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
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



