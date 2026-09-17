Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961844F96CD;
	Thu, 17 Sep 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664797; cv=none; b=RqWGXWiktGWaOwHxxKLvRuGd+DhdaVyki202JbXBymktjQxfG2osWD0+fVJzurVZsHXcUPyoAWJrcY+LgQBjF1YUZX/nJYFQaigw1GwDqd+pUvJYDi4AtoRRb246J8yqan1/4vqJ9WP8r7Seeakr4I4f68hRzfe6vwGFjZJ2Lvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664797; c=relaxed/simple;
	bh=udLHDHaQ3Ww8wFJB1+91OzpMLZAB1nDO27TCUsHxxKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0yb5L2DC90e2F6zKNihRxxcUliBW7OIChS+3Dxa586lDBvUlCHe7zXm+//kpkfuanF9pJhdv53U8HyfrxrVXZDskCOEh4NyuJjuvn4W5JbVBm1rOa7PNC2Tr1DjEcKkHJSp6Ww09UGueQPmD+AzmFNKRv71ZJmOgv4AMUSBTgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+Smwy6g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+Smwy6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C651F000FF;
	Thu, 17 Sep 2026 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664796;
	bh=YHDmlZjREvw1nUsOW5AIOcjJ/2o7dfHNzmdo3s0o1as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+Smwy6gO/qj8WqBkfzSQXbKG+GQDiw71l8iaIuqpzmJYYsTOoCigyWZ96aHmPqXa
	 vwddxMwtdTCl493mK1LcfTSqUrG3xOQT4bzLdtgO7scS4S+h8nwjB4Cy2MFQMFqbLe
	 aSJh1IXvFGf6oyIJE3qTzdolxj0H14sAGmUI23Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0491/1250] ALSA: usb-audio: caiaq: validate EP1 reply lengths
Date: Thu, 17 Sep 2026 16:04:46 +0100
Message-ID: <20260917151605.274412000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit aba30af07d4fe499b50209801eba9da8a815522f ]

usb_ep1_command_reply_dispatch() uses buf[0] as a command byte and then
reads command-specific fixed items from the same URB buffer. Several
paths use buf + 1, buf[1], buf[2], or buf + 3 without first proving that
urb->actual_length contains those bytes.

Add per-command length checks, use a payload length derived from the
bytes after the command byte for the control-state copy, and reject short
analog input payloads before the input helper reads fixed offsets from
the EP1 reply.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705084601.56400-1-pengpeng@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 17 ++++++++++++++---
 sound/usb/caiaq/input.c  |  6 ++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index b20aae0caf60a..a16e592484803 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -134,14 +134,22 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 	struct device *dev = &urb->dev->dev;
 	struct snd_usb_caiaqdev *cdev = urb->context;
 	unsigned char *buf = urb->transfer_buffer;
+	unsigned int payload_len;
+	unsigned int copy_len;
 
 	if (urb->status || !cdev) {
 		dev_warn(dev, "received EP1 urb->status = %i\n", urb->status);
 		return;
 	}
+	if (urb->actual_length < 1)
+		return;
+
+	payload_len = urb->actual_length - 1;
 
 	switch(buf[0]) {
 	case EP1_CMD_GET_DEVICE_INFO:
+		if (payload_len < sizeof(struct caiaq_device_spec))
+			break;
 	 	memcpy(&cdev->spec, buf+1, sizeof(struct caiaq_device_spec));
 		cdev->spec.fw_version = le16_to_cpu(cdev->spec.fw_version);
 		dev_dbg(dev, "device spec (firmware %d): audio: %d in, %d out, "
@@ -157,18 +165,21 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		wake_up(&cdev->ep1_wait_queue);
 		break;
 	case EP1_CMD_AUDIO_PARAMS:
+		if (payload_len < 1)
+			break;
 		cdev->audio_parm_answer = buf[1];
 		wake_up(&cdev->ep1_wait_queue);
 		break;
 	case EP1_CMD_MIDI_READ:
+		if (urb->actual_length < 3 || urb->actual_length - 3 < buf[2])
+			break;
 		snd_usb_caiaq_midi_handle_input(cdev, buf[1], buf + 3, buf[2]);
 		break;
 	case EP1_CMD_READ_IO:
 		if (cdev->chip.usb_id ==
 			USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_AUDIO8DJ)) {
-			if (urb->actual_length > sizeof(cdev->control_state))
-				urb->actual_length = sizeof(cdev->control_state);
-			memcpy(cdev->control_state, buf + 1, urb->actual_length);
+			copy_len = min_t(unsigned int, payload_len, sizeof(cdev->control_state));
+			memcpy(cdev->control_state, buf + 1, copy_len);
 			wake_up(&cdev->ep1_wait_queue);
 			break;
 		}
diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 2db4d1332df1c..c12eeb9710002 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -203,6 +203,8 @@ static void snd_caiaq_input_read_analog(struct snd_usb_caiaqdev *cdev,
 
 	switch (cdev->chip.usb_id) {
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_RIGKONTROL2):
+		if (len < 6)
+			return;
 		snd_caiaq_input_report_abs(cdev, ABS_X, buf, 2);
 		snd_caiaq_input_report_abs(cdev, ABS_Y, buf, 0);
 		snd_caiaq_input_report_abs(cdev, ABS_Z, buf, 1);
@@ -210,11 +212,15 @@ static void snd_caiaq_input_read_analog(struct snd_usb_caiaqdev *cdev,
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_RIGKONTROL3):
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_KORECONTROLLER):
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_KORECONTROLLER2):
+		if (len < 6)
+			return;
 		snd_caiaq_input_report_abs(cdev, ABS_X, buf, 0);
 		snd_caiaq_input_report_abs(cdev, ABS_Y, buf, 1);
 		snd_caiaq_input_report_abs(cdev, ABS_Z, buf, 2);
 		break;
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_TRAKTORKONTROLX1):
+		if (len < 16)
+			return;
 		snd_caiaq_input_report_abs(cdev, ABS_HAT0X, buf, 4);
 		snd_caiaq_input_report_abs(cdev, ABS_HAT0Y, buf, 2);
 		snd_caiaq_input_report_abs(cdev, ABS_HAT1X, buf, 6);
-- 
2.53.0



