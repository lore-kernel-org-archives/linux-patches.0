Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66F943CE6E;
	Thu, 30 Jul 2026 14:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422102; cv=none; b=Zrl88RyGiEDOvCsdyylKR5gSYNpDjumAzU8vfkUjVzFZRyuNs1GJS4YLCsyJhgVuQbdkrHByUjUGPpJ7ijeAUN/Z4nynBdzHrqfSfhdFAhmkbSwEN7kGXWQ/PMOzbI8FRla1O9y8BhQ5jFekDxDGum1Q87/P4kKeJnXBQTHSSzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422102; c=relaxed/simple;
	bh=uu+XeNHmxoE+inIo/8TIA4qabv+Pg3Eq7FDweMS7VhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBv1kgdt3j0cGoYk5UkDwYeBNCJosCcC/6XT7Xczp/hQrqEAxk2Ccxx7WxgTdQoVOH11t/Zrumzn3HMHs/ZDqFzbkb6woDrhBJI+AQyv/j3eFD8Nz3U6bnoLTqnrEAr5FEUBm2eakDbUAq3kKZglp+VgTDqzaXjuTPvdHuw9KsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDvaY3sU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDvaY3sU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C7D1F00A3D;
	Thu, 30 Jul 2026 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422101;
	bh=rdbnhV0r72866f2YNYfnUjf2cEIxHHYKuIzplph5Beg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDvaY3sU3V6YXGATah2Mim6Tc+NirSTE+6nhuqyWa6+iCF5m9rtSKyW9hf6y5AL8D
	 kpSJBFlaa7argfter2m8H1yGVPO8MApWiYZ9GbDrYfIl91aiqzX6UXiSVZyN17G289
	 CpTpGc1bRtJ8aBOd2l3YeuHEaoT87xPWSEGngxCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 326/744] net: gre: fix lltx regression for GRE tunnels with SEQ/CSUM
Date: Thu, 30 Jul 2026 16:09:59 +0200
Message-ID: <20260730141451.214157788@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 675ed582c1aa4d919dd535490de08c015005c653 ]

Before commit 00d066a4d4ed ("netdev_features: convert NETIF_F_LLTX to
dev->lltx"), NETIF_F_LLTX was set unconditionally in both
__gre_tunnel_init() and ip6gre_tnl_init_features() alongside
GRE_FEATURES:

    dev->features |= GRE_FEATURES | NETIF_F_LLTX;

When that commit converted NETIF_F_LLTX to the dev->lltx flag, it
placed 'dev->lltx = true' after the SEQ/CSUM early returns instead
of before them. This causes GRE/GRETAP/ip6gre tunnels with SEQ or
CSUM+encap to lose lockless TX, reintroducing _xmit_lock acquisition
around their ndo_start_xmit. Since GRE xmit re-enters the stack via
ip_tunnel_xmit(), holding _xmit_lock risks ABBA deadlock with the
underlay device.

  CPU0                        CPU1
  ----                        ----
  lock(&qdisc_xmit_lock_key#6);
                              lock(&qdisc_xmit_lock_key#3);
                              lock(&qdisc_xmit_lock_key#6);
  lock(&qdisc_xmit_lock_key#3);

Fix by moving dev->lltx = true before the early returns in both
functions, restoring the original unconditional behavior.

Fixes: 00d066a4d4ed ("netdev_features: convert NETIF_F_LLTX to dev->lltx")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260713150945.1779628-1-yun.zhou@windriver.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c  | 4 ++--
 net/ipv6/ip6_gre.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 0ebed1438f6c51..739b7fae8d3da2 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1018,6 +1018,8 @@ static void __gre_tunnel_init(struct net_device *dev)
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
 
+	dev->lltx = true;
+
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
@@ -1029,8 +1031,6 @@ static void __gre_tunnel_init(struct net_device *dev)
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-
-	dev->lltx = true;
 }
 
 static int ipgre_tunnel_init(struct net_device *dev)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 8ebc99a299c954..1a81e80a124aac 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1455,6 +1455,8 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 	dev->features		|= GRE6_FEATURES;
 	dev->hw_features	|= GRE6_FEATURES;
 
+	dev->lltx = true;
+
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
@@ -1466,8 +1468,6 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-
-	dev->lltx = true;
 }
 
 static int ip6gre_tunnel_init_common(struct net_device *dev)
-- 
2.53.0



