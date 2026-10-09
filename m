Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6603515D4;
	Fri,  9 Oct 2026 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555487; cv=none; b=ZY2SbJYKbhuJ8rPNK/5smCWOnQTnF4J9A3Xlb4PZ0p+lwA0aiofOvz/aGQDpqEkj7Ifxgu3OrspOcmo2GVPGSnyxYisj7eYmCpp6xHw375XIh8JeX1pttjbSQU/j8Mz0LPRcwam5qx5LdhjW+YFsrTCqjbRHTuJ8M7XQ549Yckw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555487; c=relaxed/simple;
	bh=X2is7sZKdI0dse++C4H0g919KAy2CICTlZJc8rUsSzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbuJAZZiFaGWD/wI+RrQDjW2LraxeDg5I8nuTcp6MTHq6FuFLhKZqyGSL3ZBOKSGxw4kDJ+B/zLOvJSoDMfrUiESFmu6nzapGWLC6A9+80CWHLHfLWsdI9J+qZzseAxD7S8WPlIu25OLEnjrRThZE2fXojeDiZ05QFZ0xHd2a74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIBPcxAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIBPcxAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A16F1F00893;
	Fri,  9 Oct 2026 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555479;
	bh=A4xZSjikqb4KWalklAeMy8HylNwzBjN2MrWxpB3L9nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIBPcxAYJr3ISwmNIruQpmiuVCXodvIZwc1HTDB630GPMiwp0IGbe4hI/NnyS2nts
	 MVXLhC5sr25GFo5NHuY8G09K2x05j6oqAPR2C3ygv1PCZYrgg4kFluC0iDXKumockr
	 uXEU69aAHiIlG9n5zHaJUEWMVpuj6mtmlBgg+76o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/403] ASoC: wm8903: Move the DRC QR threshold to the register that holds it
Date: Fri,  9 Oct 2026 16:07:06 +0200
Message-ID: <20261009140953.617073789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit e31ae4aeb049983fe3be0cf1e12c8074811a7685 ]

The DRC_THRESH_QR field is bits 7 and 6 of DRC_1, but the control sits on
DRC_0. Its shift and max are right for the field, only the register is
wrong.

Those bits of DRC_0 belong to DRC_STARTUP_GAIN, which "DRC Startup
Volume" claims as bits 10 to 6. So the two controls share bits 7 and 6.
Writing either one moves the other, and the quick release threshold is
never reached at all.

The six fields of DRC_1 tile it exactly, so there is nowhere else the
threshold could live. Point the control at DRC_1.

Found by a sweep for two controls claiming the same bits of one
register. No board with this codec was to hand, the register map is
the driver's own wm8903.h.

Fixes: f1c0a02f32f8 ("ALSA: ASoC: Add WM8903 CODEC driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260920135327.3628704-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8903.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index f7d726e3052c1..e9858aaf6ca8e 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -677,7 +677,7 @@ SOC_ENUM("DRC Decay Rate", drc_decay),
 SOC_ENUM("DRC FF Delay", drc_ff_delay),
 SOC_SINGLE("DRC Anticlip Switch", WM8903_DRC_0, 1, 1, 0),
 SOC_SINGLE("DRC QR Switch", WM8903_DRC_0, 2, 1, 0),
-SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_0, 6, 3, 0, drc_tlv_max),
+SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_1, 6, 3, 0, drc_tlv_max),
 SOC_ENUM("DRC QR Decay Rate", drc_qr_decay),
 SOC_SINGLE("DRC Smoothing Switch", WM8903_DRC_0, 3, 1, 0),
 SOC_SINGLE("DRC Smoothing Hysteresis Switch", WM8903_DRC_0, 0, 1, 0),
-- 
2.53.0



