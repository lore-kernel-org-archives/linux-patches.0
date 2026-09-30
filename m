Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF9351DAEB;
	Wed, 30 Sep 2026 18:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792992; cv=none; b=ngUUAiQE9TsinYzw69Vv0l53bbywHcPMwzutyzbR84ol9MUzpy4Gm3vEwb1QVIiLUX+MSEpRtvAcNzukWpEJJIhBs/elci10FKuMMl9hV1y47SOk4GH7verlKfJho+FxX38U/knWv+aQFbF/Jfsnl/1mSxZoBoeL8g7D9SEWL1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792992; c=relaxed/simple;
	bh=DsvXkw86ssGybaTMI9+ADm2ydkQXHpbQA3Ch4w4ExR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVRFRq/Nicr70AVx0WSAqHRbb5OLD7J35Oc8BsmNtWinqlmyqnA8ustizLPhcjXKKvLf+nbsenTk72eGJxYloG+LtLlKMHO1y4szUjGrttaXo+h74oXjCNnWi0SRN83A9DsdMc//4vI9G9UDeFlUvTNvwiLCWle/atcSeiK24iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPGunUdj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPGunUdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB661F000FF;
	Wed, 30 Sep 2026 18:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792990;
	bh=0hAwg+Fb92QHc9jjRrHGtmVXkHC5LQhLd/VQy6yRxT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPGunUdj2pxB7R9pGyOxAqOyrD7HXdise0jQGWr+ygbxoQCm/hboxTWAGPBC3eYU/
	 fbN0F+DKuog1Ru22ir9g9//u1jD/9kfBIxDd9RfK2JFQkpzEh56XkwQahErjfseDg7
	 PNlIPBdAQbhsatvLOFi3K9qAhsp5fs//vdrEAVq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Li Youhong <liyouhong@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/395] drm/bridge: samsung-dsim: fix TE GPIO lifetime for host attach
Date: Wed, 30 Sep 2026 17:25:59 +0200
Message-ID: <20260930152342.738763378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index ad8c6aa49d48a..272e6255c7322 100644
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



