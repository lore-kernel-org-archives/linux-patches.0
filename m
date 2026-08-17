Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFFB3B9943;
	Mon, 17 Aug 2026 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979218; cv=none; b=BkNpai+n2z5g95mes4KRc5cZ2K2rE7u3OeJmQwXbr5P0CU2V1NLppBnCp2aQinaa/7x6yxlBZmK+QTidCUY0AkLK+ZNE7asBojUW7qGK6E54SyBJ+g9VOym09uk+avi1SR3gYayMquM2RU4/H6wECfDPNRoiKEFlTa0dJo/EvdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979218; c=relaxed/simple;
	bh=v4mM/OMkOXO89duEKLZl+BijTTqIw6FI6/Q9sVNVvD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYFxj24xciYBZ4FUmfKsk8wBAmdoMphmViYUYTptWjD+kVBI0a3bTl728pVkhMHfB7LmPoXPk5IHVPI+9K5BpWPFui8joxm99Lk+EC46KvxJoPTCmMX8Q2w8PhQSmLEWARLp7QDx7rHyaZBYaK0/pR+awOc6JsbppIFSAGmxEf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IO4kra0e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IO4kra0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F48C1F000E9;
	Mon, 17 Aug 2026 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979217;
	bh=JjocESmZvIzIxm0kX23a/weO1ZyauV825EGKWF9WUpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IO4kra0e7WIl8jxykYTF15cj5mIYK9e2fXmyyeUIpml9UUhqL0ChtBlKU+fC3gDbh
	 CMJkegIdnZO7pyq79DvkAHSBZ9xtJW77jtiQLYjQMC+G+50sfwWevIU0VdbSOFuDtp
	 rmvZ7xz4tq2mHu4TA30uE8fh8vlCSCMTSuJhQC6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/609] amt: make the head writable before rewriting the L2 header
Date: Mon, 17 Aug 2026 15:27:23 +0200
Message-ID: <20260817132548.925963810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 64aff304c51c66..4799f8fd03c45c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2315,6 +2315,9 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 
+	if (skb_cow_head(skb, 0))
+		return true;
+
 	if (!pskb_may_pull(skb, sizeof(*iph)))
 		return true;
 	iph = ip_hdr(skb);
@@ -2391,6 +2394,8 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	skb_reset_network_header(skb);
 	eth = eth_hdr(skb);
 	ether_addr_copy(h_source, oeth->h_source);
+	if (skb_cow_head(skb, 0))
+		return true;
 	if (!pskb_may_pull(skb, sizeof(*iph)))
 		return true;
 
@@ -2516,6 +2521,9 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
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



