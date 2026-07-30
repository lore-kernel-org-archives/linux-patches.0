Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E48442120;
	Thu, 30 Jul 2026 15:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424094; cv=none; b=rCgH3dsc1CQdP9VfNPz7iDXkst34YkKtedWOO9UTB06FdmUnsEtU24leymGpZ39EI2/xZS+R8G91uYiOE9xuk8HcbbHHr87t0YjOIXyDATSmNW4Cw97RM2Ryhg8mOL3fU2h+Zt7kxF9/IaxRuyPLqBUjJpF2/Kb1cg6BX+mBoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424094; c=relaxed/simple;
	bh=eGWrRx2AKSLmumSiMJI8oZhpUzLS9rU5f6i9qTFTEDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdyPwQDBHiqtXq+VE6GpZPhDj0cUQN+25khxOnocprYFzORI/UKDo86/vZVkjMd5VSgz7CSPcPtAvu+h7TIY796SebhZcYqRfHcppmpgwe/nQt0CyQ0Vk5L/zq0uT5gXaabh+Q+bxQP7vz8ugtlnGGiOHf98/5fK0qpdFRV7Zv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+E4JIZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+E4JIZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9AD1F000E9;
	Thu, 30 Jul 2026 15:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424093;
	bh=W26pkmDEzD2OaeXZ5uhCdBc3Z+IdBVNA5HgBMYiOA0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+E4JIZ5EHhqv/jC/XdNdfp+nZMWztOiKcL1g2ck/WbLMlNip84tn0D54cWqVoSsf
	 YH7bJ1ufAbY4Y8cNA9ida96jiZ/Lm6gOnxzR5YEVvswwcdDlxWMN5rEXYKz4HGGx/U
	 d6quEyglhU4xVu2XEyz4zJX8N8s29WsTveLcMN60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/675] amt: make the head writable before rewriting the L2 header
Date: Thu, 30 Jul 2026 16:10:04 +0200
Message-ID: <20260730141450.951356433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 76e0ab70d8273d..cddcad172bbce0 100644
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



