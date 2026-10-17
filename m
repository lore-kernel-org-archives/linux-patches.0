Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44337385D7B;
	Sat, 17 Oct 2026 16:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256033; cv=none; b=hcxYsMU26TrEThFfJhUSKUcIteFciGpcB8524xKaGXM1Tf0JFK1LZl79fmzv+soQ37SLoFVd5H335ADNB6GMfDqpv6OqpAiK8fvJkwOZ7MrLoHgmDtTrMbjsfWKL58YTN9WIVrLIX2vSBdz0k9714TbAITpQkTPJerB8a89EO4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256033; c=relaxed/simple;
	bh=vIPrmPTkCGvzArfxFlnV7aJh9V796p86+UozATIu1UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHX/9g6pLkjqKwub05jPySBe0Et7oYx4cMM5iaOHvVgfYfkRokZ8Ghm1UAV98abeEozX/XfqC8bxLDS+nGUTh/DUWSqznlWEycXWffKsyMB8Cl+02VGVu/+4vcOHPHSXzh8hg1f3VjKNM3p6rKsvcpFcOuwddnAw4DjJKl2nL1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8+LgChK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8+LgChK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB011F000C4;
	Sat, 17 Oct 2026 16:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256032;
	bh=IpmUGy20A8rykKhd2t6Tn7hdtrBZkimrboCeheIV0kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8+LgChKrbHc1imb0TJ3PJZtT0/jr0G17+yFeel/0eZvZoCH2X6RO5K+jfGk7qbde
	 rKqmJdBSnoVnFe/nb0zKKDygssGxrrrP3U318Qynj0RuXLhubvXyj2m5gTlbAM9kId
	 0X4hQbJJ14hQbN66J3i61pR5AfVLerfll7moFLFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0101/1674] drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation
Date: Sat, 17 Oct 2026 17:39:33 +0200
Message-ID: <20261017160433.739065652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Shixiong Ou <oushixiong@kylinos.cn>

[ Upstream commit c6f48e59ece0123f6a11527ad4d89b21c2d65b87 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/ofdrm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/ofdrm.c b/drivers/gpu/drm/tiny/ofdrm.c
index fe2d3b7c61258..2c59e501112b8 100644
--- a/drivers/gpu/drm/tiny/ofdrm.c
+++ b/drivers/gpu/drm/tiny/ofdrm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/of_address.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 
@@ -1169,7 +1170,10 @@ static struct ofdrm_device *ofdrm_device_create(struct drm_driver *drv,
 			return ERR_PTR(-EINVAL);
 	}
 
-	fb_size = linebytes * height;
+	if (check_mul_overflow(linebytes, height, &fb_size)) {
+		drm_err(dev, "framebuffer size exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	/*
 	 * Try to figure out the address of the framebuffer. Unfortunately, Open
-- 
2.53.0



