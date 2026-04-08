Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A34C324B1F;
	Wed,  8 Apr 2026 18:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672501; cv=none; b=PIhHl7L7YCFNVMGJHmx6Sk66lv3S0FmHeW8Mm9gN7XSqeyOeNmvUyrl8xoovJ9JC6JRwWmrlPJ23zsjVYvq9K4IQ4136fdRTauvTMitJzasMH0WKHMBncQudYHl8N8XFRnh4M7fQl0e1DmAs6m0JVJ91XE2m/mdlGLRi73RLUws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672501; c=relaxed/simple;
	bh=923NnilWvOK9vPTgriWgAp6f21SNseWFL3zTHrpPgzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRxOHCQQn7dwHi7xWarh1OOAjYjkDNJfIUBAHB2LFI0e2sVhcIbhMCv9wzbO6Fwj1tMYKdacrgzF+HPFxW7cfx4WLGXyRfH0wiXWRS8kzjDXDwJwJg7UVE6L4Gid2mh9C1c+eIfjVIeYLNnBDC3/B/c1fx4QxVLAmwQQqtM8lUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vm7TQCbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vm7TQCbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22524C19421;
	Wed,  8 Apr 2026 18:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672501;
	bh=923NnilWvOK9vPTgriWgAp6f21SNseWFL3zTHrpPgzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vm7TQCbXifR2/xShPBUbViEbYA/icaIm3DhLCAha09jWWtODadKsWsS3VTQELcB+f
	 WP1Sgg4FQ2ozpuXoYc5cdv4Wwe2gkfl1RBvPW/dkbWoY6bmCp6bYUlk6selgGqEwxV
	 X1QUEhDhDa2Nn99gYd6Rq1LBsqUdR6OHgEYRhmGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/160] i2c: tegra: Dont mark devices with pins as IRQ safe
Date: Wed,  8 Apr 2026 20:01:35 +0200
Message-ID: <20260408175913.497200105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8d4270664ebd1..79ab924a4b2b9 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1139,6 +1139,8 @@ config I2C_TEGRA
 	tristate "NVIDIA Tegra internal I2C controller"
 	depends on ARCH_TEGRA || (COMPILE_TEST && (ARC || ARM || ARM64 || M68K || RISCV || SUPERH || SPARC))
 	# COMPILE_TEST needs architectures with readsX()/writesX() primitives
+	depends on PINCTRL
+	# ARCH_TEGRA implies PINCTRL, but the COMPILE_TEST side doesn't.
 	help
 	  If you say yes to this option, support will be included for the
 	  I2C controller embedded in NVIDIA Tegra SOCs
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 5766231b13cd1..a882f0f65d82a 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1788,8 +1788,11 @@ static int tegra_i2c_probe(struct platform_device *pdev)
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



