Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9133DB326;
	Sat, 12 Sep 2026 08:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202078; cv=none; b=WZ3NIpnU/YiduGvcHSCMBXXG9D7nQR0QcV/JUH2Dm2L0j4K80Yg/LqrcJlfhiWcwNQATHu24mVyxJLW2+1jgig/OUBXvVXqMs3SWraTVR1ze0OW8cRZ135Gkv31J8MWul+QNjj5rkxtk2n4AtOD2NQVSCt44odFIdTHiHf+On0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202078; c=relaxed/simple;
	bh=DW1UmuLwQWOSlJtZgOBnXcK0jPbIM2SZi2EWJ38E31o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuV+/2oZ8bVxJ2sKADxYOH3C/aCbMRus128gMqbdPi7Ig4+Tdy34HQVssY/xf8Q5SN6WDIfQ6ciGeZd9pm6/seNvjLMqgqCR6joOk9NJv1VNE4HP0XaITdRNlssFLmzEr8v+ipS+Hdxmdyprsx0dzkjbwED73BrKCESrlT6p0do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFJRdgr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFJRdgr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6069B1F00893;
	Sat, 12 Sep 2026 08:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202070;
	bh=Cb+qkUOrcF9KqxAlQR0q0c3zS1IFY9i6KMuN1cEyp/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFJRdgr+7oDNf543iloZ73zf99dWMS2/++vp8dHBl5vE5pJzidWQa7sYp19ACtaCB
	 01YbPI5v6HWVF6deA+tJDay2Um6pORMF/oShqS6SiDDDHGeB3/tctKN3eDoNCxXMCc
	 1bdlbo8CIxebl2/TjUnNSb0zp5rw+0nC7cGmaK+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1126/1815] drm/sun4i: vi scaler: Fix coefficient selection
Date: Sat, 12 Sep 2026 08:47:56 +0200
Message-ID: <20260912065715.455724505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 5c31990b21f0b535732deb2b658b78b07464f56c ]

Currently, vertical coefficients are selected based on horizontal
scaling, which is wrong. Additionally, chroma coefficients should be
selected based on format subsampling.

Fix all that.

Fixes: b862a648de3b ("drm/sun4i: Add support for HW scaling to DE2")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/263a4a41442a3c8b072b170256b72658f1b90802.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
index 3dec4eeb1ba21..d4412a62c2f07 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
@@ -894,20 +894,26 @@ static void sun8i_vi_scaler_set_coeff(struct regmap *map, u32 base,
 			     lan3coefftab32_left[offset + i]);
 		regmap_write(map, SUN8I_SCALER_VSU_YHCOEFF1(base, i),
 			     lan3coefftab32_right[offset + i]);
+	}
+	offset = sun8i_vi_scaler_coef_index(vstep) *
+			SUN8I_VI_SCALER_COEFF_COUNT;
+	for (i = 0; i < SUN8I_VI_SCALER_COEFF_COUNT; i++)
+		regmap_write(map, SUN8I_SCALER_VSU_YVCOEFF(base, i),
+			     lan2coefftab32[offset + i]);
+
+	offset = sun8i_vi_scaler_coef_index(hstep / format->hsub) *
+			SUN8I_VI_SCALER_COEFF_COUNT;
+	for (i = 0; i < SUN8I_VI_SCALER_COEFF_COUNT; i++) {
 		regmap_write(map, SUN8I_SCALER_VSU_CHCOEFF0(base, i),
 			     ch_left[offset + i]);
 		regmap_write(map, SUN8I_SCALER_VSU_CHCOEFF1(base, i),
 			     ch_right[offset + i]);
 	}
-
-	offset = sun8i_vi_scaler_coef_index(hstep) *
+	offset = sun8i_vi_scaler_coef_index(vstep / format->vsub) *
 			SUN8I_VI_SCALER_COEFF_COUNT;
-	for (i = 0; i < SUN8I_VI_SCALER_COEFF_COUNT; i++) {
-		regmap_write(map, SUN8I_SCALER_VSU_YVCOEFF(base, i),
-			     lan2coefftab32[offset + i]);
+	for (i = 0; i < SUN8I_VI_SCALER_COEFF_COUNT; i++)
 		regmap_write(map, SUN8I_SCALER_VSU_CVCOEFF(base, i),
 			     cy[offset + i]);
-	}
 }
 
 void sun8i_vi_scaler_enable(struct sun8i_layer *layer, bool enable)
-- 
2.53.0



