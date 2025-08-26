Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A75E306D3F;
	Tue, 26 Aug 2025 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218196; cv=none; b=bBX4NqXkqygItdZKURmO61/bewa7uttMI6TiOKhOihnKGe/F+dAj+m4YN18vLa3Q3AeUTORPnxcTtleRfRUtr8S7dvSb+Xw6Y9mLl2nfrGhFuQAacgsFZH24Kjb4RN/R1GL8fcDRuVG/XeRnfkruS+9jA7XWZp8I4lVylouhaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218196; c=relaxed/simple;
	bh=R/pweSUh+99glOD47I5Y1pP55Y8dXmkAENo2uKTjeqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJIvk6iidUWPfJ5xi4mb+blTO2JVoX4y6JmbaVWonieNAHWOjQkWWsH3iKk/PtNY+gJxt2dGCEuPuj7A32GQAFri84QbNAYeThuciRokFsyBA42l8YlbI8cQ0q0Tx5egvcns8ge9ZsLXDixl32nHg2l2/O7PsEE1dgb2B35SLzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Am4Sc5mR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Am4Sc5mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20C9C4CEF1;
	Tue, 26 Aug 2025 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218196;
	bh=R/pweSUh+99glOD47I5Y1pP55Y8dXmkAENo2uKTjeqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Am4Sc5mR4og9IckbmZj5wK25nX6JtXeCiigErQ1PqUD3OWnFThHZVdShV+79TmtQu
	 h2hST8OxZgRaHxgegkv+mhnkHGZNLvz/2h+lnBTyccES7df3PkRmugxKCA1wZfKRHn
	 Dq54eCSACGGIO56/XRxYU5kOlX7hd48B9pLHO+IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/523] ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()
Date: Tue, 26 Aug 2025 13:10:39 +0200
Message-ID: <20250826110935.036748900@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit 8a15ca0ca51399b652b1bbb23b590b220cf03d62 ]

During communication with Focusrite Scarlett Gen 2/3/4 USB audio
interfaces, -EPROTO is sometimes returned from scarlett2_usb_tx(),
snd_usb_ctl_msg() which can cause initialisation and control
operations to fail intermittently.

This patch adds up to 5 retries in scarlett2_usb(), with a delay
starting at 5ms and doubling each time. This follows the same approach
as the fix for usb_set_interface() in endpoint.c (commit f406005e162b
("ALSA: usb-audio: Add retry on -EPROTO from usb_set_interface()")),
which resolved similar -EPROTO issues during device initialisation,
and is the same approach as in fcp.c:fcp_usb().

Fixes: 9e4d5c1be21f ("ALSA: usb-audio: Scarlett Gen 2 mixer interface")
Closes: https://github.com/geoffreybennett/linux-fcp/issues/41
Cc: stable@vger.kernel.org
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://patch.msgid.link/aIdDO6ld50WQwNim@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ Applied retry logic directly in scarlett2_usb() instead of scarlett2_usb_tx() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett_gen2.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -95,6 +95,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/moduleparam.h>
+#include <linux/delay.h>
 
 #include <sound/control.h>
 #include <sound/tlv.h>
@@ -591,6 +592,8 @@ static int scarlett2_usb(
 	u16 req_buf_size = sizeof(struct scarlett2_usb_packet) + req_size;
 	u16 resp_buf_size = sizeof(struct scarlett2_usb_packet) + resp_size;
 	struct scarlett2_usb_packet *req = NULL, *resp = NULL;
+	int retries = 0;
+	const int max_retries = 5;
 	int err = 0;
 
 	req = kmalloc(req_buf_size, GFP_KERNEL);
@@ -614,6 +617,7 @@ static int scarlett2_usb(
 	if (req_size)
 		memcpy(req->data, req_data, req_size);
 
+retry:
 	err = snd_usb_ctl_msg(mixer->chip->dev,
 			usb_sndctrlpipe(mixer->chip->dev, 0),
 			SCARLETT2_USB_VENDOR_SPECIFIC_CMD_REQ,
@@ -624,6 +628,10 @@ static int scarlett2_usb(
 			req_buf_size);
 
 	if (err != req_buf_size) {
+		if (err == -EPROTO && ++retries <= max_retries) {
+			msleep(5 * (1 << (retries - 1)));
+			goto retry;
+		}
 		usb_audio_err(
 			mixer->chip,
 			"Scarlett Gen 2 USB request result cmd %x was %d\n",


