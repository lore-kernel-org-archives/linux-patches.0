Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6677A2FD1A2;
	Tue, 12 Aug 2025 18:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023669; cv=none; b=QGtckcvLKAZgo9TMOBznXGvYFdGOsSobTETLbq+UC4oDqsYwnnJcadfP10pLO/AAVt7ca9zTlxU70YC1PB9dcqiM3TQZiujSVmD0CrrESHSVoxWOqoZXCPQJfiKkw2GO0tiv7IyJEB8eM/L6zGgJSTHWv5lRaLJq87BUj8If8rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023669; c=relaxed/simple;
	bh=/887jQYDIqUuRK20NPGA9n8hu2gtFhrJfCrTWYJR2dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB6sD3ksPrYvDquHMGzA7rijksbdPIngBg2Evig0EHWSkt0atjj5qG5u4IyHjRhv/oSovcTn3zh55M+Nbh6xMfvdQv2Fpdxsv591hncF6YK0f4T+aX38Q09mUsZjgp6WYMJyAw0gBCMCnIf6K32o9cXWJ6eFTOOStlGXL1AHh+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBO7N7Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBO7N7Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8393C4CEF0;
	Tue, 12 Aug 2025 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023669;
	bh=/887jQYDIqUuRK20NPGA9n8hu2gtFhrJfCrTWYJR2dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBO7N7Q+fVTDeJ/ilgAAQQnw9QhUx+z29jNMi1MIL5AeAC1zHZhqXMJKoZjU3lK2y
	 SRvTAKMnnIJ0mHytho43DiM4zk85cfUbGqzCRXC0peoHsPYIPfgGnS4YNhIJCpMFf8
	 LmY485DyJ2A7vlp3nFDSFsUCQoUASxkqK/UeoIWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 148/627] net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain
Date: Tue, 12 Aug 2025 19:27:23 +0200
Message-ID: <20250812173424.929080673@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 9db31e5b998c..426859cd3409 100644
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



