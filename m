Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CACF267B65;
	Tue,  8 Apr 2025 11:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110057; cv=none; b=BfPOGLaW6U+WYbrX9Z35LZCzV1DzaBCBGtbhCd1t+6ODuBL/dcqZio16wNOx4yaIfIEKb+8ZpBSM7u0b3T+HvoerHpOOxwbxhhJXhpi3pUWjRU59UWUDozWcJNakBVX2HXFIt2bGUh4i7QIGdJgyFiqkU62BIzsRTzaCzGymKF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110057; c=relaxed/simple;
	bh=leeItVLrEJHgtmK9YeCkV+V9kbbbGRGi10sgKszaucA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7Xtv90mPnNTseARuRILfC5bmv3L+k0S2Fvjy21l/j0jcdeGEqQhUhRVQAkx3aFgrBsOz+sNeAtHCmzZQiMAeD/9WFu9x/xYath7n0dn22uWefvke4maV60vz6KSAEuwbVLEugf4ddTbJhozOdt02aONveUpYIYFstdpLQvgKXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLlWl2LA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLlWl2LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194F9C4CEE5;
	Tue,  8 Apr 2025 11:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110057;
	bh=leeItVLrEJHgtmK9YeCkV+V9kbbbGRGi10sgKszaucA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLlWl2LAKk435SPCSTD2KhyC9zjcYcDzOIYSkM3pWh52dCYt9VIcl8XGg6QbzsEpe
	 0eLJ9uWYZFlDGDElvF8qnE6JsReyqhKXEd6ldo4OyFzcu50wS+IXIwMDLg4kDG6K0Q
	 nJM0l52+mb9Z2ZcFsegNL7AEaNSpwuJWGkUZWn/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/227] pinctrl: tegra: Set SFIO mode to Mux Register
Date: Tue,  8 Apr 2025 12:48:50 +0200
Message-ID: <20250408104824.873118865@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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
index 195cfe557511b..90de78e4175c9 100644
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



