Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4783358B0;
	Mon, 20 Apr 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700977; cv=none; b=WL8oK1YCWc4PG+xOZt+jpGQ45n7SyFMlKYwBtAjhclJJ0f779YAyre80jfK3CSUM5VzPTADD8g80uVWdhYoCKxZmuDnBmBXKAFrXab3G2oz96lKHRsQ0uwJR//TMvi04ATpp/2jGXHesuMBywgs3ZUXGA8V7Rf2Qnjju+7FpDTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700977; c=relaxed/simple;
	bh=94kTuwxmGV06nCbCgfc7UD2uKGtkkwQxCq0CJYidcJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLdYDZKUY9ff9kUY9XRlzHpPO+uAKqBhXUqhruHRe7fgVRwfzJyALLOoTqQqBuVh4A9iQSkqvb4x399E4T94qybka1QytYkkCrRxMjqk492PjqWeaOWvLCqocuDn3etXhlnI7xL4ztq9u1Hk2XS650P9IikV4jmlQkm6NiNsGPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soLFUwwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soLFUwwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA6C19425;
	Mon, 20 Apr 2026 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700977;
	bh=94kTuwxmGV06nCbCgfc7UD2uKGtkkwQxCq0CJYidcJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soLFUwwiD14iq9ZVBaxE1b7jBAVlE6KBBywIM5Ayx7z28Tz0zyd+nJdUj6ysJylMT
	 S/vTG0zDexwrj8zUEAVZCt9KVTYQrKWCiCdq+YeKeh59VE9ZPQqbYoMt+0PylZVCtj
	 /Qp72LTHCXSKsWvIxIvHrmG/DPOV7CPW+KYXv508=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 133/198] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Mon, 20 Apr 2026 17:41:52 +0200
Message-ID: <20260420153940.396937383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f98b81fe011e1879e6a7b1247e69e06a5e17af2 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Helge Deller <deller@gmx.de>
Assisted-by: gregkh_clanker_t1000
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -496,6 +496,9 @@ static int tdfxfb_check_var(struct fb_va
 		}
 	}
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


