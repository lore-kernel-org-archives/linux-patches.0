Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF81413D8F;
	Thu, 30 Jul 2026 14:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422049; cv=none; b=a5eD1cy+tJficP2Ibf/4METfn19GDEetYV0duLm3ZgpdR5t0ticMZpewl+fE7KiixwGHs0fnfSlYQOeJYSmQZTQKcH1M0hW3Sx8nMklrZy6qZZgFcT6f/jnteQ/uqEZY23/0rEWM1l5KpGdap3aMwSQMvz1z7BlxTRNnmcOtMuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422049; c=relaxed/simple;
	bh=eVJERjTTI2RdC1ndsgSnwe8Rc2UN+k6892TVSefUWkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlVE8QZgFnzEih1NmPz6HcTECgiGX7qYJXKvLne0TkV9qSmXOsTTjWhSnGXn0R6RweONAlgRKm+I/ipkaZOmqn2XfAslf8QpSrI9mnaUnEVcDnBwt+4m0AmLirmBPqVKKxBLeRJgo06BSw7P1yA5uU3k0Y/BpIn7bCp4Pltq5dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3SDAYoZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3SDAYoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB2D1F000E9;
	Thu, 30 Jul 2026 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422047;
	bh=S0ly+eCaiGZqLlSAaV1yZePz+sVGxi80C83LlmVcxIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3SDAYoZAId7g5N0HPshEGtigTPve7fWVcqcbhTJtxCzB5OnarCtNTCSFGsJxlZlP
	 2Rlr03S1ZEIyiv86Z7mPIpxkQOvmBksNne7xTb4LaHIfckDGL9FupssJHGvPo3a1Gz
	 K4ns+Aq8dn7UMGs4GGXcspMFU1RXLwaLQpQx9ITY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 306/744] amt: make the head writable before rewriting the L2 header
Date: Thu, 30 Jul 2026 16:09:39 +0200
Message-ID: <20260730141450.794443327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 53969d704fa5b7c1751e277fac96bfc22b435eac ]

amt_multicast_data_handler(), amt_membership_query_handler() and
amt_update_handler() rewrite the ethernet header of the decapsulated skb
in place (eth->h_proto, eth->h_dest and, for the query, also
eth->h_source) before handing it up the stack.  The skb head may be
shared, for example when a packet tap has cloned it on the underlay
interface, so writing through it corrupts the other reader's copy.

Call skb_cow_head() before the rewrite so the head is private.  It is
placed before the pointers into the head are (re-)derived, so a
reallocation caused by the copy is picked up by those derivations.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Taehee Yoo <ap420073@gmail.com>
Link: https://patch.msgid.link/20260711151934.2955226-3-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 00452d4ed3357b..a12ff8126c6986 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2320,6 +2320,9 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 
+	if (skb_cow_head(skb, 0))
+		return true;
+
 	if (!pskb_may_pull(skb, sizeof(*iph)))
 		return true;
 	iph = ip_hdr(skb);
@@ -2396,6 +2399,8 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	skb_reset_network_header(skb);
 	eth = eth_hdr(skb);
 	ether_addr_copy(h_source, oeth->h_source);
+	if (skb_cow_head(skb, 0))
+		return true;
 	if (!pskb_may_pull(skb, sizeof(*iph)))
 		return true;
 
@@ -2521,6 +2526,9 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 	if (!pskb_may_pull(skb, sizeof(*iph)))
 		return true;
 
+	if (skb_cow_head(skb, 0))
+		return true;
+
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
 		if (ip_mc_check_igmp(skb)) {
-- 
2.53.0



