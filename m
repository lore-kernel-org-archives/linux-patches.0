Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13882FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C223C4339B;
	Mon, 15 May 2023 17:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172808;
	bh=PIL58nMpL2UU9jmVyzVmxxQxeBv/eAKf1Oj8kr59JYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVoOmzdiF8iS6ZUGSF29AjYO8O4boA5v1r143RcPpjy21oq5X7iBRU8k1jJhUOktQ
	 /6Sl1KDYX9CR06xdiSRCmCBdlt6RCkCfPuXE52ldfENX6lEj3LntOAhrmKNxlICNsO
	 D/TaKPP05ftyhDc/iDzW/iFyw+MVPOAlmVDoUNIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/381] mfd: tqmx86: Do not access I2C_DETECT register through io_base
Date: Mon, 15 May 2023 18:28:44 +0200
Message-Id: <20230515161749.113319767@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 1be1b23696b3d4b0231c694f5e0767b4471d33a9 ]

The I2C_DETECT register is at IO port 0x1a7, which is outside the range
passed to devm_ioport_map() for io_base, and was only working because
there aren't actually any bounds checks for IO port accesses.

Extending the range does not seem like a good solution here, as it would
then conflict with the IO resource assigned to the I2C controller. As
this is just a one-off access during probe, use a simple inb() instead.

While we're at it, drop the unused define TQMX86_REG_I2C_INT_EN.

Fixes: 2f17dd34ffed ("mfd: tqmx86: IO controller with I2C, Wachdog and GPIO")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/e8300a30f0791afb67d79db8089fb6004855f378.1676892223.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tqmx86.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tqmx86.c b/drivers/mfd/tqmx86.c
index 732013f40e4e8..99a59341e4492 100644
--- a/drivers/mfd/tqmx86.c
+++ b/drivers/mfd/tqmx86.c
@@ -45,9 +45,8 @@
 #define TQMX86_REG_IO_EXT_INT_MASK		0x3
 #define TQMX86_REG_IO_EXT_INT_GPIO_SHIFT	4
 
-#define TQMX86_REG_I2C_DETECT	0x47
+#define TQMX86_REG_I2C_DETECT	0x1a7
 #define TQMX86_REG_I2C_DETECT_SOFT		0xa5
-#define TQMX86_REG_I2C_INT_EN	0x49
 
 static uint gpio_irq;
 module_param(gpio_irq, uint, 0);
@@ -195,7 +194,12 @@ static int tqmx86_probe(struct platform_device *pdev)
 		 "Found %s - Board ID %d, PCB Revision %d, PLD Revision %d\n",
 		 board_name, board_id, rev >> 4, rev & 0xf);
 
-	i2c_det = ioread8(io_base + TQMX86_REG_I2C_DETECT);
+	/*
+	 * The I2C_DETECT register is in the range assigned to the I2C driver
+	 * later, so we don't extend TQMX86_IOSIZE. Use inb() for this one-off
+	 * access instead of ioport_map + unmap.
+	 */
+	i2c_det = inb(TQMX86_REG_I2C_DETECT);
 
 	if (gpio_irq_cfg) {
 		io_ext_int_val =
-- 
2.39.2



