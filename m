Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5043A78281;
	Mon, 15 Apr 2024 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191300; cv=none; b=VXWyP+3NdG9uX4YNh+1ve9CBM0VKIC46rDMi5ebxIY/rhnASiZ7uEy7T2L+5oBzJGhIAQPH5PX3bx+BsVP3voZnDTok8bKOuR79zxdD9RSD9lrAzqElAlUMLRnANszYyMwApBlkRLae7qTxpMAEglHkL/PHqnGM6SNVoNrRlryQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191300; c=relaxed/simple;
	bh=U+T+sWtXVsb5St6FP4wMnjJ5KD+FrS2jadcBbTvzQq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brRuRcUMaQaC2oDtmHOAKh70gCY6S8jO3b0x0RaODVTOBmi66aWyt64bZrVZHW5aAtNmDHkqLZyWMk5Tnr/7P2kQG7ldPXCrIpD1jR5w0FfC6ywN3sZ1bhPUC8b012BWnaCDfyDpd7qLff1Le2xEKyF+ZgKHpAB/Rou3xaq5pCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKhestEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKhestEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D8DC113CC;
	Mon, 15 Apr 2024 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191300;
	bh=U+T+sWtXVsb5St6FP4wMnjJ5KD+FrS2jadcBbTvzQq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKhestEBVtOYOpP/MXWfpDXzNLm7fsH1sKgmLPv2FSaosEhXkoEOB5iv02sENiE8W
	 yva824Rk3dUGamRL1D6QL9Ftywk9Uc8HyLf1Z+0pVE0nVa4ejTGEy0pug6ZFt5qDqk
	 RnMN0UY18ij3/wLJMQuyYxZu7EvDM6pYbRyBNWUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 091/172] net: sparx5: fix wrong config being used when reconfiguring PCS
Date: Mon, 15 Apr 2024 16:19:50 +0200
Message-ID: <20240415142003.159350716@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 33623113a48ea906f1955cbf71094f6aa4462e8f ]

The wrong port config is being used if the PCS is reconfigured. Fix this
by correctly using the new config instead of the old one.

Fixes: 946e7fd5053a ("net: sparx5: add port module support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240409-link-mode-reconfiguration-fix-v2-1-db6a507f3627@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
index 3a1b1a1f5a195..60dd2fd603a85 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -731,7 +731,7 @@ static int sparx5_port_pcs_low_set(struct sparx5 *sparx5,
 	bool sgmii = false, inband_aneg = false;
 	int err;
 
-	if (port->conf.inband) {
+	if (conf->inband) {
 		if (conf->portmode == PHY_INTERFACE_MODE_SGMII ||
 		    conf->portmode == PHY_INTERFACE_MODE_QSGMII)
 			inband_aneg = true; /* Cisco-SGMII in-band-aneg */
@@ -948,7 +948,7 @@ int sparx5_port_pcs_set(struct sparx5 *sparx5,
 	if (err)
 		return -EINVAL;
 
-	if (port->conf.inband) {
+	if (conf->inband) {
 		/* Enable/disable 1G counters in ASM */
 		spx5_rmw(ASM_PORT_CFG_CSC_STAT_DIS_SET(high_speed_dev),
 			 ASM_PORT_CFG_CSC_STAT_DIS,
-- 
2.43.0



