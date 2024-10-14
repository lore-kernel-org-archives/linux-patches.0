Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDD41C8781;
	Mon, 14 Oct 2024 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919651; cv=none; b=ZkTHop5xtJK2h5Y2mdPlK3VeuCq2a3/KLJcaCKsS4sGlOhCs7dLqLZQlP88Up3HVTLxqB8xVR80wnzibtWOOR+3i0zqP/x+wh8y6n+XkLXD1OGndFVyFaSE7JgY9YiJVhZDbS4ZgHyaRvnEJw09BtFtJGuWJcD2aabfjoOSqxTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919651; c=relaxed/simple;
	bh=ltmy8P/AfxSwTbMQkqCFGMxt4VAVVQPptHUc6LMACIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qx9C5iMUatE7VLxHNK8c1Vg4xyUnTOIisEbdjWHEmrjKWYZt3eleK9384+4OisAiCie9qCykSvfcnEa9Sij9EdaK2kL4rgdxe3AwXh4pPgANx3nESZ6VfP2FLd5LSPAf4Vd50Zb7o8uO9gxIbduyv9OR/h7NF9kxhSSGRNV+noA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxhGlpTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxhGlpTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5787DC4CEC7;
	Mon, 14 Oct 2024 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919651;
	bh=ltmy8P/AfxSwTbMQkqCFGMxt4VAVVQPptHUc6LMACIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxhGlpTGN/Bm0GHjPTPJ9+R9+FhqGxkpce9blmulKPPI8DTaSEh19qH2PlaDT3vti
	 VvO25YPfUjgs5BUSpwVss5S2PZuXovjiNAc4AzWu888BxmZR4zJ7majblhwAf7t+FQ
	 noLdUzVGNh/rLTgtlP7apHSqwCkIwwUTp7vQ9GYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 638/798] clk: imx6ul: retain early UART clocks during kernel init
Date: Mon, 14 Oct 2024 16:19:52 +0200
Message-ID: <20241014141243.106636645@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 912d7af473f163ccdeb02aaabc3534177936b86c ]

Make sure to keep UART clocks enabled during kernel init if
earlyprintk or earlycon are active.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20230421115517.1940990-1-alexander.stein@ew.tq-group.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Stable-dep-of: 32c055ef563c ("clk: imx6ul: fix clock parent for IMX6UL_CLK_ENETx_REF_SEL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6ul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/imx/clk-imx6ul.c b/drivers/clk/imx/clk-imx6ul.c
index 3e802befa2d4d..ef6c94b732684 100644
--- a/drivers/clk/imx/clk-imx6ul.c
+++ b/drivers/clk/imx/clk-imx6ul.c
@@ -542,6 +542,8 @@ static void __init imx6ul_clocks_init(struct device_node *ccm_node)
 
 	clk_set_parent(hws[IMX6UL_CLK_ENET1_REF_SEL]->clk, hws[IMX6UL_CLK_ENET_REF]->clk);
 	clk_set_parent(hws[IMX6UL_CLK_ENET2_REF_SEL]->clk, hws[IMX6UL_CLK_ENET2_REF]->clk);
+
+	imx_register_uart_clocks();
 }
 
 CLK_OF_DECLARE(imx6ul, "fsl,imx6ul-ccm", imx6ul_clocks_init);
-- 
2.43.0



