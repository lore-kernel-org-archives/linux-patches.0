Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B4A15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077ABC433C8;
	Wed,  9 Aug 2023 10:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578015;
	bh=eZrklH5sZ77N4MIS5E+KpLGufMYlpx9j5J25AaEjfYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGVaS+SPLIM9giAB/cS9v3c8YfepEUJCP9vklo4qL6LeQ276DGaKNFHHZT1yL6qEe
	 FQnHz9xvOe2zzsF0iCKhLFgegGULKg2W9vKef1r2Eu+cmgHtiJjnPcjxFXUv1C8Dbt
	 wJir0tsN0TG8nB0bnSz6w97VBIZSu7y9YO2Kwq5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 076/165] net: korina: handle clk prepare error in korina_probe()
Date: Wed,  9 Aug 2023 12:40:07 +0200
Message-ID: <20230809103645.283733060@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
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
index 2b9335cb4bb3a..8537578e1cf1d 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1302,11 +1302,10 @@ static int korina_probe(struct platform_device *pdev)
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



