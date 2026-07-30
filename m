Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F54337A85D;
	Thu, 30 Jul 2026 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425896; cv=none; b=Tws8ucdFVGduC6jT2wI98EoYpcKTD+Baksu8LHJGlKz7nuiUz2J5xF+ukO63Wnu9k/6GFWMRkOxH0JmAVACGiSHsxJn7o8R3shPShlDGWBGgoopoUDFYIKbla1KKLgeeA6Lcyjnec/oSX8YXdym4C1Yho0HYqLbDJIVjp3xENEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425896; c=relaxed/simple;
	bh=DJ+7ohoOfUI/n6neonjR1FARLuY7mOS4Xhi2hM472g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdXsGrcESABDF6LzQkezJZjQTMFxC6JLsj8Xfk6o/s/mP33cOko/PlkcerIesMWnBXps8EslFEg5yqZ3LffQG5BxE3PJPZfDsM65Ur9xqvo5cv8i7iqLddDMlrhfDFqp8DLkSjshFlcDQRajmC1OoSo1aRaJNb3A6o2krFw1mKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vb/2O2Vc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vb/2O2Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740241F000E9;
	Thu, 30 Jul 2026 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425895;
	bh=1yP9SwQs426jzpGMFL7eP/ASSh35gnngoGWKd6EkKs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vb/2O2VcJjY6X/oXaK/xFvuAawX13chpKEFcYdO4EPzxH4w/Q1iMmFIxTs7+CxYlS
	 1Isgmb4fTm/1+LBb3s4ZSmRyTdiQnPwehkZYsSQIx6vrzXUObiS7DTlGOcr5icuha4
	 D2ckOec4jju6mMes9od/CzeuMIW3e5r0teAaAOF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/602] net: gre: fix lltx regression for GRE tunnels with SEQ/CSUM
Date: Thu, 30 Jul 2026 16:10:19 +0200
Message-ID: <20260730141440.728969984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ffad16b023addf..f344e9bb31fbb3 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1012,6 +1012,8 @@ static void __gre_tunnel_init(struct net_device *dev)
 	dev->features		|= GRE_FEATURES;
 	dev->hw_features	|= GRE_FEATURES;
 
+	dev->lltx = true;
+
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
@@ -1023,8 +1025,6 @@ static void __gre_tunnel_init(struct net_device *dev)
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-
-	dev->lltx = true;
 }
 
 static int ipgre_tunnel_init(struct net_device *dev)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index f1dc1244ade301..dac2e589849df3 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1483,6 +1483,8 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 	dev->features		|= GRE6_FEATURES;
 	dev->hw_features	|= GRE6_FEATURES;
 
+	dev->lltx = true;
+
 	/* TCP offload with GRE SEQ is not supported, nor can we support 2
 	 * levels of outer headers requiring an update.
 	 */
@@ -1494,8 +1496,6 @@ static void ip6gre_tnl_init_features(struct net_device *dev)
 
 	dev->features |= NETIF_F_GSO_SOFTWARE;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;
-
-	dev->lltx = true;
 }
 
 static int ip6gre_tunnel_init_common(struct net_device *dev)
-- 
2.53.0



