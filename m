Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B7E86331;
	Tue, 12 Aug 2025 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020619; cv=none; b=Dzx1P2TumRUvAiMOYIMPAAQArVmEWu959KcRry1SArzjKfZMGKXvHU/toOZDbpvYE0TGVyGgFubZvk8Px5MIpkuhDGyBN1vvWJiS1C2pT1mesShrp2dH6PQJmarxn7KrYlSmGxsbu3Jm67ksBienk4DgT/2BQ0VEQAVemn9AKkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020619; c=relaxed/simple;
	bh=Rs8TUxt9qidyt74vPvSKejA6TXtCWJk8Qn/lTijG9tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqC81nsF4mRzJDiGZ7C7NMTlg624cMI/p0Y0ILZ9K1WwRMop40YqSgvm31aIZtpXUL0qbrV0ozXW0hfHhrsr6wwBi0A6bYOYpc70RNF5VteMJA7drv9t3HAfpzqZhiFc8Hqy41nvfHL85g0TNRLgbVRkdXVbS/IFph1/yoXu9dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCoyp3HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCoyp3HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E79C4CEF0;
	Tue, 12 Aug 2025 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020619;
	bh=Rs8TUxt9qidyt74vPvSKejA6TXtCWJk8Qn/lTijG9tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCoyp3HXvyYS7g+hdR/cXvH3zw649d2AsMqg30AfrDF0Dj7S8Q1opa0drkabGXoD8
	 gy8iC2H2a5ZVhyXVQUnAwgZCRuoJuX7EF1bmujmwlO73ybv6TxnAzhcl2V699Igqa9
	 5j3TZG16sv1ZJ5kKOTNR9X2qi1rVLZjS8PhghkGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/253] net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain
Date: Tue, 12 Aug 2025 19:28:08 +0200
Message-ID: <20250812172952.984679840@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 138f6aee70af..06f66531628f 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2045,6 +2045,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 			  struct sk_buff *skb, int vifi)
 {
 	struct vif_device *vif = &mrt->vif_table[vifi];
+	struct net_device *indev = skb->dev;
 	struct net_device *vif_dev;
 	struct ipv6hdr *ipv6h;
 	struct dst_entry *dst;
@@ -2107,7 +2108,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	IP6CB(skb)->flags |= IP6SKB_FORWARDED;
 
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD,
-		       net, NULL, skb, skb->dev, vif_dev,
+		       net, NULL, skb, indev, skb->dev,
 		       ip6mr_forward2_finish);
 
 out_free:
-- 
2.39.5



