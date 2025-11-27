Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892163346AE;
	Thu, 27 Nov 2025 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255825; cv=none; b=pmISihBPUiUoQ1Iu3lHFlz1FIvOI6Va0tOme9/PwMI+b8scCaxUKx+lFtVtFakX3yMISFzHwvEOowzcKR5uAifhAPlcjykK39c97di7a3/hWeXQiTI/ksxxlVVSojFfZHj/qSYOupvzWvBhe/EKySDtIsEMN/S9umboHuZfBoWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255825; c=relaxed/simple;
	bh=NNolQwKJyacI9TlJ2tl2eDC7Pz4va9i4k1UaFmgXuJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCW7Uz6BBrqHc/kisLjnysmD2GP7sBiCvfVHM0hXJhjp3s48djaZyFpSrKGasO1XrmIkEPKHIbN8WxlBcEEPhNjs0ZvwZ3uPAecba+m5w/SU6UuRJcq+fy2qXsOlMdU/oPpAVbRkI8YP88FNF+wHw3VxGPICiEjlFoUkK58m7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ur2/A1Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ur2/A1Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6ABC19422;
	Thu, 27 Nov 2025 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255825;
	bh=NNolQwKJyacI9TlJ2tl2eDC7Pz4va9i4k1UaFmgXuJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ur2/A1Kpn1ciVkBgj+NfRNiBYMdMXdt0TfyDFqsT4vSX+g2y+jxPAELDzX24vZnqi
	 qxJFw+wCLshkYsubbM4DWcmmqMyyAbBZl0ClyS9uKktS6qF/cTb4CRM6TbukfPHmRn
	 G8Rj5pfHS3jIPIaIzA+HSuEoO8TCSEXBlwnwPeDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 126/175] net: phylink: add missing supported link modes for the fixed-link
Date: Thu, 27 Nov 2025 15:46:19 +0100
Message-ID: <20251127144047.560563237@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit e31a11be41cd134f245c01d1329e7bc89aba78fb ]

Pause, Asym_Pause and Autoneg bits are not set when pl->supported is
initialized, so these link modes will not work for the fixed-link. This
leads to a TCP performance degradation issue observed on the i.MX943
platform.

The switch CPU port of i.MX943 is connected to an ENETC MAC, this link
is a fixed link and the link speed is 2.5Gbps. And one of the switch
user ports is the RGMII interface, and its link speed is 1Gbps. If the
flow-control of the fixed link is not enabled, we can easily observe
the iperf performance of TCP packets is very low. Because the inbound
rate on the CPU port is greater than the outbound rate on the user port,
the switch is prone to congestion, leading to the loss of some TCP
packets and requiring multiple retransmissions.

Solving this problem should be as simple as setting the Asym_Pause and
Pause bits. The reason why the Autoneg bit needs to be set, Russell
has gave a very good explanation in the thread [1], see below.

"As the advertising and lp_advertising bitmasks have to be non-empty,
and the swphy reports aneg capable, aneg complete, and AN enabled, then
for consistency with that state, Autoneg should be set. This is how it
was prior to the blamed commit."

Fixes: de7d3f87be3c ("net: phylink: Use phy_caps_lookup for fixed-link configuration")
Link: https://lore.kernel.org/aRjqLN8eQDIQfBjS@shell.armlinux.org.uk # [1]
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20251117102943.1862680-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1988b7d2089a6..928a1186f0d9a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -637,6 +637,9 @@ static int phylink_validate(struct phylink *pl, unsigned long *supported,
 
 static void phylink_fill_fixedlink_supported(unsigned long *supported)
 {
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, supported);
-- 
2.51.0



