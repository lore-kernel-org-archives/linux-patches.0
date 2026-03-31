Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B736D2D63E8;
	Tue, 31 Mar 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976610; cv=none; b=ugSV1WWNASoo4OEUgCJy6La8ylKREKRwikhKkqdFvsKpXQ0DCFiaQFJUopKUCv/1xW3L16IrfZETBi6BTARyjbx4WHCXOEHGzbrK0ybM8lQNuKhnZGmdUWMw78sUeBRCWm4yVNeDGnLS/2XRzmuUojoEpWT8i3rFSC3NWcO5k1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976610; c=relaxed/simple;
	bh=9AbhmYnavbjXMdIB10mh+JVQNfcspX/J4B9fhFhxQKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV2E1nJiMW7J8jG8ZemzO/SwO+BznrGx10cfwhbmMK//CjNBnJbctPc9dERyH6Go/m92b8Ha9NooKeIJ9cB0H5fn12sR6wh9s7eTWdwzriQ69im/JiojJewWiS1Ow9QeD+D5U+RsSOIJUIARfPnRSUREl+jG5foHQ/h3yWkXw18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7baDZT6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7baDZT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A12C19423;
	Tue, 31 Mar 2026 17:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976610;
	bh=9AbhmYnavbjXMdIB10mh+JVQNfcspX/J4B9fhFhxQKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7baDZT6Oq1BS26XD37RGg4kSJ4Vy3xgsfSaan207CAqVaZo+Pc6O5KmJiyCCqyoI
	 8ZcTOIo8NQP2pHcAePeS/IdbzrSrszz6JMPVvpjb6yiVCi0SqyKFezBiY1Tvq9c8he
	 +Wwxd1KtbgydsoyryNHgg0DWFiLDfRkWauwMhPKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/309] spi: meson-spicc: Fix double-put in remove path
Date: Tue, 31 Mar 2026 18:21:01 +0200
Message-ID: <20260331161759.283929687@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 63542bb402b7013171c9f621c28b609eda4dbf1f ]

meson_spicc_probe() registers the controller with
devm_spi_register_controller(), so teardown already drops the
controller reference via devm cleanup.

Calling spi_controller_put() again in meson_spicc_remove()
causes a double-put.

Fixes: 8311ee2164c5 ("spi: meson-spicc: fix memory leak in meson_spicc_remove")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260322-rockchip-v1-1-fac3f0c6dad8@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 6b91373075334..c99fab392add1 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -1102,8 +1102,6 @@ static void meson_spicc_remove(struct platform_device *pdev)
 
 	/* Disable SPI */
 	writel(0, spicc->base + SPICC_CONREG);
-
-	spi_controller_put(spicc->host);
 }
 
 static const struct meson_spicc_data meson_spicc_gx_data = {
-- 
2.53.0



