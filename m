Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B974225760;
	Wed, 19 Mar 2025 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395025; cv=none; b=I1roOIcBAKcch6Lv7aTXXGJoGESrlWk/m/ofD++vnAlv9fisGfVF25GnHfWtWCx49LRaw9tB3FU8qRViU1NmwST36VntUlFFarX+UFhIDuEutLeRuvuhTvhshgmvJcXFnaIkftOydn8pkKoKhaPOE6fJ453gsHIlNwZs6OF2xdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395025; c=relaxed/simple;
	bh=ZBexT3evC1u1WAEdgyWuq5lRtWmY1nvjH29htKAGpSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4x2wW9JXvrcQi2XBbFp1XKlCGul35HXJ/9bozBqcwSKRKIpZ5Xd96TPMsJa+8M8OrzYOeeeRgxne5SiF04GoOIJ3zIrDwBYtL5E7hKQbzSYjoDtnMH/s9ztp0g1m6VstlJjncPymg5F6vJfl7vDa6DgE2nZ29Rk2FxUDm/qhIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuQ2SPP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuQ2SPP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD6FC4CEE4;
	Wed, 19 Mar 2025 14:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395025;
	bh=ZBexT3evC1u1WAEdgyWuq5lRtWmY1nvjH29htKAGpSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuQ2SPP91wX9RkQcDB4DdyqEfiuqMuRYWcnhHxsRyF652J2nor8qaXjoomDiT/CQp
	 1HzTQS1Y7xr8+YbS5KaVpzK5UZC2wyiClUK+l0dE/sNnEbHf09W/FLjUG79QMSFvng
	 YcGTmpubqYb2I4WoxRRuc6nYUHXgXZ1fL5KCnPxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/231] pinctrl: bcm281xx: Fix incorrect regmap max_registers value
Date: Wed, 19 Mar 2025 07:28:18 -0700
Message-ID: <20250319143026.999437370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 68283c1cb573143c0b7515e93206f3503616bc10 ]

The max_registers value does not take into consideration the stride;
currently, it's set to the number of the last pin, but this does not
accurately represent the final register.

Fix this by multiplying the current value by 4.

Fixes: 54b1aa5a5b16 ("ARM: pinctrl: Add Broadcom Capri pinctrl driver")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Link: https://lore.kernel.org/20250207-bcm21664-pinctrl-v1-2-e7cfac9b2d3b@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
index 73dbf29c002f3..cf6efa9c0364a 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
@@ -974,7 +974,7 @@ static const struct regmap_config bcm281xx_pinctrl_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = BCM281XX_PIN_VC_CAM3_SDA,
+	.max_register = BCM281XX_PIN_VC_CAM3_SDA * 4,
 };
 
 static int bcm281xx_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
-- 
2.39.5



