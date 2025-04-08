Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F318A266EEA;
	Tue,  8 Apr 2025 12:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115705; cv=none; b=aAnAu5n66Ged/0qg+6EQFUXBNUxTMAoA7at8EcLjFHBPz1vVU0EucoY+hyOjy2VPfXmzXFC4lKUAB49q7Hoxd52QcYtrrf73oAjOQS1iC9nfeBxy5A7733vaVFXus/1gXIQAY//4SL77/+qFiDM5xscBBvkdhPUiLkJvIV+1/q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115705; c=relaxed/simple;
	bh=9WaffGS/U2qsNpUv+ODt8LfXPGe4dNsrJPahNklXeXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQVcxqjvd3HASXiUn8bc5juk0jassznaSpQ0boV+InAS/a/wRB0Ezb9/VwCemHGIZ+3Jnn1pXNt6dTtBlFPM1/fnWa7Gb+iCu+5VpVFqGIvczlTxCQdNkpzeDzCPKu9TsBNdjCU0IwW6V0Ko+JymNN+lm9Py6043flTi0p4Prow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2CeADot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2CeADot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A891C4CEE5;
	Tue,  8 Apr 2025 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115704;
	bh=9WaffGS/U2qsNpUv+ODt8LfXPGe4dNsrJPahNklXeXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2CeADotNBsnYgo9Osr9kvHoxCFPA2+Zgh9osKcFrP3/hMU2ut6Af+P8s7IoAj/XS
	 RacoA6AOa8U8SvSLuHe8P/Ojmy9Lw2nZtTQhEYXfKOV/hVoeIe45uJoHEkI08jKIGN
	 TuoZ1RInw5OeMS7QX9ozFCMRvI+BKSwVdpR9xvgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/204] pinctrl: tegra: Set SFIO mode to Mux Register
Date: Tue,  8 Apr 2025 12:50:01 +0200
Message-ID: <20250408104822.442705751@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit 17013f0acb322e5052ff9b9d0fab0ab5a4bfd828 ]

Tegra devices have an 'sfsel' bit field that determines whether a pin
operates in SFIO (Special Function I/O) or GPIO mode. Currently,
tegra_pinctrl_gpio_disable_free() sets this bit when releasing a GPIO.

However, tegra_pinctrl_set_mux() can be called independently in certain
code paths where gpio_disable_free() is not invoked. In such cases, failing
to set the SFIO mode could lead to incorrect pin configurations, resulting
in functional issues for peripherals relying on SFIO.

This patch ensures that whenever set_mux() is called, the SFIO mode is
correctly set in the Mux Register if the 'sfsel' bit is present. This
prevents situations where the pin remains in GPIO mode despite being
configured for SFIO use.

Fixes: 971dac7123c7 ("pinctrl: add a driver for NVIDIA Tegra")
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Link: https://lore.kernel.org/20250306050542.16335-1-pshete@nvidia.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/tegra/pinctrl-tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/tegra/pinctrl-tegra.c b/drivers/pinctrl/tegra/pinctrl-tegra.c
index 50bd26a30ac0a..30341c43da59a 100644
--- a/drivers/pinctrl/tegra/pinctrl-tegra.c
+++ b/drivers/pinctrl/tegra/pinctrl-tegra.c
@@ -270,6 +270,9 @@ static int tegra_pinctrl_set_mux(struct pinctrl_dev *pctldev,
 	val = pmx_readl(pmx, g->mux_bank, g->mux_reg);
 	val &= ~(0x3 << g->mux_bit);
 	val |= i << g->mux_bit;
+	/* Set the SFIO/GPIO selection to SFIO when under pinmux control*/
+	if (pmx->soc->sfsel_in_mux)
+		val |= (1 << g->sfsel_bit);
 	pmx_writel(pmx, val, g->mux_bank, g->mux_reg);
 
 	return 0;
-- 
2.39.5



