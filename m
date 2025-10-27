Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93995321F48;
	Mon, 27 Oct 2025 19:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593464; cv=none; b=rhe2zsSmgQDZeST3CPmpOAYLA89+R6DrmyMqBh3UbRLgsbkdMhdTXTQmVMPM9y/ZHmoNnJWnPlujrc5bOtNKX4brNFdAJMKTbFeH9AyyEK41OsJYOwc1SHTHbbN/JJGUwH0c1RjROsXP/oD2NoPmvuURex2DYiJOfItYmvV1gX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593464; c=relaxed/simple;
	bh=gOSvvXZJHCqXwe6gDrgNGWBfqVTvvs1hzJHZb9Ac1sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+00mEm8x0wOSFfCjfiv2Z+GBGS6/7OhiCmA4zPKmmd++cgVKUaBs3KrZvei90okc1y/Lob3WqNLy2G8i8Wb63YcH7JkRcBKNhtqwkhOWX+W2CGdJuIk1NxWmqjAiDbInd2WZPytMRCRXttt8S40dE8dz5ABoGSdLqQp3D+WlN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQuixjWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQuixjWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA64C4CEFD;
	Mon, 27 Oct 2025 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593464;
	bh=gOSvvXZJHCqXwe6gDrgNGWBfqVTvvs1hzJHZb9Ac1sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQuixjWlqbHS5bR9qvijQo3fMf6M4aGP0eM3lTjZprahrPdWqa3Md0FQJ/0vlirJR
	 dkGiOauMcLWEQiO+B8U669Pc9kmrbxlBwTxTBmtzwjVjtvQtklc/E2viADf+gdz4rm
	 kOMaZxF22Ysz0SWWh8jFl+2z48sgYT9iIeQyD9mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 141/184] drm/panic: Fix qr_code, ensure vmargin is positive
Date: Mon, 27 Oct 2025 19:37:03 +0100
Message-ID: <20251027183518.740063404@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit 4fcffb5e5c8c0c8e2ad9c99a22305a0afbecc294 ]

Depending on qr_code size and screen size, the vertical margin can
be negative, that means there is not enough room to draw the qr_code.

So abort early, to avoid a segfault by trying to draw at negative
coordinates.

Fixes: cb5164ac43d0f ("drm/panic: Add a QR code panic screen")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20251009122955.562888-4-jfalempe@redhat.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 23ba791c6131b..1bc15c44207b4 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -736,7 +736,10 @@ static int _draw_panic_static_qr_code(struct drm_scanout_buffer *sb)
 	pr_debug("QR width %d and scale %d\n", qr_width, scale);
 	r_qr_canvas = DRM_RECT_INIT(0, 0, qr_canvas_width * scale, qr_canvas_width * scale);
 
-	v_margin = (sb->height - drm_rect_height(&r_qr_canvas) - drm_rect_height(&r_msg)) / 5;
+	v_margin = sb->height - drm_rect_height(&r_qr_canvas) - drm_rect_height(&r_msg);
+	if (v_margin < 0)
+		return -ENOSPC;
+	v_margin /= 5;
 
 	drm_rect_translate(&r_qr_canvas, (sb->width - r_qr_canvas.x2) / 2, 2 * v_margin);
 	r_qr = DRM_RECT_INIT(r_qr_canvas.x1 + QR_MARGIN * scale, r_qr_canvas.y1 + QR_MARGIN * scale,
-- 
2.51.0



