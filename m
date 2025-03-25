Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86CB264A97;
	Tue, 25 Mar 2025 12:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905509; cv=none; b=iP3ObFMOtUUGz2Ai+D9wgRzwbMo0N8OveqgLWI3uKl+nSuaprvJfiQNO0S8oXFhygjOM6vUpdtUjTYzHq2ENuBWXu0bHFBlzt9KVk/5txR9CTZGaOviexlIV23E0x+WaS65Ho8ueZ9lDQuZsXc2K61jaoIMKcEUAIlDYM0McF8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905509; c=relaxed/simple;
	bh=T+2NEgaOUKRjRkAZ66m+IAXYOffsyPYWhvugwdI+/f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAtXjCItio+WKg9zzTQdjCwH8ZgatkNWv6d9Xxa5DfkNric8xgjp61U4GQ8AI2SOXA66qb64xperoFw6RLy2Q6GgaDW/xmku55PxmTpvgoWX2k4JBxxNhi1fdDRvqX9EnE5Yc/OMtuP9dRTmca25kqxfQjjsw6fnLBztpToQLCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wotIorwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wotIorwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F214CC4CEED;
	Tue, 25 Mar 2025 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905509;
	bh=T+2NEgaOUKRjRkAZ66m+IAXYOffsyPYWhvugwdI+/f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wotIorwMHEbdrl7SYxKVmZ6Ahh2q22Pd7KHPr9T/dP0e9iRy8A4DXJzVpl+7SdBVO
	 sez9LHpV+xKTYXYSFvi8Ae7J5YYbt+IdjXblhIlBn7Q/GTiWDp/p+5MV777Hd1QmON
	 KBzbKZvWERdSvxZt93ZqYFUZA8mOSnXQ1nzd2wEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/198] pinctrl: bcm281xx: Fix incorrect regmap max_registers value
Date: Tue, 25 Mar 2025 08:19:28 -0400
Message-ID: <20250325122156.806579807@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd52a83387ef7..bba5496335eeb 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
@@ -971,7 +971,7 @@ static const struct regmap_config bcm281xx_pinctrl_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = BCM281XX_PIN_VC_CAM3_SDA,
+	.max_register = BCM281XX_PIN_VC_CAM3_SDA * 4,
 };
 
 static int bcm281xx_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
-- 
2.39.5



