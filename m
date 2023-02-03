Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E001FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9688CC433EF;
	Fri,  3 Feb 2023 10:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419448;
	bh=LNOpqeKIjjxqEIuTBhQJNey81/iUJD2JJBsMq+fg+4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nt5sxRNRifSWcjv5IsM/2dp5ZCnKs7ZRzwlnExl05/Ffq/Ls1LB3UX+ujO2Bog3b8
	 YgNKenoYXRqUlN577vGwessylP3dYcFxDETaN3uhM/2S5DeqzRN9nfECs8HevlZiXi
	 R6AiahRSRguMq0UT1N9tkIS6MqGuHmWOFI/Psadw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/80] memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
Date: Fri,  3 Feb 2023 11:11:55 +0100
Message-Id: <20230203101015.312774603@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit cb8fd6f75775165390ededea8799b60d93d9fe3e ]

The clk_disable_unprepare() should be called in the error handling
of devbus_get_timing_params() and of_platform_populate(), fix it by
replacing devm_clk_get and clk_prepare_enable by devm_clk_get_enabled.

Fixes: e81b6abebc87 ("memory: add a driver for atmel ram controllers")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221126044911.7226-1-cuigaosheng1@huawei.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mvebu-devbus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/memory/mvebu-devbus.c b/drivers/memory/mvebu-devbus.c
index 981860879d02..ddd2e50814b7 100644
--- a/drivers/memory/mvebu-devbus.c
+++ b/drivers/memory/mvebu-devbus.c
@@ -294,10 +294,9 @@ static int mvebu_devbus_probe(struct platform_device *pdev)
 	if (IS_ERR(devbus->base))
 		return PTR_ERR(devbus->base);
 
-	clk = devm_clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(clk))
 		return PTR_ERR(clk);
-	clk_prepare_enable(clk);
 
 	/*
 	 * Obtain clock period in picoseconds,
-- 
2.39.0



