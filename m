Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A48033A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302252; cv=none; b=XGQ2jAhQFoCifrrP26UJInfXTesbQErEx7z9qwJ7qjJTBZksW2HjiZkXvvm61cPhvTLiPW+yg1zyUgg6xqj1Dthu3g5G1qQ5Kw0f1nUIzN2n887TaQeyYJ/P8Q3QCkQ/EVgb+26VwKkt/EepHWTv44KujrpFV7cUKYLW7qKnmio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302252; c=relaxed/simple;
	bh=YzD5rDqN6w89ze9XxHYJD/7N///vkY4xobx5mrfZIuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouoWfly1o0Ab+3BwPoATLLTSCSX3KVlwBgvON7pN5Eje9WPWLfF2wQAXKzl1n4u+gfewBownMu6Oit1PIhijQrUIVE8tHATtdyeT16WIrUD1OjgWy+UO7LJvp9vc33jbgnAQdJb5OsSB1sB6fT46RIEpN1A8jmdhSCMKXzZfrbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxkAgucP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxkAgucP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB96C116D0;
	Sat, 28 Feb 2026 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302251;
	bh=YzD5rDqN6w89ze9XxHYJD/7N///vkY4xobx5mrfZIuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxkAgucPRdJhkjSZ6RuA1Enz5+YjgqLsmdQ6MCRqjJQgUKn9rfwjEKzwGRV/pS4hV
	 XL6yi2XSKHaldizvP9Ecx1upDidTIqM+YWKbW0H8X9LoJhc5JuXvZJfz+XL9xpuRxK
	 OkX68pZJf2wbw3aaJBIGoqml9HLIxiEsywkXGWthaIytbSpOn5hxcTxx0E1qaPXaKc
	 kQpnPGk/vpcXXFsVVBRjVDlUnrf+XNtUZHwf7Kjm5pax1Sn+0Ac+yj9tLftCZwh996
	 TgcQyH04PVog5104/vydiqBeROpfDo2qmK8n3ja5dBOFa/i1vCwfU8j2jc3a/4YL/s
	 e1AGji4BJMzzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/283] net: sparx5/lan969x: fix DWRR cost max to match hardware register width
Date: Sat, 28 Feb 2026 13:06:47 -0500
Message-ID: <20260228180709.1583486-265-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

