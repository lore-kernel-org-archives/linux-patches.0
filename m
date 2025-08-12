Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13B2E4248;
	Tue, 12 Aug 2025 17:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021177; cv=none; b=mlSdU1gyYN+X/TYjrsWN7zwcm6v7WwHdEw+ntZn8E0WMbAgJoa6dsl1yQNq4lgmlD5Rn8Dv9fEEfwAgQQuDALnQxvsDSc3M0STUE15EHsXIEuBkvrPjSHbPqfg504Wh8wrApqlCttTFGC5Dggtr6ftYkDzJijS0XcEFHmeH/nEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021177; c=relaxed/simple;
	bh=9g1VSg1/+f2aBVC/Qy1vlZ7SuxcGBef3MjJ4pr823N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m05PdiMKW/kxBNhbkEeARiPfbibnQ9YJCQTekG+f3BuNNFE683YcNFs+VCMH+DQevJ4hAKHBupYc0DPGM5JQeVxyWxRgtNJ4WLi16YcmaV9kImFiBJC9YeuNjOhflTWFzqfiMjxt8cK0iOzcTN++aZfE/ZTJR8nYQpNbfnKI0Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgmEz5Tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgmEz5Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F4FC4CEF0;
	Tue, 12 Aug 2025 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021177;
	bh=9g1VSg1/+f2aBVC/Qy1vlZ7SuxcGBef3MjJ4pr823N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgmEz5Tr0D7moiSFopnWygrlV0+NLmjZ7Vxc/aW7o0kqq1c1BTYVXnUA+ceZi2gqY
	 /syGzpDzNl+xRnSGROpAti1R0XH6fWcA1Ml7Dm6VxAcJj26LOovd7oINFt/6nnXQaJ
	 TsvCPJaXR20L8b5RA/4w+OM4b8vpG20nWD17whfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/253] irqchip: Build IMX_MU_MSI only on ARM
Date: Tue, 12 Aug 2025 19:30:13 +0200
Message-ID: <20250812172958.406840373@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3b6a18f0da8720d612d8a682ea5c55870da068e0 ]

Compile-testing IMX_MU_MSI on x86 without PCI_MSI support results in a
build failure:

drivers/gpio/gpio-sprd.c:8:
include/linux/gpio/driver.h:41:33: error: field 'msiinfo' has incomplete type
drivers/iommu/iommufd/viommu.c:4:
include/linux/msi.h:528:33: error: field 'alloc_info' has incomplete type

Tighten the dependency further to only allow compile testing on Arm.
This could be refined further to allow certain x86 configs.

This was submitted before to address a different build failure, which was
fixed differently, but the problem has now returned in a different form.

Fixes: 70afdab904d2d1e6 ("irqchip: Add IMX MU MSI controller driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250805160952.4006075-1-arnd@kernel.org
Link: https://lore.kernel.org/all/20221215164109.761427-1-arnd@kernel.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index a29a426e4eed..eae221b28397 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -486,6 +486,7 @@ config IMX_MU_MSI
 	tristate "i.MX MU used as MSI controller"
 	depends on OF && HAS_IOMEM
 	depends on ARCH_MXC || COMPILE_TEST
+	depends on ARM || ARM64
 	default m if ARCH_MXC
 	select IRQ_DOMAIN
 	select IRQ_DOMAIN_HIERARCHY
-- 
2.39.5



