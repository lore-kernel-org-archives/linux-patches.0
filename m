Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0EE335BBF;
	Mon, 18 Aug 2025 13:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524847; cv=none; b=BMdbA0prLLzAafCHS8uqTpXZJLE/gd7s/2ExiWQ2fjblHXtLr5W4YVCiabD0SLzSbTd2Fqog+IfjRctJIiRKOzlnPnABcMAJmjYBJ88UtcVlIaHAQyT6LYaeHS053xUCjdx3kbg5yiZWf+ckbTDFFuPnM1wN/5nPyXOOHPkhdy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524847; c=relaxed/simple;
	bh=F9Zj81wK5AVLOv6gfAtl+aRAB3wjE3ppiW56u0J99XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6uZhsfn4dkBlSGJY2+ikUoTEIjPS6bdv7zAPk2AHVwkB3cjDQVbkRhM4OLwXflBxUNVXYabibcqJz6Msm5YmBC0TO7KxwwF2nfvGUbyK/UmOhlSno6Ix5obQq08VtaauYR7xM8DFoBq8+M/E0G2GRqXmB2Il5qWdJSoYxafB/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WqkxIWsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WqkxIWsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C05C4CEEB;
	Mon, 18 Aug 2025 13:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524847;
	bh=F9Zj81wK5AVLOv6gfAtl+aRAB3wjE3ppiW56u0J99XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqkxIWsWTiXMdHBu1i2nsRzNKmFrRzZ4dJeZHTxeeEGhuHd9z4VH/SyUBoDjSSx7M
	 seDy7ULbgnvYhTQ1mr28zXE+uF1uU7c2xx/7SLZdNp4B5mJHy1dEEdIv6w3y0zx8vW
	 lykUs+hawURSTi7L1EDsQK/CX4yBXIaH2zhanROA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Drew Fustini <fustini@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 081/570] net: stmmac: thead: Get and enable APB clock on initialization
Date: Mon, 18 Aug 2025 14:41:08 +0200
Message-ID: <20250818124508.938977787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 4cc339ce482ba78589a2d5cbe1c84b735d263383 ]

It's necessary to adjust the MAC TX clock when the linkspeed changes,
but it's noted such adjustment always fails on TH1520 SoC, and reading
back from APB glue registers that control clock generation results in
garbage, causing broken link.

With some testing, it's found a clock must be ungated for access to APB
glue registers. Without any consumer, the clock is automatically
disabled during late kernel startup. Let's get and enable it if it's
described in devicetree.

For backward compatibility with older devicetrees, probing won't fail if
the APB clock isn't found. In this case, we emit a warning since the
link will break if the speed changes.

Fixes: 33a1a01e3afa ("net: stmmac: Add glue layer for T-HEAD TH1520 SoC")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Tested-by: Drew Fustini <fustini@kernel.org>
Reviewed-by: Drew Fustini <fustini@kernel.org>
Link: https://patch.msgid.link/20250808093655.48074-4-ziyao@disroot.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c
index c72ee759aae5..f2946bea0bc2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-thead.c
@@ -211,6 +211,7 @@ static int thead_dwmac_probe(struct platform_device *pdev)
 	struct stmmac_resources stmmac_res;
 	struct plat_stmmacenet_data *plat;
 	struct thead_dwmac *dwmac;
+	struct clk *apb_clk;
 	void __iomem *apb;
 	int ret;
 
@@ -224,6 +225,19 @@ static int thead_dwmac_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(plat),
 				     "dt configuration failed\n");
 
+	/*
+	 * The APB clock is essential for accessing glue registers. However,
+	 * old devicetrees don't describe it correctly. We continue to probe
+	 * and emit a warning if it isn't present.
+	 */
+	apb_clk = devm_clk_get_enabled(&pdev->dev, "apb");
+	if (PTR_ERR(apb_clk) == -ENOENT)
+		dev_warn(&pdev->dev,
+			 "cannot get apb clock, link may break after speed changes\n");
+	else if (IS_ERR(apb_clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(apb_clk),
+				     "failed to get apb clock\n");
+
 	dwmac = devm_kzalloc(&pdev->dev, sizeof(*dwmac), GFP_KERNEL);
 	if (!dwmac)
 		return -ENOMEM;
-- 
2.50.1



