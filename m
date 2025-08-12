Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3D129BDB7;
	Tue, 12 Aug 2025 19:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026848; cv=none; b=lsPTaUrFpO5rCYAM4x5yEQR5hfInB9kz3bNn83Qa03vBvohykpo24MtrVSmUqFILDHjiQ0Qh27vAhHej8XVrGTaq2IHP2p8o5CjbayxeNz5VyWpphKo4KfxdBQU2Gap7zn9BmLuNO2UWAOTXhBIo28aFkLlJQWI9TyGWzTXTZh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026848; c=relaxed/simple;
	bh=cpn2pB3dCUr97nA9rkHH1O9xf3Dam71ZTb/ml/oioRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6XfUxGf5pbnG17E9nx/rLfF0+OXBVYxBi0dTQKMTZN2x0JVYD39XmDzMLBdeiZbExJOQY2A8fGC1mj0k9daMY2rCQoOqCdA/IShjZnriLPdisRd5gkd1ph8pDmECHSw7iurAvvUvQ2UTJw5Mh09CWy/r+3PLQm/HNuXx19RLD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtsDBwlI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtsDBwlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25906C4CEF1;
	Tue, 12 Aug 2025 19:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026847;
	bh=cpn2pB3dCUr97nA9rkHH1O9xf3Dam71ZTb/ml/oioRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtsDBwlIYbahnMg/YUVTxaaYNj1m6ThjJDCO1JzMsA95El+n7t9cl3zHneebWeKb1
	 gVZU/ti19s3yUKYjZkTB4gwca1Os5OoXRBgNa6FhQqgjRoAtrKxe89edB6wgjrBlLx
	 q7kFl7EMh8NLnSaanvW1V884V3sDUugJti3ymQVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 458/480] ALSA: scarlett2: Add retry on -EPROTO from scarlett2_usb_tx()
Date: Tue, 12 Aug 2025 19:51:06 +0200
Message-ID: <20250812174416.284402577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

commit 8a15ca0ca51399b652b1bbb23b590b220cf03d62 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett2.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -2351,6 +2351,8 @@ static int scarlett2_usb(
 	struct scarlett2_usb_packet *req, *resp = NULL;
 	size_t req_buf_size = struct_size(req, data, req_size);
 	size_t resp_buf_size = struct_size(resp, data, resp_size);
+	int retries = 0;
+	const int max_retries = 5;
 	int err;
 
 	req = kmalloc(req_buf_size, GFP_KERNEL);
@@ -2374,10 +2376,15 @@ static int scarlett2_usb(
 	if (req_size)
 		memcpy(req->data, req_data, req_size);
 
+retry:
 	err = scarlett2_usb_tx(dev, private->bInterfaceNumber,
 			       req, req_buf_size);
 
 	if (err != req_buf_size) {
+		if (err == -EPROTO && ++retries <= max_retries) {
+			msleep(5 * (1 << (retries - 1)));
+			goto retry;
+		}
 		usb_audio_err(
 			mixer->chip,
 			"%s USB request result cmd %x was %d\n",


