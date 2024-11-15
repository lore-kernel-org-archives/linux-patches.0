Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EC51891AA;
	Fri, 15 Nov 2024 06:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653775; cv=none; b=TVPU5yGxbFjR7/cNaK16LuipuGWlfWAt1AH3lNzmQXkKikpTLj+Vn1m5bp95vtjLdHaa8iN6jVNgd76DU0bXc+XesN3oZUDvOBlCKrffEGwwYzsMOCw+Yo/NLqFBhWdwoA1CVudFwClEZeLF/3t4N6/0iX2iYAaRCh9caqna2L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653775; c=relaxed/simple;
	bh=weUPVKWDspL/5pYfc/hnPzn9q0sTNn1iruj9Hlny6hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thtRII8WVYBGRG8x/fBGoAoqyUNCte4QAx8ExbFKdhl9Diqd1+fY5/ssdl2dw5wwZKYykFEw2gHKFd1tN4SJSy1cAA4mgDcY/9a9qAk38rT+dwPWrGdzoubPs8GC2SX1jdPnXtx8PDe0XtDtAv66tHa1n3Tq3vShg2ATfRBjHW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZn4XkE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZn4XkE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF74C4CED0;
	Fri, 15 Nov 2024 06:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653775;
	bh=weUPVKWDspL/5pYfc/hnPzn9q0sTNn1iruj9Hlny6hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZn4XkE5XGb5pXgOfVYsGHimVq9+j+r2UsstJL0jiY5b1bUlnNgp1jX+LLqOJZm5J
	 BLXK9iK/xQ5h0asVZjV41GLE7zsAwSQMdnafNEcJQluU9Z4sXMUaQVqLtwVHnn0pQ/
	 TxNIb/ZhPfcvtzlpsfarXI26mWXIFquaszwi+AMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/82] media: adv7604: prevent underflow condition when reporting colorspace
Date: Fri, 15 Nov 2024 07:38:02 +0100
Message-ID: <20241115063726.470605468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8cf1704308bf5..32c223b333486 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2487,10 +2487,10 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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
@@ -2589,13 +2589,21 @@ static int adv76xx_log_status(struct v4l2_subdev *sd)
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



