Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7091C1A3029;
	Tue, 21 Oct 2025 20:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077469; cv=none; b=G1wzgbTsX3gC1/u/1UeGLGKF4vVLDjAD1CnG7GSdu1C9npvh1/CSDRt8yFcNxUrY9F3kRpvASD71UJ29glYrFNB4B6stmOvPoyP0HCwGMD9kA1sSUCqITWJ3+FWJiwwC8sgHBXiBOmzVimdTQDz864WHu9vU+vtu8e1siUD2MtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077469; c=relaxed/simple;
	bh=gMBOjfOfImX9avRnguzDaqtX+ltBx9Lvj+usLNW3vZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSCwoNTIanSgicIq9SDQnhQKMWpvApsQ+l1ZopXxDEX8diu08pa/23LvxsTWgjoeOsHlgS5rEDzpyl2I2CjNYBSRB9Qwg7rG3AyvAP2+w9T6vcyYd31dYOmVCLaRwgXKIwPx1pq1ElOVXu9uM6H9Dbpbb39m4CuEpOeU2+punwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qF9r0BG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qF9r0BG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA64EC4CEF1;
	Tue, 21 Oct 2025 20:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077469;
	bh=gMBOjfOfImX9avRnguzDaqtX+ltBx9Lvj+usLNW3vZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qF9r0BG8o9HpKZ87jfqeGiYZ6mEBaGMu51kX1o8TAQqb7QKUzNpQLizM6hb3FpPmt
	 sIqJB3SdUWNrY1P76TkUvz2tTSe/V2QsCeH0cu7hvnxLv2K/RvUobnCvEXqyB7EfWb
	 rY2XFmnVrhCyd3JY1iCGfDgE+yPrprfXNqRdJU4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Valla <francesco@valla.it>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 115/159] drm/draw: fix color truncation in drm_draw_fill24
Date: Tue, 21 Oct 2025 21:51:32 +0200
Message-ID: <20251021195045.929881730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9dc0408fbbead..5b956229c82fb 100644
--- a/drivers/gpu/drm/drm_draw.c
+++ b/drivers/gpu/drm/drm_draw.c
@@ -127,7 +127,7 @@ EXPORT_SYMBOL(drm_draw_fill16);
 
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



