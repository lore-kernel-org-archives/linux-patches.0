Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A472E7379;
	Sat, 30 May 2026 17:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162742; cv=none; b=iaL/Xq50lP7auW0tp29+LJnbRENF7q2RV6rJO3Ehh6tXTfzp6O+wbwcCkK1uDxAoubIKHUEsKltPGSyNO9zvZWZe/UGCdm1O3joFtPN0EaKzc1I/PAbfHrH8OH7LQjqmDoNtDvC2yOWK27wtwqfFgtRw6F7aUdWifDBRy3gX2sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162742; c=relaxed/simple;
	bh=Xt6sAOOaLuZ8ZrgSj+NrkSiuHmZoeNq1VfHysivBI/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d75o9pEI6CMyJH+th+voCQVuvySO4T5CGy98XNisC2bTCWcNiUasfhOJCdqRIwsSOfpCzggBthOVP2JCTbdcQObJk9fjfMlW9CmaMvB9wrLVcqq1T8wizgTT44Q4Uc7Ia1OxF6KscE2ah551tmPT0y6Q3NMt7AZD+AX/3CgO808=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+XFwX6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+XFwX6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567711F00893;
	Sat, 30 May 2026 17:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162741;
	bh=0ejUvhdXONWbhaT2EGrxIl0VFdpDZtUPU4CEFIvRacQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+XFwX6h+DBJVkj9PrjvtDoXQNWoJxO3V+9Icu4c8ejSQMWC9Kbweyb7+d7F5uhBI
	 4jMA9cm5ol4HJkFqUaYr+dNJZCguncmS08VLR6/YXRRktCZpGz+3wPGThUROykwc7B
	 66VdsE1zNEPQgzfmjvXWdEpSnY9hUZvr/nXisD2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/776] ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
Date: Sat, 30 May 2026 17:56:04 +0200
Message-ID: <20260530160241.603200446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
index acfad87636277..e1c6a38303dfd 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1982,7 +1982,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	VENDOR_FLG(0x07fd, /* MOTU */
 		   QUIRK_FLAG_VALIDATE_RATES),
 	VENDOR_FLG(0x1235, /* Focusrite Novation */
-		   QUIRK_FLAG_VALIDATE_RATES),
+		   0),
 	VENDOR_FLG(0x1511, /* AURALiC */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x152a, /* Thesycon devices */
-- 
2.53.0



