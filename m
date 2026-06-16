Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C993CC303;
	Tue, 16 Jun 2026 18:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636188; cv=none; b=ialn5FZBR1FayoseM2WSlSUuV09bmX8srtEsJsuItmX218MYewTIh/K78nO09DQXB6zaVWH/oRLmhtAfAqH2CVNtKkF+eSDfuuDrXvZ/ufQ8zfZHGjSzwFxCKe2Cn/q3rZ5fObIoJb19tVCnI/jx91ib8W805IXPFceY3JXkRDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636188; c=relaxed/simple;
	bh=EjOehb+S9t9/iv9djwFa9q9jdpkceqmPKRwmWjeKXGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hccx87VSGftDPRQ/iG0itX3qFpJmYYjnR7f7JyeCsDh9i1fxLy2h4gnrC3HtTvxbnpqL030cfJeonb2FGUhxTG8qtpOF1QyidekjohDKdtkh1kFbnp/eRGOimaFgquvXt2ivWED8FUwbK5sv+ryRJMH6MFknabfHCBxrzJWXLYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2D8apAK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2D8apAK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845F01F00A3A;
	Tue, 16 Jun 2026 18:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636187;
	bh=zGzzLjN8wwUXt0158I3e7kU54WBYR/8YKGdgfo6jU8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2D8apAK6nTR8GBXGjQMnjZINjqjlmzXYsOabKI6ba8aBAB4bsss3UnEHE0+W5NxjC
	 470uB0nh4beeoyTHtT3zxjvqmpew7J881Ab9nf6spfVxBWraxY0DWpZ4ERUmmB+rM0
	 RE0USNp2LP30X7KEXIfzN5BiYpLiLuRZvHYg5vsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Alexey Panov <apanov@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/342] spi: meson-spicc: Fix double-put in remove path
Date: Tue, 16 Jun 2026 20:27:34 +0530
Message-ID: <20260616145055.530154728@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 63542bb402b7013171c9f621c28b609eda4dbf1f upstream.

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
[ Alexey: Remove the equivalent legacy spi_master_put() call used in
  linux-5.10.y. ]
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 6974a1c947aad6..ae818e7df79198 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -863,8 +863,6 @@ static int meson_spicc_remove(struct platform_device *pdev)
 	clk_disable_unprepare(spicc->core);
 	clk_disable_unprepare(spicc->pclk);
 
-	spi_master_put(spicc->master);
-
 	return 0;
 }
 
-- 
2.53.0



