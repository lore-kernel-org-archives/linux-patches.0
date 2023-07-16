Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D58F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F97C433C8;
	Sun, 16 Jul 2023 20:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538273;
	bh=e9xxmM5KlAB5/1aP8KNrtS4G/9k4iV/qvkmZj1N8iY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgVGEbDrrZX3J9Ylpv3j97SwyfOSSN4I8CcI4ngAzKSitfTwUqQbPaOaBar9bIq5d
	 6bW5Dv35p4EdqU5zribz3gyVWI/3NKpqFDRZGa8QZuu72FRDvX+ftXbfeDfGw8CNmU
	 SUk0+MMIt6w+gFNd4KRdnCZ2rIAOdx4+yeTcoXB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Stefan Wahren <stefan.wahren@i2se.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 390/800] clk: bcm: rpi: Fix off by one in raspberrypi_discover_clocks()
Date: Sun, 16 Jul 2023 21:44:03 +0200
Message-ID: <20230716194958.131999792@linuxfoundation.org>
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
index eb399a4d141ba..829406dc44a20 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -356,9 +356,9 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
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



