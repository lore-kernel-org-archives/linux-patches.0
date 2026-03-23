Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E5839890A;
	Mon, 23 Mar 2026 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275159; cv=none; b=Nk6/zLh8qn5MT5LfqrSunSmK55O8jDucqkcKqpnPczMaBMxFJ771nnPCHyHaQ/awkfyedjC9AimMIDfw8nWU0RGlT/+tKHz8vijJ6OHodAl5eHoj30kPfykPGboebmXLcvnoKGZ7+UgBsafnb2F3ltdsxqarWHw6ktKkdi0p4pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275159; c=relaxed/simple;
	bh=/lHSBFgCR+IRiFbttL0IzTVfKQ4wOJHfLF+1OzlGpT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fe93oJlVdSJRmQ2usgNZwKLX0qcAAtkwCRv/mLrB3nUX6VW6gxnGa6TXapLUf3DCBcH9Qtl4LlfX+FXH/x9CRXFkyEGEWc/GWPuRzr3gfdhW1fdbVZgFp3TDoZ51SNSDe8Y85gYxrUgL1AxndUPFxR2BbE04IbyUSOlzyJJdX3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7H0fKMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7H0fKMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178E3C4CEF7;
	Mon, 23 Mar 2026 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275159;
	bh=/lHSBFgCR+IRiFbttL0IzTVfKQ4wOJHfLF+1OzlGpT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7H0fKMolqMDOaFsbs+NaDAJECgq03fMiYnzA5AI6hitWLo7EnAH5pKODIJ9g9UJ+
	 QU7O8mR6e66M8GywvrcPEg7xY5b0vqurHVQRZ9cH0HaOvT7sRFjULg8wQ9Edwh5ZKE
	 Mg1WGGUwQJp2V+UuWdwEWbf+UcIPhs8TsZHrnuEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/481] ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
Date: Mon, 23 Mar 2026 14:39:49 +0100
Message-ID: <20260323134525.435833446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit a8cc55bf81a45772cad44c83ea7bb0e98431094a ]

Remove QUIRK_FLAG_VALIDATE_RATES for Focusrite. With the previous
commit, focusrite_valid_sample_rate() produces correct rate tables
without USB probing.

QUIRK_FLAG_VALIDATE_RATES sends SET_CUR requests for each rate (~25ms
each) and leaves the device at 192kHz. This is a problem because that
rate: 1) disables the internal mixer, so outputs are silent until an
application opens the PCM and sets a lower rate, and 2) the Air and
Safe modes get disabled.

Fixes: 5963e5262180 ("ALSA: usb-audio: Enable rate validation for Scarlett devices")
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/09b9c012024c998c4ca14bd876ef0dce0d0b6101.1771594828.git.g@b4.vu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 755ba2fe05b5a..f9e998fad773c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2298,7 +2298,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-		   QUIRK_FLAG_VALIDATE_RATES),
+		   0),
 	VENDOR_FLG(0x1511, /* AURALiC */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x152a, /* Thesycon devices */
-- 
2.51.0



