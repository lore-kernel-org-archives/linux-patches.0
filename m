Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA553C3F6F;
	Wed, 30 Sep 2026 19:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796733; cv=none; b=t4Ag0CU9hfxMl/1VmTqG5CI8WPQAOfKSmO5gwxI28JHX3pi6hYi9vlNcpyWd94QCnhMwUqVyqK3syPzpo48ma2LJ4rWmVNskef0nCedlZQihEwXfDg3EM6vRKT0P6Xnnw2jU79JgbwkH2HYKDCvPS/+iIpoFMv/fyUqcjjkDFEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796733; c=relaxed/simple;
	bh=3Keq0Srt5YvsyO67Ec0UKvTMqDGwdGv0lAMRo+Ytqd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLTuidWvC6DgrXzeZ9ED/K1j5TOhf8LFID38Co5r60bcluPGHHbt7zwzcaisE/lONypkX4KBQ0S0s7miFu6JUwGDNmwI4klguTixcFo8oDtGZPxOTIOp0A/f2FWaTQrfG4VMkzVviy/wg5ylYrwGsvHUgay3po/PFMnurDYyRWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zl4tInBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zl4tInBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECF71F00898;
	Wed, 30 Sep 2026 19:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796732;
	bh=WBcojQs6kRWgSXi0I2VXc9sEVOUs2nHoOymOhRHxU+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zl4tInBL0iUdlzd+RX0TuoeIjTc/WzLFav/wFrRJTqK2bNPFbGs4n1d8C/cpPhU3J
	 dIx33WgCGKnLduPfqCEkJDuGgY8Z1N7VyXkCKa19qnT3MKBKFYzDMX6Gujy/ru33a+
	 CDoMC0MnTFjtziH5gUP4cxlqDy4JSo0S232T70zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Li Youhong <liyouhong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1017/1193] drm/bridge: samsung-dsim: fix TE GPIO lifetime for host attach
Date: Wed, 30 Sep 2026 17:28:21 +0200
Message-ID: <20260930152456.836041266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Li Youhong <liyouhong@kylinos.cn>

[ Upstream commit ada667890773e033d2f40dc94176e3beb930b516 ]

When the Exynos DSI driver was generalized into samsung-dsim, the TE
GPIO acquisition was switched from gpiod_get_optional() to
devm_gpiod_get_optional() while keeping the matching gpiod_put() calls.
That combination is wrong for a managed descriptor.

However, dropping the puts and keeping the managed get is also wrong:
samsung_dsim_register_te_irq() runs from the DSI host attach callback,
and host detach/reattach can happen without destroying the device that
owns the managed action. A second attach would then request the GPIO
again without having released it.

Switch back to a non-managed gpiod_get_optional() and keep the explicit
gpiod_put() on the request_irq() error path and in
samsung_dsim_unregister_te_irq().

Fixes: e7447128ca4a ("drm: bridge: Generalize Exynos-DSI driver into a Samsung DSIM bridge")
Suggested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260904014958.1572918-1-dayou5941@163.com
[Luca: remove unnecessary comment]
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/samsung-dsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/samsung-dsim.c b/drivers/gpu/drm/bridge/samsung-dsim.c
index b763a6d17e687..f538fb86141cf 100644
--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -1623,7 +1623,7 @@ static int samsung_dsim_register_te_irq(struct samsung_dsim *dsi, struct device
 	int te_gpio_irq;
 	int ret;
 
-	dsi->te_gpio = devm_gpiod_get_optional(dev, "te", GPIOD_IN);
+	dsi->te_gpio = gpiod_get_optional(dev, "te", GPIOD_IN);
 	if (!dsi->te_gpio)
 		return 0;
 	else if (IS_ERR(dsi->te_gpio))
-- 
2.53.0



