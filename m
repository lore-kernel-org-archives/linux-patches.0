Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A87E2236EA;
	Thu, 12 Dec 2024 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019507; cv=none; b=G5s/P0pHNqE+FGIV+64WkbwHAXQZjjWIKy+T/SE3Du1692qtelPm0k3OlSLgeEOEIKW8SagKSDoN8f9J3vWK8EyGyEWizZVXyTqd3GC11N+sdzE+PphX3UYtkhJTCCkl25TKX+MQK/HN6UCVod8GzT1Ig1trEIz4hnMTLzOevwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019507; c=relaxed/simple;
	bh=Ko+KEClcxiVRAX2maonFERYDYfy8briStE7DgBPjsTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzGj1HHjjtWEfXXBva9Nq/CzTFqh75vRplvKmpeHO020Bah8zDCY1AUupCM9YuGnV1H00mUoqHSJsK8X85jaUqTVLn+o1u2uXiYJ04PUlD6XTkZcxTzajuoRzE5HdTVCm9naNIPditZRdhMewnjk0gckGsROnoRqTqyq+Q0WwCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbY7nQdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbY7nQdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5F7C4CECE;
	Thu, 12 Dec 2024 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019507;
	bh=Ko+KEClcxiVRAX2maonFERYDYfy8briStE7DgBPjsTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbY7nQdU/V/VJqUXYph3MFBm0FvkEMnL8a/yxdPwTrJGOrm4Qh//NTEe31rACkmyf
	 GVqZMH49rONQ/MRiSnWZRAfaKtJ/jrrUptkyKcje4k45+3IaI8wgFzPuIoAe4azNBn
	 qKH5s7c6EowEEBpZAgYnkReMG7F8O2yQv78+nQvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/772] ALSA: caiaq: Use snd_card_free_when_closed() at disconnection
Date: Thu, 12 Dec 2024 15:52:20 +0100
Message-ID: <20241212144357.998224349@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b04dcbb7f7b1908806b7dc22671cdbe78ff2b82c ]

The USB disconnect callback is supposed to be short and not too-long
waiting.  OTOH, the current code uses snd_card_free() at
disconnection, but this waits for the close of all used fds, hence it
can take long.  It eventually blocks the upper layer USB ioctls, which
may trigger a soft lockup.

An easy workaround is to replace snd_card_free() with
snd_card_free_when_closed().  This variant returns immediately while
the release of resources is done asynchronously by the card device
release at the last close.

This patch also splits the code to the disconnect and the free phases;
the former is called immediately at the USB disconnect callback while
the latter is called from the card destructor.

Fixes: 523f1dce3743 ("[ALSA] Add Native Instrument usb audio device support")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241113111042.15058-5-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/audio.c  | 10 ++++++++--
 sound/usb/caiaq/audio.h  |  1 +
 sound/usb/caiaq/device.c | 19 +++++++++++++++----
 sound/usb/caiaq/input.c  | 12 +++++++++---
 sound/usb/caiaq/input.h  |  1 +
 5 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 4981753652a7f..7a89872aa0cbd 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -869,14 +869,20 @@ int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *cdev)
 	return 0;
 }
 
-void snd_usb_caiaq_audio_free(struct snd_usb_caiaqdev *cdev)
+void snd_usb_caiaq_audio_disconnect(struct snd_usb_caiaqdev *cdev)
 {
 	struct device *dev = caiaqdev_to_dev(cdev);
 
 	dev_dbg(dev, "%s(%p)\n", __func__, cdev);
 	stream_stop(cdev);
+}
+
+void snd_usb_caiaq_audio_free(struct snd_usb_caiaqdev *cdev)
+{
+	struct device *dev = caiaqdev_to_dev(cdev);
+
+	dev_dbg(dev, "%s(%p)\n", __func__, cdev);
 	free_urbs(cdev->data_urbs_in);
 	free_urbs(cdev->data_urbs_out);
 	kfree(cdev->data_cb_info);
 }
-
diff --git a/sound/usb/caiaq/audio.h b/sound/usb/caiaq/audio.h
index 869bf6264d6a0..07f5d064456cf 100644
--- a/sound/usb/caiaq/audio.h
+++ b/sound/usb/caiaq/audio.h
@@ -3,6 +3,7 @@
 #define CAIAQ_AUDIO_H
 
 int snd_usb_caiaq_audio_init(struct snd_usb_caiaqdev *cdev);
+void snd_usb_caiaq_audio_disconnect(struct snd_usb_caiaqdev *cdev);
 void snd_usb_caiaq_audio_free(struct snd_usb_caiaqdev *cdev);
 
 #endif /* CAIAQ_AUDIO_H */
diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 49f63f878e6fe..d5c01d3f126ee 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -376,6 +376,17 @@ static void setup_card(struct snd_usb_caiaqdev *cdev)
 		dev_err(dev, "Unable to set up control system (ret=%d)\n", ret);
 }
 
+static void card_free(struct snd_card *card)
+{
+	struct snd_usb_caiaqdev *cdev = caiaqdev(card);
+
+#ifdef CONFIG_SND_USB_CAIAQ_INPUT
+	snd_usb_caiaq_input_free(cdev);
+#endif
+	snd_usb_caiaq_audio_free(cdev);
+	usb_reset_device(cdev->chip.dev);
+}
+
 static int create_card(struct usb_device *usb_dev,
 		       struct usb_interface *intf,
 		       struct snd_card **cardp)
@@ -489,6 +500,7 @@ static int init_card(struct snd_usb_caiaqdev *cdev)
 		       cdev->vendor_name, cdev->product_name, usbpath);
 
 	setup_card(cdev);
+	card->private_free = card_free;
 	return 0;
 
  err_kill_urb:
@@ -534,15 +546,14 @@ static void snd_disconnect(struct usb_interface *intf)
 	snd_card_disconnect(card);
 
 #ifdef CONFIG_SND_USB_CAIAQ_INPUT
-	snd_usb_caiaq_input_free(cdev);
+	snd_usb_caiaq_input_disconnect(cdev);
 #endif
-	snd_usb_caiaq_audio_free(cdev);
+	snd_usb_caiaq_audio_disconnect(cdev);
 
 	usb_kill_urb(&cdev->ep1_in_urb);
 	usb_kill_urb(&cdev->midi_out_urb);
 
-	snd_card_free(card);
-	usb_reset_device(interface_to_usbdev(intf));
+	snd_card_free_when_closed(card);
 }
 
 
diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 84f26dce7f5d0..a9130891bb696 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -829,15 +829,21 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 	return ret;
 }
 
-void snd_usb_caiaq_input_free(struct snd_usb_caiaqdev *cdev)
+void snd_usb_caiaq_input_disconnect(struct snd_usb_caiaqdev *cdev)
 {
 	if (!cdev || !cdev->input_dev)
 		return;
 
 	usb_kill_urb(cdev->ep4_in_urb);
+	input_unregister_device(cdev->input_dev);
+}
+
+void snd_usb_caiaq_input_free(struct snd_usb_caiaqdev *cdev)
+{
+	if (!cdev || !cdev->input_dev)
+		return;
+
 	usb_free_urb(cdev->ep4_in_urb);
 	cdev->ep4_in_urb = NULL;
-
-	input_unregister_device(cdev->input_dev);
 	cdev->input_dev = NULL;
 }
diff --git a/sound/usb/caiaq/input.h b/sound/usb/caiaq/input.h
index c42891e7be884..fbe267f85d025 100644
--- a/sound/usb/caiaq/input.h
+++ b/sound/usb/caiaq/input.h
@@ -4,6 +4,7 @@
 
 void snd_usb_caiaq_input_dispatch(struct snd_usb_caiaqdev *cdev, char *buf, unsigned int len);
 int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev);
+void snd_usb_caiaq_input_disconnect(struct snd_usb_caiaqdev *cdev);
 void snd_usb_caiaq_input_free(struct snd_usb_caiaqdev *cdev);
 
 #endif
-- 
2.43.0



