Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BC8364042;
	Tue, 16 Dec 2025 12:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888568; cv=none; b=cdt477qmAHt9pLX30KtZx8Jbc1vcb4c3zubIBB6obXeECAVFYQaJeBPzr20AewpkROJL/nkR1HUPPoSTedjtbBFyPgjV8cnMRBMbGCVEA9rkl0YnuJTFseQQh2zK0q+gwPjZ1EXphlxAmVC0cwi/7phNxpOu3UD8L1pW6AstTp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888568; c=relaxed/simple;
	bh=/9y1G9mD9ZNQ39rpRXBsfwFQmBusJbeTlJ6R1VFZyuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJtKN+TDyS/8fIVbcjGrh7fcFaRaV09pMJjSdFEyRhQk+SViF3lHYU7SwNqLSNVJ8D54IKxu9+bBbD5YT9IpLYvJCaRuIi7M7Y+Q2LrbRMthme7abqxdB+VzqnA4uF+HdwkTFX+v7Tv2DdEaJJ7ZtJ7Sy+mG62ZLUInyDkWPAKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ot+lzW3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ot+lzW3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3738BC4CEF5;
	Tue, 16 Dec 2025 12:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888568;
	bh=/9y1G9mD9ZNQ39rpRXBsfwFQmBusJbeTlJ6R1VFZyuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ot+lzW3sq9m0VOOjnz8I0mHv4NE6aUOy+791Rk4d67qEFQZDGN6wB82GfouMA8EiY
	 IyLzXFwMP97ZnZ5k2UZn960bsbTaiQ6n/4MjcSXN3ibJXosUT0wEQAVDcuWCrE51nd
	 SBsRYnEoCLYIU8WozfoBuyaZcSQ++fo2t1xA2Ft8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 574/614] gpio: tb10x: fix OF_GPIO dependency
Date: Tue, 16 Dec 2025 12:15:41 +0100
Message-ID: <20251216111422.181772538@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit dd44d4d0c55a4ecf5eabf7856f96ed47e0684780 ]

Selecting OF_GPIO is generally not allowed, it always gets enabled
when both GPIOLIB and OF are turned on.

The tb10x driver now warns about this after it was enabled for
compile-testing:

WARNING: unmet direct dependencies detected for OF_GPIO
  Depends on [n]: GPIOLIB [=y] && OF [=n] && HAS_IOMEM [=y]
  Selected by [y]:
  - GPIO_TB10X [=y] && GPIOLIB [=y] && HAS_IOMEM [=y] && (ARC_PLAT_TB10X || COMPILE_TEST [=y])

OF_GPIO is not required for compile-testing and is already enabled
when the driver is usable, so just drop the 'select' line.

Fixes: 682fbb18e14c ("gpio: tb10x: allow building the module with COMPILE_TEST=y")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20251205095429.1291866-1-arnd@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7ee3afbc2b05d..e053524c5e35f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -738,7 +738,6 @@ config GPIO_TB10X
 	depends on ARC_PLAT_TB10X || COMPILE_TEST
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
-	select OF_GPIO
 
 config GPIO_TEGRA
 	tristate "NVIDIA Tegra GPIO support"
-- 
2.51.0



