Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636FA762D2;
	Mon, 15 Apr 2024 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191719; cv=none; b=YxckqO51pmrsk61zkJkoVTno6VYZJdJ9/5zVi9INqwTrQnSr9ne9G2oc8a0q1Tc3TfMqYeeilTdJD9jZz5NPqXQIPnoh926amEVSX3ZQ33WbtdJBOagKKe/f2CfkwdemF95XfGBVQV80eP0ge45G1c49XSQALY8lMqVG054hx5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191719; c=relaxed/simple;
	bh=+mJZ+WoQYKpKZkGfG+KLpKTWeKzIyORh03LIjD9UN78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nphg/Flm21rWPnOQIAOvzTi3qfAxSyka9nJ0bd6x3K8D3FjH4C5ZNHI8pXqdBskZWL3K9TAevytBNRI+vmaXEeLsY/EwLDFVQg9nIgXlxDQ8ZDTOqZkQkjh7UU09eJumZyClBWb92APoXmXsTmTtIde91dw/2Heo3gVRzwPenRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVeed/zH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVeed/zH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7D4C2BD11;
	Mon, 15 Apr 2024 14:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191719;
	bh=+mJZ+WoQYKpKZkGfG+KLpKTWeKzIyORh03LIjD9UN78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVeed/zHyccXfIUZ0oMzNT+UlyvuxMnul2jtb9+c6kTMHqWTERCL7HOvIaMDLXt75
	 +EgCe0UnfnHvFzZOh9rVXyDytENUaoZznb2Q29UHArT1MG2wLkbJMVQm3z4gwwP3II
	 aHpQ2MZegAyojIaxTYHzGwh3fv2iCX3v/+hGfhdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/122] net: sparx5: fix wrong config being used when reconfiguring PCS
Date: Mon, 15 Apr 2024 16:20:28 +0200
Message-ID: <20240415141955.266426010@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



