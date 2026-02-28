Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8EC33A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301931; cv=none; b=GLLU/CXaPdJOUMDRQIK8VBZG0PG8oRD0GSvuOyG9gyrAfjRKYqKrPJ3nGRmxk26q5isggIqxtc75nSnOMOE7HDdE2jYKDboCvIwk6i25WL4vAuViagaBwN5ILtN9rXarnAr4tfC451A+6IhnUHbodpCTxmsyb6Yz3PKBllSZBrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301931; c=relaxed/simple;
	bh=YzD5rDqN6w89ze9XxHYJD/7N///vkY4xobx5mrfZIuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djqgC/CG+6pTTgipOfmIe4FzAvt5GZP5UpfCRaQ1bg6XLA5R+p+Ba9B7seY5Sld1bCz+srYmv24HNv07P6lqkB9xvJJwtLu2k22LMVPXoxgjbBSB/qwzS16hji9uDg/6t0lHIFY0lM3AlUUHD1WiPQGR5skAWXcaMGRT8sx7RlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvBK2GjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvBK2GjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA32C19424;
	Sat, 28 Feb 2026 18:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301931;
	bh=YzD5rDqN6w89ze9XxHYJD/7N///vkY4xobx5mrfZIuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvBK2GjWnoYGRiKReBbOpb0Ikay9OP1FSgOLAgqjc5V6dyE6XuVysSRG5+MFQKnXd
	 m6U52dBMs8fBv3XNS6G2I0UgWB+8J9laWZ2OcpYgNuvQSRTVPtV4tfp95EyXjTAcC/
	 YFwG/bvcEgMHGEmY3S6h4IueohtjOQg3tpsTb5aSXz/XwLB3ulRBm4S8Hek0qnqrxe
	 tMerCVUCkOOEynlJ1iAbxMAROMYBD24ouZvF7fkK5W35jDBEHd6jk9XW5emRqjsUWX
	 /S8yTJTGWc2w2YjY/ROpeA1nwhV6wBMV+JeZIAuYi4YUcYdZNCjDgyxmaSopRe7ztR
	 TCLB4i87JjPVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 366/385] net: sparx5/lan969x: fix DWRR cost max to match hardware register width
Date: Sat, 28 Feb 2026 12:59:48 -0500
Message-ID: <20260228180011.1568201-366-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index ced35033a6c5d..b1c6c5c6f16ca 100644
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

