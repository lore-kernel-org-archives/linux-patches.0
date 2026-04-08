Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719F93D75C9;
	Wed,  8 Apr 2026 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673722; cv=none; b=e+wue6vEixjs3I0c1jLdJ9XPm0VZCcEN0BtESdOwttBcgUXiMefL5BMOSog92+skBnzmCZFaWaSj5nmt2QfMH3HydTyBNA3eZjvCiK/pWV37hb77kupdY0cIJdencrfVEzQk1o/BHepJXqzM8MpVjj/nWPQTxO58fZASYyOaLvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673722; c=relaxed/simple;
	bh=j71PcQxG+HxTzda9oy2CO6jiRKmCJZBxLIaU2NlgKXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSRI3uKsgra+g029pfOPIhZvUhVWEMIrJwPAIidldalx57Gmjt1DLleSSSm/tIN9fd4OPSs1sL+gJjb+zVtRXfFel1fAxs13HuPZ6/UR8TUjSzRuhLkI46/DRmWEkBZVCPJt2OPwG1uscAyCqYz89e7VppZ1J3VdRstY+KgSWJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+jaVR4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+jaVR4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05558C19421;
	Wed,  8 Apr 2026 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673722;
	bh=j71PcQxG+HxTzda9oy2CO6jiRKmCJZBxLIaU2NlgKXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+jaVR4/ksEaDpHDXDhLbNan3BLAGn4i72ZiEiL1VYYFlYvnfaObmwRpEgm/sIMV+
	 pZsgfgZatL2XTUza5Dwyuo5r0HiIHjTRPiepEFF5qsPXRax9QUpZNtY4dfme4GHaHl
	 OYNWLwM86ciOuJhGkkPyPz1Dq4RE+I2md7BxOk2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/242] i2c: tegra: Dont mark devices with pins as IRQ safe
Date: Wed,  8 Apr 2026 20:01:17 +0200
Message-ID: <20260408175928.461847831@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0e679cc501488..b0185c09660b2 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1177,6 +1177,8 @@ config I2C_TEGRA
 	tristate "NVIDIA Tegra internal I2C controller"
 	depends on ARCH_TEGRA || (COMPILE_TEST && (ARC || ARM || ARM64 || M68K || RISCV || SUPERH || SPARC))
 	# COMPILE_TEST needs architectures with readsX()/writesX() primitives
+	depends on PINCTRL
+	# ARCH_TEGRA implies PINCTRL, but the COMPILE_TEST side doesn't.
 	help
 	  If you say yes to this option, support will be included for the
 	  I2C controller embedded in NVIDIA Tegra SOCs
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index fbab82d457fb0..c57a2af5ea8cc 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1786,8 +1786,11 @@ static int tegra_i2c_probe(struct platform_device *pdev)
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



