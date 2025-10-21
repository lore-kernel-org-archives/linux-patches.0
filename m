Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506D1A3029;
	Tue, 21 Oct 2025 20:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076926; cv=none; b=TahNCe0CbTGI9IxTAJFInrtXgq00bP0FrrLVVPZWTIqs7WXlaaDxSHdLPD5MJuoQtI6Fi1n+bQRFAHYRk4xTbI96SReSfQiNm2O8yp1a/scGrBCBYisc3kl8QDSX+UkcldIPh5BsuxFHL4GprGSwGbZROvVcU1VaME8iVmL4PpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076926; c=relaxed/simple;
	bh=+BNKvJiv54DDHql/ATz7W/Yu04Oboh18B37mQNno1rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6WiFuQQDXLEd0/RuxfQyTut1caVZoNbgvaLUti0OUVSgwjTzmY0+s/PCle41tjXo5Im/nRANOhelgj+DIXjQRZf3GttS+f/yRIl4C5G8tt90qVPOjhxUJesHClB/M3Wl2jsNlT4u7KeoKI7bVweAa5ttRsypH53edp6A5x3jjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xr2fAxRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xr2fAxRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05CEC4CEF1;
	Tue, 21 Oct 2025 20:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076926;
	bh=+BNKvJiv54DDHql/ATz7W/Yu04Oboh18B37mQNno1rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xr2fAxRjv0T9eK34yiLqtNuTvSKZEyV0JySOY85y8xwXt2c6a/JRmrsSUBkhIasCl
	 IIWkeb2FUlCu11b1Xtdrt7TgozBoUVeJeZBAdV3P8KBTjorwVi5F4XdluMXeh3WWA8
	 SDqkEom2M+mQL3oyiPVj06cI3yTIlzAccfPzKaWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Valla <francesco@valla.it>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/136] drm/draw: fix color truncation in drm_draw_fill24
Date: Tue, 21 Oct 2025 21:51:08 +0200
Message-ID: <20251021195037.890677045@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Valla <francesco@valla.it>

[ Upstream commit 095232711f23179053ca26bcf046ca121a91a465 ]

The color parameter passed to drm_draw_fill24() was truncated to 16
bits, leading to an incorrect color drawn to the target iosys_map.
Fix this behavior, widening the parameter to 32 bits.

Fixes: 31fa2c1ca0b2 ("drm/panic: Move drawing functions to drm_draw")

Signed-off-by: Francesco Valla <francesco@valla.it>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20251003-drm_draw_fill24_fix-v1-1-8fb7c1c2a893@valla.it
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_draw.c          | 2 +-
 drivers/gpu/drm/drm_draw_internal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_draw.c b/drivers/gpu/drm/drm_draw.c
index d41f8ae1c1483..b61ebc5bdd5ce 100644
--- a/drivers/gpu/drm/drm_draw.c
+++ b/drivers/gpu/drm/drm_draw.c
@@ -125,7 +125,7 @@ EXPORT_SYMBOL(drm_draw_fill16);
 
 void drm_draw_fill24(struct iosys_map *dmap, unsigned int dpitch,
 		     unsigned int height, unsigned int width,
-		     u16 color)
+		     u32 color)
 {
 	unsigned int y, x;
 
diff --git a/drivers/gpu/drm/drm_draw_internal.h b/drivers/gpu/drm/drm_draw_internal.h
index f121ee7339dc1..20cb404e23ea6 100644
--- a/drivers/gpu/drm/drm_draw_internal.h
+++ b/drivers/gpu/drm/drm_draw_internal.h
@@ -47,7 +47,7 @@ void drm_draw_fill16(struct iosys_map *dmap, unsigned int dpitch,
 
 void drm_draw_fill24(struct iosys_map *dmap, unsigned int dpitch,
 		     unsigned int height, unsigned int width,
-		     u16 color);
+		     u32 color);
 
 void drm_draw_fill32(struct iosys_map *dmap, unsigned int dpitch,
 		     unsigned int height, unsigned int width,
-- 
2.51.0



