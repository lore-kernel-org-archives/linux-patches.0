Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F191ACEDE;
	Tue, 17 Mar 2026 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768549; cv=none; b=T1Nepq12PtyiBEhe1Tooe9/35wlIjC3rsc+JRSfkXuIm27dpZn7aQ/O6bgMN9Qqz+5VRSbo4AxT0EGdjeEgi0UXImhs5hgBJAork17R3aO22DxgKOOZAgqK87O9/YkTxZSA9tV5pdy4YhDliAx4N2joQBhn2nZ+yi0oLxF6as/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768549; c=relaxed/simple;
	bh=g5OtyJgWAIXa3nb4ienrN1N2qcqlyZY/wh6yvlEVJqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsSwR8den72YboFLcJ1KnQqo8LTjaBInkRB8UZNpsxvp/Shz4achQbuNN2RdCe46gHr5QVSyezzUWSvppZ4FWlFzP/TB0UKOlBb2QIfm7ZDdDJfp/0S+FtCn0wVoWL93Swuj5ROPHdKE5P3WE2ElwsFeKaaKXT/19xNeraCwOaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXOFZXMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXOFZXMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8BDC4CEF7;
	Tue, 17 Mar 2026 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768549;
	bh=g5OtyJgWAIXa3nb4ienrN1N2qcqlyZY/wh6yvlEVJqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXOFZXMA8SRhMsBX0+RH9QRh4Gq9ihmlcbn+0cQwUTmQIf6pY97voEavhksHGJz02
	 oxHofeDDTBjM2/O5t3V4BuNfManF8apM0l1k2v/yxG5ftRrI9OGK79kZWRkj2PNP8J
	 TG5tu0oss9TLIiMK/sVTpIQUSZr/kbQdrDiL45eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 319/333] mmc: dw_mmc-rockchip: Add memory clock auto-gating support
Date: Tue, 17 Mar 2026 17:35:48 +0100
Message-ID: <20260317163011.216858818@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -19,6 +19,8 @@
 #define RK3288_CLKGEN_DIV		2
 #define SDMMC_TIMING_CON0		0x130
 #define SDMMC_TIMING_CON1		0x134
+#define SDMMC_MISC_CON			0x138
+#define MEM_CLK_AUTOGATE_ENABLE		BIT(5)
 #define ROCKCHIP_MMC_DELAY_SEL		BIT(10)
 #define ROCKCHIP_MMC_DEGREE_MASK	0x3
 #define ROCKCHIP_MMC_DEGREE_OFFSET	1
@@ -470,6 +472,7 @@ static int dw_mci_rk3576_parse_dt(struct
 
 static int dw_mci_rockchip_init(struct dw_mci *host)
 {
+	struct dw_mci_rockchip_priv_data *priv = host->priv;
 	int ret, i;
 
 	/* It is slot 8 on Rockchip SoCs */
@@ -494,6 +497,9 @@ static int dw_mci_rockchip_init(struct d
 			dev_warn(host->dev, "no valid minimum freq: %d\n", ret);
 	}
 
+	if (priv->internal_phase)
+		mci_writel(host, MISC_CON, MEM_CLK_AUTOGATE_ENABLE);
+
 	return 0;
 }
 


