Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50721E098;
	Sat, 30 May 2026 17:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163886; cv=none; b=V2zeeyUrkex+gSf6TEdU9vNScgob1UnCKmzu8zs/GDcPgBdoMNW1gIqpDoO8b0+FANGSnTt0KbhLKpTyw4VFuKt4FeKATqVVcoD8ZiKE5p8QFD3cYRnaVMDD4lJINSl1ZhkfSbhxryvD2ByK4h6ujVOM7cLOkvzHLAbklDx5DVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163886; c=relaxed/simple;
	bh=plH0HNDLldB/nMg65fkBiuxFA4DjYTDALbLuG6a6UWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKWifAEu6zS3hdwZ4rT4vM98lXj1ZEDc3VWaNSn+5T0TwWmnp7KutAYsj9T9+5DmIJEUloz3X2k/mF98mB3UZLpsPb06ZGEkv3g5HsigSIGsTt/D7Z2XHu9i1hsZiN+47bODxS98lRorQpBqNacEA/6QLLmsto+4Sj45B2MUjX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oe/ftfde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oe/ftfde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C592F1F00898;
	Sat, 30 May 2026 17:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163885;
	bh=fYepiqVJphLQdysFua5OKv3JxYFqtSQLX5gO810v4YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oe/ftfdeuMpH46HHKcahLOjNXNMsZGR2QqCzH+dpZSH8xil021uAbmvBwsg00KjLX
	 h4KfZjGQVslOwMX+8SKhGKPCPjhUkU54ZXgnsrpL69XbdGhhZFlRvaB12Gy49Rvz84
	 e6DGhCLjGhMpXjq+b2QN+8/53qKZ6Oveweb/oPZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 362/776] spi: imx: fix runtime pm leak on probe deferral
Date: Sat, 30 May 2026 18:01:16 +0200
Message-ID: <20260530160249.923548277@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit a1d50a37d3b1df84f536a982f692371039df4a48 upstream.

Make sure to balance the runtime PM usage count before returning on
probe failure (e.g. probe deferral) so that the controller can be
suspended when a driver is later bound.

Fixes: 43b6bf406cd0 ("spi: imx: fix runtime pm support for !CONFIG_PM")
Cc: stable@vger.kernel.org	# 5.10
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125632.1537235-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1769,6 +1769,7 @@ out_bitbang_start:
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
 	pm_runtime_disable(spi_imx->dev);
+	pm_runtime_put_noidle(spi_imx->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 
 	clk_disable_unprepare(spi_imx->clk_ipg);


