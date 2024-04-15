Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23D714265;
	Mon, 15 Apr 2024 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191996; cv=none; b=tJSc/gYrD/UfbPhzqnyGV5udq9TI10J7bfzLtY2+eo3uVWFzk9vygJ9YwbICIXeaQnzr1vaX+GPC9r4Dej9h6sr6e0blGObx/97KVkZVWvpurCHfPvxXvsioMMEaNj9WQP7L0qtL/rHhIyys4IDRrTX9fzwdwh9/P8/O7bNZt2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191996; c=relaxed/simple;
	bh=dx5mgI0Mx0lFtf2/Z45Tv8XxjeTSEOF7ByBrpoI1DwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUkOe/LTlmoVRjWzTUlYCopyjd2eyYHmHkXraCowSM88Aaa73wkwQiOX3pCRzc1TEtg6RXMIPuepgLrrUJcSfleRcZncg7i+wxwrID1DKI46BtivCYtXEGeqxqZ/UVRbgu0rk26FvryxeizWcs2Z11NrLODlKwv/sDoR2Zjepn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/a4o8+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/a4o8+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A2CC113CC;
	Mon, 15 Apr 2024 14:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191995;
	bh=dx5mgI0Mx0lFtf2/Z45Tv8XxjeTSEOF7ByBrpoI1DwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/a4o8+v1jI2ttE/uFA9feTZkBhncRgycKHZFn8iOeHy1S+xtcW9LKRBTJdlKbRuQ
	 JtKEuBtID3IOrPOf/RnQ2jon2kJHB1pRadTHr6tpYmjx5rH7VaJCKi7WurJ9H8HAj9
	 5p64yH8PoVUR070k8n4n8RJNACMLKdQBjcEt9uHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/69] net: sparx5: fix wrong config being used when reconfiguring PCS
Date: Mon, 15 Apr 2024 16:21:03 +0200
Message-ID: <20240415141947.132001894@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141946.165870434@linuxfoundation.org>
References: <20240415141946.165870434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 32709d21ab2f9..212bf6f4ed72d 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_port.c
@@ -730,7 +730,7 @@ static int sparx5_port_pcs_low_set(struct sparx5 *sparx5,
 	bool sgmii = false, inband_aneg = false;
 	int err;
 
-	if (port->conf.inband) {
+	if (conf->inband) {
 		if (conf->portmode == PHY_INTERFACE_MODE_SGMII ||
 		    conf->portmode == PHY_INTERFACE_MODE_QSGMII)
 			inband_aneg = true; /* Cisco-SGMII in-band-aneg */
@@ -947,7 +947,7 @@ int sparx5_port_pcs_set(struct sparx5 *sparx5,
 	if (err)
 		return -EINVAL;
 
-	if (port->conf.inband) {
+	if (conf->inband) {
 		/* Enable/disable 1G counters in ASM */
 		spx5_rmw(ASM_PORT_CFG_CSC_STAT_DIS_SET(high_speed_dev),
 			 ASM_PORT_CFG_CSC_STAT_DIS,
-- 
2.43.0



