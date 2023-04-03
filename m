Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6EF5683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EC4C433D2;
	Mon,  3 Apr 2023 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531252;
	bh=KrCemDSviaurH5X2KKAMxXgAU295oNfxhX0URfX7UKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMD6SXBi2XEr2eIoiTb+NR9PO2vxvUKYnsMltbBkytS3R0HxZTOLlMHxb4Gn8uv1n
	 oIhiGHIMlsyb8RlpaTQXSOZ0KT3OlbOB0K55eUM+GX0OJOvjfL0HTs16P0C6YssfUM
	 j2NrjNe2HkJd1XJJ3cY7GveskAWXuOP094neZUlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 60/66] ALSA: usb-audio: Fix regression on detection of Roland VS-100
Date: Mon,  3 Apr 2023 16:09:08 +0200
Message-Id: <20230403140353.879569084@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit fa4e7a6fa12b1132340785e14bd439cbe95b7a5a upstream.

It's been reported that the recent kernel can't probe the PCM devices
on Roland VS-100 properly, and it turned out to be a regression by the
recent addition of the bit shift range check for the format bits.
In the old code, we just did bit-shift and it resulted in zero, which
is then corrected to the standard PCM format, while the new code
explicitly returns an error in such a case.

For addressing the regression, relax the check and fallback to the
standard PCM type (with the info output).

Fixes: 43d5ca88dfcd ("ALSA: usb-audio: Fix potential out-of-bounds shift")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217084
Link: https://lore.kernel.org/r/20230324075005.19403-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/format.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -52,8 +52,12 @@ static u64 parse_audio_format_i_type(str
 	case UAC_VERSION_1:
 	default: {
 		struct uac_format_type_i_discrete_descriptor *fmt = _fmt;
-		if (format >= 64)
-			return 0; /* invalid format */
+		if (format >= 64) {
+			usb_audio_info(chip,
+				       "%u:%d: invalid format type %#x is detected, processed as PCM\n",
+				       fp->iface, fp->altsetting, format);
+			format = UAC_FORMAT_TYPE_I_PCM;
+		}
 		sample_width = fmt->bBitResolution;
 		sample_bytes = fmt->bSubframeSize;
 		format = 1 << format;


