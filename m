Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584463AF66E;
	Wed, 30 Sep 2026 17:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790862; cv=none; b=lNo0BFmf5n6zZDSmlEO1jmOkMFYFcOT3VqeuhdZdJcQoK9LEiZIjPvJR1X8co5/ri8yBJASSKeOv6Rd002NTyJEor9WyNqK0iR5oO3Tcn3ADQ+UmuR43hb8KjzvrqiLQvdC23zT3EDCagBWuuFjUgcGw3PfKJPsFUBFlSRtc8ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790862; c=relaxed/simple;
	bh=RA3yUKdaoyAKEACq0EiX9S+tHieELIQPMwXL3Wn1KBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1Gq7wXLBGKEEFesedWBafRY+Q07UjHH8EFIu9NrUQfwVJRA2iqrle8DCnx20yjvoTj5NH/b7aICFRNI/6YsrL/wyUmRmbFgnBMjCJV4zkYV7eqA+96465XAsDaKfOEG5BN6dOTQ1v0jRZVBTmY71Q2LN5MgjCL3HCyCGe3zdo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWSaoBw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWSaoBw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0151F000FF;
	Wed, 30 Sep 2026 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790861;
	bh=Sd08zk+RzL9rmMektSGGmnvV4h+oY7hiaBfhdHfJYcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWSaoBw2CASN2dKZxOJk5k4wHqoeIIKYFZkgSUwSbnpm/KVoJxnaIgZPZC/ck+gVG
	 lngAB40TkoqfGLYoXX8KXdaYgleP0XTgKTTERp23R3ZW52Nn3PXp3G0xgfRoe1eK92
	 +HTTakEiKwgoDDCPRAvr4oPTYJIVpFPfP5t+0w3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/752] net: ibm: emac: Reserve VLAN header in MJS limit
Date: Wed, 30 Sep 2026 17:19:30 +0200
Message-ID: <20260930152400.330395032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 664a91af662df..018fd19d1ce74 100644
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
@@ -465,7 +466,7 @@ static inline u32 emac_iff2rmr(struct net_device *ndev)
 
 	if (emac_has_feature(dev, EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE)) {
 		r &= ~EMAC4_RMR_MJS_MASK;
-		r |= EMAC4_RMR_MJS(ndev->mtu);
+		r |= EMAC4_RMR_MJS(ndev->mtu + VLAN_HLEN);
 	}
 
 	return r;
-- 
2.53.0



