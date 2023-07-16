Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744298F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CBFC433C8;
	Sun, 16 Jul 2023 20:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538364;
	bh=E+o87KNxCfTBEnyE+gF/Z3QTgmEvlLDwlURGDvXgTao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DujFptJ5ChD5DJaK4vDKzX2yYFmZGq7I58ao1wwQM6BzKjKHmmzRVtBUam5ARGO/k
	 wB3XPDtUhwZrWR/Z8u+FUPTOdbOt1LyOUcO+w7eWa3lsjGpQOg8MplMmVg/PnuYiEl
	 eikX7KFTqnO8qp8J7RSb74jXM4Iw9RjOzo+zkxPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 423/800] clk: clocking-wizard: check return value of devm_kasprintf()
Date: Sun, 16 Jul 2023 21:44:36 +0200
Message-ID: <20230716194958.914688292@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit b1356ed1a4461de06dfdc02bf549c3e8750162e5 ]

devm_kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: 2046338dcbc6 ("ARM: mxs: Use soc bus infrastructure")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230530093913.1656095-9-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/xilinx/clk-xlnx-clock-wizard.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
index 16df34f46280f..d56822ce6126c 100644
--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -648,6 +648,11 @@ static int clk_wzrd_probe(struct platform_device *pdev)
 	}
 
 	clkout_name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_out0", dev_name(&pdev->dev));
+	if (!clkout_name) {
+		ret = -ENOMEM;
+		goto err_disable_clk;
+	}
+
 	if (nr_outputs == 1) {
 		clk_wzrd->clkout[0] = clk_wzrd_register_divider
 				(&pdev->dev, clkout_name,
-- 
2.39.2



