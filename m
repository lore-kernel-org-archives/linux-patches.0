Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3BC8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846EAC433C8;
	Sun, 16 Jul 2023 20:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540214;
	bh=Cc/XOMoNXjows13WsTci9P5/wzuyGdRAzLhZl5Y/v0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUg5sAloDvnqSuoGDhpmh3lzbNLi2TkVF6UC9dX8PBsQ10a3DVrno9rug6/f9ZHof
	 A1g234dUHnpEhm/2CdKEj6M5UJDYMvNY18YhUIFG0wLJMMapGD0sFhNS35u2XGDvM4
	 EiT3czhWP434t03MB4xjdujVqfCi713YdlvdqiPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/591] clk: bcm: rpi: Fix off by one in raspberrypi_discover_clocks()
Date: Sun, 16 Jul 2023 21:46:35 +0200
Message-ID: <20230716194930.509436730@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit da2edb3e3c09fd1451b7f400ccd1070ef086619a ]

Smatch detected an off by one in this code:
    drivers/clk/bcm/clk-raspberrypi.c:374 raspberrypi_discover_clocks()
    error: buffer overflow 'data->hws' 16 <= 16

The data->hws[] array has RPI_FIRMWARE_NUM_CLK_ID elements so the >
comparison needs to changed to >=.

Fixes: 12c90f3f27bb ("clk: bcm: rpi: Add variant structure")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/5a850b08-d2f5-4794-aceb-a6b468965139@kili.mountain
Reviewed-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 679f4649a7efd..278f845572813 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -375,9 +375,9 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
 	while (clks->id) {
 		struct raspberrypi_clk_variant *variant;
 
-		if (clks->id > RPI_FIRMWARE_NUM_CLK_ID) {
+		if (clks->id >= RPI_FIRMWARE_NUM_CLK_ID) {
 			dev_err(rpi->dev, "Unknown clock id: %u (max: %u)\n",
-					   clks->id, RPI_FIRMWARE_NUM_CLK_ID);
+					   clks->id, RPI_FIRMWARE_NUM_CLK_ID - 1);
 			return -EINVAL;
 		}
 
-- 
2.39.2



