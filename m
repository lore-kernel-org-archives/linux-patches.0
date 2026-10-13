Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C9472F73;
	Tue, 13 Oct 2026 12:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894687; cv=none; b=WoD8Q390eTOa6y6Bb6KwJRni89ZPSX7b0OWDX/0SmtL/DDUZ/AJSJ7/mLMma3IWxncVycabR6dBXVBlLeggJ7jU/ZN1h/yhB7l5kulzrxqFhUZgiUbeNqYY/KvX5nXEN1W2oDEQqZAAgrqRytnTHcMuyv5egsQkVHa6bk8ZPX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894687; c=relaxed/simple;
	bh=l9ItHCBg364XeK1530RIN/tkFx3okgldY5eVwjUwAIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvdBvHUxiWv1v5pHkGsgDmmB2OsKWQtLvxTPJBEP/8rV4twBt9VBURKelakMNbdaixokqYzImL469NDSzbkibo6Iu86/+izpPMyGi7lK8Ehr2+WOS6dxQbF5x9aUxyuj8IyHcWa9nPtO1qBGfRw8V/9mIL50APFWVs6LHSqD67k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VJkrBvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VJkrBvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD971F000FF;
	Tue, 13 Oct 2026 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894686;
	bh=cZ9Aeb3VJsrLOep92aQmoRppTL10aUdMfcbAvR+18h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VJkrBvOFtJKVa8pjalXJsAzPd1c+MxpSVqJdxn9Wc56jRWY+nfZevKdnrZ7JCcP7
	 DxRJPuBhPq03ap0vuLLxVTW1sxpS4S/0GliCLiXe7tka/3+MjB9TAUL8cLOON8DeSN
	 r3pBWARPLy7nwGqlqu1leFTUULABdCyH3q5d7f2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Faaris Ansari <faarisansari@googlemail.com>
Subject: [PATCH 6.12 022/497] ALSA: usb-audio: Apply IGNORE_CTL_ERROR quirk to all Audient devices
Date: Tue, 13 Oct 2026 13:33:09 +0200
Message-ID: <20261013112908.410064553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a154f7b9f197b3d5e41fa3ad62083f5aa93b1fe8 ]

Faaris reported a problem with Audient EVO4 device and it turned out
to be a regression by the recent fix commit 87a6f2fa6e6c ("ALSA:
usb-audio: Propagate write errors in generic mixer put callbacks").
It exhibited that the hardware gives errors at accessing the mixer
unit 10 on certain channels, and the change above made it a fatal
error.

We had already a quirk for Audient iD14 to work around such errors
from the mixer controls, and we can simply apply the same for EVO4.
OTOH, it's highly possible that other Audient devices suffer from the
same issue; they must be using similar firmware, after all.

So, in this patch, we apply the quirk generically to all devices with
the vendor ID Audient (2708), instead.  Ignoring the control error
isn't usually less critical than overreaction to the firmware
misbehavior.

Fixes: 87a6f2fa6e6c ("ALSA: usb-audio: Propagate write errors in generic mixer put callbacks")
Reported-and-tested-by: Faaris Ansari <faarisansari@googlemail.com>
Closes: https://lore.kernel.org/CANBVYRCL=8QdLxGg4S6qrahrFtwJxhv-aSGpW7-1S=+iOe4ZGA@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260929144132.1521617-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 0872432b8574b..cc8d755256f2e 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2371,8 +2371,6 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
 		   QUIRK_FLAG_DSD_RAW),
-	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
-		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2772, 0x0502, /* Musical Fidelity M6s DAC */
 		   0), /* for avoiding QUIRK_FLAG_DSD_RAW with vendor match */
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
@@ -2440,6 +2438,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2622, /* IAG Limited devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2708, /* Audient devices */
+		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	VENDOR_FLG(0x2772, /* Musical Fidelity devices */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x278b, /* Rotel? */
-- 
2.53.0



