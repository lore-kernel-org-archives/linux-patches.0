Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3AC425CF0;
	Tue, 31 Mar 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975875; cv=none; b=qt3R7ia6r2fHCKzZkHPlgBYAEZ0BQKOcaNn7S003QylYUBhZOJaBrJrkf6uWOWEm7xTVbDv9gcCHEvyr+LGaxvoQVQEEqD4p8E0Ez9CIV992A3N2AvnY4aiwiysPGUHZun3tN4zGggXhtLSX3muowadOV4tARyX/HSwNLRVn6aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975875; c=relaxed/simple;
	bh=eRAhFrtWvY7QCdhtLGAuYSp1GU2Er/t9asTNRrov6J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fitk4UmCnjz42qlVW8Uv3pR7JrVfv4pMIigo+XfMTRUvSBs0FAFEKAmpcxtQxlJixd9p/uGQDecpg86HoBjGFwxK2+3lWhBdbB+wvU7fBBdkmhwvqW/oBXWOuvnSNZMqyHznc1J9A3l3jaUm1HRDVAw7KRZYM6u8b3hq+xkXllE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xklW3kdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xklW3kdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DB5C19423;
	Tue, 31 Mar 2026 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975875;
	bh=eRAhFrtWvY7QCdhtLGAuYSp1GU2Er/t9asTNRrov6J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xklW3kdtMDCXL0qHrucKjKepGaz7JUTyrTUUyQy2w3mMgsSqKZChf9+xpjGoCw2wc
	 LMFJ0JftoIV/rowFCqUnXubK2wuozniCpvJX/D3TpGJevlxhCc0s7c2bAtuaJT8B1G
	 VmzB+NMFS98tMa6RT/VQVdjKX511+x0n49FpZvRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/244] spi: meson-spicc: Fix double-put in remove path
Date: Tue, 31 Mar 2026 18:21:11 +0200
Message-ID: <20260331161746.129842453@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index 1d05590a74346..4ba95b148b1f6 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -903,8 +903,6 @@ static void meson_spicc_remove(struct platform_device *pdev)
 
 	/* Disable SPI */
 	writel(0, spicc->base + SPICC_CONREG);
-
-	spi_controller_put(spicc->host);
 }
 
 static const struct meson_spicc_data meson_spicc_gx_data = {
-- 
2.53.0



