Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7411C335083;
	Fri,  9 Jan 2026 12:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960931; cv=none; b=XULTvsGxTnfU08oZ3zbiGbiFLMZDy5bcqdX2+wTnCsbBpbMrAhF6BFpAfhUj0WmXzVkeQbBFq7XCHkjrXJfRrwhos/cPeIYrCCnqebCs/K+FPbX0Zp5z1WaJGti0UIWmS4NVDdtiVrAFmd9G8GZhU6F5VN4EjVgaUGqLua8TmpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960931; c=relaxed/simple;
	bh=C7iuL/XCQWYdjAM/y83eUQPnDtyDdTEad7pJrG4JXZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwqBLFYHmWI/Y99EMhZWsolwjStTDya+hgsCALHxZWzGpSvKndWocq6RpMhmqEXqAqcWSzJrEzfWn1C59OZ1RAW/9pRiCrk1c2xmiIBH+N7UfPSOiM45kG7mvsNTHCbsWNDg4exRxwq5cxH03ydXjCCTJaCr39yAcNgsnAN7aQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/w9SRM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/w9SRM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F270CC4CEF1;
	Fri,  9 Jan 2026 12:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960931;
	bh=C7iuL/XCQWYdjAM/y83eUQPnDtyDdTEad7pJrG4JXZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/w9SRM5xMpDfHy+hrn6l3FDQvKYFc/n/RASOuCLm7+wys+NDlQmZSRtoG8b5V5VN
	 CIBRGYnJ7m4MZPa2VfxAcsjwA/nOqKAEDlLWfhJ/V8JC5pS/crntu4mN0NVg/qoaPS
	 T47pH67MrgPECd/f2Oz7uXxkloh0qcuXn+rCv8yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 576/737] media: adv7842: Avoid possible out-of-bounds array accesses in adv7842_cp_log_status()
Date: Fri,  9 Jan 2026 12:41:55 +0100
Message-ID: <20260109112155.670433518@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Ivan Abramov <i.abramov@mt-integration.ru>

commit 8163419e3e05d71dcfa8fb49c8fdf8d76908fe51 upstream.

It's possible for cp_read() and hdmi_read() to return -EIO. Those
values are further used as indexes for accessing arrays.

Fix that by checking return values where it's needed.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a89bcd4c6c20 ("[media] adv7842: add new video decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/adv7842.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2680,6 +2680,7 @@ static int adv7842_cp_log_status(struct
 	/* CP block */
 	struct adv7842_state *state = to_state(sd);
 	struct v4l2_dv_timings timings;
+	int temp;
 	u8 reg_io_0x02 = io_read(sd, 0x02);
 	u8 reg_io_0x21 = io_read(sd, 0x21);
 	u8 reg_rep_0x77 = rep_read(sd, 0x77);
@@ -2802,8 +2803,9 @@ static int adv7842_cp_log_status(struct
 		  (((reg_io_0x02 >> 2) & 0x01) ^ (reg_io_0x02 & 0x01)) ?
 			"(16-235)" : "(0-255)",
 		  (reg_io_0x02 & 0x08) ? "enabled" : "disabled");
+	temp = cp_read(sd, 0xf4) >> 4;
 	v4l2_info(sd, "Color space conversion: %s\n",
-		  csc_coeff_sel_rb[cp_read(sd, 0xf4) >> 4]);
+		  temp < 0 ? "" : csc_coeff_sel_rb[temp]);
 
 	if (!is_digital_input(sd))
 		return 0;
@@ -2833,8 +2835,9 @@ static int adv7842_cp_log_status(struct
 			hdmi_read(sd, 0x5f));
 	v4l2_info(sd, "AV Mute: %s\n",
 			(hdmi_read(sd, 0x04) & 0x40) ? "on" : "off");
+	temp = hdmi_read(sd, 0x0b) >> 6;
 	v4l2_info(sd, "Deep color mode: %s\n",
-			deep_color_mode_txt[hdmi_read(sd, 0x0b) >> 6]);
+			temp < 0 ? "" : deep_color_mode_txt[temp]);
 
 	adv7842_log_infoframes(sd);
 


