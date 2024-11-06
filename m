Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBC97DA7F;
	Wed,  6 Nov 2024 12:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896289; cv=none; b=tPzYeyiYbOb2A1y3LAcgsuUgSpjHkN0jUzZWMlK188IjLw6hZKCuWOAHmo/y4SNxvhZEV+TY76piw487oq3+qwr1s/B7heFJCXL9yc1/VopldguGydE9eAhJT58xJdPacjOuP7nYX5m7m9/lVsOxTzWqfzB/+1f2ovMZa1dV7cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896289; c=relaxed/simple;
	bh=m8OYbbqxsd2IWw1bw2QEdBKj85KtH7f8xd7VuINe1GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3++LPSE3yGq3D2jrRMbf9+Ntc/NJfcFvzy9+oxRyOQ7YjBR+EJnjfy3AiGQngyVnlUYB7RyLPjhtptMardX6QqQZoq+ctM5LJEQrvnHi1ekBBO0kwKqa3ebLc9w9jbyBY3F3afoloKgLh69spcF/AmNl0TjhmBmnQSHmoZGwFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dZmbmyWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dZmbmyWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCADC4CECD;
	Wed,  6 Nov 2024 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896289;
	bh=m8OYbbqxsd2IWw1bw2QEdBKj85KtH7f8xd7VuINe1GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dZmbmyWn4+c2uQaoGOvHlYCRPnho5K7UpBYOBHStmGeT6ujqVANvz681f/d0B7r/G
	 l8z+UitMe6k2ZYN0Q6ED2NiZ5el1AwP/3Sus4ZHUiVvxv14h+oywd5iGu+hJxmgZRC
	 4YHIlVjhOxjLRDctubS65ZkNYjaT4W0Jtk2RikLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 152/245] spi: spi-fsl-dspi: Fix crash when not using GPIO chip select
Date: Wed,  6 Nov 2024 13:03:25 +0100
Message-ID: <20241106120322.971127429@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 25f00a13dccf8e45441265768de46c8bf58e08f6 ]

Add check for the return value of spi_get_csgpiod() to avoid passing a NULL
pointer to gpiod_direction_output(), preventing a crash when GPIO chip
select is not used.

Fix below crash:
[    4.251960] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[    4.260762] Mem abort info:
[    4.263556]   ESR = 0x0000000096000004
[    4.267308]   EC = 0x25: DABT (current EL), IL = 32 bits
[    4.272624]   SET = 0, FnV = 0
[    4.275681]   EA = 0, S1PTW = 0
[    4.278822]   FSC = 0x04: level 0 translation fault
[    4.283704] Data abort info:
[    4.286583]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    4.292074]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    4.297130]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    4.302445] [0000000000000000] user address but active_mm is swapper
[    4.308805] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[    4.315072] Modules linked in:
[    4.318124] CPU: 2 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.0-rc4-next-20241023-00008-ga20ec42c5fc1 #359
[    4.328130] Hardware name: LS1046A QDS Board (DT)
[    4.332832] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    4.339794] pc : gpiod_direction_output+0x34/0x5c
[    4.344505] lr : gpiod_direction_output+0x18/0x5c
[    4.349208] sp : ffff80008003b8f0
[    4.352517] x29: ffff80008003b8f0 x28: 0000000000000000 x27: ffffc96bcc7e9068
[    4.359659] x26: ffffc96bcc6e00b0 x25: ffffc96bcc598398 x24: ffff447400132810
[    4.366800] x23: 0000000000000000 x22: 0000000011e1a300 x21: 0000000000020002
[    4.373940] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
[    4.381081] x17: ffff44740016e600 x16: 0000000500000003 x15: 0000000000000007
[    4.388221] x14: 0000000000989680 x13: 0000000000020000 x12: 000000000000001e
[    4.395362] x11: 0044b82fa09b5a53 x10: 0000000000000019 x9 : 0000000000000008
[    4.402502] x8 : 0000000000000002 x7 : 0000000000000007 x6 : 0000000000000000
[    4.409641] x5 : 0000000000000200 x4 : 0000000002000000 x3 : 0000000000000000
[    4.416781] x2 : 0000000000022202 x1 : 0000000000000000 x0 : 0000000000000000
[    4.423921] Call trace:
[    4.426362]  gpiod_direction_output+0x34/0x5c (P)
[    4.431067]  gpiod_direction_output+0x18/0x5c (L)
[    4.435771]  dspi_setup+0x220/0x334

Fixes: 9e264f3f85a5 ("spi: Replace all spi->chip_select and spi->cs_gpiod references with function call")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20241023203032.1388491-1-Frank.Li@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 191de1917f831..3fa990fb59c78 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -1003,6 +1003,7 @@ static int dspi_setup(struct spi_device *spi)
 	u32 cs_sck_delay = 0, sck_cs_delay = 0;
 	struct fsl_dspi_platform_data *pdata;
 	unsigned char pasc = 0, asc = 0;
+	struct gpio_desc *gpio_cs;
 	struct chip_data *chip;
 	unsigned long clkrate;
 	bool cs = true;
@@ -1077,7 +1078,10 @@ static int dspi_setup(struct spi_device *spi)
 			chip->ctar_val |= SPI_CTAR_LSBFE;
 	}
 
-	gpiod_direction_output(spi_get_csgpiod(spi, 0), false);
+	gpio_cs = spi_get_csgpiod(spi, 0);
+	if (gpio_cs)
+		gpiod_direction_output(gpio_cs, false);
+
 	dspi_deassert_cs(spi, &cs);
 
 	spi_set_ctldata(spi, chip);
-- 
2.43.0



