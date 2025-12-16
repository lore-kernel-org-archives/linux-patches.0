Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F3C33E340;
	Tue, 16 Dec 2025 11:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884073; cv=none; b=QFioUAIMmpeXvVmJ4jRpU3DLHTActCknRWCDo34TzEjQS5e8gA826H5c92bahZxXJVZEK6Wp2RU/cFQ0H5WaC3DF1NH7og/S4KPhsUgJKNTyaw//DK1qqPrJOuImAOtFoCIKUowKwnn9wnImbAu5jEMnwXMqg+NYQ8C2Kd1toTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884073; c=relaxed/simple;
	bh=Xnxj67nfQu8/lZ/oR0YFH5QkCbUSiRIDzHXigPJekgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY6I+zC1OD8Casq4lpF7PxKh2rUBFyAQej1Y5OnDl70R0pNLnBo+UExoPjvUO3K4w42cfGbtchf8ZF/Uj35FJ06GsZspnWQzIWFAoofVd70Hw15HLnQ2L/sfOGF0MQeNEBcX1AOUC3OlgXvAlCRbQ6l8le+JD5YTV6tHgFcXTNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3yjlk1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3yjlk1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673D0C19422;
	Tue, 16 Dec 2025 11:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884072;
	bh=Xnxj67nfQu8/lZ/oR0YFH5QkCbUSiRIDzHXigPJekgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3yjlk1DGW2dyvcklr0J+70Ky+THul504GGlQfg2HbEK80DZA8zdGoJwRtSHRerz2
	 Ta7TtDewufNW6giR28dEs5m+FAy8OVHuXpNSfiTrWmQqtXQRETDhVJTyzKIOJnWXED
	 A1oPXIQQcsl8Ii+/QILwjNR8w/IkmgcLcGyjgS9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/354] mtd: rawnand: lpc32xx_slc: fix GPIO descriptor leak on probe error and remove
Date: Tue, 16 Dec 2025 12:10:51 +0100
Message-ID: <20251216111323.967009308@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ade971e4cc3b2..09d6c4f90d85a 100644
--- a/drivers/mtd/nand/raw/lpc32xx_slc.c
+++ b/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -937,6 +937,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	dma_release_channel(host->dma_chan);
 enable_wp:
 	lpc32xx_wp_enable(host);
+	gpiod_put(host->wp_gpio);
 
 	return res;
 }
@@ -962,6 +963,7 @@ static void lpc32xx_nand_remove(struct platform_device *pdev)
 	writel(tmp, SLC_CTRL(host->io_base));
 
 	lpc32xx_wp_enable(host);
+	gpiod_put(host->wp_gpio);
 }
 
 static int lpc32xx_nand_resume(struct platform_device *pdev)
-- 
2.51.0



