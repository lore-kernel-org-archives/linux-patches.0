Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4080426EB7;
	Tue, 31 Mar 2026 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975127; cv=none; b=dnlWvT/3DbQ+YuH75p2esPQ6pSOA2BZOI3l46d7ubaKrwt5iejuo53fJs4Lsqhx6md1/Eol5rjTW3D3UyF2xxFwN4Zyt3SB376RRT8aFC6wXAxy4pFZ/vKPZbD0Rj+6vywfMbbvTbHAFm/1YuWvqd7GucHJ9cvCwNHFoOG4opbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975127; c=relaxed/simple;
	bh=tt71lWwhBep+CirBDKhjHD1jC5ocB8IYAmEtMlnFp2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gztj7iPEZUThYZGzYZxIM2UnWEMIiTgRPwy4OGKNcn3mCOUojJICIBfZft2Uix5PFy7RO/6NJMTArSiWU+yhWffP+f/ALcl9uLR1FCuIzquJhbBikkECxhlzmOEOH1VbxFXzoJcdIj91aepo8zh64pJ3Ph1MdJzqC1tWir2F8es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bL+gSSMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bL+gSSMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC50C19423;
	Tue, 31 Mar 2026 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975127;
	bh=tt71lWwhBep+CirBDKhjHD1jC5ocB8IYAmEtMlnFp2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bL+gSSMAIUeQaQUzwqgKmmqH8cCrBI0rU60j0Xn9sQWd9NewhJZwpjdWDi5scWVxY
	 Z9t5LZnsggyGc53X3iCWlfHU28vfaMaaJ+2Tsp2rEJEK8Aws/+DpgmzFpvDYrIDpf5
	 QqPOYPAdyTOrra0IUEXaD7JP40pKQ/qwOnBRSf3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 175/342] spi: meson-spicc: Fix double-put in remove path
Date: Tue, 31 Mar 2026 18:20:08 +0200
Message-ID: <20260331161805.448546042@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



