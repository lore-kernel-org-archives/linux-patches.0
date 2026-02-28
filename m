Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DD6347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302469; cv=none; b=mlO3aAF3P4B+OYWj3CwrrjA2STuDhGORD49x2ZIL+rIz8hXz8MhU6GOCPs3N7L1E6EjHhXo6y0ZrSTHuS1ZB4s8JwgW6wOcCqxkHqUj8KmcdzjTBOwMH2mxs53YuLBdRw8lp7ekjOAACCn098qSctvObB8GlBFIwo2+WlxGpywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302469; c=relaxed/simple;
	bh=YzD5rDqN6w89ze9XxHYJD/7N///vkY4xobx5mrfZIuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxdgmu6b+wFZT+tKzS1dUNCXBPc7RzFCuMKZ4cxWrM+Awb2o/WJ1dyLTQy/URH/gB2zXVyvsbCKy5eI+p3ql6eVc+WT6+c2KQzfnOuZYoaDBmMOfT4AybWFdd7ffljkVfmpStieRyCATUVytHnJkcpvLs2ihX7GxAgWpPHHWyNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D1w2eHIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D1w2eHIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0BAC116D0;
	Sat, 28 Feb 2026 18:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302469;
	bh=YzD5rDqN6w89ze9XxHYJD/7N///vkY4xobx5mrfZIuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1w2eHIPCxLelqKEu8W8GK/eRcMjKYiPUuoVStRA6/l3juzrzd74KPMzngxOpOP4g
	 CAoH1SMMiXDWnHxW86ePX2xXcVobY66QpJJr8W/8zjf92bT2uI5/Bz4D1LnDQ8tSV9
	 wc7mYs3VhrImvWvHocsTxsr3M17IN378CoEtTvtS4gRMB8UvLY88hKOBfFTQtx43gB
	 UeWyoqde1Fm72wLudrNRjAfeNzPZNZCNAsrU7H59GFPRiKP5ykwLkQhfSZLtgR/uTv
	 DVdvvEEy9m4VDA15xofN4RgLopDpRUzKPkz6kAByc/RDwJvXoXy56v0PidUAsIpJvd
	 Pr77R0+Cv6MNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/232] net: sparx5/lan969x: fix DWRR cost max to match hardware register width
Date: Sat, 28 Feb 2026 13:11:07 -0500
Message-ID: <20260228181127.1592657-214-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

