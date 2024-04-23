Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEA11487C4;
	Tue, 23 Apr 2024 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908752; cv=none; b=mymhYdE9nwEa1ragoGrz4ypCfTZNOORRB+BaZL2OG/Yt1A/anymhlTXDGub1QdOLUW6OVkl+/3zOYAlJLhMY3ca5z7FQ9VbwzwljSBHCfj1UivRGb30FKcSAerZQ5RJn9JDuvw9hYpEFfv6tcR7rFP8JizUH2J4HAWihErXbNcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908752; c=relaxed/simple;
	bh=KP1+8uY0RoD/Qlmw5LGuQDt6iX15EQdMhxGaLgt11BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsEw/5+Rveqj2bZEXhPS5UPPbS6hAgakZW1SckmCske0WVRZhaoo7ytuqaY5m2Kp29WfD0osrZ/RgmCZZQC6r2NgyPU/TZeG5E+xWflMRNCo7OOyISczrs9/rcgce8++BRbT4sgFWOZaQS6DZCtO7Ia5Lwdibi6//tvuTmBGRI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dyo2vis0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dyo2vis0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889A6C32781;
	Tue, 23 Apr 2024 21:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908752;
	bh=KP1+8uY0RoD/Qlmw5LGuQDt6iX15EQdMhxGaLgt11BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dyo2vis083Eh7HG2sgiBYugVQHKna+RTLErSLbs+gqPxBnjhvVpVW3hxqw6uMmsf+
	 qgFUPc/Dy6df6s3H+uujWb11TERhMawbBEd+qRbt+3AeQPWpUegP1ugkFFYX63XHtE
	 T0cVgIjaQU7F9rTfO46SkbnHMBEO1CSVqrvQKe/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Pekka Paalanen <pekka.paalanen@collabora.com>
Subject: [PATCH 6.1 128/141] drm/vmwgfx: Sort primary plane formats by order of preference
Date: Tue, 23 Apr 2024 14:39:56 -0700
Message-ID: <20240423213857.367917583@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit d4c972bff3129a9dd4c22a3999fd8eba1a81531a upstream.

The table of primary plane formats wasn't sorted at all, leading to
applications picking our least desirable formats by defaults.

Sort the primary plane formats according to our order of preference.

Nice side-effect of this change is that it makes IGT's kms_atomic
plane-invalid-params pass because the test picks the first format
which for vmwgfx was DRM_FORMAT_XRGB1555 and uses fb's with odd sizes
which make Pixman, which IGT depends on assert due to the fact that our
16bpp formats aren't 32 bit aligned like Pixman requires all formats
to be.

Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Fixes: 36cc79bc9077 ("drm/vmwgfx: Add universal plane support")
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.12+
Acked-by: Pekka Paalanen <pekka.paalanen@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240412025511.78553-6-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.h
@@ -246,10 +246,10 @@ struct vmw_framebuffer_bo {
 
 
 static const uint32_t __maybe_unused vmw_primary_plane_formats[] = {
-	DRM_FORMAT_XRGB1555,
-	DRM_FORMAT_RGB565,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_XRGB1555,
 };
 
 static const uint32_t __maybe_unused vmw_cursor_plane_formats[] = {


