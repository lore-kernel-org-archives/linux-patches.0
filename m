Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824F7444712;
	Thu, 30 Jul 2026 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424160; cv=none; b=R36+QIze7ZvDQ+hG9V3B2zieT2ITh7quGWZxD/raZtXS6R5H1364LtS2/on7C3sa/StnyHvi+suD1E7u+VsLAQcnBB4NP5FirseCAxMIlwFhaFH/+au4PbzoEcoPhMC0GQCsl2+Q3TUhq0ZT7qZYlwfp4RVdyrZMOp+NEmRclOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424160; c=relaxed/simple;
	bh=WyM2O8f9I4DDJQZQ91NVgQIkrdh12VUfUdZHMNIGFf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ke9/zW0jsvYKk/Ee5FIxdgqQQ0WyMVq/BpE6FVN/JxqxKzyMdLvKG2fbtd6it1IkhOAe4/OGoEoPJ79svHrM/1hMX730KaY8Khjx/eCNqXhwSuxdrpiCGEf6zNAHofyEB5KCdvLz9xygCxYm+Nezkenq1i4i8Cd4//R00aPbj7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wyrRa/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wyrRa/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963F41F000E9;
	Thu, 30 Jul 2026 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424159;
	bh=TJ7+R8uH6E0MNy5aJBr11um1rVj5hmifl+IZNcUGrac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wyrRa/8GhiP7i7Nle9mIMzzSwRg94bh7qe3A4pGJPOrx8S2YlzBCjNrdnJS8R/4w
	 9+i2qvKNQ7MVNCMaDuy5B4HrY7x8ZpIbX/RHqt9W3c9GHsGxlbXRh3fvp3aC/ZvUle
	 EEJ9Mlsp604+BGutQ/siHYT1eygFK2e9JvX4McDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 295/675] net: gre: fix lltx regression for GRE tunnels with SEQ/CSUM
Date: Thu, 30 Jul 2026 16:10:25 +0200
Message-ID: <20260730141451.392840217@linuxfoundation.org>
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
index 879d37c557fafb..300b802125db27 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1017,6 +1017,8 @@ static void __gre_tunnel_init(struct net_device *dev)
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
 
+	dev->lltx = true;
+
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
@@ -1028,8 +1030,6 @@ static void __gre_tunnel_init(struct net_device *dev)
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-
-	dev->lltx = true;
 }
 
 static int ipgre_tunnel_init(struct net_device *dev)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 75961c4ebcdd22..58b473c157c820 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1454,6 +1454,8 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 	dev->features		|= GRE6_FEATURES;
 	dev->hw_features	|= GRE6_FEATURES;
 
+	dev->lltx = true;
+
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
@@ -1465,8 +1467,6 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-
-	dev->lltx = true;
 }
 
 static int ip6gre_tunnel_init_common(struct net_device *dev)
-- 
2.53.0



