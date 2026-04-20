Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526C033262B;
	Mon, 20 Apr 2026 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699983; cv=none; b=LuDbDY9bT9Tff3k+sHBl4SRU0OKtS7Qiv4/6zxBalfWGm6Hq4qW7zuRysdsmpyPhbgDMGKseAqlL1Fs6SvPwnkVPRJU93YbFWKKbHn7lj2t9WeQq7x1E6pEmXTGsZAPXbJz4jGD76R0yVx9VXRftQ2fvf0JqsRe0DM4UndGoBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699983; c=relaxed/simple;
	bh=2TT3lJ4PTIbCBGJ2VA4Nujm5eHgW9f9uclXRQi/EI2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQUQupJL0Iio8U+72UfVFMQ8QEkElgRxnIPy/3p4sDZMdivyKdrZrknh8fjz5O2xFohPobtnfrPaykkbTY6gRmXsaDH3qMa9MWdSQpHfGlI0ld2rZC8+MaIkCJV3McntFUSavCcz/E5i6dA9VMOrvPDJhAeN6DjXSTO4KwQrKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hClQZnDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hClQZnDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9CFC19425;
	Mon, 20 Apr 2026 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699983;
	bh=2TT3lJ4PTIbCBGJ2VA4Nujm5eHgW9f9uclXRQi/EI2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hClQZnDJC0878n40c4LDivpIhSD+wTWRZEN3Ugs+ckUPnm0HdOSQDpRyEWNkwZNMw
	 EcTc+NDEKOLT3NzVFnwTliar1XJLwrqBsbj0aGM4+0FpN63BKNSAzxGmlDK06sIG7M
	 ptJKZ8/ZQRSPO9BuhkAHjgGVhKy06maXMmTJ8/R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernie Thompson <bernie@plugable.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.0 31/76] fbdev: udlfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Mon, 20 Apr 2026 17:41:42 +0200
Message-ID: <20260420153911.955256631@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit a31e4518bec70333a0a98f2946a12b53b45fe5b9 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Bernie Thompson <bernie@plugable.com>
Cc: Helge Deller <deller@gmx.de>
Fixes: 59277b679f8b ("Staging: udlfb: add dynamic modeset support")
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/udlfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1018,6 +1018,9 @@ static int dlfb_ops_check_var(struct fb_
 	struct fb_videomode mode;
 	struct dlfb_data *dlfb = info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* set device-specific elements of var unrelated to mode */
 	dlfb_var_color_format(var);
 


