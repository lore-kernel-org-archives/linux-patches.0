Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10672F4A07;
	Tue, 12 Aug 2025 19:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025676; cv=none; b=VI4zn/5Eh5qSwYUYtJ+GYZAVNp9gEECAI5iToK8hgOXAIwayQpq/fkoDVWDq7F1JRRXzCQB4o3dvsgy9K1xavTUzKT2CNaE2EMLHqTjQHT+Yaf8kf2l0Xe35mzSVwwuKeRXxI3J4i0k8LXUs7qPsQMUVfXwphl4NcHVnYhcvRKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025676; c=relaxed/simple;
	bh=OB9rd2xsTS1Gg6I4SgiDnBsObz+cnxuUVKFBlGRzxrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEPwluQREDlrmS2DkR/M40NLkokVvrgAYt9VmxALOSP9Bpv/xKn23h31rML6i2Ft9KyV5PuXXL/E0NWFnF0hcCMi5PwyAH5ROR7xugmF5/Jbpg8PQkTSrTGp7F1NNfLDA4Dtw7kM2zEdILfOZUFQeZCBF7uvntwq2ZecAtal0Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odtV7IPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odtV7IPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338A7C4CEF1;
	Tue, 12 Aug 2025 19:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025676;
	bh=OB9rd2xsTS1Gg6I4SgiDnBsObz+cnxuUVKFBlGRzxrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odtV7IPIYw2vMr+jvxi8Vq7xIcqTpJ2VyR0WTFr/luJUE9wtgM4eVSuEZJmD1oDVS
	 VMgcY3Hs0kZ/xmPWNcao7vZJ5uxkuNRHezKvkaweYpjk6IRChKUbohbt2v4JWKtPee
	 vru6J7WzTcmlmZZ4bJMlE7yCqA2//aEnlqWwpwbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 110/480] net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain
Date: Tue, 12 Aug 2025 19:45:18 +0200
Message-ID: <20250812174402.026428807@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3276cde5ebd7..63c90dae6cbf 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2039,6 +2039,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 			  struct sk_buff *skb, int vifi)
 {
 	struct vif_device *vif = &mrt->vif_table[vifi];
+	struct net_device *indev = skb->dev;
 	struct net_device *vif_dev;
 	struct ipv6hdr *ipv6h;
 	struct dst_entry *dst;
@@ -2101,7 +2102,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	IP6CB(skb)->flags |= IP6SKB_FORWARDED;
 
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD,
-		       net, NULL, skb, skb->dev, vif_dev,
+		       net, NULL, skb, indev, skb->dev,
 		       ip6mr_forward2_finish);
 
 out_free:
-- 
2.39.5



