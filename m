Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B336727453;
	Tue, 29 Apr 2025 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945207; cv=none; b=sMgFEGNZxC0I3wFwadAG37faYhv6UrU9B1Odo5WiCxRvqto+QXfV3byoOPUWQMQlycQrAU9/p0jKVEb0r8ictacap5T6JdcHaU+3TmdO0X21YLFNcuCztYOzTJaZVp9VbBpsfIzDE0rjV8lDEJW09x/mMf4Yp5D9kjar05zdmIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945207; c=relaxed/simple;
	bh=G70ibjgZ1yDHo+/D8On58rWwu/LAjQXh2Nte9ZhrPHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tM1Fj7ArRnTb9d4DX0WbrXxydfNBVw1YPEqVCzf1bayUQ5gEUcqlGKLPBhog+oVJm9lQFW4GcaMzdJwVuzhjHpU9trnY340odI4zd8g4Yl7kQHB7pk9Is7Sj1IjJgeMnwlnJm+0bxhbRe1Nv3gJcKZNIikRg7VVNB3oCU+cEgQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbDF9+9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbDF9+9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F29C4CEE3;
	Tue, 29 Apr 2025 16:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945207;
	bh=G70ibjgZ1yDHo+/D8On58rWwu/LAjQXh2Nte9ZhrPHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbDF9+9ngwzwRlxk8fM/0ambxCmWmorZim4H8uBDdSCbCSelBBfYRnU/R2qCYU9DO
	 /CQ6XpTrrkqW6nx46naxulqvb1lNqiCb/gJ+WqcVfb8acek4oLKE3kcITLJ61BennE
	 vgUa4uBEP0mfM9Mycrcn6PWyhtvgZU8YbuM1sZ64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fparent@baylibre.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/179] pwm: mediatek: Always use bus clock
Date: Tue, 29 Apr 2025 18:39:38 +0200
Message-ID: <20250429161050.915125167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit 0c0ead76235db0bcfaab83f04db546995449d002 ]

The MediaTek PWM IP can sometimes use the 26 MHz source clock to
generate the PWM signal, but the driver currently assumes that we always
use the PWM bus clock to generate the PWM signal.

This commit modifies the PWM driver in order to force the PWM IP to
always use the bus clock as source clock.

I do not have the datasheet of all the MediaTek SoC, so I don't know if
the register to choose the source clock is present in all the SoCs or
only in subset. As a consequence I made this change optional by using a
platform data paremeter to says whether this register is supported or
not. On all the SoCs I don't have the datasheet (MT2712, MT7622, MT7623,
MT7628, MT7629) I kept the behavior to be the same as before this
change.

Signed-off-by: Fabien Parent <fparent@baylibre.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 7ca59947b5fc ("pwm: mediatek: Prevent divide-by-zero in pwm_mediatek_config()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mediatek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pwm/pwm-mediatek.c b/drivers/pwm/pwm-mediatek.c
index b94e0d09c300f..2bece32e62dad 100644
--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -30,12 +30,14 @@
 #define PWM45DWIDTH_FIXUP	0x30
 #define PWMTHRES		0x30
 #define PWM45THRES_FIXUP	0x34
+#define PWM_CK_26M_SEL		0x210
 
 #define PWM_CLK_DIV_MAX		7
 
 struct pwm_mediatek_of_data {
 	unsigned int num_pwms;
 	bool pwm45_fixup;
+	bool has_ck_26m_sel;
 };
 
 /**
@@ -131,6 +133,10 @@ static int pwm_mediatek_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (ret < 0)
 		return ret;
 
+	/* Make sure we use the bus clock and not the 26MHz clock */
+	if (pc->soc->has_ck_26m_sel)
+		writel(0, pc->regs + PWM_CK_26M_SEL);
+
 	/* Using resolution in picosecond gets accuracy higher */
 	resolution = (u64)NSEC_PER_SEC * 1000;
 	do_div(resolution, clk_get_rate(pc->clk_pwms[pwm->hwpwm]));
@@ -280,31 +286,37 @@ static int pwm_mediatek_remove(struct platform_device *pdev)
 static const struct pwm_mediatek_of_data mt2712_pwm_data = {
 	.num_pwms = 8,
 	.pwm45_fixup = false,
+	.has_ck_26m_sel = false,
 };
 
 static const struct pwm_mediatek_of_data mt7622_pwm_data = {
 	.num_pwms = 6,
 	.pwm45_fixup = false,
+	.has_ck_26m_sel = false,
 };
 
 static const struct pwm_mediatek_of_data mt7623_pwm_data = {
 	.num_pwms = 5,
 	.pwm45_fixup = true,
+	.has_ck_26m_sel = false,
 };
 
 static const struct pwm_mediatek_of_data mt7628_pwm_data = {
 	.num_pwms = 4,
 	.pwm45_fixup = true,
+	.has_ck_26m_sel = false,
 };
 
 static const struct pwm_mediatek_of_data mt7629_pwm_data = {
 	.num_pwms = 1,
 	.pwm45_fixup = false,
+	.has_ck_26m_sel = false,
 };
 
 static const struct pwm_mediatek_of_data mt8516_pwm_data = {
 	.num_pwms = 5,
 	.pwm45_fixup = false,
+	.has_ck_26m_sel = true,
 };
 
 static const struct of_device_id pwm_mediatek_of_match[] = {
-- 
2.39.5



