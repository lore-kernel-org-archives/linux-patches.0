Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355372D23A4;
	Wed, 25 Feb 2026 06:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002741; cv=none; b=rsuZ1nLP18gj03Ysy5ILnbgGdNj5QkDVleoR149gjCU9EDQdyR3rIreOmniNjDpwf/XUTrNbLvfe7WiIBb1uFrUgaqE+Ydu+TaZl/Vl9/72SGawRYD5lTiHbCunkp+UxPw7nJWU+xaPvCoJIkb2hWVlp/9ikJTKTsDxuqRElRVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002741; c=relaxed/simple;
	bh=rEndfa6mgQt4O4pHntKGvZO5cZEH4u8MTkBUstL7ne4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9PFQlE5G582Cgzrjr4g0Uc+DjuG6M1u7lyErUREeEys5fAdRGe+g/8McMOmxXhT7U4tPPaQLrVRgAML9f/qu04j6zMXUB/aDc+kkUHrJ8OYmdk97ElcRD5Y6+wGkjeP8GflgGNBK5mDgz3V4KB0+8+2eKCsVlkfbyhTb+fHY/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8XQAyYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8XQAyYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A67AC116D0;
	Wed, 25 Feb 2026 06:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002741;
	bh=rEndfa6mgQt4O4pHntKGvZO5cZEH4u8MTkBUstL7ne4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8XQAyYFNN3jkGRwkYon63BAXC67WJCHzeVV31p8rCPyV8UYGE5RnwQDSjZY9+tJg
	 vjT7UmgAuuMXU1ZxY4Ghy4VEYCWmLJbyDJcePyXdSySVg8NMe+1Kszy2diP6E/BwHy
	 aZpdqgtaldkfQaMaz3derWw9sMTqzVkdbuzG3y8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 518/641] net: sparx5/lan969x: fix DWRR cost max to match hardware register width
Date: Tue, 24 Feb 2026 17:24:04 -0800
Message-ID: <20260225012401.080522604@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 6c28aa8dfdf24f554d4c5d4ff7d723a95360d94a ]

DWRR (Deficit Weighted Round Robin) scheduling distributes bandwidth
across traffic classes based on per-queue cost values, where lower cost
means higher bandwidth share.

The SPX5_DWRR_COST_MAX constant is 63 (6 bits) but the hardware
register field HSCH_DWRR_ENTRY_DWRR_COST is GENMASK(24, 20), only
5 bits wide (max 31). This causes sparx5_weight_to_hw_cost() to
compute cost values that silently overflow via FIELD_PREP, resulting
in incorrect scheduling weights.

Set SPX5_DWRR_COST_MAX to 31 to match the hardware register width.

Fixes: 211225428d65 ("net: microchip: sparx5: add support for offloading ets qdisc")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260210-sparx5-fix-dwrr-cost-max-v1-1-58fbdbc25652@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_qos.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
index 1231a80335d7b..04f76f1e23f60 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
@@ -35,7 +35,7 @@
 #define SPX5_SE_BURST_UNIT 4096
 
 /* Dwrr */
-#define SPX5_DWRR_COST_MAX 63
+#define SPX5_DWRR_COST_MAX 31
 
 struct sparx5_shaper {
 	u32 mode;
-- 
2.51.0



