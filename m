Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB3450E59C;
	Thu, 17 Sep 2026 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665812; cv=none; b=t8ycpKEi9JqS//W9QtChI/YpeRffoVr+nlI5eBPReLrTCLTJWt4CYQdG1kTzwpIxo9Wbn4p+eGCigfpg/iU1lq6v/M8XQgmd1PrFywT2P3XHrxXBFOzT1/BAPMqcMwizXvZQ2+ZU8GEVYfMeRTq7u5WDHJcqgx+sDxaEDtNRoB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665812; c=relaxed/simple;
	bh=WReqFLdOQ/4mEw45qCwbQRxlfIp4odM6MTFHjCC/tb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcDLyCrVo58arxzRGXuRQdQccQ4dKu0U1neDmwDP1gL60oBgo1ZEisHOln1QUAZPfp7txZD4wZ4tLZ3xVp+ZBmAMm2vI8xuzUdzYTy9jmavsXnHlZXjiZKIF7I5Zfp0wzYDsdrg+nmR4wheF+2tyd+H0rq5JKhb8kKC4qunrODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBbIcPpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBbIcPpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7771F000FF;
	Thu, 17 Sep 2026 17:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665810;
	bh=pXBdmd9W/KMBpWhnh54ufeMnHVsYx8iIT3xt6hroapc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBbIcPpPh/PTI/LKgT8ClGj96ERSdLK8v069bgmTRyLkF14nh6tJ6E2iezzLOJlw/
	 5knOsZH8jQ9zf1Gr7T3QLs5HMkKWX3NXFH1UordfJ88FqjdBif2mBiIHZbpmQvQMii
	 m303YPdlRTfVwxbRj43TOJaRAaYO9R+Wb1v32EYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0829/1250] ALSA: caiaq: Decoupling ep1_in_urb in caiaq dev
Date: Thu, 17 Sep 2026 16:10:24 +0100
Message-ID: <20260917151614.408765672@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@sina.com>

[ Upstream commit 402a9d6aab7ac787ab075adeb562c3db8b8f564b ]

The epq_in_urb object belonging to the caiaq device is coupled within
the struct snd_usb_caiaqdev. After usb_submit_urb(epq_in_urb, GFP_KERNEL)
executes successfully, epq_in_urb is successfully added to the urbp_list
queue of the dummy HCD driver (userspace specifies dummy_hcd as the HCD
layer driver for the caiaq USB device).

When init_card() calls snd_usb_caiaq_send_command() which subsequently
fails due to a timeout, and proceeds to call snd_card_free() to release
the card, the embedded ep1_in_urb object is also freed. When the dummy
HCD driver detects that the URB has been unlinked, it returns the URB
(by usb_hcd_giveback_urb()), which triggers [1].

Decouple the ep1_in_urb object from the struct snd_usb_caiaqdev and switch
to using a pointer instead. Separately allocate and manage the memory for
ep1_in_urb to prevent the release of the snd_card memory object from
interfering with it.

midi_out_urb has the same issue as ep1_in_urb and is handled in the same
way.

[1]
BUG: KASAN: slab-use-after-free in usb_free_urb+0x24/0x120 drivers/usb/core/urb.c:96
Write of size 4 at addr ffff88803cee1050 by task ktimers/1/29
Call Trace:
 usb_free_urb+0x24/0x120 drivers/usb/core/urb.c:96
 dummy_timer+0xaac/0x4d50 drivers/usb/gadget/udc/dummy_hcd.c:2019
 __run_hrtimer kernel/time/hrtimer.c:2067 [inline]
 __hrtimer_run_queues+0x3eb/0xaf0 kernel/time/hrtimer.c:2124
 hrtimer_run_softirq+0x1e1/0x2e0 kernel/time/hrtimer.c:2141

Allocated by task 36:
 snd_card_new+0x7b/0x110 sound/core/init.c:184
 create_card sound/usb/caiaq/device.c:429 [inline]
 snd_probe+0x236/0x1af0 sound/usb/caiaq/device.c:544

Freed by task 36:
 snd_card_free_when_closed sound/core/init.c:630 [inline]
 snd_card_free+0x138/0x1d0 sound/core/init.c:662
 snd_probe+0x162b/0x1af0 sound/usb/caiaq/device.c:553

Fixes: 523f1dce3743 ("[ALSA] Add Native Instrument usb audio device support")
Reported-by: syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=832ce9fa3face1b7d44d
Tested-by: syzbot+832ce9fa3face1b7d44d@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
Link: https://patch.msgid.link/20260903130521.554840-1-eadavis@sina.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 36 ++++++++++++++++++++++++------------
 sound/usb/caiaq/device.h |  4 ++--
 sound/usb/caiaq/midi.c   |  6 +++---
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index a16e592484803..3d821fde45820 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -192,8 +192,8 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		break;
 	}
 
-	cdev->ep1_in_urb.actual_length = 0;
-	ret = usb_submit_urb(&cdev->ep1_in_urb, GFP_ATOMIC);
+	cdev->ep1_in_urb->actual_length = 0;
+	ret = usb_submit_urb(cdev->ep1_in_urb, GFP_ATOMIC);
 	if (ret < 0)
 		dev_err(dev, "unable to submit urb. OOM!?\n");
 }
@@ -408,6 +408,10 @@ static void card_free(struct snd_card *card)
 #endif
 	snd_usb_caiaq_audio_free(cdev);
 	usb_put_dev(cdev->chip.dev);
+	usb_free_urb(cdev->ep1_in_urb);
+	cdev->ep1_in_urb = NULL;
+	usb_free_urb(cdev->midi_out_urb);
+	cdev->midi_out_urb = NULL;
 }
 
 static int create_card(struct usb_device *usb_dev,
@@ -457,22 +461,30 @@ static int init_card(struct snd_usb_caiaqdev *cdev)
 		return -EIO;
 	}
 
-	usb_init_urb(&cdev->ep1_in_urb);
-	usb_init_urb(&cdev->midi_out_urb);
+	cdev->ep1_in_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!cdev->ep1_in_urb)
+		return -ENOMEM;
 
-	usb_fill_bulk_urb(&cdev->ep1_in_urb, usb_dev,
+	cdev->midi_out_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!cdev->midi_out_urb) {
+		usb_free_urb(cdev->ep1_in_urb);
+		cdev->ep1_in_urb = NULL;
+		return -ENOMEM;
+	}
+
+	usb_fill_bulk_urb(cdev->ep1_in_urb, usb_dev,
 			  usb_rcvbulkpipe(usb_dev, 0x1),
 			  cdev->ep1_in_buf, EP1_BUFSIZE,
 			  usb_ep1_command_reply_dispatch, cdev);
 
-	usb_fill_bulk_urb(&cdev->midi_out_urb, usb_dev,
+	usb_fill_bulk_urb(cdev->midi_out_urb, usb_dev,
 			  usb_sndbulkpipe(usb_dev, 0x1),
 			  cdev->midi_out_buf, EP1_BUFSIZE,
 			  snd_usb_caiaq_midi_output_done, cdev);
 
 	/* sanity checks of EPs before actually submitting */
-	if (usb_urb_ep_type_check(&cdev->ep1_in_urb) ||
-	    usb_urb_ep_type_check(&cdev->midi_out_urb)) {
+	if (usb_urb_ep_type_check(cdev->ep1_in_urb) ||
+	    usb_urb_ep_type_check(cdev->midi_out_urb)) {
 		dev_err(dev, "invalid EPs\n");
 		return -EINVAL;
 	}
@@ -480,7 +492,7 @@ static int init_card(struct snd_usb_caiaqdev *cdev)
 	init_waitqueue_head(&cdev->ep1_wait_queue);
 	init_waitqueue_head(&cdev->prepare_wait_queue);
 
-	if (usb_submit_urb(&cdev->ep1_in_urb, GFP_KERNEL) != 0)
+	if (usb_submit_urb(cdev->ep1_in_urb, GFP_KERNEL) != 0)
 		return -EIO;
 
 	err = snd_usb_caiaq_send_command(cdev, EP1_CMD_GET_DEVICE_INFO, NULL, 0);
@@ -530,7 +542,7 @@ static int init_card(struct snd_usb_caiaqdev *cdev)
 	return 0;
 
  err_kill_urb:
-	usb_kill_urb(&cdev->ep1_in_urb);
+	usb_kill_urb(cdev->ep1_in_urb);
 	return err;
 }
 
@@ -576,8 +588,8 @@ static void snd_disconnect(struct usb_interface *intf)
 #endif
 	snd_usb_caiaq_audio_disconnect(cdev);
 
-	usb_kill_urb(&cdev->ep1_in_urb);
-	usb_kill_urb(&cdev->midi_out_urb);
+	usb_kill_urb(cdev->ep1_in_urb);
+	usb_kill_urb(cdev->midi_out_urb);
 
 	snd_card_free_when_closed(card);
 }
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index 743eb0387b5fb..1c6f34693fa81 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -60,8 +60,8 @@ struct snd_usb_caiaq_cb_info;
 struct snd_usb_caiaqdev {
 	struct snd_usb_audio chip;
 
-	struct urb ep1_in_urb;
-	struct urb midi_out_urb;
+	struct urb *ep1_in_urb;
+	struct urb *midi_out_urb;
 	struct urb **data_urbs_in;
 	struct urb **data_urbs_out;
 	struct snd_usb_caiaq_cb_info *data_cb_info;
diff --git a/sound/usb/caiaq/midi.c b/sound/usb/caiaq/midi.c
index c656d01624321..18529484c8dcc 100644
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -43,7 +43,7 @@ static int snd_usb_caiaq_midi_output_close(struct snd_rawmidi_substream *substre
 {
 	struct snd_usb_caiaqdev *cdev = substream->rmidi->private_data;
 	if (cdev->midi_out_active) {
-		usb_kill_urb(&cdev->midi_out_urb);
+		usb_kill_urb(cdev->midi_out_urb);
 		cdev->midi_out_active = 0;
 	}
 	return 0;
@@ -64,9 +64,9 @@ static void snd_usb_caiaq_midi_send(struct snd_usb_caiaqdev *cdev,
 		return;
 
 	cdev->midi_out_buf[2] = len;
-	cdev->midi_out_urb.transfer_buffer_length = len+3;
+	cdev->midi_out_urb->transfer_buffer_length = len+3;
 
-	ret = usb_submit_urb(&cdev->midi_out_urb, GFP_ATOMIC);
+	ret = usb_submit_urb(cdev->midi_out_urb, GFP_ATOMIC);
 	if (ret < 0)
 		dev_err(dev,
 			"snd_usb_caiaq_midi_send(%p): usb_submit_urb() failed,"
-- 
2.53.0



