Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA4E214411;
	Tue, 12 Nov 2024 10:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408233; cv=none; b=tEp0kx3bqewBCGJHLHd8psT1HfEhWyf6pwbB/7T3OiYU6MERZuCC8OjvGdFwIU9f+6PCpU0etfFoopDHbAKfb8KH/3A6QggEqQ8IXrJUnHyEZpgr+zeOEweKvl9cps5FCwsQ7NCD+mzIbswKQnUWz/1caQUjKR1iPGsDh041v9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408233; c=relaxed/simple;
	bh=xFNGGNMhfzZ6ujQhgxsaCtg++mlQEvsebSxKQyfFYag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYq8aIfcJdxdGvP76Srh4MNzYWTWlcp1r3rFvkfiGQqIuLMNmCOyZa2OjZ6UFUyhjFkrhJ0sx4BRzDQjrJKwgqeey118gUHit9td4i+vGcVvgUWPmI8CyVEMTTkwWYH2VVciNtcTnl338x0mdbDUhV8iv4B2aEAycJ6WexfKeTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu2cfs96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu2cfs96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFBFC4CECD;
	Tue, 12 Nov 2024 10:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408233;
	bh=xFNGGNMhfzZ6ujQhgxsaCtg++mlQEvsebSxKQyfFYag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu2cfs967IakWdycPu62kfspK1Mj9U8dWO4MiMWqFGgsg3puoVmgDRHiBk1lLS5J6
	 dlyzE4SE+G1CWPj80NVCpJpM8g3lwv/xIGKI8Go39FVDOuP4BEzv6sPrN2mhltJmWd
	 SVvRLQrHnI9zBkJhqVg35y+OpE8Xc5mC9IPi247w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 068/184] media: adv7604: prevent underflow condition when reporting colorspace
Date: Tue, 12 Nov 2024 11:20:26 +0100
Message-ID: <20241112101903.476309857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 48230d5109f05..272945a878b3c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2519,10 +2519,10 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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
@@ -2621,13 +2621,21 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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



