Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108252D9EEC;
	Mon, 27 Oct 2025 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592981; cv=none; b=tsVBBQtIDGFdMfiu/r3l2zxPoACe83KsQKeKUk7Hv0jGP/mIUXAAXi8opeYpHdreL4LCpg01dEk45I7ker8ZBgIMAwCJ6mS7sLFs9Ca2CwY5Fd14TeYtlIvWv5ubRqgLqrE27PcZnrD4DbwAasOgC8mO+TKSTLSry2mUboSylqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592981; c=relaxed/simple;
	bh=qX8Lm0a35NixAd/SE3vt+3nXRIqHlfQCcaB9ux39fBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV8HRdUeURKMIjAjgaOLNAz37m5VxqyhU3veGd+jlDeKM+26FG5m2NPjoV7+vBcIeEGkJzI1IBlk/Mn3BiS6C8/WpVCRoPHu6Tn5E7IA6QSyVUQjFXiyFrDBi0HQTtZjCrmpiL3bjJULEm8vEXpYdwlyKVyBSVQjckZBL8Ucf1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyJQet3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyJQet3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99355C4CEF1;
	Mon, 27 Oct 2025 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592980;
	bh=qX8Lm0a35NixAd/SE3vt+3nXRIqHlfQCcaB9ux39fBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyJQet3AzJAMMGoiEJthSfcY2B7oyQS/YF+UZE/C+1M/hxoX4/+0xc0Hh9/axEy0r
	 0HUhIDpq/ZlfQq1x0Sdw8bGYBwrXGBqeGNAbIOiSNDm5xp23fXuZtINhbuL8FaBuVf
	 n4ct3/FxbvvH9/Mv5dK8BzW6mhFiAua84imtAvl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/117] drm/panic: Fix qr_code, ensure vmargin is positive
Date: Mon, 27 Oct 2025 19:36:52 +0100
Message-ID: <20251027183456.352169472@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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
index 932a54b674794..0aa87eafdacd5 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -618,7 +618,10 @@ static int _draw_panic_static_qr_code(struct drm_scanout_buffer *sb)
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



