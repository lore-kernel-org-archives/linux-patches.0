Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BDC223C50;
	Thu, 12 Dec 2024 16:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019462; cv=none; b=LsLhYH8sO1O2tig5gdtOg95uA2eJGiSnutZ+aB7jyRAwjLQTQbcqElYPrrfwsjXuxN9FeTIBCzFVxW1dHvlr20FlkcPg5YU5Mkn+eMgdeQSv81yLFzOR+AOD+5jJyhdkdJ/a+un9XXoxGmxwLnDc4B82Z91gyBlfh55WmC67zaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019462; c=relaxed/simple;
	bh=X/a/fgO7lksNhU0t9vFqMugxg61dr6Q73oghjTAWoq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9iRa7fGCkHhjpf2Nw/zb9xbmFAeMDrfFp0umKPKLu09+v5f88x5Kw2v1s5szzP3xbW9SDrdrY0yyaq5v4+Nu3K2tmNrfG4Rav1MSnGH5zMwx2VuaSg0U8sf4Zg9vDUpRmDhaZW153Pos+8F5kjcAvVTpCnQoMO/5IBbi9pg8uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMdxupFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMdxupFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B793CC4CECE;
	Thu, 12 Dec 2024 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019462;
	bh=X/a/fgO7lksNhU0t9vFqMugxg61dr6Q73oghjTAWoq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMdxupFnBo+jkJlH3g5lkY0U5zghRcGYHP0n2+70gYlC75+XYToSV1HpSmGQC/qDz
	 As+45LFOm06rG3a0dVEVVNnryK2KT/p9WmldB4PJJnu33d0SX3GLgcQOdIJtNOs7qm
	 bz+hZqk+pR26pEnyMEXsjbViblx6marozh1ox87k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/772] memory: renesas-rpc-if: Improve Runtime PM handling
Date: Thu, 12 Dec 2024 15:52:38 +0100
Message-ID: <20241212144358.720744145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit bb0b025d72d22b8617df920b61f5ae1e23d1b593 ]

Convert from the deprecated pm_runtime_get_sync() to the new
pm_runtime_resume_and_get(), and add error checking.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/6f2bd3b2b3d98c5bed541d969900b2ad04f93943.1669213027.git.geert+renesas@glider.be
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 7d189579a287 ("mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/renesas-rpc-if.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 7343dbb79c9f7..6991185caa7bb 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -303,12 +303,13 @@ int rpcif_hw_init(struct rpcif *rpcif, bool hyperflash)
 {
 	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	u32 dummy;
+	int ret;
 
-	pm_runtime_get_sync(rpc->dev);
+	ret = pm_runtime_resume_and_get(rpc->dev);
+	if (ret)
+		return ret;
 
 	if (rpc->type == RPCIF_RZ_G2L) {
-		int ret;
-
 		ret = reset_control_reset(rpc->rstc);
 		if (ret)
 			return ret;
@@ -478,7 +479,9 @@ int rpcif_manual_xfer(struct rpcif *rpcif)
 	u32 smenr, smcr, pos = 0, max = rpc->bus_size == 2 ? 8 : 4;
 	int ret = 0;
 
-	pm_runtime_get_sync(rpc->dev);
+	ret = pm_runtime_resume_and_get(rpc->dev);
+	if (ret < 0)
+		return ret;
 
 	regmap_update_bits(rpc->regmap, RPCIF_PHYCNT,
 			   RPCIF_PHYCNT_CAL, RPCIF_PHYCNT_CAL);
@@ -646,11 +649,14 @@ ssize_t rpcif_dirmap_read(struct rpcif *rpcif, u64 offs, size_t len, void *buf)
 	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	loff_t from = offs & (rpc->size - 1);
 	size_t size = rpc->size - from;
+	int ret;
 
 	if (len > size)
 		len = size;
 
-	pm_runtime_get_sync(rpc->dev);
+	ret = pm_runtime_resume_and_get(rpc->dev);
+	if (ret < 0)
+		return ret;
 
 	regmap_update_bits(rpc->regmap, RPCIF_CMNCR, RPCIF_CMNCR_MD, 0);
 	regmap_write(rpc->regmap, RPCIF_DRCR, 0);
-- 
2.43.0



