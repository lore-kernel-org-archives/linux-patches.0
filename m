Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F7305E08;
	Tue, 12 Aug 2025 18:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022164; cv=none; b=UoWvr0IME2XNmbQBh2++fSPrv1gQixbFMAeUKjDFS2eEFf1eP7WRxVVbyYQzMuQqIapntivncmlSPxTKTlhzpmfL9pfsaFgZTSQkiIORP9sf20MT49LFRNzFNHevAYd+jLhqU59Uc73sh7oXxQokbSEP7yypu6kcuIP6s4iXDg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022164; c=relaxed/simple;
	bh=LSDBGEoHTAt+3ePqn7hrPGl5dbUKGSZ1qxEobKmDfoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0wMxi0BpazZZgjO4UWXQJUyihc/9dU7beaRj2daSbXL6pDzcXonRO3PD7bGqwHMfRH9jJCmyVLETA6+V+kzcpI9w8ejUlXClr5x2ZekThb0PBXPonfuEmintnF529BRzXGUNKWUMG4yvwIQRFUdZmpx0PTa7yp6vtiby4HoKQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FH0WVIhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FH0WVIhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD99C4CEF0;
	Tue, 12 Aug 2025 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022164;
	bh=LSDBGEoHTAt+3ePqn7hrPGl5dbUKGSZ1qxEobKmDfoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FH0WVIhbf11c2qnbUbj2YvJzyRyU9TAoLr1FTAIYhIAS4s08EZvZHofGqrvyNl5Lj
	 rkB+05Fr/12jpHN4Zpmja2E9U/XD7mg39BzVQCVhkEBMYNhK4OmINExNjEofqTDrhH
	 3wtjj+/d6d+GVSikmGNM1Fl3H897m63jKzhN3rU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/369] net: ipv6: ip6mr: Fix in/out netdev to pass to the FORWARD chain
Date: Tue, 12 Aug 2025 19:26:12 +0200
Message-ID: <20250812173017.597849010@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 440048d609c3..68bc518500f9 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2032,6 +2032,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 			  struct sk_buff *skb, int vifi)
 {
 	struct vif_device *vif = &mrt->vif_table[vifi];
+	struct net_device *indev = skb->dev;
 	struct net_device *vif_dev;
 	struct ipv6hdr *ipv6h;
 	struct dst_entry *dst;
@@ -2094,7 +2095,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	IP6CB(skb)->flags |= IP6SKB_FORWARDED;
 
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD,
-		       net, NULL, skb, skb->dev, vif_dev,
+		       net, NULL, skb, indev, skb->dev,
 		       ip6mr_forward2_finish);
 
 out_free:
-- 
2.39.5



