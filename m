Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030267;
	b=cWFFpzTy0IfAL1sHGoQMnjP9Qu3Q/+ILLjkGL/XJJB1ftpSXJIhz8A3Fo0k8+EmTu8km
	 9NNc5tTmzCbt1wTtt3Asw0glo5eVr9HpSKbjAn3anzaXX+5/5PeqdDiUYqH/ZJk56t9gV
	 4+nG5p3BCSV2uZHtxLkmPmxn6uqDdOo8xm/F8btNSOcYZbHK/bjKO2z9hrSHvjqiYRB95
	 uX/L4mLoocGU9Q5R148AKvXNhFw6IiwYflO9W872rrNIag5dUfmsxHvNfIDnyeXKhO1bs
	 QR0t/p4ln0H2rjsZyyypnTLsN23llYpI6E2C37mEO8CDydAv0HxnmN65iYF1hRzZ4JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VMPMurInaLJVtIB8lC79Jowt4kNmIuf+frZ5DExoScw=;
	b=HC6TUvunMgqnaU7cSD7FY6KVcM3ftOxA6NSXpOOrfxxbDFfUnkbNQky+1ba18dFCN+/X
	 c5nkfMnqLJygEfSXhb+/mIGdiJwVAU1P9+4F470WtB4MSFLYq515UP0j0w0vMWvzA3bCb
	 CLq8JppbI7XIR6oIAkoJs8YFNsdANk1IoMIEMIB2oU/BR/SCjxbs4Ap7rdVjDGopBhNq5
	 7mdRlJ/xc4SVn0arJLtIDCrrsq8DfsVsJfxoPF8UU1drtMjPml7aMlSGXBoQvaMiagJwu
	 Z2Ffya+XnK77AQXvTMlyTguA9N8oa73YjO/MVf23CKzdCSNIlcbYTd7zjB2asdfIqOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qp4L6Whh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48042606FF4C;
	Wed, 18 Nov 2026 19:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qp4L6Whh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAFB1F000C4;
	Wed, 18 Nov 2026 19:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030267;
	bh=VMPMurInaLJVtIB8lC79Jowt4kNmIuf+frZ5DExoScw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qp4L6WhhoHOHV0hocTFn2aYPiDYabR6J/FyMDgpP6itq4xHDj10hHavIzDiGfDx7M
	 C2qo8ZA34MxyociYpa4A+Lwfs4p48US9dWHXXL3nopz/WFWg9E0vP2fpXkI7seo2mx
	 GqNb2DVIbF7TXcwjxvo0v7OCUpJc+HozH4wfHtNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niko Huuskonen <niko.huuskonen.00@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0642/1756] ALSA: caiaq: Serialize access to the EP1 command buffer
Date: Wed, 18 Nov 2026 15:46:09 +0100
Message-ID: <20261118150034.399887608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niko Huuskonen <niko.huuskonen.00@gmail.com>

[ Upstream commit a718fd03e1e00211cf4662f5ab82d33f4c18e2a7 ]

snd_usb_caiaq_send_command() and snd_usb_caiaq_send_command_bank() copy
the command into cdev->ep1_out_buf and send it with a synchronous bulk
transfer. Nothing serializes their callers. An ALSA control write, which
sets the LEDs on the Kore controllers and several other devices, can run
at the same time as a PCM prepare, which sends the audio parameters
through the same buffer. One caller can then overwrite the buffer while
the transfer of the other is still in flight, and the device receives a
mix of both commands.

Protect the buffer with a mutex. All callers run in process context and
already sleep in usb_bulk_msg().

The problem was found by code review while adding another user of the
buffer, the Kore LCD support later in this series. It has not been
observed or reproduced.

Fixes: 8e3cd08ed8e5 ("[ALSA] caiaq - add control API and more input features")
Assisted-by: LLM
Signed-off-by: Niko Huuskonen <niko.huuskonen.00@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260927003532.289468-2-niko.huuskonen.00@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 5 +++++
 sound/usb/caiaq/device.h | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index f604846ec6e6f..e8619bb743581 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -212,6 +212,8 @@ int snd_usb_caiaq_send_command(struct snd_usb_caiaqdev *cdev,
 	if (len > EP1_BUFSIZE - 1)
 		len = EP1_BUFSIZE - 1;
 
+	guard(mutex)(&cdev->ep1_out_mutex);
+
 	if (buffer && len > 0)
 		memcpy(cdev->ep1_out_buf+1, buffer, len);
 
@@ -235,6 +237,8 @@ int snd_usb_caiaq_send_command_bank(struct snd_usb_caiaqdev *cdev,
 	if (len > EP1_BUFSIZE - 2)
 		len = EP1_BUFSIZE - 2;
 
+	guard(mutex)(&cdev->ep1_out_mutex);
+
 	if (buffer && len > 0)
 		memcpy(cdev->ep1_out_buf+2, buffer, len);
 
@@ -443,6 +447,7 @@ static int create_card(struct usb_device *usb_dev,
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));
 	spin_lock_init(&cdev->spinlock);
+	mutex_init(&cdev->ep1_out_mutex);
 
 	*cardp = card;
 	return 0;
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index 1c6f34693fa81..822d872c8ad1a 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -2,6 +2,8 @@
 #ifndef CAIAQ_DEVICE_H
 #define CAIAQ_DEVICE_H
 
+#include <linux/mutex.h>
+
 #include "../usbaudio.h"
 
 #define USB_VID_NATIVEINSTRUMENTS 0x17cc
@@ -68,6 +70,7 @@ struct snd_usb_caiaqdev {
 
 	unsigned char ep1_in_buf[EP1_BUFSIZE];
 	unsigned char ep1_out_buf[EP1_BUFSIZE];
+	struct mutex ep1_out_mutex;	/* protects ep1_out_buf */
 	unsigned char midi_out_buf[EP1_BUFSIZE];
 
 	struct caiaq_device_spec spec;
-- 
2.53.0



