Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553BC3AEF29;
	Thu, 12 Mar 2026 20:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346304; cv=none; b=rKnD6/w/2UQtpdEMgNvjgJgYtkW1FMkQgCpl7nCIbxn+Scz/JnljwBRR2MhyL2uDL770uJnJJqUYg2yr5UJ4Rd4XuBpAvsVQ69HzbIfjo4NQG0jE6T7iQsnaAyT6kanWua8ifjJelVouA6Uacvzj3KtpFNJxg0EaXbLZC1pcMWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346304; c=relaxed/simple;
	bh=Gli7I3JwkAhVCSGZgI78g4Ff+UYROuVLej+Jvn/w/Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEDj+MuR4IrrdcLyVaXWCn4otX57CBz7zBUWKlz5GkIR/xhd8LXOh5xhYVemNzgxoL3rUDY1rWGpIiRHi6ZnSkSCwLxj6HzMKFRJ2qKuGAyvFwGwhgLx0LGgzNWp17wCX0tD7tj+nfHQpcVU8yyWMVFGVqePDgK8omYOXYiXzlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07OX4mlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07OX4mlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ABCC4CEF7;
	Thu, 12 Mar 2026 20:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346303;
	bh=Gli7I3JwkAhVCSGZgI78g4Ff+UYROuVLej+Jvn/w/Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07OX4mlmIPwWLDJh60TZ3y2fllYJF+W00b8NEVSAJqyeZFaL8We/VIc60YnGr1Hfz
	 o43KyIZ+geElMeklFUUcIDzwmhD2d0Nahx6t895KflTKg6QXmkUbquhh1NWd/j79WL
	 8Kc+xsXESi7xY7TrrzswtI5lni4oYGHC7KM+UC9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/265] ALSA: usb-audio: Remove VALIDATE_RATES quirk for Focusrite devices
Date: Thu, 12 Mar 2026 21:06:38 +0100
Message-ID: <20260312201018.566900903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 947467112409a..41752b8197463 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2408,7 +2408,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



