Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFDA221DA7;
	Tue, 29 Apr 2025 17:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946710; cv=none; b=hBT72Bx7+oXZzAjhbN6cLO3TAc0dIq9g3IAGEi5SJ02Ec9j584JBuQwFb8qEQXVxYD3YpHZSTHsfTr8rx9Os/RVFNyfD3MGa7oOXrrUAFi9vWH3pqno0JTTTCQLECPvHu44MgTnwnS+UjScXJWKpAA0H0MHwAPX6nkoweag2YSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946710; c=relaxed/simple;
	bh=PLfxIup9cKXifnUqqiC1dFlrpU1wRK/AuDoMFKjQC6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrxYf/opraVMSrGBngyOX6kPL7CGHBHH4cwK/CySN4nqDPIBmmJCh6oblstTIDAo1Hd7Gf24FvqvfuVh7UdrhL6l2QcoaR+wElnkG/BqEm23RkXxKxOXKhW4CAcsxDszRyA1U9UUmSFk4X6aWRiv719wqbRhn8lx1dmQZCLOBGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUh5nVQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUh5nVQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB40C4CEE3;
	Tue, 29 Apr 2025 17:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946710;
	bh=PLfxIup9cKXifnUqqiC1dFlrpU1wRK/AuDoMFKjQC6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUh5nVQsJXkpKehbW4ElnwV5Il4ogHbpElFFHdFs0UsodaFHAG0ep0uBOAc93tsFO
	 1ZQVHZJaSqWuDFKCdudv+iPFKDkkrY4hn9N/QuCF7btoLe90VZMF17Rybq+hAOa7TP
	 Decj4bIVZvcZknbgppDFBhNkOlYyysrsyViWKYTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabien Parent <fparent@baylibre.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/286] pwm: mediatek: Always use bus clock
Date: Tue, 29 Apr 2025 18:39:08 +0200
Message-ID: <20250429161109.674061274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ab001ce55178e..108881619aea1 100644
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
@@ -132,6 +134,10 @@ static int pwm_mediatek_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (ret < 0)
 		return ret;
 
+	/* Make sure we use the bus clock and not the 26MHz clock */
+	if (pc->soc->has_ck_26m_sel)
+		writel(0, pc->regs + PWM_CK_26M_SEL);
+
 	/* Using resolution in picosecond gets accuracy higher */
 	resolution = (u64)NSEC_PER_SEC * 1000;
 	do_div(resolution, clk_get_rate(pc->clk_pwms[pwm->hwpwm]));
@@ -281,31 +287,37 @@ static int pwm_mediatek_remove(struct platform_device *pdev)
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



