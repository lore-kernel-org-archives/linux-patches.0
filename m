Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E40A435EE9;
	Sat, 12 Sep 2026 10:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209880; cv=none; b=OPIDinNCUREjqLgEJGCw7Mdsk6WoqOVsNdO3fInCPu5uPH9dMJaCRvVO337C7Y/8f/zr2Cw9BkUwJJMNrKoDf6I/YYko7YPCcA95dh7hBR+z0MMUv7L1NpcRKpEkTTIUp8XKueJww/qggfXBY/Jg3Q2FVmC/i9SqDWEZHqIsdxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209880; c=relaxed/simple;
	bh=RB0uJnEVkj8V0i9/xaQQNO4unReZBIppRKCW9RCHgYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQr1Kbdr0Xz+Sz5kbZUO8ysDzhNHphbCP27NIOGgL7rR6jiWyjYaqvYAOCbbdXKBFpfPm+U5NA/70kAmgWMddJ7GQllI0SW7/qZigvXlRRd8/l5s+tP5Gs2iV4epGBz6Pd+UZh5nv1YpQTIVhQWYLSJadh1VGnv8ulZ+ovaP3O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm2trrQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm2trrQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB2F1F000FF;
	Sat, 12 Sep 2026 10:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209878;
	bh=qdXW6/IYZsBKAd5CYnE8+zDKE3weROYqun+SI+7F0Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hm2trrQxW/kQQadTIvtosBVlXKyrbIoSOrvfJlihZfEGDhgdjUl3+EIPinGzHy8o+
	 jZxX5xQ/rDflFdDkzVwHy3IfYwMOhW9xfmFusfbi+Cxdd4sG/a7fi8DdVwjljOMckg
	 BqKhZaf/GpfhkJh48jYn0L9aOAoP7WOTfr1dWyac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0911/1518] drm/sun4i: vi scaler: Fix coefficient selection
Date: Sat, 12 Sep 2026 08:51:20 +0200
Message-ID: <20260912065644.063088744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 82df6244af885..695491b7739bd 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
@@ -893,20 +893,26 @@ static void sun8i_vi_scaler_set_coeff(struct regmap *map, u32 base,
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



