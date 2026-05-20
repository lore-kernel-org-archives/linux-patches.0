Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1573A363C6F;
	Wed, 20 May 2026 16:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295914; cv=none; b=nfVOK9GztLq1JCJ8IbZU45PYE9w9kPHHqW13jv2qRJSOdBfoZLyF0/vEr4/1T96BVU8x4/vq41s3LF940aGGvNfxG7MrfOrd1L0BPhk0OabFgnuo1fEi/4aD+djAXs2E3CeaTVaErKyZFlF9z9wZOVv1y3P6j4rBCAeZDYb9BcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295914; c=relaxed/simple;
	bh=hWC6vVfzJo5uOHZGAKeavRWaSqUkGpEzpc5EjovASX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJmZDrtcz7vrAadRfwlXHRcfdP4ypwV9epk20JshR5U6XjhTzRgCQz+nPLaNX1zH4f1am3nAQgaCzVIfAXkN6XRfAiXE6bB9Myem3o/5EI2clMk0Tmo3VEyVVX15n+gnVqsC3E6qNBCLWxxZQR2IKz/kh/ykruTvBVXTmX8DMtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbJGdmMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbJGdmMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C17F1F000E9;
	Wed, 20 May 2026 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295913;
	bh=pQjNCNpnS5yj0WgyUiq7ztWNxfCkf3gS4h/9Mx7wz+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbJGdmMo/SFe4DNmVWMvFL/4/81ZWobKKJ6jUf/18dy6HHCP3o908FrK6VpoClnkl
	 gfJNndGMGVHmg/LNu8TLd/1ugq4gC5tJ7R82DjszVAYQw1isT5iOikoLWdedlQLp+X
	 na7Fg9JjQJZ0WTFERZZhnJ+aTJwUZ6wZFiZhc4RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0563/1146] ARM: OMAP1: Fix DEBUG_LL and earlyprintk on OMAP16XX
Date: Wed, 20 May 2026 18:13:33 +0200
Message-ID: <20260520162200.923879621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index c58d200e4816b..5203b047deac8 100644
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



