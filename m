Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78271632DA;
	Fri, 15 Nov 2024 06:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653096; cv=none; b=oxkpyVaXN+abnFSGnCQ5R1YOPiJA7LDhCxI4g8ABDNoE6HLdwnXc5qeciRJtIst3Wk4tLu+ETSej2lvrQf5aqy4hYjKKhNANbdm3kOfpM98x57RwqWUVrvpi2I3EHxdRiMFlN2r+CB3QkewD3ivSip4ncyey2PYtVlsZnf1ouFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653096; c=relaxed/simple;
	bh=gp1WGQqvj9kV5CiDWQhYZZZvZctt9AgDvJetiFQ5/LU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTdGlzzZMVG9BsYjqI3zclAIehMeiErEDmhjHJhhk1KKx/KVVZb2XX8CO/TlleLpegVuHyYEUYqnpn04GZR06xlPBoFl9sxjEV9KI9/JQapOI1ZN1618mgmJIC5VV9bJy3pSoOQO3v9nyf8/OZ+JD/ayckngsAg9gzX5Mc7HYHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8syyo+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8syyo+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C812C4CED0;
	Fri, 15 Nov 2024 06:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653096;
	bh=gp1WGQqvj9kV5CiDWQhYZZZvZctt9AgDvJetiFQ5/LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8syyo+182EizauAt2rtJjkKQXEXKBPfm+WKk4mlfHrITGyKtBMhfre+kPeNRsZDj
	 Klb/Z6Hc6ZGCz9AfgpDPe+6mZMtVJmH97wn6MAXkQd0WGObwLIEVgyNJVOhzCElonw
	 C0bsFdJYdgYQzTeGvNeIA8c4FbnE8QP+Cbzd/x+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/66] media: adv7604: prevent underflow condition when reporting colorspace
Date: Fri, 15 Nov 2024 07:37:28 +0100
Message-ID: <20241115063723.536493733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 50b9fa751d1aef5d262bde871c70a7f44262f0bc ]

Currently, adv76xx_log_status() reads some date using
io_read() which may return negative values. The current logic
doesn't check such errors, causing colorspace to be reported
on a wrong way at adv76xx_log_status(), as reported by Coverity.

If I/O error happens there, print a different message, instead
of reporting bogus messages to userspace.

Fixes: 54450f591c99 ("[media] adv7604: driver for the Analog Devices ADV7604 video decoder")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7604.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1cee69919e1b9..d0b2d960c7847 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2477,10 +2477,10 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 	const struct adv76xx_chip_info *info = state->info;
 	struct v4l2_dv_timings timings;
 	struct stdi_readback stdi;
-	u8 reg_io_0x02 = io_read(sd, 0x02);
+	int ret;
+	u8 reg_io_0x02;
 	u8 edid_enabled;
 	u8 cable_det;
-
 	static const char * const csc_coeff_sel_rb[16] = {
 		"bypassed", "YPbPr601 -> RGB", "reserved", "YPbPr709 -> RGB",
 		"reserved", "RGB -> YPbPr601", "reserved", "RGB -> YPbPr709",
@@ -2579,13 +2579,21 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "-----Color space-----\n");
 	v4l2_info(sd, "RGB quantization range ctrl: %s\n",
 			rgb_quantization_range_txt[state->rgb_quantization_range]);
-	v4l2_info(sd, "Input color space: %s\n",
-			input_color_space_txt[reg_io_0x02 >> 4]);
-	v4l2_info(sd, "Output color space: %s %s, alt-gamma %s\n",
-			(reg_io_0x02 & 0x02) ? "RGB" : "YCbCr",
-			(((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
-				"(16-235)" : "(0-255)",
-			(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
+
+	ret = io_read(sd, 0x02);
+	if (ret < 0) {
+		v4l2_info(sd, "Can't read Input/Output color space\n");
+	} else {
+		reg_io_0x02 = ret;
+
+		v4l2_info(sd, "Input color space: %s\n",
+				input_color_space_txt[reg_io_0x02 >> 4]);
+		v4l2_info(sd, "Output color space: %s %s, alt-gamma %s\n",
+				(reg_io_0x02 & 0x02) ? "RGB" : "YCbCr",
+				(((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
+					"(16-235)" : "(0-255)",
+				(reg_io_0x02 & 0x08) ? "enabled" : "disabled");
+	}
 	v4l2_info(sd, "Color space conversion: %s\n",
 			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
 
-- 
2.43.0



