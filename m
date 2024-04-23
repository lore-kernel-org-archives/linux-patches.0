Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CB085274;
	Tue, 23 Apr 2024 21:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908559; cv=none; b=e4Q4xE9kXghKBXdKYbXNqm2slJxZzIyX9exhzylbu9xde51I64FN1KuB2Cb98THrCf9Z9ZFfVQYebXQgY9nQ0QgtUDAm4e/6WtDRKU9K5BiRlLGXZlx5+QslHEPwaY8Do1WtF1FIYP4zwyHJB9wX8w2yQac9DKfviDbFTmPjciM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908559; c=relaxed/simple;
	bh=wtIbt6hKLI9SYaTZFUwU2/J3b5auzSYLLV6jtbqPsfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmSjWuNd64fanHn/Y7vPqYVAx9/msmPkus2pyW7aKPnnci8VYN4GJYjbn8cRz+Nfv/yMCA2lEpwpagUr99+/jHCzsE1QTntPdZpUQJhuoaQvTRXeJvAJa+ypS+xPBj0qEseXbxbDyOPNy/vw+gn/6NC4qgmqsQl2dzqxyfyWwzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7c3TZt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7c3TZt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862A2C116B1;
	Tue, 23 Apr 2024 21:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908559;
	bh=wtIbt6hKLI9SYaTZFUwU2/J3b5auzSYLLV6jtbqPsfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7c3TZt01Th3MyJ3C0nKnr+bcTzamLGc9nOh6FekG3Erb/2oGU/bm0Syg/PxCk/mI
	 gvKXK3wAVy3shDKiPqPP1tjC5Xf+Cac3qsGwkRWxZPE8oXKO3sZiWgKeMx/HhKtoNP
	 P6zx+7hrrCkx4unxw8MhP7M+7qs9kDhXJbNuVveo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	dri-devel@lists.freedesktop.org,
	Pekka Paalanen <pekka.paalanen@collabora.com>
Subject: [PATCH 6.8 146/158] drm/vmwgfx: Sort primary plane formats by order of preference
Date: Tue, 23 Apr 2024 14:39:28 -0700
Message-ID: <20240423213900.605907888@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -243,10 +243,10 @@ struct vmw_framebuffer_bo {
 
 
 static const uint32_t __maybe_unused vmw_primary_plane_formats[] = {
-	DRM_FORMAT_XRGB1555,
-	DRM_FORMAT_RGB565,
 	DRM_FORMAT_XRGB8888,
 	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_XRGB1555,
 };
 
 static const uint32_t __maybe_unused vmw_cursor_plane_formats[] = {


