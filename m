Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B51211493;
	Thu, 12 Dec 2024 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024222; cv=none; b=Yu103BG0cNxs30LsrbDRL2GeDzWNVJDYLqJX6aWIN8YwX3JjYODuvzu3ic8F87KCmzQY2gd/J5BjuT6Xyw1ikXI3zloObg4E3yh2DPjDiBXjHGs6pj2qFKnJ6FvOk4Jzq88T5yOD28MEbY60xv8g4LVjEtngVsR49dljgJNA64s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024222; c=relaxed/simple;
	bh=HAImLJBg+x9KZW95FwKkPr64WlE0DTsEkACqdAXXjx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lnf8fLzqCnwW6MCg8lel80lvBL/DA0OlkOQ94yGHwmhBt0YeDq+4HjHkvYbMC1CUBQJeqDCLuYpQi9S4K7/ktCP6D2qGgnNGmVbMiv5fATkEflGDGsV6NGVevop7MOfZIyusoObqdTwUXtVYaNraE3d1F0FPysIy6p8NRjV56y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jttF14y3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jttF14y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054AFC4CECE;
	Thu, 12 Dec 2024 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024222;
	bh=HAImLJBg+x9KZW95FwKkPr64WlE0DTsEkACqdAXXjx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jttF14y34ncytK/Aklp6L4smhUbD74yK4wGJHEzcRwuky04wq/Sod6sKryWAy372O
	 eVYqgdrQ+sk5N/sVIqMnYEHYyPa50GOBP+GbSL9gnFDqaP52r0feyXwCHsWYDnkFjV
	 lUw+6u6gphCS/xVoez6hIFGv4Ag5/9KUZnzY/mww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Alexander Lobakin <alobakin@pm.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/459] net: introduce a netdev feature for UDP GRO forwarding
Date: Thu, 12 Dec 2024 15:59:24 +0100
Message-ID: <20241212144302.498434245@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <alobakin@pm.me>

[ Upstream commit 6f1c0ea133a6e4a193a7b285efe209664caeea43 ]

Introduce a new netdev feature, NETIF_F_GRO_UDP_FWD, to allow user
to turn UDP GRO on and off for forwarding.
Defaults to off to not change current datapath.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9cfb5e7f0ded ("net: hsr: fix hsr_init_sk() vs network/transport headers.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdev_features.h | 4 +++-
 net/ethtool/common.c            | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index e2a92697a6638..7b7a7e4d81254 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -84,6 +84,7 @@ enum {
 	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
 
 	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
+	NETIF_F_GRO_UDP_FWD_BIT,	/* Allow UDP GRO for forwarding */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -157,6 +158,7 @@ enum {
 #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
+#define NETIF_F_GRO_UDP_FWD	__NETIF_F(GRO_UDP_FWD)
 
 /* Finds the next feature with the highest number of the range of start-1 till 0.
  */
@@ -234,7 +236,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 #define NETIF_F_SOFT_FEATURES	(NETIF_F_GSO | NETIF_F_GRO)
 
 /* Changeable features with no special hardware requirements that defaults to off. */
-#define NETIF_F_SOFT_FEATURES_OFF	NETIF_F_GRO_FRAGLIST
+#define NETIF_F_SOFT_FEATURES_OFF	(NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD)
 
 #define NETIF_F_VLAN_FEATURES	(NETIF_F_HW_VLAN_CTAG_FILTER | \
 				 NETIF_F_HW_VLAN_CTAG_RX | \
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a13..181220101a6e7 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -68,6 +68,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
 	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
+	[NETIF_F_GRO_UDP_FWD_BIT] =	 "rx-udp-gro-forwarding",
 };
 
 const char
-- 
2.43.0



