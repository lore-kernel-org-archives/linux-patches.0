Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB44136EA8B;
	Wed, 20 May 2026 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302307; cv=none; b=LukyINJ4B2Bl3HjNrDQ4v5t6TxEce4J8T5L8cXmYRtWtq5dLivsBC1rU2NUvaWmTF98X5/q/vAi8t6k1xboUNozbdnTrdsf9bWl/RW4UvsYxITYjH9Yspgf6YcrfAj+cGs0ES/jORTIi0uVDRTk29Y5N42FxvDK71SnfBBpssD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302307; c=relaxed/simple;
	bh=1ucYbZj8gkgtdeRYcPFdDnZ60NQRzwSANo+TNW4xI0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDngiEWSIWY8PfAtNZVTgm2VMRFA+l0dTexECWcbuj/Ia+1qDqN8pQ5X/wx1dawM1NxzcC09jtqFY9WfhDjVAjs+GHKWaraGjrCjivsftZV+LrsW4eP1ECN1faTZ+55phcR72K7TmYq2UPVM1ASFoRuBUXaXpZKonRk6buaLCfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQmRbTer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQmRbTer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB7F1F000E9;
	Wed, 20 May 2026 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302306;
	bh=nvodCYMIKpGqlGXQF90NiNgyqXfctDp0360oASqJoaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQmRbTeroPc75wz3KGWRG+cnawfWxAbZ3xClwVJ9ntEnCPg75yokP4c8N6ZpohOnJ
	 25cq6z3Rw5RlT1BOoP/BbOjfyNauhNDRng3fxWffSSKmeOweinEyVthuObsyM/t73Q
	 os652XIGNnO9F4hkxxOzgL4jyzzp1e7OCkfm95Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/508] ARM: OMAP1: Fix DEBUG_LL and earlyprintk on OMAP16XX
Date: Wed, 20 May 2026 18:20:33 +0200
Message-ID: <20260520162103.187986135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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



