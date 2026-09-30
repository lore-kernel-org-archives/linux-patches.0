Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39851542EC4;
	Wed, 30 Sep 2026 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790091; cv=none; b=RooTWKW6Z1AQim/o8xuuMAG9k7PD5kjvaLsJjeZ3BWukh3duhwsFGCMXvgvCwfs47iIjB33ZKq5f77WsC0HiuHhYClj//xdF4tB2m2O8a3rosmug+crGjlorUnJCiyjlnVPUDy5mPEAvwXtA5MnedkHadW1a61G+EQkTfqwcAXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790091; c=relaxed/simple;
	bh=tjiFC6psTOdVqNadenI0fChrzOd8sSuebCEfPUIfIyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz4YtAGTWp+vhM9L3qJsDEW2YniLmOxg5yR+c/pd56AasC4czn9HiVrKbV7/H16ydmkdD+4UYHQgBQbpIlBQ3IXGSX/y0KjISZiyllbuYwob6hMTgfAbdNg1D69jF+mndctkrayan5k9SxmTh9GHnOFwU7yX98KYGD5JGcFIcl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRQ/Fd1x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRQ/Fd1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C731F000FF;
	Wed, 30 Sep 2026 17:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790090;
	bh=T5gAwVOze7tuqOhSPwcDtF9pYkthr+PPJ2IjFriTuQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRQ/Fd1xg5egFCJnugqkIC3IcLc+MC+vNl4zXEsynxPTH4Bc7VU2dfYC02zrRjUtG
	 1QUit+UNPHfx8+UzNC6Mo+SVRmEhVqjI14YjwOVbS1vuSwQ5b4Iosw3LjEg84A2CjM
	 Dq4mB0A7u3bkgX93HqxOOM6V++jKYyI7ryrTFnK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shixiong Ou <oushixiong@kylinos.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 707/877] drm/sysfb: ofdrm: Fix integer overflow in fb_size calculation
Date: Wed, 30 Sep 2026 17:26:58 +0200
Message-ID: <20260930152429.940379265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/ofdrm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/tiny/ofdrm.c
+++ b/drivers/gpu/drm/tiny/ofdrm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/of_address.h>
+#include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 
@@ -1182,7 +1183,10 @@ static struct ofdrm_device *ofdrm_device
 			return ERR_PTR(-EINVAL);
 	}
 
-	fb_size = linebytes * height;
+	if (check_mul_overflow(linebytes, height, &fb_size)) {
+		drm_err(dev, "framebuffer size exceeds maximum\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	/*
 	 * Try to figure out the address of the framebuffer. Unfortunately, Open


