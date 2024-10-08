Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D59B1DE4CB;
	Tue,  8 Oct 2024 12:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391299; cv=none; b=aymH8E+oyvcxMOTdD+O9k/0urBZ7naXcHe9gync9YtmBLjRxM0G+wtO1Upd4H7Ozi6Ct9IoqWPfxRdvGlcQy+JzgogaGoP2RIDYLk2kVEWLmNQrRvT/GZjf7wv4SEi9F6pG0qA8L7v/9hXDgM5FAblB/AuAcTjPDcExA0dAmbqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391299; c=relaxed/simple;
	bh=W7GTAXiuCEcXcPHyyi6fWLrgK1+qgV6qmsBmyh1dQtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4NxHGJp/8o2jODfWyMgBi+wkjmt3lXj6chqGqqxQKlwhaHT4ZsdtVJwGm3rG2HbVsPRNBltKMYElUrY11jEDqeCPyViY6C2N+dfRnP06S6s2L8k/NU9utVn+GHMDPg60DZx9Z07rxo+IhJms/JS9f/RaVvL/qwQ5TqxhXp5Pvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSXZ40aW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSXZ40aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7942C4CEC7;
	Tue,  8 Oct 2024 12:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391299;
	bh=W7GTAXiuCEcXcPHyyi6fWLrgK1+qgV6qmsBmyh1dQtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSXZ40aWa9JBkjMzamZMkW8tjuBSCWHMoQr2ImNvdIkG9Auucxp0f45NjvxH4MFsJ
	 PI7Ok3sfMwuwOWK/fopGx/Nvt+bZSatKimSqdyYm+Htk0MtCXgi4de4gcBCbWqf1Ed
	 9iCAiRs1qq3wR3G04cVqhatdLYR2krN/0JpXctIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 039/558] net: ethernet: lantiq_etop: fix memory disclosure
Date: Tue,  8 Oct 2024 14:01:09 +0200
Message-ID: <20241008115703.762064272@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 45c0de18ff2dc9af01236380404bbd6a46502c69 ]

When applying padding, the buffer is not zeroed, which results in memory
disclosure. The mentioned data is observed on the wire. This patch uses
skb_put_padto() to pad Ethernet frames properly. The mentioned function
zeroes the expanded buffer.

In case the packet cannot be padded it is silently dropped. Statistics
are also not incremented. This driver does not support statistics in the
old 32-bit format or the new 64-bit format. These will be added in the
future. In its current form, the patch should be easily backported to
stable versions.

Ethernet MACs on Amazon-SE and Danube cannot do padding of the packets
in hardware, so software padding must be applied.

Fixes: 504d4721ee8e ("MIPS: Lantiq: Add ethernet driver")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240923214949.231511-2-olek2@wp.pl
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 9e69848153864..804914e7d9a83 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -482,7 +482,9 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 	u32 byte_offset;
 
-	len = skb->len < ETH_ZLEN ? ETH_ZLEN : skb->len;
+	if (skb_put_padto(skb, ETH_ZLEN))
+		return NETDEV_TX_OK;
+	len = skb->len;
 
 	if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) || ch->skb[ch->dma.desc]) {
 		netdev_err(dev, "tx ring full\n");
-- 
2.43.0



