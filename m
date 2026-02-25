Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5A31D5ABA;
	Wed, 25 Feb 2026 01:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983117; cv=none; b=qlJAZ00G72Ej5ODRgnJCK6XoG1MGIZN1c/Bm+JXHpGJFaksHDHBl1bn5Oar0r2HBUv7eaIwwduCYm3C5LJeqRgTWfNzthBRiCOReXyxTvQ7nJCrxoM3bdyq6jVK3P5jwbcYPkTfG676+bKGUjKqfnLZeYiWw/wY9Cq3UD53O/+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983117; c=relaxed/simple;
	bh=0O24iYf6ie0lTl6Qu6YoqI+JQnxMlHEeoAkYtJMJYzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6aWfV5+47sjN0839FKunxohUhFmoz8bZR1qahBgMWGCpuvDHJ0YIh+WmZcCZ4Bz6+ScAVt8czOqYumksh5nljMcw0OTUMu5geLS1TMhEP6OH+kf1IAXDYfxE2tNJm4Ypf8QxCKLCpzv5QiZB5bC4PCBpqBMjS/lXXZzFmh8zkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8UBFYkX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8UBFYkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEE7C19424;
	Wed, 25 Feb 2026 01:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983115;
	bh=0O24iYf6ie0lTl6Qu6YoqI+JQnxMlHEeoAkYtJMJYzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8UBFYkXTImZPHKePDerb/7M/VQBHzq8JpHiBVw6/Dgr2y6HQK01BtN7dgxxb3rha
	 5HlMa8M+Q52F0rSAU+xwrCbASu+SyKhLT8l+ZmAytk3UAcUYb9RpBnyqX6+RnO16x7
	 2vMPliVcGxq45qLEyavt6NKlkhIs3koZgAcKv+uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 275/781] drm/rockchip: dw_hdmi_qp: Fix RK3576 HPD interrupt handling
Date: Tue, 24 Feb 2026 17:16:24 -0800
Message-ID: <20260225012406.443526985@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 5f7be8afc40c5ccf1be0410514703e50a49532c0 ]

The threaded interrupt handler on RK3576 checks HPD IRQ status before
deciding to continue with interrupt clearing and unmasking.

This is not only redundant, since a similar verification has been
already performed by the hard IRQ handler before masking the interrupt,
but is also error prone, because it might happen that hardware clears
the status register right after the masking operation completes, and
before the threaded handler reads its value.

The consequence is that HPD IRQ gets never unmasked, which breaks
hotplug detection until reloading the driver or rebooting the system.

Drop the unnecessary verification of the HPD interrupt status from the
threaded interrupt handler.

Fixes: 36439120efbd ("drm/rockchip: dw_hdmi_qp: Add basic RK3576 HDMI output support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20260115-dw-hdmi-qp-hpd-v1-1-e59c166eaa65@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
index 8604342f99432..c7158b1b8c59e 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -280,12 +280,7 @@ static irqreturn_t dw_hdmi_qp_rk3576_hardirq(int irq, void *dev_id)
 static irqreturn_t dw_hdmi_qp_rk3576_irq(int irq, void *dev_id)
 {
 	struct rockchip_hdmi_qp *hdmi = dev_id;
-	u32 intr_stat, val;
-
-	regmap_read(hdmi->regmap, RK3576_IOC_HDMI_HPD_STATUS, &intr_stat);
-
-	if (!intr_stat)
-		return IRQ_NONE;
+	u32 val;
 
 	val = FIELD_PREP_WM16(RK3576_HDMI_HPD_INT_CLR, 1);
 	regmap_write(hdmi->regmap, RK3576_IOC_MISC_CON0, val);
-- 
2.51.0



