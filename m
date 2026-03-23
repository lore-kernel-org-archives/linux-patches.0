Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F42396D3D;
	Mon, 23 Mar 2026 14:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276901; cv=none; b=g5+70bj6QLsDpcx13ZVAnDElsweGzsenXPeryaP55DGZVVIYzCe74nBz+W7rNCSTJOHWYwjTlaPffLtPWH0m6fJ1UBgX5LILnDa00JsVTYL8tJLCMuLDFYbQsj9T3B40+5RKdG75k50lnaqcZoi1EvWXk4sFPlFJ1GIZEfdjgv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276901; c=relaxed/simple;
	bh=JA6TUCk08pHccPL0JEjpiWUvXPHiIqp8gwPwIBrywKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVc59EVxsN1nbsYMf55+pMfQT93pHBImq00hYDX1baxB564MZQjakPwDeF9Zv+CfClyGLWs43RevK//86Sm0p1ATtcLdJhkfd+NgwJ6EGQkP3puRGBopXjtmIOUhPYPwZDnwZokxC01CuH4UHAwzC3iS3F8n/YSgpWh7RNfLMrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfPsGTsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfPsGTsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA70C4CEF7;
	Mon, 23 Mar 2026 14:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276901;
	bh=JA6TUCk08pHccPL0JEjpiWUvXPHiIqp8gwPwIBrywKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfPsGTsdRnj2j0/0VFlfpbU2jNIW5PHTt3PjOAXvin/7+LuNWNISA56xDdFAbV+zB
	 EGAc4ZZjgF97M+EjLxr1jGgHr7G2SuGYfqBr9oT3/Ql1GuwqHRmhjupH8qyNDObkDo
	 FZGO196mU1n4x5/SqVD9vLaAs9GD6kg0M1HPlNic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/460] mmc: dw_mmc-rockchip: Add memory clock auto-gating support
Date: Mon, 23 Mar 2026 14:44:04 +0100
Message-ID: <20260323134532.592353565@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit ff6f0286c896f062853552097220dd93961be9c4 ]

Per design recommendations, the memory clock can be gated when there
is no in-flight transfer, which helps save power. This feature is
introduced alongside internal phase support, and this patch enables it.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 6465a8bbb0f6 ("mmc: dw_mmc-rockchip: Fix runtime PM support for internal phase support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc-rockchip.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -18,6 +18,8 @@
 #define RK3288_CLKGEN_DIV		2
 #define SDMMC_TIMING_CON0		0x130
 #define SDMMC_TIMING_CON1		0x134
+#define SDMMC_MISC_CON			0x138
+#define MEM_CLK_AUTOGATE_ENABLE		BIT(5)
 #define ROCKCHIP_MMC_DELAY_SEL		BIT(10)
 #define ROCKCHIP_MMC_DEGREE_MASK	0x3
 #define ROCKCHIP_MMC_DEGREE_OFFSET	1
@@ -469,6 +471,7 @@ static int dw_mci_rk3576_parse_dt(struct
 
 static int dw_mci_rockchip_init(struct dw_mci *host)
 {
+	struct dw_mci_rockchip_priv_data *priv = host->priv;
 	int ret, i;
 
 	/* It is slot 8 on Rockchip SoCs */
@@ -493,6 +496,9 @@ static int dw_mci_rockchip_init(struct d
 			dev_warn(host->dev, "no valid minimum freq: %d\n", ret);
 	}
 
+	if (priv->internal_phase)
+		mci_writel(host, MISC_CON, MEM_CLK_AUTOGATE_ENABLE);
+
 	return 0;
 }
 


