Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997BA56E076;
	Wed,  9 Sep 2026 14:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963219; cv=none; b=WyVzmm7C7barYzIB3cJNXZE2PGcNz7UyNWj6E+d27apLHMBejP5BVOASwRl3Ed6btOIon9PbjkQR6Vw19BqIma6SUGuryqNoTP/v1yhDCzIEBlXuOWb6sZtUINWxFHXntszW1ZJn8oBgvxNE/oo08Ur8YyQMsacwP+Xg8YLxxAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963219; c=relaxed/simple;
	bh=JtPA608+V5LnmSCmXA+3OfGgFXKicRc7j97W+cBRdZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WysPIOixTvL6u2SIjPneRVNPAucnMrF3AbYJ+kxq80qXKTDlbEyhcWMkCg72DUg0ZGYcfg+3waxDzsAV8d12NlkgizY9424rKogtKtZuyAND709jXQJQCGaTkx051pK7/rEasL60MWMYA42j+P3Gp6mvsknzbSFcv4nCY1FQX3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyB9cFUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyB9cFUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D241F00A3E;
	Wed,  9 Sep 2026 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963218;
	bh=WO7texvS+QozYArHHroR92HkP5F9yFy4MzExYXo6NqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyB9cFUbbVq6Gqt1kae+qLbKmO8cDSd1Lo4L8b5C4uySheLO/GVAAyfbnpEaVRiAb
	 g4x2tHcEgjBVbtQ0j+/VSPvhFsvr7eeo8dtwScAjDEz7MLXHWHoc3cI2qw7miEiMNP
	 w3sZ4J+ehH/vwsPWCDTLaioQeDxjCJ34Hn9+5EjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 7.2 523/556] drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation
Date: Wed,  9 Sep 2026 15:43:23 +0200
Message-ID: <20260909134248.821058604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Shixiong Ou <oushixiong@kylinos.cn>

commit c6f48e59ece0123f6a11527ad4d89b21c2d65b87 upstream.

The framebuffer size calculation `fb_size = linebytes * height` can
overflow when both values are large (e.g., 46341 * 46341 > INT_MAX).
Since linebytes and height are both int types, the multiplication is
performed as int * int, which results in undefined behavior on overflow.

Use check_mul_overflow() to detect and prevent this overflow, consistent
with the approach used in simpledrm.c and corebootdrm.c.

Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: c8a17756c425 ("drm/ofdrm: Add ofdrm for Open Firmware framebuffers")
Cc: <stable@vger.kernel.org> # v6.2+
Link: https://patch.msgid.link/20260825104134.669676-1-oushixiong1025@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/ofdrm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/sysfb/ofdrm.c
+++ b/drivers/gpu/drm/sysfb/ofdrm.c
@@ -2,6 +2,7 @@
 
 #include <linux/aperture.h>
 #include <linux/of_address.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -913,7 +914,10 @@ static struct ofdrm_device *ofdrm_device
 			return ERR_PTR(-EINVAL);
 	}
 
-	fb_size = linebytes * height;
+	if (check_mul_overflow(linebytes, height, &fb_size)) {
+		drm_err(dev, "framebuffer size exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	/*
 	 * Try to figure out the address of the framebuffer. Unfortunately, Open


