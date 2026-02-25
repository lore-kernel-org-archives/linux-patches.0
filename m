Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE227FD75;
	Wed, 25 Feb 2026 01:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983949; cv=none; b=nfURLOXaXjh01YjpJuiOjUufmkExvVy3rDPk1sNFhvvEDJcz8AG1GBtJVgKG8cfYgGIaPNiJE6si+DtnZMKsxlAU9mDJT/pN9FZC7cQBnU3lGuooKxY2ja06ntceiB4XrZph079rxfz+ZBvxD4RwjdOghTCIfHKgTT5UQk5tR5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983949; c=relaxed/simple;
	bh=PW/txOodojUfxX83ygjfG0mES+iC6Tfg/17JcLinW78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xd5VHC82sXiRBcFre+WBW0SzXC5MorJ/duX2RFzL/+sz9yMO3ytaMJ8e01GE5OyVrJE9aFyWxjiWIhXmrjmypEPv/jB2G4Qb3vt3ZLRQeZwTPK//GXo5OiLrosKqbJx0ivEFz8Yo34XDcumQL9uD9tTo4omW+g+GahIWt05W4X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdMjaNSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdMjaNSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53C6C116D0;
	Wed, 25 Feb 2026 01:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983949;
	bh=PW/txOodojUfxX83ygjfG0mES+iC6Tfg/17JcLinW78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdMjaNSMLMt/pMjLKRwpytKpMdrkd5G7WL3m3HUwnEmOWYLfxhkr7aukJCeV+zgxd
	 pQ5YMNkk/T9O7nlSwUt8i5v7glultT6Xv773eIvfGrDvl/AbRxWyNtVTswoa2iX1tR
	 Sm8yixt3eiFAUHUR9fIB5Dkql9nk3Ic+b/p6ar2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/641] drm/rockchip: dw_hdmi_qp: Fix RK3576 HPD interrupt handling
Date: Tue, 24 Feb 2026 17:18:55 -0800
Message-ID: <20260225012354.016469758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 9ac45e7bc987a..409f1a1e82a06 100644
--- a/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw_hdmi_qp-rockchip.c
@@ -267,12 +267,7 @@ static irqreturn_t dw_hdmi_qp_rk3576_hardirq(int irq, void *dev_id)
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



