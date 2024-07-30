Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DD81A76A1;
	Tue, 30 Jul 2024 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360312; cv=none; b=q5SDYX5SbHU9c59SyM8bmBAapuPPV90voNfHruV378ZaTmKzapbJpOPrDGyuPUF54/J7BRYVBqluIeHDXTbSSzN5X9L+XX38dzOzI0c4LCFHSNxqYw4QtSSwCe3iqeg3vPX/1DmLV78weN1tFUeajOMJAm/ylZaC6XtIKKTmyic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360312; c=relaxed/simple;
	bh=UcGOo7QGoNZ2B3PdnPbPAA/O7rZMqhCWaZsQdbBqj4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqyKeb02nvTkEUFRR+EquuILYLJgSO/Niqdw9SDHm5ffmugO0QIDaLFR322t5bawtWPEnITNSnQXB19wwuGARZj5ue7T6NzRWnLfW/XHOdkmN/Yll1y4ez6t9W03LnsB8/zka9LDsXz68aNVCCFRKmI26J4Ws2nlohqqtOMSt1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbKcpRjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbKcpRjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8848BC4AF0E;
	Tue, 30 Jul 2024 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360312;
	bh=UcGOo7QGoNZ2B3PdnPbPAA/O7rZMqhCWaZsQdbBqj4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbKcpRjlZ+//r3ownFTtZe5jCUb5jVjO7kQXoQKNRuEgzp3H3Fnr5U0dcjtQP58uQ
	 zU1HSXRivsqtibGmkAUlTJrHT88ujYDLi8VJJ0vF7m7iNi88jMG0PKQD74wdFTruLv
	 ARgLHtIPsqvQ1dJbxDkbTr96cMkmvPDpW6maDhnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 629/809] ALSA: usb-audio: Fix microphone sound on HD webcam.
Date: Tue, 30 Jul 2024 17:48:25 +0200
Message-ID: <20240730151749.686202328@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

commit 74dba240881820b46b9b1c62ef4de3bfff47fbd4 upstream.

I own an external usb Webcam, HD webcam, which had low mic volume and
inconsistent sound quality. Video works as expected.

(snip)
[   95.473820][ 1] [   T73] usb 5-2.2: new high-speed USB device number 7 using xhci_hcd
[   95.773974][ 1] [   T73] usb 5-2.2: New USB device found, idVendor=1bcf, idProduct=2281, bcdDevice= 0.05
[   95.783445][ 1] [   T73] usb 5-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   95.791872][ 1] [   T73] usb 5-2.2: Product: HD webcam
[   95.797001][ 1] [   T73] usb 5-2.2: Manufacturer: Sunplus IT Co
[   95.802996][ 1] [   T73] usb 5-2.2: SerialNumber: 20200513
[   96.092610][ 2] [ T3680] usb 5-2.2: Warning! Unlikely big volume range (=4096), cval->res is probably wrong.
[   96.102436][ 2] [ T3680] usb 5-2.2: [5] FU [Mic Capture Volume] ch = 1, val = 0/4096/1

Set up quirk cval->res to 16 for 256 levels,
Set GET_SAMPLE_RATE quirk flag to stop trying to get the sample rate.
Confirmed that happened anyway later due to the backoff mechanism,
After 3 failures.

All audio stream on device interfaces share the same values,
apart from wMaxPacketSize and tSamFreq :

      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass         1 Audio

Interface Descriptor:
  bLength                 9
  bDescriptorType         4
  bInterfaceNumber        3
  bAlternateSetting       4
  bNumEndpoints           1
  bInterfaceClass         1 Audio
  bInterfaceSubClass      2 Streaming
  bInterfaceProtocol      0
  iInterface              0
  AudioStreaming Interface Descriptor:
    bLength                 7
    bDescriptorType        36
    bDescriptorSubtype      1 (AS_GENERAL)
    bTerminalLink           3
    bDelay                  1 frames
    wFormatTag         0x0001 PCM
  AudioStreaming Interface Descriptor:
    bLength                11
    bDescriptorType        36
    bDescriptorSubtype      2 (FORMAT_TYPE)
    bFormatType             1 (FORMAT_TYPE_I)
    bNrChannels             1
    bSubframeSize           2
    bBitResolution         16
    bSamFreqType            1 Discrete
    tSamFreq[ 0]        48000
  Endpoint Descriptor:
    bLength                 9
    bDescriptorType         5
    bEndpointAddress     0x86  EP 6 IN
    bmAttributes            5
      Transfer Type            Isochronous
      Synch Type               Asynchronous
      Usage Type               Data
    wMaxPacketSize     0x0064  1x 100 bytes
    bInterval               4
    bRefresh                0
    bSynchAddress           0
    AudioStreaming Endpoint Descriptor:
      bLength                 7
      bDescriptorType        37
      bDescriptorSubtype      1 (EP_GENERAL)
      bmAttributes         0x01
        Sampling Frequency
      bLockDelayUnits         0 Undefined
      wLockDelay         0x0000
(snip)

Testing patch provides consistent good sound recording quality and volume range.

(snip)
[   95.473820][ 1] [   T73] usb 5-2.2: new high-speed USB device number 7 using xhci_hcd
[   95.773974][ 1] [   T73] usb 5-2.2: New USB device found, idVendor=1bcf, idProduct=2281, bcdDevice= 0.05
[   95.783445][ 1] [   T73] usb 5-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   95.791872][ 1] [   T73] usb 5-2.2: Product: HD webcam
[   95.797001][ 1] [   T73] usb 5-2.2: Manufacturer: Sunplus IT Co
[   95.802996][ 1] [   T73] usb 5-2.2: SerialNumber: 20200513
[   96.110630][ 3] [ T3680] usbcore: registered new interface driver snd-usb-audio
[   96.114329][ 7] [ T3677] usb 5-2.2: Found UVC 1.00 device HD webcam (1bcf:2281)
[   96.167555][ 7] [ T3677] usbcore: registered new interface driver uvcvideo

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240719020906.8078-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c  |    7 +++++++
 sound/usb/quirks.c |    2 ++
 2 files changed, 9 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1211,6 +1211,13 @@ static void volume_control_quirks(struct
 			cval->res = 16;
 		}
 		break;
+	case USB_ID(0x1bcf, 0x2281): /* HD Webcam */
+		if (!strcmp(kctl->id.name, "Mic Capture Volume")) {
+			usb_audio_info(chip,
+				"set resolution quirk: cval->res = 16\n");
+			cval->res = 16;
+		}
+		break;
 	}
 }
 
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2225,6 +2225,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x534d, 0x2109, /* MacroSilicon MS2109 */
 		   QUIRK_FLAG_ALIGN_TRANSFER),
+	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


