Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBDD143861;
	Thu, 13 Jun 2024 11:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279328; cv=none; b=nPJRywwf8j3GDjOGfdD9S0/3iFND+5xwUChR3BseroXNlbQ4NzTPKGgqet2TlHWV6vEeDnbYkDxH5aoT2BNtCgS4KS5/2nKKfbrOc1bxh4YcC3GuuESXUZL68fsSmUyWGhkrm5DbdigFPnKWnlfi1axL6YRsedsoOOBnfLJUlkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279328; c=relaxed/simple;
	bh=fQHVz5q2NFdCDFWSgFVbGBOY4WdymHLEeTy8wlO9kj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knka5F7DuSeF5Wc6lfbbNUwYSbTz9Dkvta2fG0HgtB+krUwG8b7QXgSYlawb3BAP4raH4jGFZ7dDXnqnMSa114cHhDyuBraOiMTgyXWUfEBBPJAefAr8WsMmlqP+4KGFX9TgaOX7V5BObtXaVDvWD+ATjDts9eU904JfO00xIE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0Rj0Egj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0Rj0Egj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DB7C2BBFC;
	Thu, 13 Jun 2024 11:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279328;
	bh=fQHVz5q2NFdCDFWSgFVbGBOY4WdymHLEeTy8wlO9kj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0Rj0EgjZUwITyrP8/w4XvEieTQ47w1P9M0ecRyoo44q2ADCYlHL4fXdDUqh9BXFb
	 GjENE7zNt6nAr2LKMTGmhgosE54ROzu4ib4G85MCqSG8taGKOo/Lkijs2DNOrYirlV
	 L/3Qt/hXDy8an2tN0QcfWESmqC3IFSwcjY/KelWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.9 039/157] media: ov2740: Fix LINK_FREQ and PIXEL_RATE control value reporting
Date: Thu, 13 Jun 2024 13:32:44 +0200
Message-ID: <20240613113228.933446354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit f7aa5995910cb5e7a5419c6705f465c55973b714 upstream.

The driver dug the supported link frequency up from the V4L2 fwnode
endpoint and used it internally, but failed to report this in the
LINK_FREQ and PIXEL_RATE controls. Fix this.

Fixes: 0677a2d9b735 ("media: ov2740: Add support for 180 MHz link frequency")
Cc: stable@vger.kernel.org # for v6.8 and later
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov2740.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -768,14 +768,15 @@ static int ov2740_init_controls(struct o
 	cur_mode = ov2740->cur_mode;
 	size = ARRAY_SIZE(link_freq_menu_items);
 
-	ov2740->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr, &ov2740_ctrl_ops,
-						   V4L2_CID_LINK_FREQ,
-						   size - 1, 0,
-						   link_freq_menu_items);
+	ov2740->link_freq =
+		v4l2_ctrl_new_int_menu(ctrl_hdlr, &ov2740_ctrl_ops,
+				       V4L2_CID_LINK_FREQ, size - 1,
+				       ov2740->supported_modes->link_freq_index,
+				       link_freq_menu_items);
 	if (ov2740->link_freq)
 		ov2740->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
-	pixel_rate = to_pixel_rate(OV2740_LINK_FREQ_360MHZ_INDEX);
+	pixel_rate = to_pixel_rate(ov2740->supported_modes->link_freq_index);
 	ov2740->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &ov2740_ctrl_ops,
 					       V4L2_CID_PIXEL_RATE, 0,
 					       pixel_rate, 1, pixel_rate);


