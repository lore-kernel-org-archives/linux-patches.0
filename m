Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4C25A321;
	Wed,  8 Apr 2026 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674244; cv=none; b=JJwH+MJXkYIlis2bQ0tui2EZMALXEdkDVhrF19msAQSmQAJ6NW1kej6yso/iaSMsIqLyWNBe0KrtCx3TZb5yRXUMvi/BCZPlToKZQyaqtDytXDV5N6Zjgz+mhxMIEoGLNAsSA5b7vbp8i6ZlrYI5SgAv/iuMCcn1VTtcoHlr4AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674244; c=relaxed/simple;
	bh=Vhc3wAGOBmSO+wJ+h46o4sp9vaBPLs+swRAHNebLy5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErJOPkX2f70PzVh1R+Tpwe1/R7nOdJVb9FD8RR82e5s25/WalUlIaE63hYGN+fzO+m5LKN0iPilN7wD32TBWdtg0jQYzipzxCmxdAZ7TEum+sJC7G/psJkOPdSkdlP48kj4u7TGvrD6+BXXZuGv182RxYXuLNfO6FcGao+u/g1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dawgIoiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dawgIoiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49513C19421;
	Wed,  8 Apr 2026 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674244;
	bh=Vhc3wAGOBmSO+wJ+h46o4sp9vaBPLs+swRAHNebLy5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dawgIoiyc3nOy5JUkoCFlypU3pakhqnuoH4WeLMjdb3XeDKuZAwPx3DCZ38wa+nvD
	 qZRO/utuPkwt+ix+assD94iu8zF3KUJVozazH+ro4uern05hweVi+aGkNZ7M1epn+7
	 1sFad37+X3uNxvMs9xzf22+sp+QCh47eJEbeUypw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 022/311] i2c: tegra: Dont mark devices with pins as IRQ safe
Date: Wed,  8 Apr 2026 20:00:22 +0200
Message-ID: <20260408175940.242789280@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit ec69c9e88315c4be70c283f18c2ff130da6320b5 ]

I2C devices with associated pinctrl states (DPAUX I2C controllers)
will change pinctrl state during runtime PM. This requires taking
a mutex, so these devices cannot be marked as IRQ safe.

Add PINCTRL as dependency to avoid build errors.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/all/E1vsNBv-00000009nfA-27ZK@rmk-PC.armlinux.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig     | 2 ++
 drivers/i2c/busses/i2c-tegra.c | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 09ba55bae1fac..7d0afdc7d8862 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1220,6 +1220,8 @@ config I2C_TEGRA
 	tristate "NVIDIA Tegra internal I2C controller"
 	depends on ARCH_TEGRA || (COMPILE_TEST && (ARC || ARM || ARM64 || M68K || RISCV || SUPERH || SPARC))
 	# COMPILE_TEST needs architectures with readsX()/writesX() primitives
+	depends on PINCTRL
+	# ARCH_TEGRA implies PINCTRL, but the COMPILE_TEST side doesn't.
 	help
 	  If you say yes to this option, support will be included for the
 	  I2C controller embedded in NVIDIA Tegra SOCs
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index e533460bccc39..a9aed411e3190 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1837,8 +1837,11 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 	 *
 	 * VI I2C device shouldn't be marked as IRQ-safe because VI I2C won't
 	 * be used for atomic transfers. ACPI device is not IRQ safe also.
+	 *
+	 * Devices with pinctrl states cannot be marked IRQ-safe as the pinctrl
+	 * state transitions during runtime PM require mutexes.
 	 */
-	if (!IS_VI(i2c_dev) && !has_acpi_companion(i2c_dev->dev))
+	if (!IS_VI(i2c_dev) && !has_acpi_companion(i2c_dev->dev) && !i2c_dev->dev->pins)
 		pm_runtime_irq_safe(i2c_dev->dev);
 
 	pm_runtime_enable(i2c_dev->dev);
-- 
2.53.0



