Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BDB171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC06CC433CA;
	Wed,  9 Aug 2023 10:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578736;
	bh=Aoyw+FCeUA5IeGy98SIeBtVMXfIRDQJ/HrJiPFDKRBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuYaQgnuNV53YVQkY4Jg2t/A8YuERA1yf4oiHQQiduHXm2O6xwK9PFrZ15CTmOWNL
	 5MawppeD4Pu9jjodOri4ntQNraPLP467n4tG62Zy9mCQMBLONT1+R4ivdonqakJbEG
	 26jnVS2/AuRsXDTffYowb/9pmS0rHK18aPcSsI4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/92] net: korina: handle clk prepare error in korina_probe()
Date: Wed,  9 Aug 2023 12:41:15 +0200
Message-ID: <20230809103634.970825424@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 0b6291ad1940c403734312d0e453e8dac9148f69 ]

in korina_probe(), the return value of clk_prepare_enable()
should be checked since it might fail. we can use
devm_clk_get_optional_enabled() instead of devm_clk_get_optional()
and clk_prepare_enable() to automatically handle the error.

Fixes: e4cd854ec487 ("net: korina: Get mdio input clock via common clock framework")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Link: https://lore.kernel.org/r/20230731090535.21416-1-ruc_gongyuanjun@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/korina.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index df9a8eefa007a..916e85039b610 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1301,11 +1301,10 @@ static int korina_probe(struct platform_device *pdev)
 	else if (of_get_ethdev_address(pdev->dev.of_node, dev) < 0)
 		eth_hw_addr_random(dev);
 
-	clk = devm_clk_get_optional(&pdev->dev, "mdioclk");
+	clk = devm_clk_get_optional_enabled(&pdev->dev, "mdioclk");
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
 	if (clk) {
-		clk_prepare_enable(clk);
 		lp->mii_clock_freq = clk_get_rate(clk);
 	} else {
 		lp->mii_clock_freq = 200000000; /* max possible input clk */
-- 
2.40.1



