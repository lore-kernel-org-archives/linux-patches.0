Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2182F8E82;
	Mon, 17 Aug 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977373; cv=none; b=rgY8bdmc0k402BbbC+Hzki1DAQnONxeaIgruQvh3Ti0AgfvH4kPr3sOZj3yQ0kBavAlvb8Y9il5+5pDQdLFU5loZCLjHrvgdYirv/7ORTFpfgprwm3nNOZVHeX56EPZgFY4o37CIblDGE3TR78Eii59a2j+IwHGXaAozWmrYYdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977373; c=relaxed/simple;
	bh=A4FNgke9h9wcTRNw+amiqjRyitLRDIWjOSAOGjhrlGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTHJYvsjVxOkUogO/90pTq7SA0JP4xnyj/3eNf2dohTOjxS/S2ollbgfVyN0FuI+X1fSiuWmTOaGMYKLIHS3HEhomd2qYzUvm1WEa/2FXwoVx25T//fTE6buJs3Irl5rw99a6sUzf02Ssw4eF9OhLhiqjscNMSe9cBFlQFl7hNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdAz1BbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdAz1BbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591F91F00A3A;
	Mon, 17 Aug 2026 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977368;
	bh=tWqEKXesiqIJmpwUc2Njv++5PviJnAfTd3c/gRf10pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdAz1BbUO+7z6iH5bIfbFLVlVWhyhDY4lurNjXMJcwzFtSrz9J3xTqynNyH3Ue2Q8
	 EONy6s+pPqDtFwGoHAE9j905L8UnNf8jaTNos7hyFvsdQRAZnoCuQm3Ao0EKS/gTw3
	 5VFRSi9qj4hB4Vy4ZyzNL4xJBLeCL6lIncwK3lsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haidar Lee <haidar.lee@adlinktech.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 304/456] ASoC: tas2562: fix DVC coefficient write order
Date: Mon, 17 Aug 2026 15:31:34 +0200
Message-ID: <20260817132551.684804762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haidar Lee <haidar.lee@adlinktech.com>

commit 8e957e4907c58e9ca944f98799524f2bbb9cf68a upstream.

The TAS2562 applies the 32-bit digital volume coefficient to the
playback path when the last byte, DVC_CFG4 (book 0 page 2 reg 0x0F), is
written. tas2562_volume_control_put() wrote DVC_CFG4 first and DVC_CFG1
(the MSB) last, so every volume change latched a value made of the
previous coefficient's upper three bytes combined with the new LSB; the
remaining bytes only took effect on the next volume change.

In practice the control was unusable: the first setting after power-on
always played at roughly 0 dB no matter what value was requested (the
chip's default upper bytes were still latched), and most subsequent
changes muted the output entirely or produced a distorted, over-unity
gain.

Verified on a TAS2562 (ADLINK OSM-520 / MT8189 board) by tracing the
I2C writes with ftrace and by writing the same coefficients manually in
both byte orders: written MSB-first the register block behaves exactly
as the driver expects, LSB-first reproduces the broken behaviour.

Write the bytes MSB first with DVC_CFG4 last so the complete new
coefficient is latched atomically.

Fixes: bf726b1c86f2 ("ASoC: tas2562: Add support for digital volume control")
Cc: stable@vger.kernel.org
Signed-off-by: Haidar Lee <haidar.lee@adlinktech.com>
Link: https://patch.msgid.link/20260715-tas2562-dvc-fix-v1-1-072b13901b20@adlinktech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2562.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -507,20 +507,27 @@ static int tas2562_volume_control_put(st
 	u32 reg_val;
 
 	reg_val = float_vol_db_lookup[ucontrol->value.integer.value[0]/2];
-	ret = snd_soc_component_write(component, TAS2562_DVC_CFG4,
-				      (reg_val & 0xff));
-	if (ret)
-		return ret;
-	ret = snd_soc_component_write(component, TAS2562_DVC_CFG3,
-				      ((reg_val >> 8) & 0xff));
+	/*
+	 * The device applies the 32-bit coefficient to the playback path on
+	 * the write to DVC_CFG4 (the LSB, book 0 page 2 reg 0x0F), so the
+	 * bytes must be written MSB first and DVC_CFG4 last. Writing CFG4
+	 * first latches a mix of the previous coefficient's upper bytes and
+	 * the new LSB instead of the requested value.
+	 */
+	ret = snd_soc_component_write(component, TAS2562_DVC_CFG1,
+				      ((reg_val >> 24) & 0xff));
 	if (ret)
 		return ret;
 	ret = snd_soc_component_write(component, TAS2562_DVC_CFG2,
 				      ((reg_val >> 16) & 0xff));
 	if (ret)
 		return ret;
-	ret = snd_soc_component_write(component, TAS2562_DVC_CFG1,
-				      ((reg_val >> 24) & 0xff));
+	ret = snd_soc_component_write(component, TAS2562_DVC_CFG3,
+				      ((reg_val >> 8) & 0xff));
+	if (ret)
+		return ret;
+	ret = snd_soc_component_write(component, TAS2562_DVC_CFG4,
+				      (reg_val & 0xff));
 	if (ret)
 		return ret;
 


