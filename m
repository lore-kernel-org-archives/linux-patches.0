Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2621E28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F897C433EF;
	Mon, 30 Jan 2023 14:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087889;
	bh=FxERe+RFUM5rPkiZbMMrkk1q7F2XS/VoDUBqXu9nvOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgpiQbkZmEBdYrHwCXV3pdFzovf+ff/Ie7yA0s9v/455hxl15SbbGlxUDG6KLtAhB
	 P2bJ6LDpS/WKUoeyhP/3+cI7w2VES3t1pjZ95+JkVYGjVuMqebIfKooPlGMKtL+l4t
	 kmGvXBi08WgGtKy+s4Ei47pHsAxOFp9e3LsS6F4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/204] memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
Date: Mon, 30 Jan 2023 14:49:28 +0100
Message-Id: <20230130134316.470114389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 8450638e8670..efc6c08db2b7 100644
--- a/drivers/memory/mvebu-devbus.c
+++ b/drivers/memory/mvebu-devbus.c
@@ -280,10 +280,9 @@ static int mvebu_devbus_probe(struct platform_device *pdev)
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



