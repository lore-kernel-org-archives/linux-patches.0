Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D30D373BE0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301541; cv=none; b=E0ASuWaCWbDUHZkKK0TsLr1xS5k1wZOKGDxMelG/mZT2wVWpILOq5TR8x4m8xBh/he1NzIC/3e+CselrS89dhLXDAtEbRt/NAYIj29n1WObVpSLGLytfCCiRisyeRJbh1XF3dzk4DD/X0xXataccxkLvDyJoGYVbZNTH/Ymxpgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301541; c=relaxed/simple;
	bh=V2tvp4dZtMlmn6CDDyghQpc2R+K7b9K7s10vy4//yF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XnOrtNk3NKUYzGVETfOHjsXh7fdi1ErFa0UDuY8Kbon7x1ljKdcbdiHCNej/+oIyIe9p73E+wtKEUT0RoESiqPP4X8ICiuWeH2e/HVT2d8iXeOx29SKMxnFOKtiSk7VFlS+OQo6jC28oDVVwA2ngcpdrhDqU1vZ5eYVruJxgKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sxLuhgQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sxLuhgQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32A8C116D0;
	Sat, 28 Feb 2026 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301541;
	bh=V2tvp4dZtMlmn6CDDyghQpc2R+K7b9K7s10vy4//yF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxLuhgQuOgGxY8tzGkiX6KAmXHnHaqpvana8Qe5E6r+3UeJ/Y5y5Ytk9X3sKy9Pzs
	 4yWG0oBSGxEUS1B0rssWeDGeQJGa6ql9SrCZEQYHXCZPOA/kvISvqk1YG8xwIrGted
	 4MalsF3AwF09kPDaqDUhXP5XSmee1SxBxQF9tMdcuUd/rmmv5q3MHaVVDqActSZS6X
	 8oB+e68t1G8xBjCIDYlRyal0EbSjZoazvlsQ28ZjOVqUye7fL00h9bGFFzjwrTuU7V
	 ozaMeKmraZXPVwSlWQ3CVd1V4sm7sxjtNiWttxIoxIQv6xWathZnvvgl+rmJcIVtOE
	 c7wmwFvM4pqCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	stable@kernel.org,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 723/752] fbdev: ffb: fix corrupted video output on Sun FFB1
Date: Sat, 28 Feb 2026 12:47:14 -0500
Message-ID: <20260228174750.1542406-723-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: René Rebe <rene@exactco.de>

[ Upstream commit b28da0d092461ac239ff034a8ac3129320177ba3 ]

Fix Sun FFB1 corrupted video out ([1] and [2]) by disabling overlay and
initializing window mode to a known state. The issue never appeared on
my FFB2+/vertical nor Elite3D/M6. It could also depend on the PROM
version.

/SUNW,ffb@1e,0: FFB at 000001fc00000000, type 11, DAC pnum[236c] rev[10] manuf_rev[4]
X (II) /dev/fb0: Detected FFB1, Z-buffer, Single-buffered.
X (II) /dev/fb0: BT9068 (PAC1) ramdac detected (with normal cursor control)
X (II) /dev/fb0: Detected Creator/Creator3D

[1] https://www.instagram.com/p/DUTcSmSjSem/
[2] https://chaos.social/@ReneRebe/116023241660154102

Signed-off-by: René Rebe <rene@exactco.de>
Cc: stable@kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/ffb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/ffb.c b/drivers/video/fbdev/ffb.c
index 34b6abff9493e..da531b4cb4513 100644
--- a/drivers/video/fbdev/ffb.c
+++ b/drivers/video/fbdev/ffb.c
@@ -335,6 +335,9 @@ struct ffb_dac {
 };
 
 #define FFB_DAC_UCTRL		0x1001 /* User Control */
+#define FFB_DAC_UCTRL_OVENAB	0x00000008 /* Overlay Enable */
+#define FFB_DAC_UCTRL_WMODE	0x00000030 /* Window Mode */
+#define FFB_DAC_UCTRL_WM_COMB	0x00000000 /* Window Mode = Combined */
 #define FFB_DAC_UCTRL_MANREV	0x00000f00 /* 4-bit Manufacturing Revision */
 #define FFB_DAC_UCTRL_MANREV_SHIFT 8
 #define FFB_DAC_TGEN		0x6000 /* Timing Generator */
@@ -425,7 +428,7 @@ static void ffb_switch_from_graph(struct ffb_par *par)
 {
 	struct ffb_fbc __iomem *fbc = par->fbc;
 	struct ffb_dac __iomem *dac = par->dac;
-	unsigned long flags;
+	unsigned long flags, uctrl;
 
 	spin_lock_irqsave(&par->lock, flags);
 	FFBWait(par);
@@ -450,6 +453,15 @@ static void ffb_switch_from_graph(struct ffb_par *par)
 		upa_writel((FFB_DAC_CUR_CTRL_P0 |
 			    FFB_DAC_CUR_CTRL_P1), &dac->value2);
 
+	/* Disable overlay and window modes. */
+	upa_writel(FFB_DAC_UCTRL, &dac->type);
+	uctrl = upa_readl(&dac->value);
+	uctrl &= ~FFB_DAC_UCTRL_WMODE;
+	uctrl |= FFB_DAC_UCTRL_WM_COMB;
+	uctrl &= ~FFB_DAC_UCTRL_OVENAB;
+	upa_writel(FFB_DAC_UCTRL, &dac->type);
+	upa_writel(uctrl, &dac->value);
+
 	spin_unlock_irqrestore(&par->lock, flags);
 }
 
-- 
2.51.0

