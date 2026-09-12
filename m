Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D991624D5;
	Sat, 12 Sep 2026 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224799; cv=none; b=uxKnOQlnhd0fGL9RVb89U44CVo2aqXHLqxsJp/ZYiLKM+OR9Xjykj1NSKhX/tWSJgIH7aj6dn1akbOqC51620LAN+9EXhZ5CKcR06NHKjftOM//S5MdW0sQC3ZY2x59N/VxYYip+DYUQgj0jc9EPfICy2VpZWo7+CcL9QiudT8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224799; c=relaxed/simple;
	bh=btdZqQIMa1W+TRNFiU0Z9axkqIutaBFlkXQ/4zc8Mn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsDylcKwu0cNrMr31Zd6HBbhouOFpbUntzrfDON48WG2rXGwgPr75j9WBi9Xsh+WOYY9fTGIf9lphT8aTXd+nRTuZ8mjs5nS0/BXwk3ow+mH5R5tFnOr+IeUcoJMs8a+1BojkI2Qe7L4la6Iu4B1JkEJyzCxNWb4Sa2aRI/Bmis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTulS60J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTulS60J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC53B1F000FF;
	Sat, 12 Sep 2026 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224798;
	bh=53tx0bdAu3bWoGpIHf72YIqhlzgRu58aMddmeVSMP0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTulS60JYV/MrMLcXvHGQMAvc4xL2PJ3YOVDEK6XhDV2d0EUloLqoOAxvaySUOJtO
	 RnaxH2N8pwfOwEEuD3tXz9pW/ml89B/3DNm+UfkhoogYR+bLhlv5jiBBCiUwsSmRAk
	 ATdKJHX8YdujbqlUeFkFISguHwyfdBMQBZHIjUTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1067/1424] drm/sun4i: vi scaler: Fix coefficient selection
Date: Sat, 12 Sep 2026 08:58:19 +0200
Message-ID: <20260912065631.199678338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 7ba75011adf9f..328b84df2ee5e 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
@@ -891,20 +891,26 @@ static void sun8i_vi_scaler_set_coeff(struct regmap *map, u32 base,
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
 
 void sun8i_vi_scaler_enable(struct sun8i_mixer *mixer, int layer, bool enable)
-- 
2.53.0



