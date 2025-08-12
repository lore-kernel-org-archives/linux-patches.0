Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434D02D46AC;
	Tue, 12 Aug 2025 17:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021034; cv=none; b=SIFEqWyvBUmajEYWH9skgDg6WHpKULXS5cFcGcG95a/YfSabAhsL/tI1Z3ZNrf7sTkCBYC2N8L3Uua3rt358Q3m1k2IrDFUQnM84rmJlycKidkDvPBXkCIltrNjR+trzTrxAI+qqiNkKbEIQ1ZYoDrYdynkurptXZ7WSmA5XweQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021034; c=relaxed/simple;
	bh=oLw5RuTK6AYNIRfmoASi3/ora9A06EK2Yx/AnDuRNFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMMISW0SwNbiDTWBUhC1XQ+VXweVN35H3qne88oRDgYHzyFo8BdVl0tcqeRbBCZkyxqGdWm0TBiPJ96Cky6plTNLQ5t4slTEaTo3LcVWkNOu7bJbfVoa0tmE9yo/Y+uwSJ9gSOlqvpJE3qmvkM0a6R0Awwa61Xmgj0SuBUAvT2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLC3zyyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLC3zyyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC26C4CEF0;
	Tue, 12 Aug 2025 17:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021033;
	bh=oLw5RuTK6AYNIRfmoASi3/ora9A06EK2Yx/AnDuRNFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLC3zyykZBVHgn8gor1z3HlBNUzZTMK8tQo4uS4tgmloz6HHooG8pOxila7a9M5jc
	 5E+fuGCoUhBA79GoqF47MAE8p9usbdRI9cib4ELRZuUcRhMgQfRObCoLJ1ED3nrjq9
	 6s2qmgrA+Ef0wIClNiBoNA20CabtOQYIec0d1T1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/262] net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain
Date: Tue, 12 Aug 2025 19:27:20 +0200
Message-ID: <20250812172955.194196856@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 3365afd3abda5f6a54f4a822dad5c9314e94c3fc ]

The netfilter hook is invoked with skb->dev for input netdevice, and
vif_dev for output netdevice. However at the point of invocation, skb->dev
is already set to vif_dev, and MR-forwarded packets are reported with
in=out:

 # ip6tables -A FORWARD -j LOG --log-prefix '[forw]'
 # cd tools/testing/selftests/net/forwarding
 # ./router_multicast.sh
 # dmesg | fgrep '[forw]'
 [ 1670.248245] [forw]IN=v5 OUT=v5 [...]

For reference, IPv4 MR code shows in and out as appropriate.
Fix by caching skb->dev and using the updated value for output netdev.

Fixes: 7bc570c8b4f7 ("[IPV6] MROUTE: Support multicast forwarding.")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/3141ae8386fbe13fef4b793faa75e6bae58d798a.1750113335.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 7f19868d7d6c..18451dfeae68 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2035,6 +2035,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 			  struct sk_buff *skb, int vifi)
 {
 	struct vif_device *vif = &mrt->vif_table[vifi];
+	struct net_device *indev = skb->dev;
 	struct net_device *vif_dev;
 	struct ipv6hdr *ipv6h;
 	struct dst_entry *dst;
@@ -2097,7 +2098,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	IP6CB(skb)->flags |= IP6SKB_FORWARDED;
 
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD,
-		       net, NULL, skb, skb->dev, vif_dev,
+		       net, NULL, skb, indev, skb->dev,
 		       ip6mr_forward2_finish);
 
 out_free:
-- 
2.39.5



