Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4BE32D42B;
	Sat, 30 May 2026 16:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160264; cv=none; b=IJKMCGYnglon732JvjpilT2X4ikXkHiYtTKCgeg30ibBWI08OSNM7xpbq7OKyNBQM0wbQrbIBSP2Ww6lGJjVg4WZyKl2qi5RknNcJhtLwQ/1+NIPxIBazhGL3/DihbRQ6qymuw+w6s2WgS+3iF7mWx+yA+PYsFRGtzLcwur6MGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160264; c=relaxed/simple;
	bh=i4zVbvtJlY+XXLk4RdHgfFynt18va+nBS3jkNPrfgl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+kmZNdhdl1CIW/52JJaCLvvXTfUVxAGOtc/jHZ8G5dUaap1B5T5zKk3W/eBZwLbqklgh1lGc4Ms5MfkMEjs1svp5IGah4XMkmi7VMn6umFMmKd6HJ6Wxy1vNUgX+Y7x/wMsfgfyHfhB1Dc6n+hWBCMvt5C3q/toJ40hWbJjNQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2nDDoRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2nDDoRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA33E1F00893;
	Sat, 30 May 2026 16:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160263;
	bh=R22tBWA8+dKDxJelcLpPMv9+DHbpTHPtqFuzsSPxW74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2nDDoRCMDFuH+6wB+kGCGQTuRZkY0iKahZgsFaQsMojgwXCVrLo2BWY/6TiJ13LQ
	 FAWwosIKPR3UpcALNOD25vRo/uMxfdHXW4fygrOejmyIGyiKDcH2N+6VwZzPxuyvxq
	 dRLUKGZVmBCeQztTYXqaohmInmYhKjBRvgfJQ2+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 290/969] spi: meson-spicc: Fix double-put in remove path
Date: Sat, 30 May 2026 17:56:54 +0200
Message-ID: <20260530160308.463535099@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ In v6.1, commit 68bf3288c7eb ("spi: meson-spicc: switch to use modern name")
has not been applied, so the driver still uses the legacy spicc->master field
and spi_master_put() API. The line to remove is spi_master_put(spicc->master)
rather than spi_controller_put(spicc->host) as in the upstream patch.
They are functionally identical. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 1b4195c54ee26..04cf8489dd56b 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -883,8 +883,6 @@ static int meson_spicc_remove(struct platform_device *pdev)
 	clk_disable_unprepare(spicc->core);
 	clk_disable_unprepare(spicc->pclk);
 
-	spi_master_put(spicc->master);
-
 	return 0;
 }
 
-- 
2.53.0



