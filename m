Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDE8218AC1;
	Mon, 23 Jun 2025 21:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715174; cv=none; b=fplP3piurZm8Tntjyx37o8i8k4Cp9cMU/d7s0ZhdZWJ193qHGJtea17qeLVelIP7seV6bjW9SxCqF6hd8Q2bdtcOA0TXX/PI2ubvVRoFWvDqHxXoaLqdW+vttg2QKPdl0i5tPgguXtAzn1+QsuKQnq/wAXXke0NHix/W2a7EVEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715174; c=relaxed/simple;
	bh=4KbrGx0TQhi11RMBVmL5h+4p0SljSvFBWlhLkM9262w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9qBnpCkVnSAGmiMeRH7LcbTOEWdjii7fAM1GqJObGtpgrdRCi4kB5cInGtCtmfFw7IyV8nA0ndMtC++0S6csgkVoFJaxNaJfuep02CfbwT04G1CtU1p1Rt/lfh4mTqHr0JHf3wBhvWLsgEPj1S0hEz5iOv/Lq3MAlaUNEJB2No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUpiYRWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUpiYRWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C95CC4CEED;
	Mon, 23 Jun 2025 21:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715173;
	bh=4KbrGx0TQhi11RMBVmL5h+4p0SljSvFBWlhLkM9262w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUpiYRWL82kELrrfkVDUP1fFtDUAdhFDHbngKZb0Xl3BNA6JLfBLeoJYKyVYYHoFg
	 FUmNKtxivu5jb1jAPh76dlu25SIGzsgBP9nzoXWHMMhl7ans/ggOMM6IhtNCcV9xqm
	 2Ckq/5Ch37N1mh/c2Shk19/b11+s6hCq1LRvMPVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/414] gpiolib: of: Add polarity quirk for s5m8767
Date: Mon, 23 Jun 2025 15:05:24 +0200
Message-ID: <20250623130646.694013867@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 4e310626eb4df52a31a142c1360fead0fcbd3793 ]

This is prepare patch for switching s5m8767 regulator driver to
use GPIO descriptor. DTS for exynos5250 spring incorrectly specifies
"active low" polarity for the DVS and DS line. But per datasheet,
they are actually active high. So add polarity quirk for it.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250327004945.563765-1-peng.fan@oss.nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-of.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 626daedb01698..36f8c7bb79d81 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -215,6 +215,15 @@ static void of_gpio_try_fixup_polarity(const struct device_node *np,
 		 */
 		{ "lantiq,pci-xway",	"gpio-reset",	false },
 #endif
+#if IS_ENABLED(CONFIG_REGULATOR_S5M8767)
+		/*
+		 * According to S5M8767, the DVS and DS pin are
+		 * active-high signals. However, exynos5250-spring.dts use
+		 * active-low setting.
+		 */
+		{ "samsung,s5m8767-pmic", "s5m8767,pmic-buck-dvs-gpios", true },
+		{ "samsung,s5m8767-pmic", "s5m8767,pmic-buck-ds-gpios", true },
+#endif
 #if IS_ENABLED(CONFIG_TOUCHSCREEN_TSC2005)
 		/*
 		 * DTS for Nokia N900 incorrectly specified "active high"
-- 
2.39.5



