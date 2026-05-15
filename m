Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466392EAB82;
	Fri, 15 May 2026 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861065; cv=none; b=O4pdSw9karj5QXiJvG5h5EKYBuqfdVCYblGn/A2WpjPjFvsSFjV+p7TvhQoCgv8nmo23LVW0NPPggAhB1PFVLcadfn2MxdfYClitrvmQNXitX3Ro33czPxW4kh75mXNW4Q8IXBvuqRTjVlsY2WTi2iATKZdg3HnpTiixv/nwhko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861065; c=relaxed/simple;
	bh=YxU40DjLlder0NQTZyAeVQ4Ut2lmg4ED/u4759l8lUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4h5M2p0wcxUWgIWQUG6KqrKtPw6dWLv2sE/wUh8kuoOV72z5xbQULjaIFhrnyqn36btuhh54XtA1M5Tk/xRipltB1lmTgNMI4vuAKLYk1Alm5+NFsfFE2ud4H1y6KW6rhNfeYJMG8K90JMwrq6E5F4ha2aRj4UpZWajarP5Q7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ijp6RgYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ijp6RgYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC11AC2BCB0;
	Fri, 15 May 2026 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861065;
	bh=YxU40DjLlder0NQTZyAeVQ4Ut2lmg4ED/u4759l8lUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ijp6RgYiH9NigC+d/yfqaPTfR1wNSVWVIWQggCgEhNp9eOxtfFRSBjpkILEHPkXfg
	 sEaGasfE45Etbt/bx3dWynXZyz9FyX5piSnkUVMjjADRY7na+xD59rEm/JA701wVc/
	 mHsXHsoKhYa3jaYUmIHZm1M/K5nP4QWMz7jhbQ3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/474] spi: meson-spicc: Fix double-put in remove path
Date: Fri, 15 May 2026 17:44:27 +0200
Message-ID: <20260515154718.444319397@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
[ In v6.6, commit 68bf3288c7eb ("spi: meson-spicc: switch to use modern name")
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
index 43d134f4b42b1..de8cf91658fd5 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -918,8 +918,6 @@ static void meson_spicc_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(spicc->core);
 	clk_disable_unprepare(spicc->pclk);
-
-	spi_master_put(spicc->master);
 }
 
 static const struct meson_spicc_data meson_spicc_gx_data = {
-- 
2.53.0



