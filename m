Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4545146444;
	Tue, 10 Sep 2024 09:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960989; cv=none; b=LXWAiH/rjHWaP2uO61DOR6WrSGAWByG+rJVk4PshGtbRw36BRKaU8/pGt6e8ASkHhqX+EzLwx5F7quu1Fo/nVqF7lazPpkOLLVaqPkB56L/V73kULvbuW7EPHVThSD2MOMZmN6BMwX+gPTMuw3hsMv30g1MZnHKAMvr2OrsKmBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960989; c=relaxed/simple;
	bh=zuqfhiAFze72Yd9RR0w6pMhjAdlO/d25hCbmwUCWvjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NO6n/6tWFbUOexkRDJc0oNYKsbq7Gnj1/QXEyQUBR+zLSO1kO5ED4jp7Lumwfo1FbTqoe/YjF1IKVfYp+LLkRlB/dQb1zl1hlItucOZYX4TqaZcGz6FkTZKKFVIxOpygPrROmPQ2oinjmBi/ElowWAyqrF044httV37o46AVjC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLOq/8U5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLOq/8U5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB0EC4CEC6;
	Tue, 10 Sep 2024 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725960989;
	bh=zuqfhiAFze72Yd9RR0w6pMhjAdlO/d25hCbmwUCWvjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLOq/8U5KcOAzeSCkHIuMQMcnnFv6vXHT0cHaY6m4Q+CAkYoWgEjy+Zy6SgXO+y3S
	 eiR+im2d9fIyZd95fzFLSDG6SVbep555tOTQ5osaA0IXdMV5ddDNVNVOpwSOPy1XEc
	 n27Y3SB8EyJ3K6viYCiWK3e8PeVy/27aw8ISC9p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	Jaroslav Kysela <perex@perex.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d952e5e28f5fb7718d23@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 4.19 16/96] ALSA: usb-audio: Sanity checks for each pipe and EP types
Date: Tue, 10 Sep 2024 11:31:18 +0200
Message-ID: <20240910092542.128616144@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 801ebf1043ae7b182588554cc9b9ad3c14bc2ab5 ]

The recent USB core code performs sanity checks for the given pipe and
EP types, and it can be hit by manipulated USB descriptors by syzbot.
For making syzbot happier, this patch introduces a local helper for a
sanity check in the driver side and calls it at each place before the
message handling, so that we can avoid the WARNING splats.

Reported-by: syzbot+d952e5e28f5fb7718d23@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/helper.c |   17 +++++++++++++++++
 sound/usb/helper.h |    1 +
 sound/usb/quirks.c |   14 +++++++++++---
 3 files changed, 29 insertions(+), 3 deletions(-)

--- a/sound/usb/helper.c
+++ b/sound/usb/helper.c
@@ -76,6 +76,20 @@ void *snd_usb_find_csint_desc(void *buff
 	return NULL;
 }
 
+/* check the validity of pipe and EP types */
+int snd_usb_pipe_sanity_check(struct usb_device *dev, unsigned int pipe)
+{
+	static const int pipetypes[4] = {
+		PIPE_CONTROL, PIPE_ISOCHRONOUS, PIPE_BULK, PIPE_INTERRUPT
+	};
+	struct usb_host_endpoint *ep;
+
+	ep = usb_pipe_endpoint(dev, pipe);
+	if (usb_pipetype(pipe) != pipetypes[usb_endpoint_type(&ep->desc)])
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * Wrapper for usb_control_msg().
  * Allocates a temp buffer to prevent dmaing from/to the stack.
@@ -88,6 +102,9 @@ int snd_usb_ctl_msg(struct usb_device *d
 	void *buf = NULL;
 	int timeout;
 
+	if (snd_usb_pipe_sanity_check(dev, pipe))
+		return -EINVAL;
+
 	if (size > 0) {
 		buf = kmemdup(data, size, GFP_KERNEL);
 		if (!buf)
--- a/sound/usb/helper.h
+++ b/sound/usb/helper.h
@@ -7,6 +7,7 @@ unsigned int snd_usb_combine_bytes(unsig
 void *snd_usb_find_desc(void *descstart, int desclen, void *after, u8 dtype);
 void *snd_usb_find_csint_desc(void *descstart, int desclen, void *after, u8 dsubtype);
 
+int snd_usb_pipe_sanity_check(struct usb_device *dev, unsigned int pipe);
 int snd_usb_ctl_msg(struct usb_device *dev, unsigned int pipe,
 		    __u8 request, __u8 requesttype, __u16 value, __u16 index,
 		    void *data, __u16 size);
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -743,11 +743,13 @@ static int snd_usb_novation_boot_quirk(s
 static int snd_usb_accessmusic_boot_quirk(struct usb_device *dev)
 {
 	int err, actual_length;
-
 	/* "midi send" enable */
 	static const u8 seq[] = { 0x4e, 0x73, 0x52, 0x01 };
+	void *buf;
 
-	void *buf = kmemdup(seq, ARRAY_SIZE(seq), GFP_KERNEL);
+	if (snd_usb_pipe_sanity_check(dev, usb_sndintpipe(dev, 0x05)))
+		return -EINVAL;
+	buf = kmemdup(seq, ARRAY_SIZE(seq), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 	err = usb_interrupt_msg(dev, usb_sndintpipe(dev, 0x05), buf,
@@ -772,7 +774,11 @@ static int snd_usb_accessmusic_boot_quir
 
 static int snd_usb_nativeinstruments_boot_quirk(struct usb_device *dev)
 {
-	int ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+	int ret;
+
+	if (snd_usb_pipe_sanity_check(dev, usb_sndctrlpipe(dev, 0)))
+		return -EINVAL;
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				  0xaf, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				  1, 0, NULL, 0, 1000);
 
@@ -879,6 +885,8 @@ static int snd_usb_axefx3_boot_quirk(str
 
 	dev_dbg(&dev->dev, "Waiting for Axe-Fx III to boot up...\n");
 
+	if (snd_usb_pipe_sanity_check(dev, usb_sndctrlpipe(dev, 0)))
+		return -EINVAL;
 	/* If the Axe-Fx III has not fully booted, it will timeout when trying
 	 * to enable the audio streaming interface. A more generous timeout is
 	 * used here to detect when the Axe-Fx III has finished booting as the


