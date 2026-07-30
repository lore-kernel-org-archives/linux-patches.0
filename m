Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41338451996;
	Thu, 30 Jul 2026 16:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427515; cv=none; b=fmgtjEpvJi3/vVEeT+KRFgpZticD4/P2OWI3ONxgnFLnKOftQJQ3sKho+Gr37A8/Qky/kCblpgtf1JdvsvJF2v8CILcq4gBLmABIxHuY3CIg87a9Ulc7eEDFSxn5yyyxxnI8kbLkhwbxnU67LSMK0oCkXpYUdQ+Lr7KwXW8fotA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427515; c=relaxed/simple;
	bh=bDZCwzVWri44avjKJRH09FcoAhNADR2mlj8BneXQraI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5NnPmbr/ejo8fyBjCiU2CRbYNyVahzzLXWEZjydy+FvJsCAQDZ8PNjbZ7C0yHg1h/iHqPy4dlCPdxMny3RUjo5DeS8t3NyoYp03GuPQ18LhVDQV2To/bt+D9WhGhl9riDVmJQIsEeQvpj1Ubm5Kslun1XAOCfG1O/Qwt0XuXaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjZ26SeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjZ26SeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459081F00A3E;
	Thu, 30 Jul 2026 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427513;
	bh=hBnMpTX4my9NFULNPILGMpsepA7CjjViYlliBmiXVDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjZ26SeLBNmzuTDqYm+ImUs1lL4OUgWQlpehc+/4Bru0wm8zQ2EvHVIvagz5BW/ER
	 iOyYG5tN7886CmTOA/aH8rIq3rgHfABua6tnGV5h3GoAhFerWhnhcxV1B5oVnwAbuf
	 5RmGkmpVMEKzGOrvGCzKt2ePz7RmsR09ppsRHxdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/484] amt: make the head writable before rewriting the L2 header
Date: Thu, 30 Jul 2026 16:11:17 +0200
Message-ID: <20260730141427.379422874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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



