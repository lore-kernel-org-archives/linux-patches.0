Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9FE189907;
	Tue, 30 Jul 2024 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357905; cv=none; b=lg4v8brPDA5GrWHQnoVRoUuJUJ8LJ0FYCIrrf3JM7EVSZrvShph+kalXgnIis6kswIfKxz2jY8pIYrCm7mVMSVuUmtM4N4sFPmnsQklWhT3mfmGW5cfXBcTQnTXf0k32nRyzjzA8+x2Oiz2tBPB70+C05cPLcyX3gkY0JPCxaNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357905; c=relaxed/simple;
	bh=1lN5SRC3VE74B2XgwLd1wDXBR4k2EB2B+A1KotlULto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sty4C68V3rnBoqqEES9S5uF/wOCH2qz1hryLIQabX8RfGhf8XfEVkXsFEvJutWRUtVMrZpYLAZt5dh/m80IyjdcZ+Yk53Wnn13FMARaLDOb1t7UXo7EsFpED5kbT73M7wudufLRtmfUC13FreFYyHPiv7/dSEoDNJFJdstKmtHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThRmito+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThRmito+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCC2C32782;
	Tue, 30 Jul 2024 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357905;
	bh=1lN5SRC3VE74B2XgwLd1wDXBR4k2EB2B+A1KotlULto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThRmito+hGr4RW9mymmeM9xdORRlPiOiodPt4qhpGtE9hG8NfYv3PO1RW4ser6+/h
	 5TgXzfJwSHFqbEOPY3b3tVwPQEgAQH7imWYXKOcoqPEYF/SLYp1Xp0gwahpANZ+/00
	 nz4M0gUoMZ3naXwuT7Rb6sAIxcSUHhOpAJ8QFqeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 303/809] drm/bridge: samsung-dsim: Set P divider based on min/max of fin pll
Date: Tue, 30 Jul 2024 17:42:59 +0200
Message-ID: <20240730151736.560447186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 78c4c0011bb577a29906d8ca135795af2293c49e ]

The P divider should be set based on the min and max values of
the fin pll which may vary between different platforms.
These ranges are defined per platform, but hard-coded values
were used instead which resulted in a smaller range available
on the i.MX8M[MNP] than what was possible.

As noted by Frieder, there are descripencies between the reference
manuals of the Mini, Nano and Plus, so I reached out to my NXP
rep and got the following response regarding the varing notes
in the documentation.

"Yes it is definitely wrong, the one that is part of the NOTE in
MIPI_DPHY_M_PLLPMS register table against PMS_P, PMS_M and PMS_S is
not correct. I will report this to Doc team, the one customer should
be take into account is the Table 13-40 DPHY PLL Parameters and the
Note above."

With this patch, the clock rates now match the values used in NXP's
downstream kernel.

Fixes: 846307185f0f ("drm/bridge: samsung-dsim: update PLL reference clock")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Marek Vasut <marex@denx.de>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240601144103.198299-1-aford173@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/samsung-dsim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/samsung-dsim.c b/drivers/gpu/drm/bridge/samsung-dsim.c
index 95fedc68b0ae5..8476650c477c2 100644
--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -574,8 +574,8 @@ static unsigned long samsung_dsim_pll_find_pms(struct samsung_dsim *dsi,
 	u16 _m, best_m;
 	u8 _s, best_s;
 
-	p_min = DIV_ROUND_UP(fin, (12 * MHZ));
-	p_max = fin / (6 * MHZ);
+	p_min = DIV_ROUND_UP(fin, (driver_data->pll_fin_max * MHZ));
+	p_max = fin / (driver_data->pll_fin_min * MHZ);
 
 	for (_p = p_min; _p <= p_max; ++_p) {
 		for (_s = 0; _s <= 5; ++_s) {
-- 
2.43.0



