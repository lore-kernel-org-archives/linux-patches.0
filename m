Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8A835206F;
	Tue, 26 Aug 2025 14:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219357; cv=none; b=mYuuNbpD1knXz1fVkKysakV3zs7xlyAFOGcTcgcXIWyvI7W1zL+FPitIPb4zl0qgjLc6SWBs7YZRde15MfjQ6c+vDOVhnFUUS7sBTVpssLCcjAfYBVBOuBB8V290M8GVMuHkJV8OpkqOTxM/+VATPMYA7YeSlRpblvNCAxnRJeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219357; c=relaxed/simple;
	bh=fvHOm1T5WuVoJ8QC02yqFzZlctIuTzFUi4E80qgHJTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nR1vVCPYsieA4mNj+5oMiGhfqVau4iXC3x0odMOagIoKUhaf8bSuVk8/vdlQ+yT9vg0e6CR8V+lq5p/jcj9Kl4uZ/exxxXcGT1aVnD0PN5gZVJuxNadguz1SxsCD6hO2GsYyrKIXtcUU1Gt4CLYrU4Md8OLSzpJPz/WjfY5VAUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z++FVuaU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z++FVuaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8265FC4CEF1;
	Tue, 26 Aug 2025 14:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219356;
	bh=fvHOm1T5WuVoJ8QC02yqFzZlctIuTzFUi4E80qgHJTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z++FVuaUlca06o2TUQtZdBLPV37DIwucyuois3J1jnqCnI4k3ccSUxuaSpjw0dvvR
	 n7bf2s7X0JigLpFSfWuQJpLJW96acSlI7BKbc7zx21Ntl6ELO1P91XNnDdGxiMvyvh
	 EgjZdyeYMdgwBFsgPJSslzJC/wn3qJhFzNE1el/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 349/403] ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()
Date: Tue, 26 Aug 2025 13:11:15 +0200
Message-ID: <20250826110916.517725604@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[ Applied retry logic around snd_usb_ctl_msg() instead of scarlett2_usb_tx() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett_gen2.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -118,6 +118,8 @@
 #define SCARLETT2_MIXER_MAX_VALUE \
 	((SCARLETT2_MIXER_MAX_DB - SCARLETT2_MIXER_MIN_DB) * 2)
 
+#include <linux/delay.h>
+
 /* map from (dB + 80) * 2 to mixer value
  * for dB in 0 .. 172: int(8192 * pow(10, ((dB - 160) / 2 / 20)))
  */
@@ -591,6 +593,8 @@ static int scarlett2_usb(
 	u16 req_buf_size = sizeof(struct scarlett2_usb_packet) + req_size;
 	u16 resp_buf_size = sizeof(struct scarlett2_usb_packet) + resp_size;
 	struct scarlett2_usb_packet *req = NULL, *resp = NULL;
+	int retries = 0;
+	const int max_retries = 5;
 	int err = 0;
 
 	req = kmalloc(req_buf_size, GFP_KERNEL);
@@ -614,6 +618,7 @@ static int scarlett2_usb(
 	if (req_size)
 		memcpy(req->data, req_data, req_size);
 
+retry:
 	err = snd_usb_ctl_msg(mixer->chip->dev,
 			usb_sndctrlpipe(mixer->chip->dev, 0),
 			SCARLETT2_USB_VENDOR_SPECIFIC_CMD_REQ,
@@ -624,6 +629,10 @@ static int scarlett2_usb(
 			req_buf_size);
 
 	if (err != req_buf_size) {
+		if (err == -EPROTO && ++retries <= max_retries) {
+			msleep(5 * (1 << (retries - 1)));
+			goto retry;
+		}
 		usb_audio_err(
 			mixer->chip,
 			"Scarlett Gen 2 USB request result cmd %x was %d\n",


