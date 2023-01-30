Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D003C28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD1DC433EF;
	Mon, 30 Jan 2023 14:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087718;
	bh=7FLw4lpAnRKk/OY7ol1GEUoAYKmM45l2YRaspYl3lbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6HlPjILXinJgguOzKZGEPbIX9C+4dngBrfDDJxF+pzfjIGBq1BZcGqMAFHieUt0/
	 rAPeki0H7Qa3MDU7tOjc1Lu++HJp/OHPL5LYZA0YKMlUeDGjLrTzPioghOZsJdJUPe
	 z6HLn+olRAn9zsXqfmd0WKGk0r4ceuPR95xu2k/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 271/313] net: dsa: microchip: fix probe of I2C-connected KSZ8563
Date: Mon, 30 Jan 2023 14:51:46 +0100
Message-Id: <20230130134349.361267420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 360fdc999d92db4a4adbba0db8641396dc9f1b13 ]

Starting with commit eee16b147121 ("net: dsa: microchip: perform the
compatibility check for dev probed"), the KSZ switch driver now bails
out if it thinks the DT compatible doesn't match the actual chip ID
read back from the hardware:

  ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
  KSZ8563, please fix it!

For the KSZ8563, which used ksz_switch_chips[KSZ9893], this was fine
at first, because it indeed shares the same chip id as the KSZ9893.

Commit b44908095612 ("net: dsa: microchip: add separate struct
ksz_chip_data for KSZ8563 chip") started differentiating KSZ9893
compatible chips by consulting the 0x1F register. The resulting breakage
was fixed for the SPI driver in the same commit by introducing the
appropriate ksz_switch_chips[KSZ8563], but not for the I2C driver.

Fix this for I2C-connected KSZ8563 now to get it probing again.

Fixes: b44908095612 ("net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip").
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230120110933.1151054-1-a.fatoum@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz9477_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 3763930dc6fc..aae1dadef882 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -105,7 +105,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
 	},
 	{
 		.compatible = "microchip,ksz8563",
-		.data = &ksz_switch_chips[KSZ9893]
+		.data = &ksz_switch_chips[KSZ8563]
 	},
 	{
 		.compatible = "microchip,ksz9567",
-- 
2.39.0



