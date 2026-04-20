Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C198533F586;
	Mon, 20 Apr 2026 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701411; cv=none; b=mktWJX++I7WDpEtQ7dmaXBnTzGIv2jORW3LZy5gTrnvgNg0WHGqohTKiM37jGpvTlAUVizGhGcq8hgROZBRJiddvGU4X2KwfSRYV3GzbHICUIQF2WsiTO8t9ULIa7Mm0UjEWDeR6cOKu+k0HEFOPSzJyWUfIui15Ap660uRbgMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701411; c=relaxed/simple;
	bh=mBMIlvAbz4j8BELH/YVgu1Xuk1kDhZZEmjGzjtIm/Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPWKLw9T2bWt8/YgeEHTqha5BadE7KXBlibOk2h72XqSxZQKkDA+2DE8oraH2/eYiYovS5X/HwCFP3wcZw/msAJygVUYdLfgjckNdpkfupYNgVP1Nj1Ud/ZSnzS5wHA1lllce9CVvOMYTjJIwyy5eiZeHFvWGJuoBg4nGyzAr54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYdyB45p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYdyB45p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58129C2BCB4;
	Mon, 20 Apr 2026 16:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701411;
	bh=mBMIlvAbz4j8BELH/YVgu1Xuk1kDhZZEmjGzjtIm/Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYdyB45p4tKkey1ejdA/wub5Trk6SKPhyUcnQvqiakh3CHkEB2WYIPKTbyVFbiphB
	 MX0jOSI6JEdhsGBflm4Nv7di4fmHkBDdChqZ9g/gO5qmjfkK1BifsT3mS2a0jJGe+x
	 a24uWKSimhAVWhof9X/s1c0Fqq1X6WkuXOO0eeXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 103/162] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Mon, 20 Apr 2026 17:42:15 +0200
Message-ID: <20260420153930.770949197@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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


