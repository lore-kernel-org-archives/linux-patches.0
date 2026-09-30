Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9862F8BEE;
	Wed, 30 Sep 2026 18:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794400; cv=none; b=rzopV6aBioEdKLF9UGuQPKk5+f21RjxX6CEYqrFegfnyzCsONbEZP3CaFAKVVduMirs6ogS2YuEJCHthNwJzIIjts+seW53YcG23iXZINq6WKQ+GCCYxYKUZOIqI7owiy2q8oRpFZAJRIEWwXH+hbpkNp1oLJU3vWgcNUm7mqUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794400; c=relaxed/simple;
	bh=iaN+Hy9mxlTL19JBBo/yEOVOUXEtpzp19pB+rDullI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4XhKD/jcTg0XmJzk0As2wcGCs0VI226LGOnL9cRdzSswPP+37rMrwe4nbzFGA5kI0CkCP6cC8Y4Gz/P71q7t+28ErngNyy/bnMd+kpHihyMqm8+lTm7ZnsHfVbxCrfaFmx3rTFOWCxUm8gcqPSv57mJ6AzJ2KIs/yIIJsElAuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmeI8iLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmeI8iLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EA11F000FF;
	Wed, 30 Sep 2026 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794398;
	bh=RN7GG/77dtnAhhbNwEyWm/SMeA9lRA1VkSRZ9EKTXRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmeI8iLX399dU4RMQ2ajz+37R4t4wZ9KBYqRkbNECj1R8OPkK1gNARHf/R5c1sgYF
	 7eWbgHGcWUL9XbHDhbJq2wYgOOFzooC3P71Y3tQeIi0GGOc5GP7egvQtYMv5Y9ydhd
	 ZX777PQzhtz0Ao8Lw+31wP7u4kFwpE1CoLyjk4r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0149/1193] net: ibm: emac: Reserve VLAN header in MJS limit
Date: Wed, 30 Sep 2026 17:13:53 +0200
Message-ID: <20260930152437.519611294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0906c117f81c2ae6e6dbfa82719f79c75e1c9325 ]

The IBM EMAC programs its Maximum Jumbo Size (MJS) drop
threshold from ndev->mtu directly. The hardware sizes the threshold
against the L2 frame minus the ethernet header, but does not
discount the 802.1Q tag, so a frame carrying a VLAN tag and a full
1500-byte payload exceeds MJS by exactly 4 bytes and is dropped.

This is normally hidden because JPSM (and therefore the MJS check)
only engages when the MTU is raised above ETH_DATA_LEN.  With the
qca8k DSA tagger the conduit MTU is bumped by QCA_HDR_LEN to 1502
during dsa_conduit_setup(), which is enough to enable JPSM and
expose the off-by-VLAN-tag in the limit.

Pad MJS by VLAN_HLEN so a VLAN-tagged full-MTU frame passes.

Reported on Meraki MX60 (qca8k switch): tagged VLAN
traffic drops at 1500-byte payload, while 1496 bytes works
and untagged 1500 bytes works.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260526202247.13823-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/emac/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 0c314bf974808..5a602697c5748 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -30,6 +30,7 @@
 #include <linux/skbuff.h>
 #include <linux/crc32.h>
 #include <linux/ethtool.h>
+#include <linux/if_vlan.h>
 #include <linux/mii.h>
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
@@ -466,7 +467,7 @@ static inline u32 emac_iff2rmr(struct net_device *ndev)
 
 	if (emac_has_feature(dev, EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE)) {
 		r &= ~EMAC4_RMR_MJS_MASK;
-		r |= EMAC4_RMR_MJS(ndev->mtu);
+		r |= EMAC4_RMR_MJS(ndev->mtu + VLAN_HLEN);
 	}
 
 	return r;
-- 
2.53.0



