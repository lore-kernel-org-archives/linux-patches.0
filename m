Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C832FA3D;
	Fri,  9 Jan 2026 11:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959567; cv=none; b=subHfbmNRJRzIwbsClwQW4H4RHtiYQH23dXWGdea5NZgiuGfdIvc5IAwDzzjaZ/BlHbIQi16cAvWs2ew0eX+UBXsyve0+VIRVq8hCVkCIT7a3WLq6/JJAh/0ccHxchV9DL6tLfKkUQDDfwcEOHJ6artfC6iMu1L6qZW8OvZiCj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959567; c=relaxed/simple;
	bh=BqoTCwINle163ftdHq+xz41KvcJyNTI4jdi9+ghywXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZLvQQ8S7eCS9koAHmbo3nqR22qruf844It+KSbpDPTgb6Nyx66zEf33gAYoydd3TCvRqZaff8CTkM0bU1lESK1Ny9jJgG7elezMzmQLr49o030McUCs8GH+Y0AEWhahSsnkUrB1s/k4UKBEwgxLURBAfxckGVETVtOJUUHwwTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pawTcd+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pawTcd+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBA7C4CEF1;
	Fri,  9 Jan 2026 11:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959567;
	bh=BqoTCwINle163ftdHq+xz41KvcJyNTI4jdi9+ghywXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pawTcd+4oGwIbdEWPgTBx815lRb1U6WFLmbF8rvcbm+uaglSK6iZd2PCVLyTU6man
	 Czg1HubLz93JWJmRSW5CCQp8meyC9X4+ndrkqPFaSUDArZ/2fVUlakIksebVCnOQ+Q
	 Dvj1LuLkj0b2U2uV+9phejIGcwHdSrZMN4OFhKKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/737] mtd: rawnand: lpc32xx_slc: fix GPIO descriptor leak on probe error and remove
Date: Fri,  9 Jan 2026 12:33:56 +0100
Message-ID: <20260109112137.649913630@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit cdf44f1add4ec9ee80569d5a43e6e9bba0d74c7a ]

The driver calls gpiod_get_optional() in the probe function but
never calls gpiod_put() in the remove function or in the probe
error path. This leads to a GPIO descriptor resource leak.
The lpc32xx_mlc.c driver in the same directory handles this
correctly by calling gpiod_put() on both paths.

Add gpiod_put() in the remove function and in the probe error path
to fix the resource leak.

Fixes: 6b923db2867c ("mtd: rawnand: lpc32xx_slc: switch to using gpiod API")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/lpc32xx_slc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/raw/lpc32xx_slc.c b/drivers/mtd/nand/raw/lpc32xx_slc.c
index 1c5fa855b9f2d..8abad092b0580 100644
--- a/drivers/mtd/nand/raw/lpc32xx_slc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -933,6 +933,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	dma_release_channel(host->dma_chan);
 enable_wp:
 	lpc32xx_wp_enable(host);
+	gpiod_put(host->wp_gpio);
 
 	return res;
 }
@@ -958,6 +959,7 @@ static void lpc32xx_nand_remove(struct platform_device *pdev)
 	writel(tmp, SLC_CTRL(host->io_base));
 
 	lpc32xx_wp_enable(host);
+	gpiod_put(host->wp_gpio);
 }
 
 static int lpc32xx_nand_resume(struct platform_device *pdev)
-- 
2.51.0



