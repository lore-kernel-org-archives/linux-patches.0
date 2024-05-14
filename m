Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D2B139CF3;
	Tue, 14 May 2024 11:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687050; cv=none; b=SpN8XFayjgEw6O6yEgzZCANy2JoK9Rc9X7yapZyepe6ne+w4OCZfp1Kacy4Hclj6/wG6pOxZThGJ97pp/jjXKGI+6R0fols/V6VsrXk3Z+fPr6r5VbcO+RkC8NrEpSqxdu0PSR5OhHo6HtOJI0V5zgI+ndSb92nFs4VGoZW6dDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687050; c=relaxed/simple;
	bh=wHNRsxsHzdDz2zt2rP+mIwqrTxnFGYSY99XMK0hr4uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G30QU5+pFmguxq9vyBy4OTJEPXoWf2g5HzXZ6mee5yVGqVZPOVLXmNBNnu/NgYlc3wuBlLXQSgKQL+ZpDWlCdP+UgKoA7ViAMqdQmzG22EngdVzJgeItiY2s3jcUSZ/2V5WCQpV2ln+7keyPlb0Ew8FBZUS3tWujcmIjEjRpFEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+YNgp4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+YNgp4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30216C2BD10;
	Tue, 14 May 2024 11:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687050;
	bh=wHNRsxsHzdDz2zt2rP+mIwqrTxnFGYSY99XMK0hr4uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+YNgp4zXs4ubpG8Lh2LMu9BIktNeBBzDUNIBOlXvmiOyQ1hwgWmBNjvOWsNx07cv
	 vmbf8PsARrJMad0wc8RkH+R+0UsgtiDHEvIXM7g9r2TaxfnQDt9jNkG5VsWUmmjp1K
	 l8ITI71+lhVyH4747kxV4IX845BjlW9pv+WAisuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/84] net: bridge: fix multicast-to-unicast with fraglist GSO
Date: Tue, 14 May 2024 12:19:41 +0200
Message-ID: <20240514100952.830004994@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 59c878cbcdd80ed39315573b3511d0acfd3501b5 ]

Calling skb_copy on a SKB_GSO_FRAGLIST skb is not valid, since it returns
an invalid linearized skb. This code only needs to change the ethernet
header, so pskb_copy is the right function to call here.

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 4f8eb83976f10..0a1ca20f719da 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -253,7 +253,7 @@ static void maybe_deliver_addr(struct net_bridge_port *p, struct sk_buff *skb,
 	if (skb->dev == p->dev && ether_addr_equal(src, addr))
 		return;
 
-	skb = skb_copy(skb, GFP_ATOMIC);
+	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (!skb) {
 		DEV_STATS_INC(dev, tx_dropped);
 		return;
-- 
2.43.0



