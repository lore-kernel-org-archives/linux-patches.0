Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07D04E5321;
	Fri,  9 Oct 2026 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556206; cv=none; b=FgPTGS0ICi4TjhQnou0rIFfUb94RlQ9lrrexccblkvsPKcBaTVWggzAKe5MGbKM14ra/wdEhzPJBohkGd1m1sUD9tR0nD7xc1sjMzdUSGJPmvKiMxYFiQmuswMB6ng+JGyNKKerULanh//Zd41Y0J7RhuIIIO/wRF3y8rz6E+Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556206; c=relaxed/simple;
	bh=E8sd1MtzpKLIu5u53cneEWyHWGrg341ucbLw/JRzzF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipHzFfIrftMZa0+/mG72dYgYYxWX4F9owJij57WkOC3dkaHmCxgUxKspWapqesmce7GSsR3iVkUp4T1PYUdCcOGQuuRxWvhRWJ7aQYsl5WANOyKzH3rx4bZrZaYKXCwPgJIlBM3qg/8gGGzeL1yKuhOGBdC2dCGu6PFB+uhN+d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHySJHzM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHySJHzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB27E1F000FF;
	Fri,  9 Oct 2026 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556204;
	bh=DAUn861YObhG08GazPkS52ZClk8tdftTv+iivxlsOgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHySJHzMXTEOCgOwbZdkv7h5a4WMzjO1MAUQoRFN8lJdCL8vEJlt2JNooeAyEKghs
	 ZbcffqFH7T8SyxDcGvgeJqr6o2uAWeTJwRWDT9euWK/aJRbD9Iz9jsjNU2DJNyOxEy
	 YGFuE1feN8K0y8Yh4efzNNNhz1Egg1LlqhjTQGE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Lentfer <jan.lentfer@web.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 137/428] ALSA: usb-audio: Apply boot quirk for Behringer models generically
Date: Fri,  9 Oct 2026 16:07:54 +0200
Message-ID: <20261009140949.188520013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b5c4823cf3e49b3419a3bc8c6715101e1ac6cc59 ]

Jan reported that a few Behringer devices became broken since the
recent optimization to avoid usb_string() call at probe time at the
commit b364a0d23cae ("ALSA: usb-audio: Use strings in struct usb_dev
for manufacturer & co").  Interestingly, the devices seem requiring
the explicit descriptor read at probing time, and the optimization
above dropped it.

There is already a boot quirk for another model, Behringer CM1A
(1397:1234), that adds a device descriptor read, and this seems
working for them, too.  As the quirk is safe and cheap, just apply the
same boot quirk to all Behringer devices for avoiding the pitfall
again.

Fixes: b364a0d23cae ("ALSA: usb-audio: Use strings in struct usb_dev for manufacturer & co")
Reported-by: Jan Lentfer <jan.lentfer@web.de>
Closes: https://lore.kernel.org/e7087d42-5e74-4d85-b1c5-b11eff235d41@web.de
Link: https://patch.msgid.link/20260929122938.1471867-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 034bc4bbe7f4c..9ab79172fd4ae 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1702,10 +1702,12 @@ int snd_usb_apply_boot_quirk_once(struct usb_device *dev,
 	switch (id) {
 	case USB_ID(0x07fd, 0x0008): /* MOTU M Series, 1st hardware version */
 		return snd_usb_motu_m_series_boot_quirk(dev);
-	case USB_ID(0x1397, 0x1234): /* Behringer CM1A */
-		return snd_usb_cm1a_boot_quirk(dev);
 	}
 
+	/* Behringer devices may need explicit device descriptor read at boot */
+	if (USB_ID_VENDOR(id) == 0x1397)
+		return snd_usb_cm1a_boot_quirk(dev);
+
 	return 0;
 }
 
-- 
2.53.0



