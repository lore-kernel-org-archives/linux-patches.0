Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB3E6FBD
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A223CC433C8;
	Wed, 20 Sep 2023 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213203;
	bh=KgrAHmZcACVf93R5gKJHmxhO0TXU7NTAY+pzyouhFoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGEsrtNmcrR4OJFf9U/s7U2cpbr4AQj0j+WQNgHKXE+Td4aWqiLtbiT/GT4giwzSF
	 nfOExyQK9qZrUaZ6IJ9LYTNHc1Mww6WSDOROqs5ceZcjhLAjo/3gTr3juaa4qulSdU
	 EpbOUUoXFWCG3bak+7gUrPg3D2HLRw21bFqQzX+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/367] mtd: rawnand: fsmc: handle clk prepare error in fsmc_nand_resume()
Date: Wed, 20 Sep 2023 13:29:36 +0200
Message-ID: <20230920112903.777542201@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit a5a88125d00612586e941ae13e7fcf36ba8f18a7 ]

In fsmc_nand_resume(), the return value of clk_prepare_enable() should be
checked since it might fail.

Fixes: e25da1c07dfb ("mtd: fsmc_nand: Add clk_{un}prepare() support")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230817115839.10192-1-yiyang13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsmc_nand.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/fsmc_nand.c b/drivers/mtd/nand/raw/fsmc_nand.c
index cc8369a595de3..bccadf8f27fa4 100644
--- a/drivers/mtd/nand/raw/fsmc_nand.c
+++ b/drivers/mtd/nand/raw/fsmc_nand.c
@@ -1181,9 +1181,14 @@ static int fsmc_nand_suspend(struct device *dev)
 static int fsmc_nand_resume(struct device *dev)
 {
 	struct fsmc_nand_data *host = dev_get_drvdata(dev);
+	int ret;
 
 	if (host) {
-		clk_prepare_enable(host->clk);
+		ret = clk_prepare_enable(host->clk);
+		if (ret) {
+			dev_err(dev, "failed to enable clk\n");
+			return ret;
+		}
 		if (host->dev_timings)
 			fsmc_nand_setup(host, host->dev_timings);
 		nand_reset(&host->nand, 0);
-- 
2.40.1



