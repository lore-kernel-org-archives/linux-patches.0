Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59CF881F;
	Sat, 30 Dec 2023 12:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za3u6AO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F159C433C8;
	Sat, 30 Dec 2023 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937818;
	bh=KxyLGrmPfPt0JWp6zdwv1YW8JpRA71SP1XnWV190JTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za3u6AO2a4zI8swxZXsC4/cAI0Oy/uF40v0KbsHCMlAyesj0QxQPmxc3bQ++U0WcQ
	 QlvgcR/Bq/knh5VLYSG76e+9w2iNcAcH9hexKaWs22LHQh81HOgndi8+KdtpyPxU3O
	 CI9RixCkK18JB/1QqYSXvEYzN1cdDhU9KLhu5DFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/156] i2c: qcom-geni: fix missing clk_disable_unprepare() and geni_se_resources_off()
Date: Sat, 30 Dec 2023 11:58:48 +0000
Message-ID: <20231230115814.781076381@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 043465b66506e8c647cdd38a2db1f2ee0f369a1b ]

Add missing clk_disable_unprepare() and geni_se_resources_off() in the error
path in geni_i2c_probe().

Fixes: 14d02fbadb5d ("i2c: qcom-geni: add desc struct to prepare support for I2C Master Hub variant")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 229353e96e095..0a9d389df301b 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -857,6 +857,7 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {
 		dev_err(dev, "Error turning on resources %d\n", ret);
+		clk_disable_unprepare(gi2c->core_clk);
 		return ret;
 	}
 	proto = geni_se_read_proto(&gi2c->se);
@@ -876,8 +877,11 @@ static int geni_i2c_probe(struct platform_device *pdev)
 		/* FIFO is disabled, so we can only use GPI DMA */
 		gi2c->gpi_mode = true;
 		ret = setup_gpi_dma(gi2c);
-		if (ret)
+		if (ret) {
+			geni_se_resources_off(&gi2c->se);
+			clk_disable_unprepare(gi2c->core_clk);
 			return dev_err_probe(dev, ret, "Failed to setup GPI DMA mode\n");
+		}
 
 		dev_dbg(dev, "Using GPI DMA mode for I2C\n");
 	} else {
@@ -890,6 +894,8 @@ static int geni_i2c_probe(struct platform_device *pdev)
 
 		if (!tx_depth) {
 			dev_err(dev, "Invalid TX FIFO depth\n");
+			geni_se_resources_off(&gi2c->se);
+			clk_disable_unprepare(gi2c->core_clk);
 			return -EINVAL;
 		}
 
-- 
2.43.0



