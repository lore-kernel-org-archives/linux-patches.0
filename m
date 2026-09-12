Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3CC368D5A;
	Sat, 12 Sep 2026 07:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199762; cv=none; b=Xm9rq4/nJi/l3A87tGvSaLjqSeJrXc3L75zQ2g0JOMEb2VdEV/cjLzDbfZ7aw4nKkOYX/q8iFJhnTqhnLvoAdovsyak18K0sVPPPx8uMxQ4LMXex3LK+gaoPC0YFUyg6GDgjTOouGIehZbEcyUooP1LdhOZnLG8lFZ+85FFVgb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199762; c=relaxed/simple;
	bh=ILt8U5tU5MktgkQtZrfkBBNComqFqORwREUIqhTi9WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5COC1oF+INzoAHvPbZrGpJcNKS+RSwFCo0EmVOpXab4wkamWZfwxU1ujpHyJgkFS4+odJQIZBx2xfc3Gz1XEFg0XCxvFmo0nEK0tRhoBYq1z4Dy3Yib63IDKr1NMUOYO/iQyaJNB5BX0vnQmSll5cWwkPnfDb7cnYNIHy41JHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikejGM3e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikejGM3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443E91F000FF;
	Sat, 12 Sep 2026 07:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199760;
	bh=wbudPQQBVPdzS8R73HmhTwHYjIbls//qN8EmsWKe6kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikejGM3eBgnljGwajyoyxhQ27gS4tOacjoVn5WFi/oFy/VDsLMpm8srikeYcoh03C
	 Ay9+QPPQLtpLXC/ikBxZM3TgPUy5DXtQOvmq9EF8U4mFwdXhqzcZbTi3Wf3bHCQNLR
	 g12DlvGkBsZC36x36ithoZNjIMeFeHFA6UKtiwog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0652/1815] pinctrl: fix unmet dependencies from missing GPIOLIB
Date: Sat, 12 Sep 2026 08:40:02 +0200
Message-ID: <20260912065704.185526286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit 46840fa8c9f53b9c90db4b4be2b808bbc626cde2 ]

These 4 options, PINCTRL_PIC32, PINCTRL_PIC32, PINCTRL_IPROC_GPIO, and
PINCTRL_NSP_GPIO all select GPIOLIB_IRQCHIP without ensuring GPIOLIB is
enabled, causing unmet dependencies, such as:

WARNING: unmet direct dependencies detected for GPIOLIB_IRQCHIP
  Depends on [n]: GPIOLIB [=n]
  Selected by [y]:
  - PINCTRL_PIC32 [=y] && PINCTRL [=y] && OF [=y] && (MACH_PIC32 || COMPILE_TEST [=y])

Similar options in this subsystem select GPIOLIB, so let's do the same here.

These unmet dependency bugs were found by kconfirm, a static analysis tool for
Kconfig.

Fixes: 2ba384e6c381 ("pinctrl: pinctrl-pic32: Add PIC32 pin control driver")
Fixes: 1490d9f841b1 ("pinctrl: Add STMFX GPIO expander Pinctrl/GPIO driver")
Fixes: b64333ce769c ("pinctrl: cygnus: add gpio/pinconf driver")
Fixes: 8bfcbbbcabe0 ("pinctrl: nsp: add gpio-a driver support for Broadcom NSP SoC")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/Kconfig     | 2 ++
 drivers/pinctrl/bcm/Kconfig | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index eda54aa5fde6f..e5618b51ac144 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -488,6 +488,7 @@ config PINCTRL_PIC32
 	depends on MACH_PIC32 || COMPILE_TEST
 	select PINMUX
 	select GENERIC_PINCONF
+	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	help
 	  This is the pin controller and gpio driver for Microchip PIC32
@@ -564,6 +565,7 @@ config PINCTRL_STMFX
 	depends on I2C
 	depends on HAS_IOMEM
 	select GENERIC_PINCONF
+	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select MFD_STMFX
 	help
diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
index 206f3f1249cf5..19d22e7fd11ed 100644
--- a/drivers/pinctrl/bcm/Kconfig
+++ b/drivers/pinctrl/bcm/Kconfig
@@ -121,6 +121,7 @@ source "drivers/pinctrl/bcm/Kconfig.stb"
 config PINCTRL_IPROC_GPIO
 	bool "Broadcom iProc GPIO (with PINCONF) driver"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
+	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select PINCONF
 	select GENERIC_PINCONF
@@ -186,6 +187,7 @@ config PINCTRL_NS
 config PINCTRL_NSP_GPIO
 	bool "Broadcom NSP GPIO (with PINCONF) driver"
 	depends on ARCH_BCM_NSP || COMPILE_TEST
+	select GPIOLIB
 	select GPIOLIB_IRQCHIP
 	select PINCONF
 	select GENERIC_PINCONF
-- 
2.53.0



