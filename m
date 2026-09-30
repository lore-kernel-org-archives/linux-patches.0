Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC5C4F55B6;
	Wed, 30 Sep 2026 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787107; cv=none; b=qad6puoPzGLhDA1RtDE1hibb78TSr4VwZfYrrqkNGa4xhm6HDRqZS7XF2WI7tefjdY7LnAMZPMJX93GGvK7CqfKBA8/zD+GJCeBJ8+7W0uaFVtNbj+oIepJFFmMmKm4hDBtvG+MfYxoeOmDcOcQfYQlSkiaIYAjNsqRmkG1RvXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787107; c=relaxed/simple;
	bh=iTCWlpaMJenXY0PtP46SAKbKTenDMmYTOOBCBKWDFNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awxpYzSRLC02uApYQr75l14gnhbc0JZgZTCzi8qTrbuDrxop9aQ9VqIYK7DdYAFTwl5iyt+beQFgoay8O93Pds3m/IxM9DCe2S57wJSC73EBwibNU3QvuSYdzdfndDmbQnE9g4HQCwxq/lgizS8JfiljM6Xwv6UamlLeTvFiF0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0omg0gR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0omg0gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BF01F00898;
	Wed, 30 Sep 2026 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787106;
	bh=HapPA/aykgD/49Y2wCIsSizCT8ecIpiRSMYCuQ4sI5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0omg0gRzmI8/FVLOETAIKydQyg2cqLycLtpuQTxGnX4RGXGYVqbOvhfs4NlRb6YM
	 mnte8CHb+3ghn65S+jJyPhR0BoVxMqCxhW6+Kk2Gmq8gEOkHcOJIwRRd5YC1iH7SBv
	 R5xau6fvk1GNb/NHv1oBK22QntlyIVQ4BQaJnN9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Li Youhong <liyouhong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 115/457] drm/bridge: samsung-dsim: fix TE GPIO lifetime for host attach
Date: Wed, 30 Sep 2026 17:23:40 +0200
Message-ID: <20260930152348.535285140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 9ee0515074c78..7e320eac2e4ad 100644
--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -1862,7 +1862,7 @@ static int samsung_dsim_register_te_irq(struct samsung_dsim *dsi, struct device
 	int te_gpio_irq;
 	int ret;
 
-	dsi->te_gpio = devm_gpiod_get_optional(dev, "te", GPIOD_IN);
+	dsi->te_gpio = gpiod_get_optional(dev, "te", GPIOD_IN);
 	if (!dsi->te_gpio)
 		return 0;
 	else if (IS_ERR(dsi->te_gpio))
-- 
2.53.0



