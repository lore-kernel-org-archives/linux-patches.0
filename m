Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF293AA9F3;
	Sat, 17 Oct 2026 16:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256347; cv=none; b=e/H7YVsKH6LyQaYSV1mnpfdIKtNQmHRsMhat3Os182gu/av/5hIjTHz16adH3N1iesRX5MqMhTPvpWNiPcP+/umrCnlA1sunvb8l2MeEI/zku8mHxWoIHz6GcCCcr40Ytp2KJWvUGLFO/Mp9Ki2kEJbjyE89OWkF+qXgfrKJcqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256347; c=relaxed/simple;
	bh=/Fuhz82XyvBoe+LGRBdg3LusWKqVcoc+4nzIVx0rR+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArhLqERW5qDmKu77YSfGughKLQvsaOqNoW3SFmSNDlm87iMZuFVbm3FdzEr95z05lCulX4xVKw6s5BibuxExrO5X8Q0t3198oR2IUwXdKk0xcRksHnncN0M19Fx17KaMmCfHwGtEqJT1IOBHjNHnnL776ZSo6Z8XXhnCSPsyanY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATqaiS1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATqaiS1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9952A1F000C4;
	Sat, 17 Oct 2026 16:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256346;
	bh=F2iQXTtCR00y5O0KcEv3hfWLBnHekCy2D823od1Y1dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATqaiS1yaG/QmRgURipgcNH/nPBx65TAHm1dDFIVtNNkgXJVW9HksKsmpljN1sZ8a
	 8myp9+VzYGNMGEIyxQgZu1TCYzAqhfcrkK7+XcRJCOTJW8T1YsdGPTDS3RB/drbu9g
	 uExF0KzQ0gJMIcfDX7KJFzBsObCTlHYhMSJteHg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Faaris Ansari <faarisansari@googlemail.com>
Subject: [PATCH 6.6 0164/1674] ALSA: usb-audio: Apply IGNORE_CTL_ERROR quirk to all Audient devices
Date: Sat, 17 Oct 2026 17:40:36 +0200
Message-ID: <20261017160435.372911077@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index edfdf1625a671..598ca38be9676 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2271,8 +2271,6 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x262a, 0x9302, /* ddHiFi TC44C */
 		   QUIRK_FLAG_DSD_RAW),
-	DEVICE_FLG(0x2708, 0x0002, /* Audient iD14 */
-		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2772, 0x0502, /* Musical Fidelity M6s DAC */
 		   0), /* for avoiding QUIRK_FLAG_DSD_RAW with vendor match */
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
@@ -2340,6 +2338,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



