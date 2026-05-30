Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489E33FE15;
	Sat, 30 May 2026 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161327; cv=none; b=a7ePzh4B26WaoAePHDznwXFAfinoGIb9SYR+RKMc+jxHCoIQAw3U0G9F5lDUA1E9gTdXQL2tAJ8+yRCGrVJt8nNlHtsf4o12YTu3mDVDg11mkPA4mI6awBfwH/d7ojpT996tXVRrf7b+ayeaTrjK6G7Mj05ePGTh23JzFDhiuWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161327; c=relaxed/simple;
	bh=DC+F9dLHvjarE5PEk3gjxmT7Z+juzicEKbsJnvfoG4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/R+n/f7BsLbISPdkCaeKIsyQ9T63BTXVJzRAfw0+GuupqzQe/X3r5VNwTjR/0C2a/B075IxVu+zELWRf3fddw/7+9mG9jbtUXgxzORj/R1keyEtDDeLYYD5crmSfS/NHG6ywCQU2gO1xg1Ie3/pZ9RKoorInSXbIT9GLRMimWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbWO6iYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbWO6iYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1591F00898;
	Sat, 30 May 2026 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161326;
	bh=hVb/AdBgLDnB33PBNV5KaWuJKdYDzAow9RXAYZlx4HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZbWO6iYsmTB6XUc5GYbShBn3WT9rYGrfN4tmVdHDYmGK4qY2mYiYlpF7BJBN7HRhv
	 GanNJsrFQI3clKCDRlsgeSsRkkP5PCd8mwjm6BiygwmNH0aeUmc/+L0OhzJhuZF6TG
	 3iWMYnsgTyYT7W6kIexHBD2ntTauiaNmyKxy7EKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 591/969] ARM: OMAP1: Fix DEBUG_LL and earlyprintk on OMAP16XX
Date: Sat, 30 May 2026 18:01:55 +0200
Message-ID: <20260530160316.736703116@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 7e74b606dd39c46d4378d6f6563f560a00ab8694 ]

On OMAP16XX, the UART enable bit shifts are written instead of the actual
bits. This breaks the boot when DEBUG_LL and earlyprintk is enabled;
the UART gets disabled and some random bits get enabled. Fix that.

Fixes: 34c86239b184 ("ARM: OMAP1: clock: Fix early UART rate issues")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Link: https://patch.msgid.link/aca7HnXZ-aCSJPW7@darkstar.musicnaut.iki.fi
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/clock_data.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap1/clock_data.c b/arch/arm/mach-omap1/clock_data.c
index 96d846c37c432..0b08aef5b3677 100644
--- a/arch/arm/mach-omap1/clock_data.c
+++ b/arch/arm/mach-omap1/clock_data.c
@@ -700,8 +700,8 @@ int __init omap1_clk_init(void)
 	/* Make sure UART clocks are enabled early */
 	if (cpu_is_omap16xx())
 		omap_writel(omap_readl(MOD_CONF_CTRL_0) |
-			    CONF_MOD_UART1_CLK_MODE_R |
-			    CONF_MOD_UART3_CLK_MODE_R, MOD_CONF_CTRL_0);
+			    (1 << CONF_MOD_UART1_CLK_MODE_R) |
+			    (1 << CONF_MOD_UART3_CLK_MODE_R), MOD_CONF_CTRL_0);
 #endif
 
 	/* USB_REQ_EN will be disabled later if necessary (usb_dc_ck) */
-- 
2.53.0



